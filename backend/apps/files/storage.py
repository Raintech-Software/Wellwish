"""Where uploaded files live (ARCHITECTURE §3.2, §6.8).

- **local** (dev): `MEDIA_ROOT`. Uploads go to a short-lived signed URL on this API, which
  mimics an S3 presigned POST, so the apps use the same flow everywhere.
- **s3** (staging/prod): private bucket in Mumbai; a presigned **POST** to upload (v2.31: its
  policy fixes the key and type and has a `content-length-range`, so S3 itself refuses a file
  over the limit) and presigned GET links to view. Files never pass through the API.
  `FILE_S3_ENDPOINT_URL` points at an S3-compatible store instead (the `ww.ps1 s3-test` store).
"""

from pathlib import Path
from typing import Protocol

from django.conf import settings

from common.tokens import issue_challenge


class FileStorage(Protocol):
    def upload_target(self, key: str, mime: str, max_bytes: int) -> tuple[str, dict[str, str]]:
        """Where to POST the file, and the form fields to send before it."""
        ...

    def view_url(self, key: str) -> str: ...

    def size(self, key: str) -> int | None: ...

    def head_bytes(self, key: str, count: int) -> bytes: ...

    def delete(self, key: str) -> None: ...


class LocalStorage:
    def _path(self, key: str) -> Path:
        root = Path(settings.MEDIA_ROOT).resolve()
        path = (root / key).resolve()
        if root not in path.parents:
            raise ValueError("Bad file key")
        return path

    def upload_target(self, key: str, mime: str, max_bytes: int) -> tuple[str, dict[str, str]]:
        token = issue_challenge(
            "file_upload",
            {"key": key, "mime": mime, "max": max_bytes},
            settings.FILE_UPLOAD_URL_TTL_SECONDS,
        )
        return f"/v1/files/upload/{token}", {"Content-Type": mime}

    def view_url(self, key: str) -> str:
        token = issue_challenge("file_view", {"key": key}, settings.FILE_VIEW_URL_TTL_SECONDS)
        return f"/v1/files/view/{token}"

    def size(self, key: str) -> int | None:
        path = self._path(key)
        return path.stat().st_size if path.is_file() else None

    def head_bytes(self, key: str, count: int) -> bytes:
        with self._path(key).open("rb") as f:
            return f.read(count)

    def save(self, key: str, content: bytes) -> None:
        path = self._path(key)
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_bytes(content)

    def open_path(self, key: str) -> Path:
        return self._path(key)

    def delete(self, key: str) -> None:
        self._path(key).unlink(missing_ok=True)


class S3Storage:
    """Private S3 bucket (KMS-encrypted by bucket policy). Short-lived presigned URLs."""

    def __init__(self) -> None:
        import boto3  # type: ignore[import-untyped]
        from botocore.config import Config  # type: ignore[import-untyped]

        self.bucket = settings.FILE_S3_BUCKET
        endpoint = settings.FILE_S3_ENDPOINT_URL or None
        self.client = boto3.client(
            "s3",
            region_name=settings.FILE_S3_REGION,
            endpoint_url=endpoint,
            config=Config(
                signature_version="s3v4",
                # an S3-compatible test store has no bucket subdomains
                s3={"addressing_style": "path" if endpoint else "virtual"},
            ),
        )

    def upload_target(self, key: str, mime: str, max_bytes: int) -> tuple[str, dict[str, str]]:
        post = self.client.generate_presigned_post(
            Bucket=self.bucket,
            Key=key,
            Fields={"Content-Type": mime},
            Conditions=[{"Content-Type": mime}, ["content-length-range", 1, max_bytes]],
            ExpiresIn=settings.FILE_UPLOAD_URL_TTL_SECONDS,
        )
        return str(post["url"]), {str(k): str(v) for k, v in post["fields"].items()}

    def view_url(self, key: str) -> str:
        url: str = self.client.generate_presigned_url(
            "get_object",
            Params={"Bucket": self.bucket, "Key": key},
            ExpiresIn=settings.FILE_VIEW_URL_TTL_SECONDS,
        )
        return url

    def size(self, key: str) -> int | None:
        try:
            head = self.client.head_object(Bucket=self.bucket, Key=key)
        except self.client.exceptions.ClientError:
            return None
        return int(head["ContentLength"])

    def delete(self, key: str) -> None:
        self.client.delete_object(Bucket=self.bucket, Key=key)

    def head_bytes(self, key: str, count: int) -> bytes:
        obj = self.client.get_object(Bucket=self.bucket, Key=key, Range=f"bytes=0-{count - 1}")
        data: bytes = obj["Body"].read()
        return data


def get_storage() -> LocalStorage | S3Storage:
    return S3Storage() if settings.FILE_STORAGE == "s3" else LocalStorage()
