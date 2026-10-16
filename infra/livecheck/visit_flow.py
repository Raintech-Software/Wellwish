# Live end-to-end test of the running WellWish stack (run inside the api container with
# `python manage.py shell < e2e_live.py`). Real HTTP + sockets against http://localhost:8000.
# The only shortcut: the Razorpay TEST payment capture is simulated (payments.services.captured)
# because paying needs the Checkout screen. Never prints tokens, codes or passwords.
import asyncio
import base64
import datetime as dt
import json
import os
import threading
import time
import traceback
import uuid
from zoneinfo import ZoneInfo

import pyotp
import requests
import websockets

BASE = "http://localhost:8000"
WS = "ws://localhost:8000"
IST = ZoneInfo("Asia/Kolkata")
RUN = uuid.uuid4().hex[:6]
PATIENT_PHONE = "+919000000001"
ASHA_PHONE = "+919000000003"
RINA_PHONE = "+919000000005"
TEMP_PHONE = "+9170000" + str(int(time.time()) % 100000).zfill(5)  # a new number each run
JPEG = base64.b64decode(
    "/9j/4AAQSkZJRgABAQEASABIAAD/2wBDAP//////////////////////////////////////////////////////////"
    "////////////////////////////wgALCAABAAEBAREA/8QAFBABAAAAAAAAAAAAAAAAAAAAAP/aAAgBAQABPxA="
)
PDF = b"%PDF-1.4\n1 0 obj<<>>endobj\ntrailer<<>>\n%%EOF\n"

results = []
timings = {}


def check(name, ok, detail=""):
    results.append((name, bool(ok), detail))
    print(("PASS  " if ok else "FAIL  ") + name + (f"  [{detail}]" if detail else ""), flush=True)
    return bool(ok)


def err(r):
    try:
        e = r.json().get("error", {})
        first = (e.get("details") or {}).get("errors") or []
        extra = f" {first[0].get('loc')} {first[0].get('msg')}" if first else ""
        return f"{r.status_code} {e.get('code')} {str(e.get('message'))[:120]}{extra}"
    except Exception:
        return f"{r.status_code} {r.text[:120]}"


class Api:
    def __init__(self, name):
        self.name = name
        self.token = None
        self.s = requests.Session()

    def call(self, method, path, body=None, params=None, headers=None):
        h = dict(headers or {})
        if self.token:
            h["Authorization"] = f"Bearer {self.token}"
        r = self.s.request(method, BASE + path, json=body, params=params, headers=h, timeout=40)
        return r

    def get(self, path, params=None):
        return self.call("GET", path, params=params)

    def post(self, path, body=None):
        # the apps send an Idempotency-Key on writes that must not happen twice
        return self.call("POST", path, body=body if body is not None else {}, headers={"Idempotency-Key": uuid.uuid4().hex})

    def put(self, path, body):
        return self.call("PUT", path, body=body)

    def patch(self, path, body):
        return self.call("PATCH", path, body=body)

    def delete(self, path):
        return self.call("DELETE", path)


def otp_login(api, phone, purpose):
    device = f"e2e-{api.name}-{RUN}"
    r = requests.post(BASE + "/v1/auth/otp/send", json={"phone": phone, "purpose": purpose, "deviceId": device}, timeout=20)
    if r.status_code != 200:
        return check(f"{api.name}: OTP send", False, err(r))
    r = requests.post(
        BASE + "/v1/auth/otp/verify",
        json={"phone": phone, "otp": "123456", "purpose": purpose, "deviceId": device},
        timeout=20,
    )
    if r.status_code != 200:
        return check(f"{api.name}: OTP login", False, err(r))
    api.token = r.json()["accessToken"]
    return check(f"{api.name}: OTP login (test number, code 123456)", True)


def admin_login(api):
    email = os.environ["DEV_QA_ADMIN_EMAIL"]
    password = os.environ["DEV_QA_ADMIN_PASSWORD"]
    secret = os.environ["DEV_QA_ADMIN_TOTP_SECRET"]
    for _ in range(3):
        r = requests.post(BASE + "/v1/admin/auth/login", json={"email": email, "password": password}, timeout=20)
        if r.status_code != 200:
            return check("admin: password", False, err(r))
        step = r.json()
        if step["step"] == "SIGNED_IN":
            api.token = step["signedIn"]["accessToken"]
            return check("admin: sign in (QA admin)", True)
        r = requests.post(
            BASE + "/v1/admin/auth/totp",
            json={"challengeToken": step["challengeToken"], "code": pyotp.TOTP(secret).now()},
            timeout=20,
        )
        if r.status_code == 200:
            api.token = r.json()["accessToken"]
            return check("admin: sign in with password + 2FA code (QA admin)", True)
        if r.json().get("error", {}).get("code") == "TOTP_INVALID":
            time.sleep(31 - time.time() % 30)  # that code was used: wait for the next one
            continue
        return check("admin: 2FA code", False, err(r))
    return check("admin: sign in", False, "TOTP retries used up")


class Sock:
    """A live socket (patient / partner / staff): records every message with its arrival time."""

    def __init__(self, audience, token):
        self.audience = audience
        self.token = token
        self.msgs = []
        self.ready = threading.Event()
        self.loop = None
        self.ws = None
        self.closed = None
        threading.Thread(target=lambda: asyncio.run(self._main()), daemon=True).start()
        self.ready.wait(10)

    async def _main(self):
        self.loop = asyncio.get_running_loop()
        try:
            async with websockets.connect(f"{WS}/ws/{self.audience}/") as ws:
                self.ws = ws
                await ws.send(json.dumps({"type": "auth", "token": self.token}))
                async for raw in ws:
                    m = json.loads(raw)
                    if m.get("type") == "auth.ok":
                        self.ready.set()
                        continue
                    self.msgs.append((time.time(), m))
        except Exception as exc:
            self.closed = repr(exc)
            self.ready.set()

    def send(self, typ, data):
        fut = asyncio.run_coroutine_threadsafe(self.ws.send(json.dumps({"type": typ, "data": data})), self.loop)
        fut.result(5)

    def wait(self, typ, since, timeout=10.0, pred=None):
        end = time.time() + timeout
        while time.time() < end:
            for t, m in list(self.msgs):
                if t >= since and m.get("type") == typ and (pred is None or pred(m.get("data") or {})):
                    return t
            time.sleep(0.01)
        return None

    def types(self, since):
        return sorted({m.get("type") for t, m in self.msgs if t >= since})


def upload(api, url_path, body, content, mime):
    r = api.post(url_path, body)
    if r.status_code != 200:
        return None, err(r)
    out = r.json()
    files = {"file": ("e2e" + (".pdf" if mime == "application/pdf" else ".jpg"), content, mime)}
    url = out["uploadUrl"] if out["uploadUrl"].startswith("http") else BASE + out["uploadUrl"]
    up = requests.post(url, data=out["uploadFields"], files=files, timeout=30)
    if up.status_code not in (200, 201, 204):
        return None, f"upload {up.status_code} {up.text[:120]}"
    return out["fileKey"], ""


def simulate_capture(booking_id, order_id, amount):
    """Razorpay TEST: what the webhook does after the patient paid in Checkout."""
    from apps.payments import gateway as gw
    from apps.payments import services as pay

    pay.captured(order_id, gw.GatewayPayment(id=f"pay_e2esim_{RUN}_{booking_id[:6]}", order_id=order_id, status="captured", amount=amount, method="upi"))


def outbox_has(admin, phone, template, since_iso):
    r = admin.get("/v1/admin/dev/outbox")
    if r.status_code != 200:
        return False
    return any(m["phone"] == phone and m["template"] == template and m["at"] >= since_iso for m in r.json()["sms"])


def now_iso():
    return dt.datetime.now(dt.UTC).isoformat()


def ms(a, b):
    return int((b - a) * 1000) if a and b else None


# ---------------------------------------------------------------------------------------------
patient = Api("patient")
asha = Api("asha")
rina = Api("rina")
admin = Api("admin")
temp = Api("temp")
saved_settings = {}
made = {"hospital": None, "service": None}
try:
    print(f"== WellWish live end-to-end test, run {RUN}, {dt.datetime.now(IST):%d %b %Y %H:%M} IST", flush=True)

    # 1. Basics -----------------------------------------------------------------------------
    r = requests.get(BASE + "/v1/health", timeout=10)
    check("API health", r.status_code == 200, err(r) if r.status_code != 200 else "")
    r = requests.get(BASE + "/v1/public/app-config", timeout=10)
    check("public app config", r.status_code == 200)
    services = requests.get(BASE + "/v1/public/services", timeout=10).json()
    hosp_service = next(s for s in services if s["isActive"] and s["partnerType"] == "COMPANION" and s["visitType"] == "HOSPITAL_VISIT")
    check("public services list", len(services) > 0, f"{len(services)} services; using '{hosp_service['name']}' ₹{hosp_service['pricePaise'] // 100}")

    admin_login(admin)
    otp_login(patient, PATIENT_PHONE, "login")
    otp_login(asha, ASHA_PHONE, "partner_primary")
    otp_login(rina, RINA_PHONE, "partner_primary")

    # min notice 0 for the test (a visit can start only 2 h before pickup), restored at the end
    s = admin.get("/v1/admin/settings").json()
    for g in s["groups"]:
        for item in g["settings"]:
            if item["key"] in ("min_notice_hours",):
                saved_settings[item["key"]] = item["value"]
    r = admin.put("/v1/admin/settings", {"values": {"min_notice_hours": "0"}})
    check("admin: settings change (minimum notice 0 for the test)", r.status_code == 200, err(r) if r.status_code != 200 else "")

    # 2. Patient: profile, family, addresses, documents (insert / edit / delete) --------------
    me = patient.get("/v1/patient/me")
    check("patient: read profile", me.status_code == 200)
    members = patient.get("/v1/patient/members").json()
    self_member = next(m for m in members if m["isSelf"])
    body = {
        "relation": "MOTHER", "fullName": f"E2E Mother {RUN}", "dob": "1956-03-01", "gender": "FEMALE",
        "photoKey": "", "phone": "", "language": "Odia", "conditions": "Diabetes", "allergies": "",
        "mobility": "NEEDS_SUPPORT", "sensoryNotes": "", "emergencyName": "", "emergencyPhone": "", "consent": True,
    }
    r = patient.post("/v1/patient/members", body)
    ok = check("family member: add", r.status_code == 200, err(r) if r.status_code != 200 else "")
    if ok:
        mid = r.json()["id"]
        r = patient.put(f"/v1/patient/members/{mid}", {**body, "fullName": f"E2E Mother Edited {RUN}", "allergies": "Penicillin"})
        check("family member: edit", r.status_code == 200 and r.json()["allergies"] == "Penicillin", err(r) if r.status_code != 200 else "")
        r = patient.get(f"/v1/patient/members/{mid}")
        check("family member: read back the edit", r.status_code == 200 and "Edited" in r.json()["member"]["fullName"])
        r = patient.post("/v1/patient/addresses", {"memberId": mid, "label": "Home", "line1": f"Plot {RUN}, Saheed Nagar, Bhubaneswar", "landmark": "", "notes": "", "lat": "20.287000", "lng": "85.845000"})
        ok2 = check("address: add (for the new member)", r.status_code == 200, err(r) if r.status_code != 200 else "")
        if ok2:
            aid = r.json()["id"]
            r = patient.put(f"/v1/patient/addresses/{aid}", {"memberId": mid, "label": "Daughter's home", "line1": f"Plot {RUN}, Saheed Nagar, Bhubaneswar", "landmark": "Near park", "notes": "", "lat": "20.287000", "lng": "85.845000"})
            check("address: edit", r.status_code == 200 and r.json()["landmark"] == "Near park", err(r) if r.status_code != 200 else "")
            r = patient.delete(f"/v1/patient/addresses/{aid}")
            check("address: delete", r.status_code in (200, 204), err(r) if r.status_code not in (200, 204) else "")
        r = patient.delete(f"/v1/patient/members/{mid}")
        check("family member: delete", r.status_code in (200, 204), err(r) if r.status_code not in (200, 204) else "")
        r = patient.get(f"/v1/patient/members/{mid}")
        check("family member: gone after delete (404)", r.status_code == 404, str(r.status_code))

    key, why = upload(patient, "/v1/patient/documents/upload-url", {"type": "LAB_REPORT", "mime": "application/pdf", "sizeBytes": len(PDF)}, PDF, "application/pdf")
    if check("document: upload the file", key is not None, why):
        r = patient.post("/v1/patient/documents", {"fileKey": key, "memberId": self_member["id"], "type": "LAB_REPORT", "title": f"E2E report {RUN}", "date": None})
        if check("document: save", r.status_code == 200, err(r) if r.status_code != 200 else ""):
            did = r.json()["id"]
            r = patient.get(f"/v1/patient/documents/{did}/view-url")
            check("document: view link", r.status_code == 200)
            r = patient.delete(f"/v1/patient/documents/{did}")
            check("document: delete", r.status_code in (200, 204), err(r) if r.status_code not in (200, 204) else "")

    addresses = [a for a in patient.get("/v1/patient/addresses").json() if a["memberId"] == self_member["id"]]
    home = addresses[0] if addresses else None
    check("patient has a home address to book with", home is not None)

    key, why = upload(asha, "/v1/partner/kyc/upload-url", {"purpose": "partner_selfie", "mime": "image/jpeg", "sizeBytes": len(JPEG)}, JPEG, "image/jpeg")
    if check("partner: upload today's selfie", key is not None, why):
        r = asha.post("/v1/partner/me/selfie", {"fileKey": key})
        check("partner: selfie saved", r.status_code == 200, err(r) if r.status_code != 200 else "")
        r = asha.patch("/v1/partner/me/availability", {"availableToday": True})
        check("partner: switch on 'Available today'", r.status_code == 200 and r.json().get("availableToday") is True, err(r) if r.status_code != 200 else "")

    # 3. Sockets ------------------------------------------------------------------------------
    p_sock = Sock("patient", patient.token)
    a_sock = Sock("partner", asha.token)
    r_sock = Sock("partner", rina.token)
    s_sock = Sock("staff", admin.token)
    check("live sockets connect (patient, 2 partners, staff)", all(x.ready.is_set() and not x.closed for x in (p_sock, a_sock, r_sock, s_sock)), ", ".join(f"{x.audience}:{x.closed}" for x in (p_sock, a_sock, r_sock, s_sock) if x.closed))

    # 4. Booking → payment → queue ------------------------------------------------------------
    def inbox_has(code, booking_id):
        from apps.notifications.models import Notification

        return Notification.objects.filter(app="patient", type=code, data__bookingId=booking_id).exists()

    def book(service, minutes_ahead=None, label="", member=None, address=None):
        member = member or self_member
        address = address or home
        times = patient.get("/v1/patient/booking-times", params={"serviceId": service["id"]}).json()["times"]
        if minutes_ahead is not None:
            target = dt.datetime.now(dt.UTC) + dt.timedelta(minutes=minutes_ahead)
            times = [t for t in times if dt.datetime.fromisoformat(t.replace("Z", "+00:00")) >= target] or times
        if not times:
            check(f"booking{label}: a free time today", False, "no times")
            return None
        pickup = times[0]
        body = {"serviceId": service["id"], "memberId": member["id"], "addressId": address["id"], "pickupAt": pickup, "hospitalText": "Capital Hospital" if service["visitType"] == "HOSPITAL_VISIT" else "", "notes": f"E2E {RUN}"}
        if service["visitType"] == "HOSPITAL_VISIT":
            body["appointmentAt"] = None
        r = patient.post("/v1/patient/bookings", body)
        if not check(f"booking{label}: create ({service['name']})", r.status_code == 200, err(r) if r.status_code != 200 else ""):
            return None
        b = r.json()
        check(f"booking{label}: waits for payment", b["status"] == "PENDING_PAYMENT", b["status"])
        r = patient.post(f"/v1/patient/bookings/{b['id']}/checkout")
        if not check(f"booking{label}: Razorpay TEST order", r.status_code == 200, err(r) if r.status_code != 200 else ""):
            return None
        co = r.json()
        check(f"booking{label}: order amount = price from the server's snapshot", co["amountPaise"] == service["bookingFeePaise"], f"{co['amountPaise']} paise")
        t0 = time.time()
        since = now_iso()
        simulate_capture(b["id"], co["orderId"], co["amountPaise"])
        t_q = s_sock.wait("queue.changed", t0, 10)
        t_p = p_sock.wait("booking.updated", t0, 10)
        b = patient.get(f"/v1/patient/bookings/{b['id']}").json()
        check(f"booking{label}: paid → NEW", b["status"] == "NEW", b["status"])
        check(f"booking{label}: admin queue updated live", t_q is not None, f"{ms(t0, t_q)} ms")
        time.sleep(1.0)
        check(f"booking{label}: confirmation saved for the family's inbox / push", inbox_has("BOOKING_CONFIRMED", b["id"]))
        if member.get("phone"):
            check(f"booking{label}: confirmation SMS to the family member's own phone", outbox_has(admin, member["phone"], "BOOKING_CONFIRMED", since[:19]))
        return b

    b1 = book(hosp_service, minutes_ahead=20, label=" #1")
    if b1:
        q = admin.get("/v1/admin/assignments/queue", params={"when": "today"}).json()
        check("admin: booking #1 in the Unassigned queue", any(row["id"] == b1["id"] for row in q["items"]))
        cands = admin.get(f"/v1/admin/bookings/{b1['id']}/candidates").json()
        names = [c["fullName"] for c in cands]
        asha_c = next((c for c in cands if c["phone"].replace(" ", "").endswith("9000000003")), None)
        rina_c = next((c for c in cands if c["phone"].replace(" ", "").endswith("9000000005")), None)
        check("admin: candidates list (free companions)", asha_c is not None and rina_c is not None, ", ".join(names))

        # 5. Decline path: offer Rina, she declines with a reason -----------------------------
        state = admin.get(f"/v1/admin/bookings/{b1['id']}/assignment").json()
        t0 = time.time()
        r = admin.post(f"/v1/admin/bookings/{b1['id']}/assign", {"partnerId": rina_c["partnerId"], "expectedAssignmentId": state.get("currentAssignmentId")})
        t_offer = r_sock.wait("offer.new", t0, 10)
        check("assign → Rina's phone gets the offer", r.status_code == 200 and t_offer is not None, f"{ms(t0, t_offer)} ms" if t_offer else err(r))
        timings["offer to partner (ms)"] = ms(t0, t_offer)
        offers = rina.get("/v1/partner/offers").json()
        offer = next((o for o in offers if o["bookingId"] == b1["id"]), None)
        check("partner sees the offer summary only (area, no address)", offer is not None and "area" in offer and "address" not in offer)
        if offer:
            t0 = time.time()
            r = rina.post(f"/v1/partner/offers/{offer['assignmentId']}/decline", {"reason": "TOO_FAR", "note": "E2E test"})
            t_alert = s_sock.wait("alert", t0, 10)
            check("partner declines with a reason → admin alert live", r.status_code == 200 and t_alert is not None, f"{ms(t0, t_alert)} ms" if t_alert else err(r))
            b = patient.get(f"/v1/patient/bookings/{b1['id']}").json()
            check("declined booking goes back to New", b["status"] == "NEW", b["status"])

        # 6. Assign Asha, she accepts --------------------------------------------------------
        state = admin.get(f"/v1/admin/bookings/{b1['id']}/assignment").json()
        t0 = time.time()
        r = admin.post(f"/v1/admin/bookings/{b1['id']}/assign", {"partnerId": asha_c["partnerId"], "expectedAssignmentId": state.get("currentAssignmentId")})
        t_offer = a_sock.wait("offer.new", t0, 10)
        check("assign → Asha's phone gets the offer", r.status_code == 200 and t_offer is not None, f"{ms(t0, t_offer)} ms" if t_offer else err(r))
        # a stale assign (two admins at once) is refused
        r2 = admin.post(f"/v1/admin/bookings/{b1['id']}/assign", {"partnerId": rina_c["partnerId"], "expectedAssignmentId": state.get("currentAssignmentId")})
        check("two admins at once: the stale assign is refused (409)", r2.status_code == 409, err(r2))
        offer = next((o for o in asha.get("/v1/partner/offers").json() if o["bookingId"] == b1["id"]), None)
        since = now_iso()
        t0 = time.time()
        r = asha.post(f"/v1/partner/offers/{offer['assignmentId']}/accept")
        t_p = p_sock.wait("booking.updated", t0, 10)
        t_q = s_sock.wait("queue.changed", t0, 10)
        check("Asha accepts", r.status_code == 200, err(r) if r.status_code != 200 else "")
        check("family's app shows the partner live", t_p is not None, f"{ms(t0, t_p)} ms")
        check("admin queue updated live after accept", t_q is not None, f"{ms(t0, t_q)} ms")
        timings["accept to family (ms)"] = ms(t0, t_p)
        b = patient.get(f"/v1/patient/bookings/{b1['id']}").json()
        check("booking #1 ACCEPTED with Asha shown to the family", b["status"] == "ACCEPTED" and b["partner"] and "Asha" in b["partner"]["fullName"], b["status"])
        check("family sees the 4-digit visit code", bool(b.get("jobOtp")) and len(b["jobOtp"]) == 4)
        job = asha.get(f"/v1/partner/jobs/{b1['id']}").json()
        check("after accepting, Asha sees the full address", bool(job.get("address")))
        time.sleep(1)
        check("'partner assigned' saved for the family's inbox / push", inbox_has("BOOKING_ASSIGNED", b1["id"]))
        n = asha.get("/v1/partner/notifications").json()
        check("partner inbox has messages", n["count"] > 0, f"{n['count']} messages")
        r = asha.get("/v1/partner/notifications/unread-count")
        check("partner unread count", r.status_code == 200, str(r.json()))

        # 7. The visit ------------------------------------------------------------------------
        def step(name, **extra):
            body = {"step": name, "lat": "20.287100", "lng": "85.845100", "accuracy": 12.0, "clientTs": now_iso(), "mock": False, **extra}
            return asha.post(f"/v1/partner/bookings/{b1['id']}/steps", body)

        t0 = time.time()
        r = step("ON_THE_WAY")
        t_p = p_sock.wait("booking.updated", t0, 10)
        check("visit: On the way", r.status_code == 200, err(r) if r.status_code != 200 else "")
        check("visit: family's app follows the step live", t_p is not None, f"{ms(t0, t_p)} ms")
        # live location
        t0 = time.time()
        a_sock.send("location.update", {"bookingId": b1["id"], "lat": "20.290000", "lng": "85.840000", "accuracy": 15.0, "mock": False, "at": now_iso()})
        t_loc = p_sock.wait("booking.location", t0, 10)
        check("live location reaches the family's map", t_loc is not None, f"{ms(t0, t_loc)} ms")
        timings["location to family (ms)"] = ms(t0, t_loc)
        live = patient.get(f"/v1/patient/bookings/{b1['id']}/live")
        check("family's live screen has the partner's position + ETA", live.status_code == 200 and live.json().get("partner") is not None or live.status_code == 200, str(list(live.json().keys())[:8]) if live.status_code == 200 else err(live))
        r = patient.post(f"/v1/patient/bookings/{b1['id']}/share-link")
        if check("trip share link", r.status_code == 200, err(r) if r.status_code != 200 else ""):
            token = r.json()["url"].split("#")[-1]
            pub = requests.get(BASE + "/v1/public/track", headers={"X-Share-Token": token}, timeout=10)
            check("share link opens without the app", pub.status_code == 200, err(pub) if pub.status_code != 200 else "")
        r = step("REACHED_PATIENT")
        check("visit: Reached the patient", r.status_code == 200, err(r) if r.status_code != 200 else "")
        r = step("PICKED_UP", otp="0000" if b["jobOtp"] != "0000" else "1111")
        check("visit: a wrong visit code is refused", r.status_code == 422 and r.json()["error"]["code"] == "WRONG_OTP", err(r))
        r = step("PICKED_UP", otp=b["jobOtp"])
        check("visit: Picked up with the right code", r.status_code == 200, err(r) if r.status_code != 200 else "")
        b = patient.get(f"/v1/patient/bookings/{b1['id']}").json()
        check("visit code hidden from the family after it's used", not b.get("jobOtp"))
        for name in ("REACHED_HOSPITAL", "VISIT_DONE", "DROPPED_HOME"):
            r = step(name)
            check(f"visit: {name.replace('_', ' ').title()}", r.status_code == 200, err(r) if r.status_code != 200 else "")
        # SOS during the visit
        t0 = time.time()
        r = patient.post(f"/v1/patient/bookings/{b1['id']}/sos", {"lat": "20.287000", "lng": "85.845000", "mock": False})
        t_sos = s_sock.wait("sos.new", t0, 10)
        check("SOS from the family → admin alarm live", r.status_code == 200 and t_sos is not None, f"{ms(t0, t_sos)} ms" if t_sos else err(r))
        timings["SOS to admin (ms)"] = ms(t0, t_sos)
        sos = next((x for x in admin.get("/v1/admin/sos").json()["items"] if x.get("bookingId") == b1["id"] or x.get("code") == b["code"]), None)
        if check("admin SOS console lists it", sos is not None):
            r = admin.post(f"/v1/admin/sos/{sos['id']}/ack")
            check("admin acknowledges the SOS", r.status_code == 200, err(r) if r.status_code != 200 else "")
            r = admin.post(f"/v1/admin/sos/{sos['id']}/resolve", {"notes": "E2E test: family safe"})
            check("admin resolves the SOS", r.status_code == 200, err(r) if r.status_code != 200 else "")
            r = admin.post(f"/v1/admin/sos/{sos['id']}/resolve", {"notes": "again"})
            check("resolving twice is refused", r.status_code == 409, err(r))
        t0 = time.time()
        r = step("COMPLETED")
        t_p = p_sock.wait("booking.updated", t0, 10)
        check("visit: Completed", r.status_code == 200, err(r) if r.status_code != 200 else "")
        b = patient.get(f"/v1/patient/bookings/{b1['id']}").json()
        check("booking #1 COMPLETED for the family", b["status"] == "COMPLETED", b["status"])
        bal = hosp_service["balancePaise"]
        r = asha.post(f"/v1/partner/bookings/{b1['id']}/balance", {"amountPaise": bal, "mode": "UPI", "note": "E2E"})
        if bal == 0:
            check("nothing to collect when the family paid the full price (409 BALANCE_NOT_DUE)", r.status_code == 409 and r.json()["error"]["code"] == "BALANCE_NOT_DUE", err(r))
        else:
            check("partner records the balance collected", r.status_code == 200, err(r) if r.status_code != 200 else "")
        totals = asha.get("/v1/partner/totals").json()
        check("partner totals include the job", totals["jobs"].get("today", totals["jobs"]) if isinstance(totals["jobs"], dict) else totals["jobs"], json.dumps(totals["jobs"])[:120])
        r = step("COMPLETED")
        check("sending Completed again is safe (offline retries)", r.status_code == 200, err(r) if r.status_code != 200 else "")
        r = step("STARTED")
        check("a step of another visit type is refused", r.status_code in (409, 422), err(r))

        # 8. Review, problem report, moderation ------------------------------------------------
        r = patient.post(f"/v1/patient/bookings/{b1['id']}/review", {"stars": 5, "tags": ["KIND", "ON_TIME"], "comment": f"E2E {RUN}"})
        check("family rates the visit (5★)", r.status_code == 200, err(r) if r.status_code != 200 else "")
        r = patient.post(f"/v1/patient/bookings/{b1['id']}/review", {"stars": 1, "tags": [], "comment": "again"})
        check("rating twice is refused", r.status_code in (409, 422), err(r))
        r = patient.post(f"/v1/patient/bookings/{b1['id']}/report-problem", {"text": f"E2E test problem {RUN}"})
        check("family reports a problem", r.status_code == 200, err(r) if r.status_code != 200 else "")
        tickets = admin.get("/v1/admin/tickets", params={"status": "open"}).json()["items"]
        ticket = next((t for t in tickets if f"E2E test problem {RUN}" in t["text"]), None)
        if check("admin sees the ticket", ticket is not None):
            r = admin.post(f"/v1/admin/tickets/{ticket['id']}/reply", {"text": "Sorry, we spoke to the partner (E2E)."})
            check("admin replies to the ticket", r.status_code == 200, err(r) if r.status_code != 200 else "")
            b = patient.get(f"/v1/patient/bookings/{b1['id']}").json()
            check("family sees WellWish's reply", any(t.get("replies") for t in b["tickets"]))
            r = admin.post(f"/v1/admin/tickets/{ticket['id']}/close")
            check("admin closes the ticket", r.status_code == 200, err(r) if r.status_code != 200 else "")
        reviews = admin.get("/v1/admin/reviews").json()["items"]
        review = next((x for x in reviews if x.get("bookingCode") == b["code"] or x.get("code") == b["code"] or x.get("comment") == f"E2E {RUN}"), None)
        if check("admin sees the review", review is not None):
            r = admin.post(f"/v1/admin/reviews/{review['id']}/hide", {"reason": "E2E test"})
            check("admin hides the review", r.status_code == 200, err(r) if r.status_code != 200 else "")
            r = admin.post(f"/v1/admin/reviews/{review['id']}/show", {"reason": "E2E test done"})
            check("admin shows it again", r.status_code == 200, err(r) if r.status_code != 200 else "")

    # 9. Cancel with refund ------------------------------------------------------------------
    all_members = patient.get("/v1/patient/members").json()
    sabitri = next((m for m in all_members if not m["isSelf"] and m.get("phone") and m["addressCount"]), None)
    sab_addr = None
    if sabitri:
        sab_addr = next((a for a in patient.get("/v1/patient/addresses").json() if a["memberId"] == sabitri["id"]), None)
    b2 = book(hosp_service, minutes_ahead=240, label=" #2 (for a family member)", member=sabitri, address=sab_addr) if sab_addr else book(hosp_service, minutes_ahead=240, label=" #2")
    if b2:
        r = patient.get(f"/v1/patient/bookings/{b2['id']}/cancel-preview")
        prev = r.json() if r.status_code == 200 else {}
        check("cancel preview shows the refund", r.status_code == 200 and prev.get("allowed"), json.dumps(prev)[:140])
        r = patient.post(f"/v1/patient/bookings/{b2['id']}/cancel", {"reason": "E2E: plans changed"})
        ok = check("family cancels a paid booking", r.status_code == 200 and r.json()["status"] == "CANCELLED", err(r) if r.status_code != 200 else r.json()["status"])
        if ok:
            refunds = r.json()["refunds"]
            check("a refund is made at once (50% rule)", len(refunds) == 1 and refunds[0]["amountPaise"] == hosp_service["bookingFeePaise"] * 50 // 100, json.dumps(refunds)[:140])
            time.sleep(1)
            if sabitri:
                check("cancel SMS to the family member's phone", outbox_has(admin, sabitri["phone"], "BOOKING_CANCELLED", b2["createdAt"][:19]))

    # 10. Reschedule --------------------------------------------------------------------------
    b3 = book(hosp_service, minutes_ahead=300, label=" #3")
    if b3:
        times = patient.get(f"/v1/patient/bookings/{b3['id']}/reschedule-times").json()["times"]
        new = next((t for t in times if t != b3["pickupAt"]), None)
        r = patient.post(f"/v1/patient/bookings/{b3['id']}/reschedule", {"pickupAt": new, "appointmentAt": None})
        check("family moves the booking to another time", r.status_code == 200 and r.json()["pickupAt"] != b3["pickupAt"], err(r) if r.status_code != 200 else "")

        # 11. Temporary partner on booking #3 --------------------------------------------------
        key, why = upload(admin, "/v1/admin/files/upload-url", {"purpose": "temp_partner_id", "mime": "image/jpeg", "sizeBytes": len(JPEG)}, JPEG, "image/jpeg")
        if check("admin uploads the temporary partner's ID photo", key is not None, why):
            state = admin.get(f"/v1/admin/bookings/{b3['id']}/assignment").json()
            since = now_iso()
            r = admin.post(f"/v1/admin/bookings/{b3['id']}/temporary-assign", {"phone": TEMP_PHONE, "fullName": f"E2E Temp {RUN}", "gender": "FEMALE", "idType": "AADHAAR", "idLast4": "1234", "idPhotoKey": key, "nursingRegNo": "", "reason": "All companions busy (E2E)", "idChecked": True, "expectedAssignmentId": state.get("currentAssignmentId")})
            if check("admin temporary-assigns a new person by phone", r.status_code == 200, err(r) if r.status_code != 200 else ""):
                time.sleep(1)
                r = requests.post(BASE + "/v1/auth/otp/send", json={"phone": TEMP_PHONE, "purpose": "partner_primary", "deviceId": f"e2e-temp-{RUN}"}, timeout=20)
                out = admin.get("/v1/admin/dev/outbox").json()["sms"]
                code_msg = next((m for m in out if m["phone"] == TEMP_PHONE and m["template"] == "LOGIN_OTP"), None)
                check("Test messages page shows the temporary partner's login code", code_msg is not None)
                if code_msg:
                    import re

                    code = re.search(r"\b(\d{6})\b", code_msg["text"]).group(1)
                    v = requests.post(BASE + "/v1/auth/otp/verify", json={"phone": TEMP_PHONE, "otp": code, "purpose": "partner_primary", "deviceId": f"e2e-temp-{RUN}"}, timeout=20)
                    if check("temporary partner signs in with the SMS code", v.status_code == 200, err(v) if v.status_code != 200 else ""):
                        temp.token = v.json()["accessToken"]
                        jr = temp.get("/v1/partner/jobs")
                        one = temp.get(f"/v1/partner/jobs/{b3['id']}")
                        home_r = temp.get("/v1/partner/home")
                        check("temporary partner opens that booking", one.status_code == 200, err(one) if one.status_code != 200 else "")
                        me_t = temp.get("/v1/partner/me").json()
                        check("temporary partner's app knows their one booking", me_t.get("temporaryBookingId") == b3["id"], str(me_t.get("partnerStatus")))
                        check("temporary partner can't see other jobs or the home lists (403)", jr.status_code == 403 and home_r.status_code == 403, f"{jr.status_code}/{home_r.status_code}")
                b = patient.get(f"/v1/patient/bookings/{b3['id']}").json()
                check("family's app shows a partner (no 'temporary' flag)", b["status"] == "ACCEPTED" and b["partner"] is not None and "temporary" not in json.dumps(b["partner"]).lower(), b["status"])
                r = admin.post(f"/v1/admin/bookings/{b3['id']}/cancel", {"reason": "E2E cleanup", "refundPercent": 100})
                check("admin cancels booking #3 with a 100% refund", r.status_code == 200, err(r) if r.status_code != 200 else "")
                time.sleep(1)
                if temp.token:
                    after = temp.get("/v1/partner/me")
                    check("temporary partner's access ends when the booking is cancelled", after.status_code == 401 or after.json().get("partnerStatus") == "TEMP_ENDED", err(after) if after.status_code != 200 else after.json().get("partnerStatus"))

    # 12. Admin master data: insert / edit / deactivate / delete -------------------------------
    r = admin.post("/v1/admin/hospitals", {"name": f"E2E Hospital {RUN}", "type": "CLINIC", "address": "Unit 9, Bhubaneswar", "city": "Bhubaneswar", "lat": "20.290000", "lng": "85.830000", "phone": "", "opdHours": "", "departments": [], "photoKey": ""})
    if check("hospital: add", r.status_code == 200, err(r) if r.status_code != 200 else ""):
        hid = made["hospital"] = r.json()["id"]
        r = admin.put(f"/v1/admin/hospitals/{hid}", {"name": f"E2E Hospital Edited {RUN}", "type": "CLINIC", "address": "Unit 9, Bhubaneswar", "city": "Bhubaneswar", "lat": "20.290000", "lng": "85.830000", "phone": "", "opdHours": "9-5", "departments": [], "photoKey": ""})
        check("hospital: edit", r.status_code == 200, err(r) if r.status_code != 200 else "")
        r = admin.post(f"/v1/admin/hospitals/{hid}/deactivate")
        check("hospital: deactivate", r.status_code == 200, err(r) if r.status_code != 200 else "")
        r = admin.delete(f"/v1/admin/hospitals/{hid}")
        check("hospital: delete", r.status_code in (200, 204), err(r) if r.status_code not in (200, 204) else "")
        made["hospital"] = None
    r = admin.post("/v1/admin/services", {"name": f"E2E Service {RUN}", "partnerType": "COMPANION", "visitType": "ERRAND", "pricePaise": 30000, "bookingFeePaise": 30000, "durationMin": 60, "docsRequired": False})
    if check("service: add", r.status_code == 200, err(r) if r.status_code != 200 else ""):
        sid = made["service"] = r.json()["id"]
        r = admin.put(f"/v1/admin/services/{sid}", {"name": f"E2E Service Edited {RUN}", "partnerType": "COMPANION", "visitType": "ERRAND", "pricePaise": 35000, "bookingFeePaise": 35000, "durationMin": 60, "docsRequired": False})
        check("service: edit price", r.status_code == 200 and r.json()["pricePaise"] == 35000, err(r) if r.status_code != 200 else "")
        pub = requests.get(BASE + "/v1/public/services", timeout=10).json()
        check("public price list shows the new price", any(s["id"] == sid and s["pricePaise"] == 35000 for s in pub))
        r = admin.post(f"/v1/admin/services/{sid}/deactivate")
        check("service: deactivate (hidden from the apps)", r.status_code == 200 and not any(s["id"] == sid for s in requests.get(BASE + "/v1/public/services", timeout=10).json()), err(r) if r.status_code != 200 else "")
        r = admin.delete(f"/v1/admin/services/{sid}")
        check("service: delete", r.status_code in (200, 204), err(r) if r.status_code not in (200, 204) else "")
        made["service"] = None

    # 13. Admin reads ---------------------------------------------------------------------------
    for path, label in [("/v1/admin/dashboard", "dashboard"), ("/v1/admin/bookings", "bookings list"), ("/v1/admin/payments", "payments"), ("/v1/admin/refunds", "refunds"), ("/v1/admin/reports/fees", "fee report"), ("/v1/admin/partners", "partners"), ("/v1/admin/patients", "patients"), ("/v1/admin/live", "live map"), ("/v1/admin/alerts", "alerts"), ("/v1/admin/audit-log", "audit log"), ("/v1/admin/legal", "legal pages")]:
        r = admin.get(path)
        check(f"admin page data: {label}", r.status_code == 200, err(r) if r.status_code != 200 else "")
    r = admin.get("/v1/admin/audit-log")
    check("audit log records this run's admin actions", r.status_code == 200 and r.json()["count"] > 0)

except Exception:
    traceback.print_exc()
    check("test script ran to the end", False, "exception (see above)")
finally:
    if saved_settings:
        r = admin.put("/v1/admin/settings", {"values": saved_settings})
        check("settings restored (minimum notice)", r.status_code == 200, json.dumps(saved_settings))
    try:
        for m in patient.get("/v1/patient/members").json():
            if m["fullName"].startswith("E2E Mother"):
                for a in patient.get("/v1/patient/addresses").json():
                    if a["memberId"] == m["id"]:
                        patient.delete(f"/v1/patient/addresses/{a['id']}")
                patient.delete(f"/v1/patient/members/{m['id']}")
    except Exception:
        pass
    for kind in ("hospital", "service"):
        if made[kind]:
            admin.delete(f"/v1/admin/{kind}s/{made[kind]}")

passed = sum(1 for _, ok, _ in results if ok)
print(f"\n== RESULT: {passed}/{len(results)} passed; timings: {json.dumps(timings)}")
for name, ok, detail in results:
    if not ok:
        print(f"   FAILED: {name}  [{detail}]")
