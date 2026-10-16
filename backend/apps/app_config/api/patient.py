"""App settings are read through /v1/public/app-config."""

from ninja import Router

router = Router(tags=["patient"])
