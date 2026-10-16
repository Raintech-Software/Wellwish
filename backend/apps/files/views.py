"""Local dev storage only: plain Django views that stand in for S3 presigned URLs
(a presigned POST to upload, GET to view). Not mounted when FILE_STORAGE=s3."""

from django.http import FileResponse, HttpRequest, HttpResponse, JsonResponse
from django.http.response import HttpResponseBase
from django.views.decorators.clickjacking import xframe_options_sameorigin
from django.views.decorators.csrf import csrf_exempt
from django.views.decorators.http import require_GET, require_http_methods

from apps.files.services import sniff_mime
from apps.files.storage import LocalStorage
from common.errors import error_body
from common.tokens import InvalidToken, read_challenge


def _error(status: int, code: str, message: str) -> JsonResponse:
    return JsonResponse(error_body(code, message), status=status)


FORM_OVERHEAD = 64 * 1024  # the multipart framing and the fields around the file


@csrf_exempt
@require_http_methods(["POST"])
def upload(request: HttpRequest, token: str) -> HttpResponse:
    """Like S3's presigned POST (v2.31): the `Content-Type` field must be the ticket's type and
    the file at most the purpose's size, or nothing is stored. 204 like S3."""
    try:
        _, data = read_challenge(token, "file_upload")
    except InvalidToken:
        return _error(403, "UPLOAD_EXPIRED", "The upload link has expired. Please try again.")
    max_bytes = int(data["max"])
    # far too big: refused before the body is read, as S3 does
    if int(request.META.get("CONTENT_LENGTH") or 0) > max_bytes + FORM_OVERHEAD:
        return _error(413, "FILE_TOO_LARGE", "The file is too large.")
    if request.POST.get("Content-Type") != data["mime"]:
        return _error(422, "INVALID_FILE", "The file type doesn't match.")
    file = request.FILES.get("file")
    if file is None or not file.size:
        return _error(422, "INVALID_FILE", "No file was sent.")
    if file.size > max_bytes:
        return _error(413, "FILE_TOO_LARGE", "The file is too large.")
    LocalStorage().save(str(data["key"]), file.read())
    return HttpResponse(status=204)


@require_GET
@xframe_options_sameorigin  # the admin's document viewer shows PDFs in a frame on its own origin
def view(request: HttpRequest, token: str) -> HttpResponseBase:
    try:
        _, data = read_challenge(token, "file_view")
    except InvalidToken:
        return _error(403, "LINK_EXPIRED", "This link has expired.")
    storage = LocalStorage()
    key = str(data["key"])
    if storage.size(key) is None:
        return _error(404, "NOT_FOUND", "Not found.")
    response = FileResponse(
        storage.open_path(key).open("rb"),
        content_type=sniff_mime(storage.head_bytes(key, 16)) or "application/octet-stream",
    )
    response["Cache-Control"] = "private, no-store"
    response["X-Content-Type-Options"] = "nosniff"
    return response
