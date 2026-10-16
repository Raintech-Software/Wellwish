import pytest

from common import events

received: list[tuple[str, dict]] = []


@events.subscribe("demo.happened")
def demo_handler(name: str, payload: dict) -> None:
    received.append((name, payload))


@pytest.fixture(autouse=True)
def _clear():
    received.clear()


@pytest.mark.django_db
def test_publish_runs_handler_only_after_commit(django_capture_on_commit_callbacks):
    with django_capture_on_commit_callbacks(execute=False) as callbacks:
        events.publish("demo.happened", {"booking_id": "b-1"})
        assert received == []  # nothing runs before commit

    for callback in callbacks:
        callback()
    assert received == [("demo.happened", {"booking_id": "b-1"})]


@pytest.mark.django_db
def test_publish_without_handlers_does_nothing(django_capture_on_commit_callbacks):
    with django_capture_on_commit_callbacks(execute=True) as callbacks:
        events.publish("nobody.listens", {"x": 1})
    assert callbacks == []


def test_publish_rejects_non_json_payload():
    with pytest.raises(TypeError):
        events.publish("demo.happened", {"when": object()})


def test_subscribe_registers_handler_once():
    events.subscribe("demo.happened")(demo_handler)
    path = f"{demo_handler.__module__}.{demo_handler.__qualname__}"
    assert events.handlers_for("demo.happened").count(path) == 1
