"""Dev seed: the sample catalogue from ARCHITECTURE §6.6 (example prices; the admin sets the
real ones). Matched by English name, so running it again changes nothing."""

from apps.services.models import PartnerType, Service, VisitType

C, N = PartnerType.COMPANION, PartnerType.NURSE
H, HOME, E = VisitType.HOSPITAL_VISIT, VisitType.HOME_VISIT, VisitType.ERRAND

# fmt: off
# name, Hindi, Odia, partner type, visit type, price ₹, fee ₹, minutes, documents required
SAMPLE_SERVICES = [
    ("Doctor visit companion", "डॉक्टर विज़िट साथी", "ଡାକ୍ତର ଦେଖାଇବା ସାଥୀ", C, H, 500, 100, 240, False),
    ("Test / diagnostic companion", "जाँच / टेस्ट साथी", "ପରୀକ୍ଷା ସାଥୀ", C, H, 400, 80, 180, False),
    ("Hospital paperwork", "अस्पताल का कागज़ी काम", "ଡାକ୍ତରଖାନା କାଗଜପତ୍ର", C, E, 300, 60, 180, False),
    ("Medicine pickup", "दवा लाना", "ଔଷଧ ଆଣିବା", C, E, 200, 50, 120, False),
    ("Elderly care at home (4 h)", "घर पर बुज़ुर्ग देखभाल (4 घंटे)", "ଘରେ ବୟସ୍କଙ୍କ ଯତ୍ନ (4 ଘଣ୍ଟା)", C, HOME, 600, 100, 240, False),
    ("Post-visit support", "विज़िट के बाद सहायता", "ଡାକ୍ତର ଦେଖାଇବା ପରେ ସହାୟତା", C, H, 300, 60, 120, False),
    ("Injection visit", "इंजेक्शन विज़िट", "ଇଞ୍ଜେକସନ ଭିଜିଟ", N, HOME, 300, 60, 45, True),
    ("Wound dressing", "घाव की ड्रेसिंग", "ଘା ଡ୍ରେସିଂ", N, HOME, 400, 80, 60, False),
    ("IV drip", "आईवी ड्रिप", "ଆଇଭି ଡ୍ରିପ", N, HOME, 700, 120, 180, True),
    ("12-hour nursing shift", "12 घंटे की नर्सिंग शिफ्ट", "12 ଘଣ୍ଟା ନର୍ସିଂ ସିଫ୍ଟ", N, HOME, 1500, 200, 720, False),
]
# fmt: on


def seed_services() -> None:
    for sort, row in enumerate(SAMPLE_SERVICES):
        name, hi, odia, ptype, vtype, price, fee, minutes, docs = row
        Service.objects.get_or_create(
            name=name,
            defaults={
                "name_hi": hi,
                "name_or": odia,
                "partner_type": ptype,
                "visit_type": vtype,
                "price_paise": price * 100,
                "booking_fee_paise": fee * 100,
                "duration_min": minutes,
                "docs_required": docs,
                "sort": sort,
            },
        )
