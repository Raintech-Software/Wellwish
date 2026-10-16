"""Step 2 of an upload, as the apps do it (v2.31): a multipart POST with the ticket's fields
first and the file last."""

from typing import Any

from django.core.files.uploadedfile import SimpleUploadedFile
from django.test import Client


def send_file(url: str, content: bytes, mime: str, fields: dict[str, str] | None = None) -> Any:
    """`fields`: the ticket's `uploadFields` (the local storage's are just the type)."""
    form: dict[str, Any] = dict(fields if fields is not None else {"Content-Type": mime})
    form["file"] = SimpleUploadedFile("upload", content, content_type=mime)
    return Client().post(url, form)
