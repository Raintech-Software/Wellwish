# Live test 2: a new companion signs up in the partner app, uploads documents, an admin
# approves them, and they receive their first offer. Then they delete their own account.
# Runs inside the api container (`python manage.py shell < e2e_partner.py`).
import asyncio
import base64
import datetime as dt
import json
import os
import re
import threading
import time
import traceback
import uuid

import pyotp
import requests
import websockets

BASE = "http://localhost:8000"
WS = "ws://localhost:8000"
RUN = uuid.uuid4().hex[:6]
STAMP = str(int(time.time()) % 100000).zfill(5)
NEW_PHONE = "+9170001" + STAMP
ALT_PHONE = "+9170002" + STAMP
EMAIL = f"e2e.partner.{RUN}@example.com"
JPEG = base64.b64decode(
    "/9j/4AAQSkZJRgABAQEASABIAAD/2wBDAP//////////////////////////////////////////////////////////"
    "////////////////////////////wgALCAABAAEBAREA/8QAFBABAAAAAAAAAAAAAAAAAAAAAP/aAAgBAQABPxA="
)
PDF = b"%PDF-1.4\n1 0 obj<<>>endobj\ntrailer<<>>\n%%EOF\n"
results = []


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
    def __init__(self):
        self.token = None
        self.s = requests.Session()

    def call(self, method, path, body=None, params=None):
        h = {"Idempotency-Key": uuid.uuid4().hex}
        if self.token:
            h["Authorization"] = f"Bearer {self.token}"
        return self.s.request(method, BASE + path, json=body, params=params, headers=h, timeout=40)

    def get(self, p, params=None):
        return self.call("GET", p, params=params)

    def post(self, p, b=None):
        return self.call("POST", p, b if b is not None else {})

    def put(self, p, b):
        return self.call("PUT", p, b)


def admin_login(api):
    for _ in range(3):
        r = requests.post(BASE + "/v1/admin/auth/login", json={"email": os.environ["DEV_QA_ADMIN_EMAIL"], "password": os.environ["DEV_QA_ADMIN_PASSWORD"]}, timeout=20).json()
        if r["step"] == "SIGNED_IN":
            api.token = r["signedIn"]["accessToken"]
            return True
        t = requests.post(BASE + "/v1/admin/auth/totp", json={"challengeToken": r["challengeToken"], "code": pyotp.TOTP(os.environ["DEV_QA_ADMIN_TOTP_SECRET"]).now()}, timeout=20)
        if t.status_code == 200:
            api.token = t.json()["accessToken"]
            return True
        time.sleep(31 - time.time() % 30)
    return False


def sms_code(admin, phone, template="LOGIN_OTP"):
    for _ in range(20):
        for m in admin.get("/v1/admin/dev/outbox").json()["sms"]:
            if m["phone"] == phone and m["template"] == template:
                return re.search(r"\b(\d{6})\b", m["text"]).group(1)
        time.sleep(0.3)
    return None


def email_code(admin, email):
    for _ in range(20):
        for m in admin.get("/v1/admin/dev/outbox").json()["email"]:
            if m["to"] == email.lower():
                found = re.search(r"\b(\d{6})\b", m["text"])
                if found:
                    return found.group(1)
        time.sleep(0.3)
    return None


def upload(api, purpose, content, mime):
    r = api.post("/v1/partner/kyc/upload-url", {"purpose": purpose, "mime": mime, "sizeBytes": len(content)})
    if r.status_code != 200:
        return None, err(r)
    out = r.json()
    url = out["uploadUrl"] if out["uploadUrl"].startswith("http") else BASE + out["uploadUrl"]
    up = requests.post(url, data=out["uploadFields"], files={"file": ("f.pdf" if mime == "application/pdf" else "f.jpg", content, mime)}, timeout=30)
    return (out["fileKey"], "") if up.status_code in (200, 201, 204) else (None, f"upload {up.status_code}")


class Sock:
    def __init__(self, audience, token):
        self.msgs = []
        self.ready = threading.Event()
        self.audience, self.token = audience, token
        threading.Thread(target=lambda: asyncio.run(self._main()), daemon=True).start()
        self.ready.wait(10)

    async def _main(self):
        async with websockets.connect(f"{WS}/ws/{self.audience}/") as ws:
            await ws.send(json.dumps({"type": "auth", "token": self.token}))
            async for raw in ws:
                m = json.loads(raw)
                if m.get("type") == "auth.ok":
                    self.ready.set()
                    continue
                self.msgs.append((time.time(), m))

    def wait(self, typ, since, timeout=10):
        end = time.time() + timeout
        while time.time() < end:
            for t, m in list(self.msgs):
                if t >= since and m.get("type") == typ:
                    return t
            time.sleep(0.01)
        return None


admin, partner, patient = Api(), Api(), Api()
try:
    print(f"== New partner sign-up → approval → first offer, run {RUN}", flush=True)
    check("admin signs in", admin_login(admin))
    dev = f"e2e-new-{RUN}"
    r = requests.post(BASE + "/v1/auth/otp/send", json={"phone": NEW_PHONE, "purpose": "partner_primary", "deviceId": dev}, timeout=20)
    check("new partner: login code sent", r.status_code == 200, err(r) if r.status_code != 200 else "")
    code = sms_code(admin, NEW_PHONE)
    check("the code is on Settings → Test messages", code is not None)
    r = requests.post(BASE + "/v1/auth/otp/verify", json={"phone": NEW_PHONE, "otp": code or "000000", "purpose": "partner_primary", "deviceId": dev}, timeout=20)
    if not check("new partner signs in", r.status_code == 200, err(r) if r.status_code != 200 else ""):
        raise SystemExit
    partner.token = r.json()["accessToken"]
    me = partner.get("/v1/partner/me").json()
    check("new partner starts unregistered", me.get("partnerStatus") in (None, "", "NEW", "UNREGISTERED", "REGISTERING"), str(me.get("partnerStatus")))
    if me.get("consentsNeeded"):
        r = partner.post("/v1/partner/me/consents", {"items": [{"type": c["type"], "version": c["version"]} for c in me["consentsNeeded"]]})
        check("accepts the Partner Terms and Privacy Policy", r.status_code == 200, err(r) if r.status_code != 200 else "")
    r = partner.post("/v1/partner/register/start", {"role": "COMPANION"})
    check("chooses the role: companion", r.status_code == 200, err(r) if r.status_code != 200 else "")

    r = partner.post("/v1/partner/register/alternate-phone", {"phone": ALT_PHONE})
    if check("alternate phone: code sent", r.status_code == 200, err(r) if r.status_code != 200 else ""):
        c = sms_code(admin, ALT_PHONE, template=None) if False else None
        for _ in range(20):
            msgs = [m for m in admin.get("/v1/admin/dev/outbox").json()["sms"] if m["phone"] == ALT_PHONE]
            if msgs:
                c = re.search(r"\b(\d{6})\b", msgs[0]["text"]).group(1)
                break
            time.sleep(0.3)
        r = partner.post("/v1/partner/register/alternate-phone/verify", {"code": c or "000000"})
        check("alternate phone verified with the SMS code", r.status_code == 200, err(r) if r.status_code != 200 else "")
    r = partner.post("/v1/partner/register/email", {"email": EMAIL})
    if check("email: code sent", r.status_code == 200, err(r) if r.status_code != 200 else ""):
        c = email_code(admin, EMAIL)
        check("the email code is on Settings → Test messages", c is not None)
        r = partner.post("/v1/partner/register/email/verify", {"code": c or "000000"})
        check("email verified", r.status_code == 200, err(r) if r.status_code != 200 else "")

    photo, why = upload(partner, "partner_photo", JPEG, "image/jpeg")
    check("profile photo uploaded", photo is not None, why)
    r = partner.put("/v1/partner/register/profile", {"fullName": f"E2E Companion {RUN}", "dob": "1994-05-10", "gender": "FEMALE", "photoKey": photo or "", "address": "Plot 5, Nayapalli, Bhubaneswar", "lat": "20.296100", "lng": "85.824500", "languages": ["Odia", "English"], "skills": [], "emergencyName": "Ravi", "emergencyPhone": "+919437012345"})
    check("profile saved", r.status_code == 200, err(r) if r.status_code != 200 else "")

    required = partner.get("/v1/partner/kyc/required").json()
    for doc in [d for d in required if d["mandatory"]]:
        purpose = "kyc_document"
        content, mime = (JPEG, "image/jpeg") if doc["cameraOnly"] else (PDF, "application/pdf")
        key, why = upload(partner, purpose, content, mime)
        if not check(f"KYC {doc['docType']}: file uploaded", key is not None, why):
            continue
        number = {"AADHAAR": "234567891234", "PAN": "ABCPE1234F", "TEXT": "OD-02-2019-0012345"}.get(doc["numberRule"], "")
        expires = (dt.date.today() + dt.timedelta(days=400)).isoformat() if doc["hasExpiry"] else None
        r = partner.post("/v1/partner/kyc/documents", {"docType": doc["docType"], "fileKey": key, "number": number, "expiresOn": expires})
        check(f"KYC {doc['docType']}: saved", r.status_code == 200, err(r) if r.status_code != 200 else "")
    r = partner.post("/v1/partner/kyc/submit")
    check("application submitted", r.status_code == 200, err(r) if r.status_code != 200 else "")
    status = partner.get("/v1/partner/kyc/status")
    check("partner sees 'under review'", status.status_code == 200, json.dumps(status.json())[:120] if status.status_code == 200 else err(status))

    # admin review
    me = partner.get("/v1/partner/me").json()
    apps = admin.get("/v1/admin/applications").json()
    items = apps["items"] if isinstance(apps, dict) else apps
    app_row = next((a for a in items if json.dumps(a).find(RUN) >= 0 or a.get("partnerId") == me["id"]), None)
    if check("admin sees the new application", app_row is not None, f"{len(items)} in the list"):
        aid = app_row.get("id") or app_row.get("applicationId")
        r = admin.post(f"/v1/admin/applications/{aid}/claim")
        check("admin claims it", r.status_code == 200, err(r) if r.status_code != 200 else "")
        detail = admin.get(f"/v1/admin/applications/{aid}").json()
        for state in detail["documents"]:
            d = state.get("document")
            if not d:
                continue
            v = admin.get(f"/v1/admin/partner-documents/{d['id']}/view-url")
            r = admin.post(f"/v1/admin/partner-documents/{d['id']}/approve")
            check(f"admin opens + approves {state['required']['docType']}", v.status_code == 200 and r.status_code == 200, err(r) if r.status_code != 200 else "")
        r = admin.post(f"/v1/admin/applications/{aid}/approve")
        check("admin approves the partner", r.status_code == 200, err(r) if r.status_code != 200 else "")
    me = partner.get("/v1/partner/me").json()
    check("partner is APPROVED", me.get("partnerStatus") == "APPROVED", str(me.get("partnerStatus")))
    time.sleep(1)
    check("approval SMS sent", any(m["phone"] == NEW_PHONE and m["template"] == "PARTNER_APPROVED" for m in admin.get("/v1/admin/dev/outbox").json()["sms"]))
    check("approval email sent", any(m["to"] == EMAIL for m in admin.get("/v1/admin/dev/outbox").json()["email"] if "approv" in (m["subject"] + m["text"]).lower()))
    n = partner.get("/v1/partner/notifications").json()
    check("approval in the partner's inbox", n["count"] > 0, f"{n['count']} message(s)")

    # first offer
    psock = Sock("partner", partner.token)
    r = requests.post(BASE + "/v1/auth/otp/send", json={"phone": "+919000000001", "purpose": "login", "deviceId": f"e2e-p-{RUN}"}, timeout=20)
    v = requests.post(BASE + "/v1/auth/otp/verify", json={"phone": "+919000000001", "otp": "123456", "purpose": "login", "deviceId": f"e2e-p-{RUN}"}, timeout=20)
    patient.token = v.json().get("accessToken")
    svc = next(s for s in requests.get(BASE + "/v1/public/services", timeout=10).json() if s["isActive"] and s["partnerType"] == "COMPANION")
    self_m = next(m for m in patient.get("/v1/patient/members").json() if m["isSelf"])
    addr = next(a for a in patient.get("/v1/patient/addresses").json() if a["memberId"] == self_m["id"])
    times = patient.get("/v1/patient/booking-times", params={"serviceId": svc["id"]}).json()["times"]
    b = patient.post("/v1/patient/bookings", {"serviceId": svc["id"], "memberId": self_m["id"], "addressId": addr["id"], "pickupAt": times[-1], "hospitalText": "Capital Hospital" if svc["visitType"] == "HOSPITAL_VISIT" else "", "notes": "E2E new partner"})
    if check("a booking to offer", b.status_code == 200, err(b) if b.status_code != 200 else ""):
        b = b.json()
        co = patient.post(f"/v1/patient/bookings/{b['id']}/checkout").json()
        from apps.payments import gateway as gw
        from apps.payments import services as pay

        pay.captured(co["orderId"], gw.GatewayPayment(id=f"pay_e2esim_{RUN}", order_id=co["orderId"], status="captured", amount=co["amountPaise"], method="upi"))
        cands = admin.get(f"/v1/admin/bookings/{b['id']}/candidates").json()
        mine = next((c for c in cands if c["partnerId"] == me["id"]), None)
        if check("the new partner is a candidate", mine is not None, ", ".join(c["fullName"] for c in cands)):
            state = admin.get(f"/v1/admin/bookings/{b['id']}/assignment").json()
            t0 = time.time()
            r = admin.post(f"/v1/admin/bookings/{b['id']}/assign", {"partnerId": me["id"], "expectedAssignmentId": state.get("currentAssignmentId")})
            t = psock.wait("offer.new", t0)
            check("the new partner gets their first offer live", r.status_code == 200 and t is not None, f"{int((t - t0) * 1000)} ms" if t else err(r))
            offer = next(o for o in partner.get("/v1/partner/offers").json() if o["bookingId"] == b["id"])
            r = partner.post(f"/v1/partner/offers/{offer['assignmentId']}/accept")
            check("the new partner accepts", r.status_code == 200, err(r) if r.status_code != 200 else "")
            r = partner.post("/v1/partner/me/delete")
            check("account deletion refused while a job is theirs (409 ACTIVE_JOBS)", r.status_code == 409, err(r))
        r = admin.post(f"/v1/admin/bookings/{b['id']}/cancel", {"reason": "E2E cleanup", "refundPercent": 100})
        check("admin cancels the test booking", r.status_code == 200, err(r) if r.status_code != 200 else "")
    r = partner.post("/v1/partner/me/delete")
    check("the partner deletes their own account", r.status_code == 200, err(r) if r.status_code != 200 else json.dumps(r.json())[:120])
    after = partner.get("/v1/partner/me")
    check("signed out after deleting", after.status_code == 401, str(after.status_code))
except SystemExit:
    pass
except Exception:
    traceback.print_exc()
    check("test script ran to the end", False, "exception")
passed = sum(1 for _, ok, _ in results if ok)
print(f"\n== RESULT: {passed}/{len(results)} passed")
for name, ok, detail in results:
    if not ok:
        print(f"   FAILED: {name}  [{detail}]")
