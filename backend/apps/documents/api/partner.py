"""Document endpoints for the partner app. From Phase 7 the assigned partner sees the booking's
documents during the job window (§6.8, §6.18)."""

from ninja import Router

router = Router(tags=["partner"])
