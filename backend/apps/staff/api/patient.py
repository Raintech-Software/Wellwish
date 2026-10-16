"""Staff endpoints exist only for the admin panel (/v1/admin)."""

from ninja import Router

router = Router(tags=["patient"])
