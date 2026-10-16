"""WellWish load test (PHASES 9.4, ARCHITECTURE §13). Run it with `.\\ww.ps1 loadtest`.

- 100 partners on a live job send their location every 10 s over the partner socket (as the app
  does) and open Home every minute. The family of each job listens on the patient socket: the
  time from the partner sending a point to the family getting it is reported as
  "WS location → family".
- Patients book 30 times a minute: the services, the times of a date, the booking, the booking
  page.

Target: p95 < 300 ms for every request, nothing failing. The run fails (exit code 1) otherwise.
Phones aren't in step: each partner starts at a random moment of its 10 s. The first
WARM_UP_S seconds after everyone started are not counted (a fresh server process warms up).
The people and their tokens come from `manage.py loadtest_data` (/data/users.json).
"""

import itertools
import json
import os
import random
import time
import uuid

import gevent
import websocket
from locust import HttpUser, constant, constant_throughput, events, task

DATA = json.load(open(os.environ.get("LOADTEST_USERS", "/data/users.json")))
PARTNERS = DATA["partners"]
PATIENTS = DATA["patients"]
SERVICE = DATA["serviceId"]
BOOKINGS_PER_MINUTE = 30
BOOKERS = 3
P95_TARGET_MS = 300
STEP = 0.0001  # about 11 m per point: a walk, never "too fast"
WARM_UP_S = 15

_partner_slots = itertools.count()
# live points sent but never seen by the family (counted when a partner stops)
_LOST: list[int] = [0]
LOST_AFTER_S = 5
_patient_turns = itertools.count()


def _report(name: str, started: float, error: Exception | None = None) -> None:
    events.request.fire(
        request_type="WS",
        name=name,
        response_time=(time.perf_counter() - started) * 1000,
        response_length=0,
        exception=error,
        context={},
    )


def _socket(host: str, path: str, token: str) -> websocket.WebSocket:
    url = host.replace("http://", "ws://").replace("https://", "wss://") + path
    ws = websocket.create_connection(url, timeout=15)
    ws.send(json.dumps({"type": "auth", "token": token}))
    reply = json.loads(ws.recv())
    if reply.get("type") != "auth.ok":
        raise RuntimeError(f"{path}: {reply}")
    ws.settimeout(None)  # the readers wait as long as it takes
    return ws


class LivePartner(HttpUser):
    """A partner on a job: a point every 10 s; Home every minute."""

    fixed_count = len(PARTNERS)
    wait_time = constant(10)

    def on_start(self) -> None:
        me = PARTNERS[next(_partner_slots) % len(PARTNERS)]
        self.me = me
        self.auth = {"Authorization": f"Bearer {me['token']}"}
        self.seq = 0
        self.sent: dict[int, float] = {}
        self.partner_ws = _socket(self.host, "/ws/partner/", me["token"])
        self.family_ws = _socket(self.host, "/ws/patient/", me["familyToken"])
        self.readers = [gevent.spawn(self._family), gevent.spawn(self._partner)]
        gevent.sleep(random.uniform(0, 10))  # not every phone at the same second

    def on_stop(self) -> None:
        now = time.perf_counter()
        _LOST[0] += sum(1 for sent in self.sent.values() if now - sent > LOST_AFTER_S)
        for reader in self.readers:
            reader.kill()
        for ws in (self.partner_ws, self.family_ws):
            ws.close()

    def _family(self) -> None:
        """booking.location reaches the family: the point's number is in its latitude."""
        while True:
            message = json.loads(self.family_ws.recv())
            if message.get("type") != "booking.location":
                continue
            seq = round((float(message["data"]["lat"]) - self.me["lat"]) / STEP)
            started = self.sent.pop(seq, None)
            if started is not None:
                _report("location → family", started)

    def _partner(self) -> None:
        while True:
            message = json.loads(self.partner_ws.recv())
            if message.get("type") == "location.rejected":
                _report("location → family", time.perf_counter(), RuntimeError(str(message)))

    @task
    def location(self) -> None:
        self.seq += 1
        self.sent[self.seq] = time.perf_counter()
        point = {
            "bookingId": self.me["bookingId"],
            "lat": f"{self.me['lat'] + self.seq * STEP:.6f}",
            "lng": f"{self.me['lng']:.6f}",
            "accuracy": 8.0,
            "mock": False,
        }
        self.partner_ws.send(json.dumps({"type": "location.update", "data": point}))
        if self.seq % 6 == 1:
            self.client.get("/v1/partner/home", headers=self.auth, name="/v1/partner/home")


class Booker(HttpUser):
    """Patients booking (30 a minute in all)."""

    fixed_count = BOOKERS
    wait_time = constant_throughput(BOOKINGS_PER_MINUTE / 60 / BOOKERS)

    @task
    def book(self) -> None:
        me = PATIENTS[next(_patient_turns) % len(PATIENTS)]  # at most a few unpaid each
        auth = {"Authorization": f"Bearer {me['token']}"}
        self.client.get("/v1/public/services", name="/v1/public/services")
        first = self.client.get(
            f"/v1/patient/booking-times?serviceId={SERVICE}",
            headers=auth,
            name="/v1/patient/booking-times",
        ).json()
        days = [d["date"] for d in first["days"] if d["available"]]
        times = self.client.get(
            f"/v1/patient/booking-times?serviceId={SERVICE}&date={random.choice(days)}",
            headers=auth,
            name="/v1/patient/booking-times?date",
        ).json()["times"]
        if not times:
            return
        booking = self.client.post(
            "/v1/patient/bookings",
            json={
                "serviceId": SERVICE,
                "memberId": me["memberId"],
                "addressId": me["addressId"],
                "pickupAt": random.choice(times),
                "documentIds": [],
                "notes": "",
            },
            headers=auth | {"Idempotency-Key": uuid.uuid4().hex},
            name="/v1/patient/bookings",
        )
        if booking.ok:
            self.client.get(
                f"/v1/patient/bookings/{booking.json()['id']}",
                headers=auth,
                name="/v1/patient/bookings/:id",
            )


_ENV: list = []


@events.init.add_listener
def _keep(environment, **kwargs) -> None:
    _ENV.append(environment)


@events.spawning_complete.add_listener
def _warm_up(user_count, **kwargs) -> None:
    """Count from WARM_UP_S seconds after the last user started."""
    gevent.spawn_later(WARM_UP_S, _ENV[0].stats.reset_all)


@events.quitting.add_listener
def _verdict(environment, **kwargs) -> None:
    """Fail the run when a request type misses the target, anything failed (also an error in a
    user's own code, which Locust would otherwise only list), or live points got lost."""
    stats = environment.stats
    slow = [
        f"{s.method} {s.name}: p95 {s.get_response_time_percentile(0.95):.0f} ms"
        for s in stats.entries.values()
        if s.num_requests and s.get_response_time_percentile(0.95) > P95_TARGET_MS
    ]
    total = stats.total
    print(
        f"\nRESULT: {total.num_requests} requests, {total.num_failures} failed, "
        f"p95 {total.get_response_time_percentile(0.95):.0f} ms (target < {P95_TARGET_MS} ms)"
    )
    for line in slow:
        print("  too slow:", line)
    errors = sum(e["occurrences"] for e in environment.runner.errors.values()) if environment.runner else 0
    errors += len(environment.runner.exceptions) if environment.runner else 0
    if errors:
        print(f"  errors in the test itself: {errors} (see the report)")
    if _LOST[0]:
        print(f"  live points that never reached the family: {_LOST[0]}")
    failed = slow or total.num_failures or errors or _LOST[0]
    environment.process_exit_code = 1 if failed else 0
