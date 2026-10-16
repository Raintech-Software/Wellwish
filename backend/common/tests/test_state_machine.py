import pytest
from django.db import connection, models
from django.test.utils import isolate_apps

from common.state_machine import ConcurrentUpdate, InvalidTransition, StateMachine, transition

MACHINE = StateMachine(
    name="demo",
    transitions={
        ("NEW", "assign"): "OFFERED",
        ("OFFERED", "accept"): "ACCEPTED",
        ("OFFERED", "decline"): "NEW",
    },
)


def test_next_status_follows_the_table():
    assert MACHINE.next_status("NEW", "assign") == "OFFERED"
    assert MACHINE.allowed_events("OFFERED") == ["accept", "decline"]


def test_next_status_refuses_unknown_moves():
    with pytest.raises(InvalidTransition) as exc:
        MACHINE.next_status("NEW", "accept")
    assert exc.value.status == 409
    assert exc.value.code == "INVALID_TRANSITION"


@pytest.fixture
def job_model():
    with isolate_apps("common"):

        class Job(models.Model):
            status = models.CharField(max_length=20, default="NEW")
            version = models.PositiveIntegerField(default=0)
            updated_at = models.DateTimeField(auto_now=True)

            class Meta:
                app_label = "common"

        with connection.schema_editor() as editor:
            editor.create_model(Job)
        yield Job
        with connection.schema_editor() as editor:
            editor.delete_model(Job)


@pytest.mark.django_db
def test_transition_updates_status_version_and_records_event(job_model):
    job = job_model.objects.create()
    seen = []

    new = transition(
        job,
        "assign",
        machine=MACHINE,
        actor="admin-1",
        on_transition=lambda obj, old, new, event, actor: seen.append((old, new, event, actor)),
    )

    assert new == "OFFERED"
    assert job.status == "OFFERED"
    assert job.version == 1
    assert seen == [("NEW", "OFFERED", "assign", "admin-1")]


@pytest.mark.django_db
def test_transition_detects_concurrent_change(job_model):
    job = job_model.objects.create()
    stale = job_model.objects.get(pk=job.pk)
    transition(job, "assign", machine=MACHINE)  # someone else moves it first

    with pytest.raises(ConcurrentUpdate):
        transition(stale, "assign", machine=MACHINE)


@pytest.mark.django_db
def test_failed_on_transition_rolls_back(job_model):
    job = job_model.objects.create()

    def boom(*args):
        raise RuntimeError("event row failed")

    with pytest.raises(RuntimeError):
        transition(job, "assign", machine=MACHINE, on_transition=boom)

    assert job_model.objects.get(pk=job.pk).status == "NEW"
