"""Dev seed: specialities, 5 Bhubaneswar hospitals and 10 sample doctors.

The map pins are approximate: check them on the Hospitals page before going live. The doctors
are made up (for testing the directory only). Matched by name, so running it again is safe.
"""

from decimal import Decimal

from apps.hospitals.models import Doctor, DoctorHospital, Hospital, Speciality

# fmt: off
# name, Hindi, Odia, icon key
SPECIALITIES = [
    ("General Medicine", "सामान्य चिकित्सा", "ସାଧାରଣ ଚିକିତ୍ସା", "stethoscope"),
    ("Cardiology", "हृदय रोग", "ହୃଦରୋଗ", "heart"),
    ("Orthopaedics", "हड्डी रोग", "ଅସ୍ଥି ରୋଗ", "bone"),
    ("Gynaecology", "स्त्री रोग", "ସ୍ତ୍ରୀ ରୋଗ", "female"),
    ("Paediatrics", "बाल रोग", "ଶିଶୁ ରୋଗ", "child"),
    ("Neurology", "तंत्रिका रोग", "ସ୍ନାୟୁ ରୋଗ", "brain"),
    ("Nephrology", "गुर्दा रोग", "ବୃକକ ରୋଗ", "kidney"),
    ("ENT", "नाक-कान-गला", "ନାକ-କାନ-ଗଳା", "ear"),
    ("Ophthalmology", "नेत्र रोग", "ଚକ୍ଷୁ ରୋଗ", "eye"),
    ("Dermatology", "त्वचा रोग", "ଚର୍ମ ରୋଗ", "skin"),
]

OPD = "Mon to Sat 9:00 to 13:00 and 16:00 to 19:00"
DEPTS = ["General Medicine", "Cardiology", "Orthopaedics", "Gynaecology", "Paediatrics"]

# name, type, address, lat, lng, departments
HOSPITALS = [
    ("AIIMS Bhubaneswar", Hospital.Type.HOSPITAL, "Sijua, Patrapada, Bhubaneswar 751019",
     "20.231200", "85.774000", [*DEPTS, "Neurology", "Nephrology", "ENT", "Ophthalmology"]),
    ("Capital Hospital", Hospital.Type.HOSPITAL, "Unit 6, Ganga Nagar, Bhubaneswar 751001",
     "20.262000", "85.818000", [*DEPTS, "ENT", "Ophthalmology", "Dermatology"]),
    ("KIMS Hospital", Hospital.Type.HOSPITAL, "KIIT Road, Patia, Bhubaneswar 751024",
     "20.354000", "85.817000", [*DEPTS, "Neurology", "Nephrology"]),
    ("IMS and SUM Hospital", Hospital.Type.HOSPITAL, "K8, Kalinga Nagar, Bhubaneswar 751003",
     "20.283000", "85.771000", [*DEPTS, "Neurology", "Dermatology"]),
    ("Apollo Hospitals Bhubaneswar", Hospital.Type.HOSPITAL,
     "Sainik School Road, Gajapati Nagar, Bhubaneswar 751005",
     "20.303000", "85.838000", [*DEPTS, "Neurology", "Nephrology"]),
]

# name, speciality, qualifications, hospitals, languages
DOCTORS = [
    ("Dr. Ananya Mishra", "General Medicine", "MBBS, MD (Medicine)", ["Capital Hospital"], ["Odia", "English"]),
    ("Dr. Rakesh Patnaik", "Cardiology", "MBBS, MD, DM (Cardiology)", ["AIIMS Bhubaneswar"], ["Odia", "Hindi", "English"]),
    ("Dr. Sunita Behera", "Gynaecology", "MBBS, MS (Obstetrics and Gynaecology)", ["KIMS Hospital", "Capital Hospital"], ["Odia", "English"]),
    ("Dr. Prakash Sahoo", "Orthopaedics", "MBBS, MS (Orthopaedics)", ["IMS and SUM Hospital"], ["Odia", "Hindi"]),
    ("Dr. Meera Das", "Paediatrics", "MBBS, MD (Paediatrics)", ["Apollo Hospitals Bhubaneswar"], ["Odia", "English"]),
    ("Dr. Arjun Nayak", "Neurology", "MBBS, MD, DM (Neurology)", ["AIIMS Bhubaneswar", "KIMS Hospital"], ["English", "Hindi"]),
    ("Dr. Pooja Mohanty", "Dermatology", "MBBS, MD (Dermatology)", ["Capital Hospital"], ["Odia", "English"]),
    ("Dr. Sanjay Panda", "Nephrology", "MBBS, MD, DM (Nephrology)", ["Apollo Hospitals Bhubaneswar"], ["Odia", "Hindi", "English"]),
    ("Dr. Kavita Rout", "ENT", "MBBS, MS (ENT)", ["IMS and SUM Hospital"], ["Odia", "English"]),
    ("Dr. Debasis Jena", "Ophthalmology", "MBBS, MS (Ophthalmology)", ["AIIMS Bhubaneswar"], ["Odia", "Hindi"]),
]
# fmt: on


def seed_directory() -> None:
    specialities: dict[str, Speciality] = {}
    for name, hi, odia, icon in SPECIALITIES:
        specialities[name], _ = Speciality.objects.get_or_create(
            name=name, defaults={"name_hi": hi, "name_or": odia, "icon": icon}
        )
    hospitals: dict[str, Hospital] = {}
    for name, kind, address, lat, lng, departments in HOSPITALS:
        hospitals[name], _ = Hospital.objects.get_or_create(
            name=name,
            defaults={
                "type": kind,
                "address": address,
                "city": "Bhubaneswar",
                "lat": Decimal(lat),
                "lng": Decimal(lng),
                "opd_hours": OPD,
                "departments": departments,
            },
        )
    for name, speciality, quals, where, languages in DOCTORS:
        doctor, created = Doctor.objects.get_or_create(
            full_name=name,
            defaults={
                "speciality": specialities[speciality],
                "qualifications": quals,
                "opd_info": "Mon, Wed and Fri 10:00 to 13:00",
                "languages": languages,
            },
        )
        if created:
            for hospital_name in where:
                DoctorHospital.objects.get_or_create(
                    doctor=doctor, hospital=hospitals[hospital_name]
                )
