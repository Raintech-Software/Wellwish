from django.conf import settings
from django.contrib import admin
from django.urls import URLPattern, URLResolver, path

from config.api import api

urlpatterns: list[URLPattern | URLResolver] = []

# Local dev uploads: stand-ins for S3 presigned URLs (apps/files/views.py).
if settings.FILE_STORAGE == "local":
    from apps.files import views as file_views

    urlpatterns += [
        path("v1/files/upload/<str:token>", file_views.upload, name="file-upload"),
        path("v1/files/view/<str:token>", file_views.view, name="file-view"),
    ]

urlpatterns.append(path("v1/", api.urls))

# The trip share link's public page (§6.15).
from apps.safety.views import share_page  # noqa: E402

urlpatterns.append(path("t/", share_page, name="share-page"))

# Legal pages and the account deletion page (§6.20): public, server-rendered.
from apps.legal import deletion as legal_deletion  # noqa: E402
from apps.legal import views as legal_views  # noqa: E402

urlpatterns.append(path("legal/<slug:slug>", legal_views.legal_page, name="legal-page"))
urlpatterns.append(path("delete-account", legal_deletion.delete_account, name="delete-account"))

# Built-in Django admin: developers only (ARCHITECTURE §3.2). Staff use the Next.js admin panel.
if settings.ENABLE_DJANGO_ADMIN:
    urlpatterns.append(path("django-admin/", admin.site.urls))
