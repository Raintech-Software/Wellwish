"""WebSocket routes (ARCHITECTURE §6.14, §10.4)."""

from django.conf import settings
from django.urls import URLPattern, path

from common.consumers import EchoConsumer
from common.realtime import PartnerSocketConsumer, PatientSocketConsumer, StaffSocketConsumer

websocket_urlpatterns: list[URLPattern] = [
    path("ws/patient/", PatientSocketConsumer.as_asgi()),
    path("ws/partner/", PartnerSocketConsumer.as_asgi()),
    path("ws/staff/", StaffSocketConsumer.as_asgi()),
]

if settings.DEBUG:
    # Dev-only smoke test for the WebSocket server.
    websocket_urlpatterns.append(path("ws/echo/", EchoConsumer.as_asgi()))
