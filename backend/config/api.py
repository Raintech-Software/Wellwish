"""The WellWish API at /v1.

- `/v1/auth/*`     login for the patient and partner apps (public, except logout)
- `/v1/public/*`   no login (app config, services, specialities)
- `/v1/patient/*`  patient app: needs a patient access token
- `/v1/partner/*`  partner app: needs a partner access token
- `/v1/admin/*`    admin panel: needs a staff access token (except /v1/admin/auth/*)

The audience check sits on the three top-level routers (ARCHITECTURE §6.5), so every app's
sub-router inherits it. Role, status and permission checks are decorators on each endpoint.
Each Django app plugs its own sub-routers in below (one line per app and audience).
Tags (= the generated client classes: AuthApi, PatientApi, …) are set on the sub-routers.
"""

from django.conf import settings
from ninja import NinjaAPI, Router

from apps.accounts.api import auth as accounts_auth
from apps.accounts.api import partner as accounts_partner
from apps.accounts.api import patient as accounts_patient
from apps.accounts.api import staff as accounts_staff
from apps.addresses.api import patient as addresses_patient
from apps.app_config.api import public as app_config_public
from apps.app_config.api import staff as app_config_staff
from apps.assignments.api import partner as assignments_partner
from apps.assignments.api import staff as assignments_staff
from apps.audit.api import staff as audit_staff
from apps.bookings.api import partner as bookings_partner
from apps.bookings.api import patient as bookings_patient
from apps.bookings.api import staff as bookings_staff
from apps.dashboard.api import staff as dashboard_staff
from apps.documents.api import patient as documents_patient
from apps.files.api import staff as files_staff
from apps.hospitals.api import patient as hospitals_patient
from apps.hospitals.api import public as hospitals_public
from apps.hospitals.api import staff as hospitals_staff
from apps.kyc.api import partner as kyc_partner
from apps.kyc.api import staff as kyc_staff
from apps.legal.api import staff as legal_staff
from apps.notifications.api import partner as notifications_partner
from apps.notifications.api import patient as notifications_patient
from apps.partners.api import partner as partners_partner
from apps.partners.api import staff as partners_staff
from apps.patients.api import patient as patients_patient
from apps.patients.api import staff as patients_staff
from apps.payments.api import patient as payments_patient
from apps.payments.api import staff as payments_staff
from apps.payments.api import webhook as payments_webhook
from apps.reviews.api import partner as reviews_partner
from apps.reviews.api import patient as reviews_patient
from apps.reviews.api import staff as reviews_staff
from apps.safety.api import partner as safety_partner
from apps.safety.api import patient as safety_patient
from apps.safety.api import public as safety_public
from apps.safety.api import staff as safety_staff
from apps.services.api import public as services_public
from apps.services.api import staff as services_staff
from apps.staff.api import staff as staff_staff
from apps.staff.api import staff_users as staff_users_staff
from apps.tracking.api import partner as tracking_partner
from apps.tracking.api import patient as tracking_patient
from apps.tracking.api import staff as tracking_staff
from common.auth import ApprovedPartnerAuth, SessionJWTAuth
from common.errors import register_error_handlers
from common.health import router as health_router

api = NinjaAPI(
    title="WellWish API",
    version="1.0.0",
    description="Backend for the WellWish patient app, partner app and admin panel.",
    docs_url="/docs" if settings.API_DOCS_ENABLED else None,
    openapi_url="/openapi.json" if settings.API_DOCS_ENABLED else None,
    urls_namespace="v1",
)
register_error_handlers(api)

auth_router = Router()
public_router = Router()
patient_router = Router(auth=SessionJWTAuth("patient"))
# Partners: everything needs APPROVED except registration, KYC, "me" (and its device,
# language, consents and account deletion) and the inbox (§6.3, §6.20).
partner_router = Router(
    auth=ApprovedPartnerAuth(
        prefix="/v1/partner",
        open_paths=("/me", "/me/device", "/me/language", "/me/consents", "/me/delete"),
        open_prefixes=("/register/", "/kyc/", "/notifications"),
    )
)
staff_router = Router(auth=SessionJWTAuth("staff"))

# --- app sub-routers ---
auth_router.add_router("", accounts_auth.router)
public_router.add_router("", app_config_public.router)
public_router.add_router("", services_public.router)
public_router.add_router("", hospitals_public.router)
public_router.add_router("", safety_public.router)
patient_router.add_router("", accounts_patient.router)
patient_router.add_router("", patients_patient.router)
patient_router.add_router("", addresses_patient.router)
patient_router.add_router("", documents_patient.router)
patient_router.add_router("", hospitals_patient.router)
patient_router.add_router("", bookings_patient.router)
patient_router.add_router("", payments_patient.router)
patient_router.add_router("", tracking_patient.router)
patient_router.add_router("", safety_patient.router)
patient_router.add_router("", reviews_patient.router)
patient_router.add_router("", notifications_patient.router)
partner_router.add_router("", accounts_partner.router)
partner_router.add_router("", partners_partner.router)
partner_router.add_router("", kyc_partner.router)
partner_router.add_router("", notifications_partner.router)
partner_router.add_router("", assignments_partner.router)
partner_router.add_router("", bookings_partner.router)
partner_router.add_router("", tracking_partner.router)
partner_router.add_router("", safety_partner.router)
partner_router.add_router("", reviews_partner.router)
staff_router.add_router("", accounts_staff.router)
staff_router.add_router("", staff_staff.router)
staff_router.add_router("", staff_users_staff.router)
staff_router.add_router("", services_staff.router)
staff_router.add_router("", hospitals_staff.router)
staff_router.add_router("", files_staff.router)
staff_router.add_router("", app_config_staff.router)
staff_router.add_router("", audit_staff.router)
staff_router.add_router("", kyc_staff.router)
staff_router.add_router("", partners_staff.router)
staff_router.add_router("", patients_staff.router)
staff_router.add_router("", bookings_staff.router)
staff_router.add_router("", payments_staff.router)
staff_router.add_router("", assignments_staff.router)
staff_router.add_router("", tracking_staff.router)
staff_router.add_router("", safety_staff.router)
staff_router.add_router("", reviews_staff.router)
staff_router.add_router("", dashboard_staff.router)
staff_router.add_router("", legal_staff.router)

api.add_router("", health_router)
api.add_router("/auth", auth_router)
api.add_router("/public", public_router)
api.add_router("/webhooks", payments_webhook.router)  # signature-checked, no login
api.add_router("/patient", patient_router)
api.add_router("/partner", partner_router)
api.add_router("/admin", staff_router)
