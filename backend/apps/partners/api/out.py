"""Turning partner rows into API answers (shared by the partner app and admin endpoints)."""

from datetime import datetime

from apps.files.services import view_url
from apps.partners.models import PartnerPhone, PartnerProfile
from apps.partners.schemas import PartnerProfileOut, PhoneOut
from apps.partners.selectors import find_partner, is_available_today
from apps.partners.services import NotRegistered, pending_deletion


def phones_out(partner: PartnerProfile) -> list[PhoneOut]:
    out = []
    for phone in PartnerPhone.objects.filter(partner=partner).order_by("kind"):
        verified = (
            partner.user.phone_verified_at is not None
            if phone.kind == PartnerPhone.Kind.PRIMARY
            else phone.verified_at is not None
        )
        out.append(PhoneOut(kind=phone.kind, phone=phone.phone, verified=verified))
    return out


def profile_out(partner: PartnerProfile) -> PartnerProfileOut:
    return PartnerProfileOut(
        id=str(partner.pk),
        role=partner.role,
        status=partner.status,
        suspended_reason=partner.suspended_reason,
        full_name=partner.full_name,
        dob=partner.dob,
        gender=partner.gender,
        photo_key=partner.photo_key,
        photo_url=view_url(partner.photo_key) if partner.photo_key else None,
        email=partner.email,
        email_verified=partner.email_verified_at is not None,
        address=partner.address,
        lat=str(partner.lat) if partner.lat is not None else None,
        lng=str(partner.lng) if partner.lng is not None else None,
        languages=list(partner.languages),
        skills=list(partner.skills),
        emergency_name=partner.emergency_name,
        emergency_phone=partner.emergency_phone,
        available_today=is_available_today(partner),
        added_by_admin=partner.added_by_admin,
        phones=phones_out(partner),
        created_at=partner.created_at,
        approved_at=partner.approved_at,
        deletion_due_at=_deletion_due(partner),
    )


def _deletion_due(partner: PartnerProfile) -> datetime | None:
    deletion = pending_deletion(str(partner.pk))
    return deletion.due_at if deletion else None


def own_partner(user_id: str) -> PartnerProfile:
    """The caller's own partner profile (409 NOT_REGISTERED before they choose a role)."""
    partner = find_partner(user_id)
    if partner is None:
        raise NotRegistered()
    return partner
