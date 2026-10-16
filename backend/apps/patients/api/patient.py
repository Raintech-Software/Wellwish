"""Patient endpoints (/v1/patient/...): own profile, family members (§6.18) and account
deletion (§12)."""

from uuid import UUID

from django.http import HttpRequest
from ninja import Query, Router

from apps.accounts import selectors as account_selectors
from apps.accounts.schemas import ConsentNeededOut
from apps.addresses import selectors as address_selectors
from apps.addresses.api.patient import address_out
from apps.bookings import selectors as booking_selectors
from apps.bookings.api.patient import payment_time, row_fields
from apps.bookings.schemas import BookingRowOut
from apps.documents import selectors as document_selectors
from apps.documents.api.patient import document_out
from apps.files import services as files
from apps.files.schemas import UploadUrlOut
from apps.patients import selectors, services
from apps.patients.models import Member
from apps.patients.schemas import (
    DeletionRequestOut,
    MemberDetailOut,
    MemberIn,
    MemberOut,
    MemberPhotoUrlIn,
    PatientMeIn,
    PatientMeOut,
)
from common.auth import get_principal
from common.schemas import OkOut

router = Router(tags=["patient"])


def _me(user_id: str) -> PatientMeOut:
    profile = selectors.get_profile(user_id)
    user = profile.user
    return PatientMeOut(
        id=str(user.pk),
        phone=user.phone,
        full_name=profile.full_name,
        dob=profile.dob,
        gender=profile.gender,
        language=user.language,
        self_member_id=str(selectors.get_self_member(user_id).pk),
        profile_complete=profile.is_complete,
        consents_needed=[
            ConsentNeededOut(type=t, version=v)  # type: ignore[arg-type]
            for t, v in account_selectors.consents_needed(user_id)
        ],
        google_linked=bool(user.google_sub),
    )


@router.get("/me", response=PatientMeOut, by_alias=True, operation_id="patientMeGet")
def get_me(request: HttpRequest) -> PatientMeOut:
    return _me(get_principal(request).subject_id)


@router.put("/me", response=PatientMeOut, by_alias=True, operation_id="patientMeUpdate")
def update_me(request: HttpRequest, data: PatientMeIn) -> PatientMeOut:
    """Profile setup (P04): name, date of birth, gender, language. Updates the SELF member too."""
    user_id = get_principal(request).subject_id
    services.update_profile(
        user=account_selectors.get_user(user_id),
        full_name=data.full_name,
        dob=data.dob,
        gender=data.gender,
        language=data.language,
    )
    return _me(user_id)


@router.post(
    "/me/delete-request",
    response=DeletionRequestOut,
    by_alias=True,
    operation_id="patientDeleteAccount",
)
def delete_account(request: HttpRequest) -> DeletionRequestOut:
    """Delete my account (P27). You are logged out on every phone now; your personal data
    (profile, family, addresses, documents) is removed after `dueAt`. Logging in again before
    then keeps the account. Payment records are kept, as the law requires."""
    deletion = services.request_deletion(user_id=get_principal(request).subject_id)
    return DeletionRequestOut(due_at=deletion.due_at)


# --- Family members (§6.18) ---


def member_out(member: Member, addresses: int = 0, documents: int = 0) -> MemberOut:
    return MemberOut(
        id=str(member.pk),
        relation=member.relation,
        is_self=member.relation == Member.Relation.SELF,
        full_name=member.full_name,
        dob=member.dob,
        age=selectors.age(member.dob),
        gender=member.gender,
        photo_key=member.photo_key,
        photo_url=files.view_url(member.photo_key) if member.photo_key else None,
        phone=member.phone,
        language=member.language,
        conditions=member.conditions,
        allergies=member.allergies,
        mobility=member.mobility,
        sensory_notes=member.sensory_notes,
        emergency_name=member.emergency_name,
        emergency_phone=member.emergency_phone,
        consent_at=member.consent_at,
        address_count=addresses,
        document_count=documents,
    )


def _input(data: MemberIn) -> services.MemberInput:
    return services.MemberInput(
        relation=data.relation,
        full_name=data.full_name,
        dob=data.dob,
        gender=data.gender,
        photo_key=data.photo_key,
        phone=data.phone,
        language=data.language,
        conditions=data.conditions,
        allergies=data.allergies,
        mobility=data.mobility,
        sensory_notes=data.sensory_notes,
        emergency_name=data.emergency_name,
        emergency_phone=data.emergency_phone,
        consent=data.consent,
    )


def _counted(user_id: str, member: Member) -> MemberOut:
    member_id = str(member.pk)
    return member_out(
        member,
        address_selectors.counts_by_member(user_id).get(member_id, 0),
        document_selectors.counts_by_member(user_id).get(member_id, 0),
    )


@router.get("/members", response=list[MemberOut], by_alias=True, operation_id="patientMemberList")
def list_members(request: HttpRequest) -> list[MemberOut]:
    """You and your family members (P22): yourself first."""
    user_id = get_principal(request).subject_id
    addresses = address_selectors.counts_by_member(user_id)
    documents = document_selectors.counts_by_member(user_id)
    return [
        member_out(m, addresses.get(str(m.pk), 0), documents.get(str(m.pk), 0))
        for m in selectors.members(user_id)
    ]


@router.post("/members", response=MemberOut, by_alias=True, operation_id="patientMemberAdd")
def add_member(request: HttpRequest, data: MemberIn) -> MemberOut:
    """Add a family member (P28). Up to 10 (a setting); the consent tick is required."""
    user_id = get_principal(request).subject_id
    return _counted(user_id, services.add_member(user_id=user_id, data=_input(data)))


@router.post(
    "/members/photo-upload-url",
    response=UploadUrlOut,
    by_alias=True,
    operation_id="patientMemberPhotoUploadUrl",
)
def photo_upload_url(request: HttpRequest, data: MemberPhotoUrlIn) -> UploadUrlOut:
    """Step 1 of a member photo: PUT it to `uploadUrl`, then save the member with `fileKey`."""
    ticket = services.create_member_photo_upload(
        user_id=get_principal(request).subject_id, mime=data.mime, size_bytes=data.size_bytes
    )
    return UploadUrlOut(
        file_key=ticket.file_key,
        upload_url=ticket.upload_url,
        upload_fields=ticket.upload_fields,
        mime=ticket.mime,
        max_bytes=ticket.max_bytes,
    )


@router.get(
    "/members/{uuid:member_id}",
    response=MemberDetailOut,
    by_alias=True,
    operation_id="patientMemberGet",
)
def get_member(request: HttpRequest, member_id: UUID) -> MemberDetailOut:
    user_id = get_principal(request).subject_id
    member = selectors.own_member(user_id, str(member_id))
    addresses = list(address_selectors.addresses(user_id, member_id=str(member.pk)))
    documents = document_selectors.documents(user_id, member_id=str(member.pk))
    expiry = payment_time()
    return MemberDetailOut(
        member=member_out(member, len(addresses), documents.count()),
        addresses=[address_out(a) for a in addresses],
        documents=[document_out(d) for d in documents[:20]],
        bookings=[
            BookingRowOut(**row_fields(b, expiry))
            for b in booking_selectors.member_bookings(user_id, str(member.pk))
        ],
    )


@router.put(
    "/members/{uuid:member_id}",
    response=MemberOut,
    by_alias=True,
    operation_id="patientMemberUpdate",
)
def update_member(request: HttpRequest, member_id: UUID, data: MemberIn) -> MemberOut:
    """Edit a member. Changes apply to future bookings only (each booking keeps a copy)."""
    user_id = get_principal(request).subject_id
    member = services.update_member(user_id=user_id, member_id=str(member_id), data=_input(data))
    return _counted(user_id, member)


@router.delete(
    "/members/{uuid:member_id}",
    response=OkOut,
    by_alias=True,
    operation_id="patientMemberRemove",
)
def remove_member(
    request: HttpRequest,
    member_id: UUID,
    delete_documents: bool = Query(False, alias="deleteDocuments"),
) -> OkOut:
    """Remove a family member: hidden from the app, past bookings keep their history.
    `deleteDocuments=true` also deletes their medical documents (otherwise they are kept for
    past bookings and no longer count towards the 200 MB)."""
    services.remove_member(
        user_id=get_principal(request).subject_id,
        member_id=str(member_id),
        delete_documents=delete_documents,
    )
    return OkOut()
