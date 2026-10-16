# Live check (Phase 9C): the family's inbox and bell. A booking is paid (BOOKING_CONFIRMED) and a
# partner accepts (BOOKING_ASSIGNED): both reach the family's inbox and the live socket says
# `notification.new` with the new count at once. Run in the api container (see README.md).
import asyncio
import json
import os
import threading
import time
import uuid

import pyotp
import requests
import websockets

BASE, WS = "http://localhost:8000", "ws://localhost:8000"
RUN = uuid.uuid4().hex[:6]
results = []


def check(name, ok, detail=""):
    results.append((name, bool(ok), detail))
    print(("PASS  " if ok else "FAIL  ") + name + (f"  [{detail}]" if detail else ""), flush=True)


class Api:
    def __init__(self):
        self.token, self.s = None, requests.Session()

    def call(self, m, p, b=None, params=None):
        h = {"Idempotency-Key": uuid.uuid4().hex}
        if self.token:
            h["Authorization"] = f"Bearer {self.token}"
        return self.s.request(m, BASE + p, json=b, params=params, headers=h, timeout=40)

    def get(self, p, params=None):
        return self.call("GET", p, params=params)

    def post(self, p, b=None):
        return self.call("POST", p, b if b is not None else {})


def otp(api, phone, purpose):
    dev = f"e2e-inbox-{RUN}-{phone[-2:]}"
    requests.post(BASE + "/v1/auth/otp/send", json={"phone": phone, "purpose": purpose, "deviceId": dev}, timeout=20)
    api.token = requests.post(BASE + "/v1/auth/otp/verify", json={"phone": phone, "otp": "123456", "purpose": purpose, "deviceId": dev}, timeout=20).json()["accessToken"]


def admin_login(api):
    for _ in range(3):
        r = requests.post(BASE + "/v1/admin/auth/login", json={"email": os.environ["DEV_QA_ADMIN_EMAIL"], "password": os.environ["DEV_QA_ADMIN_PASSWORD"]}, timeout=20).json()
        if r["step"] == "SIGNED_IN":
            api.token = r["signedIn"]["accessToken"]
            return
        t = requests.post(BASE + "/v1/admin/auth/totp", json={"challengeToken": r["challengeToken"], "code": pyotp.TOTP(os.environ["DEV_QA_ADMIN_TOTP_SECRET"]).now()}, timeout=20)
        if t.status_code == 200:
            api.token = t.json()["accessToken"]
            return
        time.sleep(31 - time.time() % 30)


class Sock:
    def __init__(self, audience, token):
        self.msgs, self.ready = [], threading.Event()
        threading.Thread(target=lambda: asyncio.run(self._main(audience, token)), daemon=True).start()
        self.ready.wait(10)

    async def _main(self, audience, token):
        async with websockets.connect(f"{WS}/ws/{audience}/") as ws:
            await ws.send(json.dumps({"type": "auth", "token": token}))
            async for raw in ws:
                m = json.loads(raw)
                if m.get("type") == "auth.ok":
                    self.ready.set()
                else:
                    self.msgs.append((time.time(), m))

    def wait(self, since, kind, timeout=10):
        end = time.time() + timeout
        while time.time() < end:
            for t, m in list(self.msgs):
                if t >= since and m.get("type") == "notification.new" and (m.get("data") or {}).get("type") == kind:
                    return t, m["data"]
            time.sleep(0.01)
        return None, None


admin, patient, asha = Api(), Api(), Api()
admin_login(admin)
otp(patient, "+919000000001", "login")
otp(asha, "+919000000003", "partner_primary")
p_sock = Sock("patient", patient.token)
before = patient.get("/v1/patient/notifications/unread-count").json()["unread"]
check("family bell count readable", True, f"{before} unread before")

svc = next(s for s in requests.get(BASE + "/v1/public/services", timeout=10).json() if s["isActive"] and s["partnerType"] == "COMPANION")
me = next(m for m in patient.get("/v1/patient/members").json() if m["isSelf"])
addr = next(a for a in patient.get("/v1/patient/addresses").json() if a["memberId"] == me["id"])
times = patient.get("/v1/patient/booking-times", params={"serviceId": svc["id"]}).json()["times"]
b = patient.post("/v1/patient/bookings", {"serviceId": svc["id"], "memberId": me["id"], "addressId": addr["id"], "pickupAt": times[-1], "hospitalText": "Capital Hospital" if svc["visitType"] == "HOSPITAL_VISIT" else "", "notes": f"E2E inbox {RUN}"}).json()
co = patient.post(f"/v1/patient/bookings/{b['id']}/checkout").json()
from apps.payments import gateway as gw  # noqa: E402
from apps.payments import services as pay  # noqa: E402

t0 = time.time()
pay.captured(co["orderId"], gw.GatewayPayment(id=f"pay_e2esim_{RUN}", order_id=co["orderId"], status="captured", amount=co["amountPaise"], method="upi"))
t, data = p_sock.wait(t0, "BOOKING_CONFIRMED")
check("'Booking confirmed' reaches the family's bell live", t is not None, f"{int((t - t0) * 1000)} ms, unread {data['unread']}" if t else "")
asha_id = next(c["partnerId"] for c in admin.get(f"/v1/admin/bookings/{b['id']}/candidates").json() if c["phone"].replace(" ", "").endswith("9000000003"))
state = admin.get(f"/v1/admin/bookings/{b['id']}/assignment").json()
admin.post(f"/v1/admin/bookings/{b['id']}/assign", {"partnerId": asha_id, "expectedAssignmentId": state.get("currentAssignmentId")})
offer = next(o for o in asha.get("/v1/partner/offers").json() if o["bookingId"] == b["id"])
t0 = time.time()
asha.post(f"/v1/partner/offers/{offer['assignmentId']}/accept")
t, data = p_sock.wait(t0, "BOOKING_ASSIGNED")
check("'Partner assigned' reaches the family's bell live", t is not None, f"{int((t - t0) * 1000)} ms, unread {data['unread']}" if t else "")
items = patient.get("/v1/patient/notifications").json()["items"]
check("both are in the family's inbox, newest first, linked to the booking", [n["type"] for n in items[:2]] == ["BOOKING_ASSIGNED", "BOOKING_CONFIRMED"] and items[0]["data"].get("bookingId") == b["id"], ", ".join(n["type"] for n in items[:3]))
check("the bell counts them", patient.get("/v1/patient/notifications/unread-count").json()["unread"] == before + 2)
print(f"\nBOOKING {b['code']} (left ACCEPTED with Asha for the app check)")
print(f"== RESULT: {sum(1 for _, ok, _ in results if ok)}/{len(results)} passed")
