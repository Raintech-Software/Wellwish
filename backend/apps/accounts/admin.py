from django.contrib import admin

from apps.accounts.models import User


@admin.register(User)
class UserAdmin(admin.ModelAdmin):
    """Developer-only view (the Django admin is off in staging/production)."""

    list_display = ("id", "status", "language", "is_staff", "created_at")
    list_filter = ("status", "is_staff")
    search_fields = ("id",)
    readonly_fields = ("id", "created_at", "updated_at", "last_login")
    exclude = ("password", "groups", "user_permissions")
