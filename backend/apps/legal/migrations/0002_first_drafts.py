"""The first drafts of the legal pages (ARCHITECTURE §6.20, Phase 9B).

They describe what the app really does. A lawyer must check them before launch, and the client
fills in the parts in [square brackets]. Admins change them in Settings → Legal pages (a new
version each time); this migration never changes. Version 1's consent version is "2026-10",
the version patients accepted before the pages existed, so nobody is asked again by it.
"""

from django.db import migrations
from django.utils import timezone

FIRST_CONSENT_VERSION = "2026-10"

TERMS = """# About these terms
These terms apply when you use the WellWish app to book a companion or a home nurse for yourself or a family member. WellWish is run by [WellWish's legal company name], [registered address] ("WellWish", "we"). By creating an account you accept these terms and the Privacy Policy.

# What WellWish does
- WellWish connects you with verified companions and home nurses in its service areas in Odisha.
- A regular partner's identity and documents (including police verification) are checked by WellWish before they get bookings. When no regular partner is free, WellWish may send, for that one booking, a person whose identity document it checked over the phone.
- A WellWish team member assigns each booking to a partner by hand. We do our best to find someone for every booking, but we can't promise that a partner is free at every time.
- WellWish is not a hospital, a clinic or an emergency service. In an emergency call 112 or go to the nearest hospital.

# Your account
- You log in with your mobile number and a one-time code sent by SMS. Keep your phone safe: anyone with it can use your account.
- You may add family members and book for them only with their permission. You are responsible for the details you enter about them.
- You must be 18 or older to create an account.

# Bookings and payment
- The price of each service is shown before you book. You pay the amount shown online through Razorpay when you book; WellWish never sees your card or UPI details. If a service has a balance to pay the companion or nurse after the visit, the app shows it before you book.
- Anything agreed on the day (a cab or auto, extra time, medicines) is settled directly with whoever provides it.
- Cancellations and refunds follow the Refund Policy.

# During the visit
- The partner shares their live location with you from "On the way" until the visit is done. You can share a live link with relatives.
- Give the partner the visit code from your app only when they are with the patient.
- If something goes wrong, use SOS in the app: WellWish's team is alerted at once.

# Things you must not do
- Give false details, book for someone without their permission, or use the app for anything unlawful.
- Harass, threaten or harm a partner, or ask them to do something unsafe or outside the service booked.
- Try to break, copy or misuse the app.
WellWish may block an account that breaks these rules.

# Responsibility
WellWish checks the partners it sends and supports every visit, but it is not responsible for medical decisions, which stay with your doctor. Nothing in these terms limits a right you have under Indian law.

# Closing your account
You can delete your account in the app (Settings → Delete my account) or on WellWish's website. The Privacy Policy says what is deleted and when.

# Changes and contact
We may update these terms. If a change matters to you, the app asks you to accept the new version. Questions or complaints: [support email], [support phone]. These terms follow the laws of India; the courts of [city], Odisha decide any dispute."""

PRIVACY = """# Who we are
[WellWish's legal company name], [registered address] ("WellWish") runs the WellWish and WellWish Partner apps. This policy explains what personal data we collect, why, and the rights you have under India's Digital Personal Data Protection Act, 2023.

# What we collect
- **Account:** your mobile number, name, date of birth, gender and app language; your Google account's email if you sign in with Google.
- **Family members you add:** their name, relation, date of birth, gender, photo and phone (if given), language, home address and health notes (conditions, allergies, getting around, hearing or vision), with your confirmation that they agreed.
- **Documents you upload:** prescriptions, lab reports, scans, discharge summaries and others.
- **Bookings and payments:** what you booked, for whom, where and when, and the payment status from Razorpay. We never see or store card or UPI details.
- **Location:** the pin of each address you save (it can come from your phone's location), and where you are when you press SOS.
- **Partners:** both phone numbers, email, address, photo, the identity and police verification documents they upload (kept as uploaded: an Aadhaar photo shows the full number; the number typed into the app is kept as its last 4 digits only), selfies, and their location during a job.
- **Technical:** your device's identifier for notifications, the app version, the internet (IP) address of a consent or a WellWish team action, and error reports without personal details.

# Why we use it
- To run your bookings: assign a partner, share the visit details with them, take payment, send updates and handle refunds.
- To keep visits safe: verify partners, show the partner's live location during the visit, SOS alerts.
- To meet the law (tax, payments, police requests) and to prevent fraud.
We don't sell your data and don't use it for advertising.

# Who sees it
- **The partner assigned to a booking** sees what the visit needs: the patient's name, photo, address and health notes, and the documents attached to the booking. The documents can be opened only from acceptance until 24 hours after the visit, and every opening is logged.
- **WellWish's team**, only what their role needs; opening a medical document asks for a reason and is logged.
- **Service providers** who work for us: Amazon Web Services (hosting in Mumbai, email), Razorpay (payments), MSG91 (SMS), Google Firebase (notifications), Google Maps (maps), Sentry (error reports without personal details).
- Government authorities when the law requires it.

# Where it is kept and how long
- Your data is stored in India (Amazon Web Services, Mumbai), encrypted. Some service providers (Google for notifications and maps, Sentry for error reports) may handle limited data outside India.
- Until you delete your account. After a deletion request your data is erased once the waiting time shown in the app has passed. Copies in our backups go as the backups are replaced, normally within 7 more days; a copy made just before a software update is kept until that update is confirmed working.
- Kept after a deletion, as the law and safety require: past bookings and payments (without your personal details where the law allows), tax records, records of what you consented to, SOS alerts, the routes of finished visits, and the log of what WellWish's team did.
- A partner's live location is used only during a job; the route of a finished visit is kept with the booking.

# Your rights
- See the data we hold about you, and correct it (most of it in the app).
- Withdraw your consent and delete your account: in the app, or on WellWish's website, without the app.
- Nominate someone to use these rights if you can't.
- Complain to our Grievance Officer: [name], [email], [phone]. We answer within 30 days. You may also complain to the Data Protection Board of India.

# Children
Accounts are for adults (18+). A parent or guardian may add a child as a family member and book for them.

# Changes
We may update this policy. If a change matters to you, the app asks you to accept the new version. The date of each version is shown on this page."""

REFUNDS = """# Paying for a booking
You pay for a booking online when you book, through Razorpay (UPI, card or net banking). The price is shown before you pay. A booking that isn't paid within 30 minutes is cancelled by itself and nothing is charged.

# If you cancel
- **Before the partner taps "On the way":** you get back 50% of the amount you paid.
- **After "On the way":** the app can't cancel it any more. Contact WellWish support; the team decides what is fair.

# If WellWish cancels
If no partner is available, or the problem is on WellWish's side, you get back 100% of the amount you paid.

# If the patient isn't there
If the partner reaches the address and can't meet the patient (after the wait and a call shown in the app), there is no refund.

# After the visit
If something went wrong, use "Report a problem" on the booking within 24 hours of the visit (after that, call WellWish support). WellWish looks into it and may refund part or all of the amount paid.

# Payments that arrive late or twice
If a payment arrives after the booking was cancelled, or arrives twice, it is refunded in full automatically.

# How refunds reach you
Refunds go back to the way you paid (UPI, card or bank account) through Razorpay, usually within 5–7 working days. The app shows the status of each refund.

# Contact
[support email], [support phone]."""

PARTNER_TERMS = """# About these terms
These terms apply when you register and work as a companion or home nurse through the WellWish Partner app. WellWish is run by [WellWish's legal company name], [registered address] ("WellWish"). Your separate agreement with WellWish (if any) says how you are paid and the details of your engagement; these terms cover how you use the app.

# Registering and verification
- You give your real details: two mobile numbers you use, your email, address, photo, and the documents asked for (Aadhaar, PAN, police verification, address proof, and for nurses the nursing registration).
- WellWish checks every document before you get regular bookings. If WellWish gives you a single booking as a temporary partner (after checking your ID over the phone), these terms apply to that job too. Documents with an expiry date (like the police verification) must be renewed in time, or your account is paused until you do.
- You must be 18 or older.

# Jobs
- WellWish's team offers you jobs; you have 2 minutes to accept or decline an offer.
- Once you accept, be on time. If you can't make it, tell WellWish at once so the patient isn't left waiting.
- Follow the steps in the app. Ask the family for the visit code only when you are with the patient.
- Do only the service booked, and never anything that needs a doctor's order without one.

# Location
- The app shares your location only during a job, from "On the way" until the job is done, with a visible notification. The family and WellWish's team see it.
- Never use a fake-location app. Fake GPS on 3 different jobs suspends your account for review.

# Patients' data
You see the patient's name, address and health notes for your jobs; their documents open only from acceptance until 24 hours after the visit, and every opening is logged. Keep all of it confidential: don't copy, share or use it for anything else.

# Conduct and safety
- Treat patients and families with respect. Harassment, rudeness, asking for extra money or any unsafe behaviour can end your account.
- In danger, use SOS in the app: WellWish's team is alerted at once.
- Families may rate you after a visit. WellWish may suspend or close an account for poor conduct, fake details or misuse.

# Closing your account
You can delete your account in the app (Profile → Delete my account) or on WellWish's website, once you have no accepted or ongoing job. The Privacy Policy says what is deleted and when; your past jobs stay on record without your personal details.

# Changes and contact
We may update these terms. If a change matters to you, the app asks you to accept the new version. Questions: [partner support email], [support phone]. These terms follow the laws of India; the courts of [city], Odisha decide any dispute."""

DRAFTS = [
    ("TERMS", "Terms of Use", TERMS),
    ("PRIVACY", "Privacy Policy", PRIVACY),
    ("REFUNDS", "Refund Policy", REFUNDS),
    ("PARTNER_TERMS", "Partner Terms", PARTNER_TERMS),
]


def seed(apps, schema_editor):
    LegalDocument = apps.get_model("legal", "LegalDocument")
    now = timezone.now()
    for kind, title, body in DRAFTS:
        LegalDocument.objects.get_or_create(
            kind=kind,
            version=1,
            defaults={
                "consent_version": FIRST_CONSENT_VERSION,
                "asked_again": True,
                "title_en": title,
                "body_en": body,
                "published_at": now,
            },
        )


def unseed(apps, schema_editor):
    apps.get_model("legal", "LegalDocument").objects.filter(version=1).delete()


class Migration(migrations.Migration):
    dependencies = [("legal", "0001_initial")]

    operations = [migrations.RunPython(seed, unseed)]
