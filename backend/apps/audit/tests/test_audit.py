"""The audit log can only grow (PHASES 1.10, ARCHITECTURE §9.1)."""

import pytest
from django.db import DatabaseError, connection, transaction

from apps.audit.models import AuditLog
from apps.audit.services import record
from conftest import make_staff

pytestmark = pytest.mark.django_db


def test_record_with_a_model_entity(staff_roles):
    staff = make_staff(staff_roles)
    row = record(
        staff,
        "staff.role_changed",
        staff,
        before={"role": "SUPPORT"},
        after={"role": "FINANCE"},
        reason="Moved to finance",
        ip="10.0.0.5",
    )
    assert row.staff == staff
    assert row.entity_type == "staff.staffuser"
    assert row.entity_id == str(staff.pk)
    assert row.before == {"role": "SUPPORT"}
    assert row.after == {"role": "FINANCE"}
    assert row.at is not None


def test_record_by_the_system_with_a_tuple_entity():
    row = record(None, "booking.expired", ("bookings.booking", "b-1"))
    assert row.staff is None
    assert (row.entity_type, row.entity_id) == ("bookings.booking", "b-1")


def test_rows_cannot_be_changed_or_deleted_through_django():
    row = record(None, "x.y", ("a.b", "1"))
    row.reason = "changed"
    with pytest.raises(RuntimeError):
        row.save()
    with pytest.raises(RuntimeError):
        row.delete()


def test_rows_cannot_be_changed_or_deleted_even_with_sql():
    row = record(None, "x.y", ("a.b", "1"))
    for sql in (
        "UPDATE audit_log SET reason = 'x' WHERE id = %s",
        "DELETE FROM audit_log WHERE id = %s",
    ):
        with pytest.raises(DatabaseError), transaction.atomic(), connection.cursor() as cursor:
            cursor.execute(sql, [row.pk])
    with pytest.raises(DatabaseError), transaction.atomic():
        AuditLog.objects.filter(pk=row.pk).update(reason="x")
    assert AuditLog.objects.get(pk=row.pk).reason == ""
