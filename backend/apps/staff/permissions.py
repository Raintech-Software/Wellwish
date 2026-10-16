"""Admin permissions and the five roles (ARCHITECTURE §9.2).

Endpoints check one permission code with `@staff_permission("bookings.manage")`. The admin
panel shows a menu item only if the staff member has its permission. Migration 0002 seeds the
roles from ROLE_PERMISSIONS; change both together.
"""

PERMISSIONS: dict[str, str] = {
    "dashboard.view": "See the dashboard",
    "bookings.view": "See bookings",
    "bookings.manage": "Assign, reassign, unassign, cancel and reschedule bookings",
    "live.view": "See the live map and alerts",
    "live.manage": "Acknowledge alerts and SOS",
    "partners.view": "See partners and applications",
    "partners.review": "Review partner applications and documents",
    "partners.add": "Add a partner by hand",
    "partners.suspend": "Suspend and reinstate partners",
    "services.view": "See services and prices",
    "services.manage": "Change services and prices",
    "directory.view": "See hospitals, doctors and specialities",
    "directory.manage": "Change hospitals, doctors and specialities",
    "patients.view": "See patients",
    "patients.manage": "Edit details on request, block / unblock, start account deletion",
    "patients.documents": "Open patient documents (logged)",
    "payments.view": "See payments and fee reports",
    "refunds.request": "Request a refund",
    "refunds.approve": "Approve refunds",
    "support.manage": "Answer tickets and moderate reviews",
    "settings.manage": "Change settings, service areas and blocked dates",
    "staff.manage": "Manage admin users and roles",
    "audit.view": "See the audit log",
    "legal.manage": "Edit and publish the legal pages (terms, privacy, refunds)",
}

ROLES: dict[str, str] = {
    "SUPER_ADMIN": "Super Admin",
    "OPERATIONS": "Operations",
    "VERIFICATION": "Verification",
    "FINANCE": "Finance",
    "SUPPORT": "Support",
}

ROLE_PERMISSIONS: dict[str, list[str]] = {
    "SUPER_ADMIN": list(PERMISSIONS),
    "OPERATIONS": [
        "dashboard.view",
        "bookings.view",
        "bookings.manage",
        "live.view",
        "live.manage",
        "partners.view",
        "partners.add",
        "partners.suspend",
        "services.view",
        "directory.view",
        "directory.manage",
        "patients.view",
        "patients.documents",
        "refunds.request",
        "support.manage",
    ],
    "VERIFICATION": [
        "dashboard.view",
        "partners.view",
        "partners.review",
        "partners.add",
        "partners.suspend",
    ],
    "FINANCE": [
        "dashboard.view",
        "services.view",
        "services.manage",
        "patients.view",
        "payments.view",
        "refunds.request",
        "refunds.approve",
    ],
    "SUPPORT": [
        "dashboard.view",
        "bookings.view",
        "live.view",
        "services.view",
        "directory.view",
        "patients.view",
        "refunds.request",
        "support.manage",
    ],
}
