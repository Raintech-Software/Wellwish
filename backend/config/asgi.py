"""ASGI entry point: HTTP goes to Django, `/ws/...` goes to Channels consumers."""

import os

from django.core.asgi import get_asgi_application

os.environ.setdefault("DJANGO_SETTINGS_MODULE", "config.settings.dev")

# Django must be set up before importing anything that touches models.
django_asgi_app = get_asgi_application()

from channels.routing import ProtocolTypeRouter, URLRouter  # noqa: E402
from django.urls import get_resolver  # noqa: E402

from config.routing import websocket_urlpatterns  # noqa: E402

# Load every API module now rather than on the first request (about 2 s, found by the load
# test, PHASES 9.4): with several server processes each would make one real user wait.
get_resolver().url_patterns  # noqa: B018

application = ProtocolTypeRouter(
    {
        "http": django_asgi_app,
        "websocket": URLRouter(websocket_urlpatterns),
    }
)
