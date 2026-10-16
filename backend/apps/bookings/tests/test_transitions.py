"""The allowed-transitions table (§6.9, PHASES 5.5): every allowed move works and writes a
timeline row; every other (status, event) pair is refused with 409 INVALID_TRANSITION."""

import pytest

from apps.bookings.models import ActorType, Booking, BookingStatus
from apps.bookings.services import MACHINE, SYSTEM, Actor, transition
from apps.bookings.tests.support import body, book, make_world
from common.state_machine import ConcurrentUpdate, InvalidTransition

pytestmark = pytest.mark.django_db

S = BookingStatus
EVENTS = sorted({event for (_, event) in MACHINE.transitions})
EXPECTED = {
    (S.PENDING_PAYMENT, "PAY"): S.NEW,
    (S.PENDING_PAYMENT, "EXPIRE"): S.EXPIRED,
    (S.NEW, "OFFER"): S.OFFERED,
    (S.OFFERED, "ACCEPT"): S.ACCEPTED,
    (S.OFFERED, "DECLINE"): S.NEW,
    (S.OFFERED, "WITHDRAW"): S.NEW,
    (S.ACCEPTED, "UNASSIGN"): S.NEW,
    (S.ACCEPTED, "START"): S.IN_PROGRESS,
    (S.IN_PROGRESS, "COMPLETE"): S.COMPLETED,
    (S.IN_PROGRESS, "NO_SHOW"): S.PATIENT_NO_SHOW,
    (S.NEW, "CANCEL"): S.CANCELLED,
    (S.OFFERED, "CANCEL"): S.CANCELLED,
    (S.ACCEPTED, "CANCEL"): S.CANCELLED,
}


def test_the_table_is_the_one_in_the_architecture():
    assert dict(MACHINE.transitions) == EXPECTED
    # finished bookings never move again
    for done in (S.COMPLETED, S.CANCELLED, S.EXPIRED, S.PATIENT_NO_SHOW):
        assert MACHINE.allowed_events(done) == []


@pytest.fixture
def booking(api):
    world = make_world(api)
    resp = book(api, world.token, body(world))
    assert resp.status_code == 200, resp.json()
    return Booking.objects.get(pk=resp.json()["id"])


def test_every_status_and_event(booking):
    """All 9 statuses x all 11 events on one booking (resetting the status each time)."""
    staff = Actor(ActorType.STAFF, "6f1c3b8e-0000-4000-8000-000000000001")
    for status in S:
        for event in EVENTS:
            Booking.objects.filter(pk=booking.pk).update(status=status)
            booking.refresh_from_db()
            events_before = booking.events.count()
            expected = EXPECTED.get((status, event))
            case = f"{status} + {event}"
            if expected is None:
                with pytest.raises(InvalidTransition):
                    transition(booking, event, SYSTEM)
                booking.refresh_from_db()
                assert booking.status == status, case
                assert booking.events.count() == events_before, case
                continue
            version = booking.version
            assert transition(booking, event, staff, note="test") == expected, case
            booking.refresh_from_db()
            assert booking.status == expected, case
            assert booking.version == version + 1, case
            last = booking.events.order_by("-server_ts", "-created_at").first()
            assert last is not None
            assert (last.from_status, last.to_status, last.event) == (status, expected, event)
            assert last.actor_type == "STAFF" and str(last.actor_id).endswith("0001"), case
            assert last.note == "test", case


def test_a_stale_copy_cannot_win(booking):
    """Optimistic locking: a cancel and an accept arriving together can't both win."""
    Booking.objects.filter(pk=booking.pk).update(status=S.OFFERED)
    first = Booking.objects.get(pk=booking.pk)
    second = Booking.objects.get(pk=booking.pk)
    transition(first, "ACCEPT", SYSTEM)
    with pytest.raises(ConcurrentUpdate):
        transition(second, "CANCEL", SYSTEM)
    assert Booking.objects.get(pk=booking.pk).status == S.ACCEPTED
