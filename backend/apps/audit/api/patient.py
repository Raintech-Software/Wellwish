"""The audit log is admin-only."""

from ninja import Router

router = Router(tags=["patient"])
