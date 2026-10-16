"""Admin: patients (§9.1 Patients): list, profile with family, addresses and documents
(opening a document needs a reason and is logged), and account deletion requests (PHASES 4.5).
`patients.manage` (PHASES 9.10): block / unblock the patient app (abuse), edit the details on the
patient's request, start "delete my account" for a patient who asks by phone; each logged with
its reason.
Health notes (conditions, allergies, getting around, hearing/vision) are not shown here: only the
assigned partner sees them during the job (§6.18). The document list itself (titles are medical
information) is only for roles that may open patient documents (`patients.documents`, §9.2)."""

from typing import Literal
from uuid import UUID

from django.db.models import QuerySet
from django.http import HttpRequest
from ninja import Router
from ninja.pagination import paginate

from apps.accounts.models import User
from apps.addresses import selectors as address_selectors
from apps.addresses.api.patient import address_out
from apps.bookings import selectors as booking_selectors
from apps.bookings.api.staff import admin_row
from apps.documents import selectors as document_selectors
from apps.documents import services as document_services
from apps.documents.api.patient import document_out
from apps.files.schemas import ViewUrlOut
from apps.patients import selectors, services
from apps.patients.models import AccountDeletion
from apps.patients.schemas import (
    AccountDeletionOut,
    AdminMemberOut,
    AdminPatientIn,
    DocumentReasonIn,
    PatientDetailOut,
    PatientReasonIn,
    PatientRowOut,
)
from apps.staff.selectors import acting_staff
from common.auth import get_principal, staff_permission
from common.errors import NotFound
from common.pagination import WWPagination
from common.request import client_ip

router = Router(tags=["admin"])


@router.get(
    "/patients", response=list[PatientRowOut], by_alias=True, operation_id="adminPatientsList"
)
@staff_permission("patients.view")
@paginate(WWPagination)
def list_patients(request: HttpRequest, q: str = "") -> QuerySet[User]:
    """Newest first. `q`: name, or at least 4 digits of the phone."""
    return selectors.patients(q=q)


@router.get(
    "/patients/{uuid:user_id}",
    response=PatientDetailOut,
    by_alias=True,
    operation_id="adminPatientGet",
)
@staff_permission("patients.view")
def get_patient(request: HttpRequest, user_id: UUID) -> PatientDetailOut:
    """The account, its family members (removed ones too), addresses and, for roles that may
    open them, documents (titles only). Payments are added in Phase 6."""
    return _detail(request, str(user_id))


def _detail(request: HttpRequest, user_id: str) -> PatientDetailOut:
    user = selectors.patients().filter(pk=user_id).first()
    if user is None:
        raise NotFound()
    profile = user.patient_profile
    members = [
        AdminMemberOut(
            id=str(m.pk),
            relation=m.relation,
            full_name=m.full_name,
            age=selectors.age(m.dob),
            gender=m.gender,
            phone=m.phone,
            language=m.language,
            is_active=m.is_active,
        )
        for m in selectors.all_members(str(user.pk))
    ]
    permissions = get_principal(request).permissions
    may_see_documents = "patients.documents" in permissions
    may_see_bookings = "bookings.view" in permissions
    return PatientDetailOut(
        patient=PatientRowOut.from_orm(user),
        dob=profile.dob,
        gender=profile.gender,
        language=user.language,
        members=members,
        addresses=[address_out(a) for a in address_selectors.all_addresses(str(user.pk))],
        documents_visible=may_see_documents,
        documents=[document_out(d) for d in document_selectors.admin_documents(str(user.pk))]
        if may_see_documents
        else [],
        bookings_visible=may_see_bookings,
        bookings=[
            admin_row(b) for b in booking_selectors.patient_bookings_for_admin(str(user.pk))[:100]
        ]
        if may_see_bookings
        else [],
        blocked_reason=profile.blocked_reason,
    )


@router.post(
    "/patients/{uuid:user_id}/block",
    response=PatientDetailOut,
    by_alias=True,
    operation_id="adminPatientBlock",
)
@staff_permission("patients.manage")
def block(request: HttpRequest, user_id: UUID, data: PatientReasonIn) -> PatientDetailOut:
    """Abuse (§9.1): logged out of the patient app on every phone at once and its login refused
    ("This account is blocked") until unblocked. The partner app is not touched. Logged."""
    services.block(
        actor=acting_staff(request), user_id=str(user_id), reason=data.reason, ip=client_ip(request)
    )
    return _detail(request, str(user_id))


@router.post(
    "/patients/{uuid:user_id}/unblock",
    response=PatientDetailOut,
    by_alias=True,
    operation_id="adminPatientUnblock",
)
@staff_permission("patients.manage")
def unblock(request: HttpRequest, user_id: UUID, data: PatientReasonIn) -> PatientDetailOut:
    services.unblock(
        actor=acting_staff(request), user_id=str(user_id), reason=data.reason, ip=client_ip(request)
    )
    return _detail(request, str(user_id))


@router.put(
    "/patients/{uuid:user_id}",
    response=PatientDetailOut,
    by_alias=True,
    operation_id="adminPatientUpdate",
)
@staff_permission("patients.manage")
def update(request: HttpRequest, user_id: UUID, data: AdminPatientIn) -> PatientDetailOut:
    """Only on the patient's request (§9.1): name, date of birth, gender, app language (the
    profile screen's details; the phone number is the login and can't change here). Logged with
    the reason and what changed."""
    services.admin_update_profile(
        actor=acting_staff(request),
        user_id=str(user_id),
        full_name=data.full_name,
        dob=data.dob,
        gender=data.gender,
        language=data.language,
        reason=data.reason,
        ip=client_ip(request),
    )
    return _detail(request, str(user_id))


@router.post(
    "/patients/{uuid:user_id}/deletion",
    response=PatientDetailOut,
    by_alias=True,
    operation_id="adminPatientRequestDeletion",
)
@staff_permission("patients.manage")
def request_deletion(
    request: HttpRequest, user_id: UUID, data: PatientReasonIn
) -> PatientDetailOut:
    """A patient who asks by phone to delete their account: the same as in the app (409
    ACTIVE_BOOKINGS while a paid booking isn't finished; logged out at once; erased after the
    waiting time unless they log in again). Logged."""
    services.admin_request_deletion(
        actor=acting_staff(request), user_id=str(user_id), reason=data.reason, ip=client_ip(request)
    )
    return _detail(request, str(user_id))


@router.post(
    "/patients/{uuid:user_id}/documents/{uuid:document_id}/view-url",
    response=ViewUrlOut,
    by_alias=True,
    operation_id="adminPatientDocumentViewUrl",
)
@staff_permission("patients.documents")
def view_document(
    request: HttpRequest, user_id: UUID, document_id: UUID, data: DocumentReasonIn
) -> ViewUrlOut:
    """Open a patient's document: a reason is required and the view is audit-logged (§9.1)."""
    url, mime = document_services.admin_view_url(
        actor=acting_staff(request),
        user_id=str(user_id),
        document_id=str(document_id),
        reason=data.reason,
        ip=client_ip(request),
    )
    return ViewUrlOut(url=url, mime=mime)


@router.get(
    "/account-deletions",
    response=list[AccountDeletionOut],
    by_alias=True,
    operation_id="adminAccountDeletionsList",
)
@staff_permission("patients.manage")
@paginate(WWPagination)
def list_deletions(
    request: HttpRequest, status: Literal["PENDING", "CANCELLED", "DONE"] | None = None
) -> QuerySet[AccountDeletion]:
    """ "Delete my account" requests, newest first: waiting (the patient can still log in to
    cancel), cancelled, or done. Only the phone's last 4 digits are kept."""
    return selectors.account_deletions(status=status or "")
