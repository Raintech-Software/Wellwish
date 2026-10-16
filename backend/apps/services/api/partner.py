"""The apps read the catalogue through /v1/public/services."""

from ninja import Router

router = Router(tags=["partner"])
