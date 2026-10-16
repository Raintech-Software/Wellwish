"""Read queries for patients, always filtered by the caller."""

import datetime as dt

from django.db.models import Count, F, OuterRef, Q, QuerySet, Subquery

from apps.accounts.models import User
from apps.patients.models import AccountDeletion, Member, PatientProfile
from common.dates import today_ist
from common.errors import NotFound
from common.ids import uid


def get_profile(user_id: str) -> PatientProfile:
    """The caller's own profile (created at first login)."""
    return PatientProfile.objects.select_related("user").get(user_id=user_id)


def get_self_member(user_id: str) -> Member:
    return Member.objects.get(owner_id=uid(user_id), relation=Member.Relation.SELF)


def age(dob: dt.date | None, today: dt.date | None = None) -> int | None:
    if dob is None:
        return None
    today = today or today_ist()
    return today.year - dob.year - ((today.month, today.day) < (dob.month, dob.day))


def members(user_id: str) -> QuerySet[Member]:
    """The caller's active members: yourself first, then in the order they were added."""
    return (
        Member.objects.filter(owner_id=uid(user_id), is_active=True)
        .annotate(is_self=Q(relation=Member.Relation.SELF))
        .order_by("-is_self", "created_at")
    )


def own_member(user_id: str, member_id: str) -> Member:
    """The caller's active member, or 404 (also for other people's members, §6.5)."""
    member = Member.objects.filter(pk=uid(member_id), owner_id=uid(user_id), is_active=True).first()
    if member is None:
        raise NotFound()
    return member


def is_own_member(user_id: str, member_id: str) -> bool:
    return Member.objects.filter(pk=uid(member_id), owner_id=uid(user_id), is_active=True).exists()


# --- Admin ---


def has_profile(user_id: str) -> bool:
    """A patient account (kept when the same person deletes their partner account, §6.20)."""
    return PatientProfile.objects.filter(user_id=uid(user_id)).exists()


def is_blocked(user_id: str) -> bool:
    """Blocked from the patient app by an admin (§9.1)."""
    return PatientProfile.objects.filter(user_id=uid(user_id), blocked_at__isnull=False).exists()


def patients(*, q: str = "") -> QuerySet[User]:
    """Patient accounts (anyone with a patient profile), newest first. `q`: phone or name."""
    pending = AccountDeletion.objects.filter(
        user=OuterRef("pk"), status=AccountDeletion.Status.PENDING
    )
    users = (
        User.objects.filter(patient_profile__isnull=False)
        .select_related("patient_profile")
        .annotate(
            member_count=Count(
                "members",
                filter=Q(members__is_active=True) & ~Q(members__relation=Member.Relation.SELF),
            ),
            deletion_due_at=Subquery(pending.values("due_at")[:1]),
            full_name=F("patient_profile__full_name"),
            blocked_at=F("patient_profile__blocked_at"),
        )
        .order_by("-created_at")
    )
    q = q.strip()
    if q:
        digits = "".join(ch for ch in q if ch.isdigit())
        match = Q(patient_profile__full_name__icontains=q)
        if len(digits) >= 4:
            match |= Q(phone__contains=digits[-10:])
        users = users.filter(match)
    return users


def patient(user_id: str) -> User:
    user = (
        User.objects.filter(pk=uid(user_id), patient_profile__isnull=False)
        .select_related("patient_profile")
        .first()
    )
    if user is None:
        raise NotFound()
    return user


def all_members(user_id: str) -> QuerySet[Member]:
    """Every member of an account, removed ones too (admin view)."""
    return (
        Member.objects.filter(owner_id=uid(user_id))
        .annotate(is_self=Q(relation=Member.Relation.SELF))
        .order_by("-is_self", "-is_active", "created_at")
    )


def pending_deletion(user_id: str) -> AccountDeletion | None:
    return AccountDeletion.objects.filter(
        user_id=uid(user_id), status=AccountDeletion.Status.PENDING
    ).first()


def account_deletions(*, status: str = "") -> QuerySet[AccountDeletion]:
    rows = AccountDeletion.objects.order_by("-created_at")
    return rows.filter(status=status) if status else rows
