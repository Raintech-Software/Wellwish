# Live test 3: an offer nobody answers → at 2 minutes the admin gets the alert (with call
# buttons) and the partner a reminder; "Accepted by phone" then works. Run in the api container.
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


def err(r):
    try:
        e = r.json().get("error", {})
        return f"{r.status_code} {e.get('code')} {e.get('message')}"
    except Exception:
        return str(r.status_code)


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
    dev = f"e2e-to-{RUN}-{phone[-2:]}"
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

    def find(self, since, pred):
        return next(((t, m) for t, m in list(self.msgs) if t >= since and pred(m)), (None, None))


admin, patient, rina = Api(), Api(), Api()
admin_login(admin)
otp(patient, "+919000000001", "login")
otp(rina, "+919000000005", "partner_primary")
s_sock, r_sock = Sock("staff", admin.token), Sock("partner", rina.token)
svc = next(s for s in requests.get(BASE + "/v1/public/services", timeout=10).json() if s["isActive"] and s["partnerType"] == "COMPANION")
me = next(m for m in patient.get("/v1/patient/members").json() if m["isSelf"])
addr = next(a for a in patient.get("/v1/patient/addresses").json() if a["memberId"] == me["id"])
times = patient.get("/v1/patient/booking-times", params={"serviceId": svc["id"]}).json()["times"]
b = patient.post("/v1/patient/bookings", {"serviceId": svc["id"], "memberId": me["id"], "addressId": addr["id"], "pickupAt": times[len(times) // 2], "hospitalText": "Capital Hospital" if svc["visitType"] == "HOSPITAL_VISIT" else "", "notes": "E2E timeout"}).json()
co = patient.post(f"/v1/patient/bookings/{b['id']}/checkout").json()
from apps.payments import gateway as gw  # noqa: E402
from apps.payments import services as pay  # noqa: E402

pay.captured(co["orderId"], gw.GatewayPayment(id=f"pay_e2esim_{RUN}", order_id=co["orderId"], status="captured", amount=co["amountPaise"], method="upi"))
rina_id = next(c["partnerId"] for c in admin.get(f"/v1/admin/bookings/{b['id']}/candidates").json() if c["phone"].replace(" ", "").endswith("9000000005"))
state = admin.get(f"/v1/admin/bookings/{b['id']}/assignment").json()
t0 = time.time()
r = admin.post(f"/v1/admin/bookings/{b['id']}/assign", {"partnerId": rina_id, "expectedAssignmentId": state.get("currentAssignmentId")})
check("offer sent to Rina (she won't answer)", r.status_code == 200, err(r) if r.status_code != 200 else "")
print("   waiting 2 minutes for the timeout…", flush=True)
deadline = t0 + 150
alert_t = remind_t = None
while time.time() < deadline and not (alert_t and remind_t):
    alert_t = alert_t or s_sock.find(t0, lambda m: m.get("type") == "alert" and (m.get("data") or {}).get("kind") == "OFFER_TIMEOUT")[0]
    remind_t = remind_t or r_sock.find(t0, lambda m: m.get("type") in ("offer.reminder", "notification", "inbox.new") or "remind" in json.dumps(m).lower())[0]
    time.sleep(0.5)
check("admin alert 'not accepted in 2 minutes' arrives live", alert_t is not None, f"after {alert_t - t0:.0f} s" if alert_t else "none in 150 s")
inbox = rina.get("/v1/partner/notifications").json()["items"]
check("Rina gets a reminder in her inbox", any("OFFER_REMINDER" in (n.get("type") or "") for n in inbox), ", ".join(sorted({n["type"] for n in inbox[:5]})))
alerts = admin.get("/v1/admin/alerts", params={"open": True}).json()
items = alerts["items"] if isinstance(alerts, dict) else alerts
check("the alert is in the admin's open alerts", any(a.get("kind") == "OFFER_TIMEOUT" and (a.get("bookingId") == b["id"] or a.get("bookingCode") == b["code"] or a.get("code") == b["code"]) for a in items))
state = admin.get(f"/v1/admin/bookings/{b['id']}/assignment").json()
r = admin.post(f"/v1/admin/bookings/{b['id']}/accept-by-phone", {"reason": "Rina said yes on the phone (E2E)", "expectedAssignmentId": state.get("currentAssignmentId")})
check("admin records 'Accepted by phone'", r.status_code == 200, err(r) if r.status_code != 200 else "")
bb = patient.get(f"/v1/patient/bookings/{b['id']}").json()
check("booking ACCEPTED with Rina for the family", bb["status"] == "ACCEPTED" and bb["partner"] and "Rina" in bb["partner"]["fullName"], bb["status"])
r = admin.post(f"/v1/admin/bookings/{b['id']}/cancel", {"reason": "E2E cleanup", "refundPercent": 100})
check("cleanup: admin cancels the test booking", r.status_code == 200, err(r) if r.status_code != 200 else "")
print(f"\n== RESULT: {sum(1 for _, ok, _ in results if ok)}/{len(results)} passed")
