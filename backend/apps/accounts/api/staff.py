"""Accounts endpoints for the staff audience (/v1/admin/...). None yet: patient and partner
accounts are shown in the admin panel from Phase 3 (partners) and Phase 4 (patients)."""

from ninja import Router

router = Router(tags=["admin"])
