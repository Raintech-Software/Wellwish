"""One error format for every endpoint (ARCHITECTURE §10.3):

    {"error": {"code": "SLOT_TAKEN", "message": "...", "details": {}}}

Raise `ApiError` (or a subclass) from services; the handlers below turn it into a response.
"""

import logging
from typing import Any

from django.http import Http404, HttpRequest, HttpResponse
from ninja import NinjaAPI
from ninja.errors import AuthenticationError, HttpError, ValidationError

logger = logging.getLogger(__name__)


class ApiError(Exception):
    status: int = 400
    code: str = "BAD_REQUEST"
    message: str = "The request could not be processed."

    def __init__(
        self,
        message: str | None = None,
        *,
        code: str | None = None,
        status: int | None = None,
        details: dict[str, Any] | None = None,
    ) -> None:
        self.message = message or self.message
        self.code = code or self.code
        self.status = status or self.status
        self.details = details or {}
        super().__init__(self.message)


class NotFound(ApiError):
    """Also used for ownership failures, so callers can't probe other users' ids (§6.5)."""

    status = 404
    code = "NOT_FOUND"
    message = "Not found."


class PermissionDenied(ApiError):
    status = 403
    code = "FORBIDDEN"
    message = "You don't have permission to do this."


class Conflict(ApiError):
    status = 409
    code = "CONFLICT"
    message = "This conflicts with the current state. Reload and try again."


def error_body(code: str, message: str, details: dict[str, Any] | None = None) -> dict[str, Any]:
    return {"error": {"code": code, "message": message, "details": details or {}}}


def _clean_validation_errors(errors: list[Any]) -> list[dict[str, Any]]:
    """Keep only JSON-safe fields from pydantic errors (ctx can hold exception objects)."""
    cleaned = []
    for err in errors:
        if isinstance(err, dict):
            cleaned.append(
                {
                    "loc": [str(part) for part in err.get("loc", [])],
                    "msg": str(err.get("msg", "")),
                    "type": str(err.get("type", "")),
                }
            )
    return cleaned


def register_error_handlers(api: NinjaAPI) -> None:
    def respond(request: HttpRequest, status: int, body: dict[str, Any]) -> HttpResponse:
        return api.create_response(request, body, status=status)

    @api.exception_handler(ApiError)
    def on_api_error(request: HttpRequest, exc: ApiError) -> HttpResponse:
        return respond(request, exc.status, error_body(exc.code, exc.message, exc.details))

    @api.exception_handler(ValidationError)
    def on_validation_error(request: HttpRequest, exc: ValidationError) -> HttpResponse:
        details = {"errors": _clean_validation_errors(list(exc.errors))}
        return respond(
            request, 422, error_body("VALIDATION_ERROR", "Some fields are not valid.", details)
        )

    @api.exception_handler(AuthenticationError)
    def on_auth_error(request: HttpRequest, exc: AuthenticationError) -> HttpResponse:
        return respond(request, 401, error_body("UNAUTHORIZED", "Please log in again."))

    @api.exception_handler(Http404)
    def on_not_found(request: HttpRequest, exc: Http404) -> HttpResponse:
        return respond(request, 404, error_body(NotFound.code, NotFound.message))

    @api.exception_handler(HttpError)
    def on_http_error(request: HttpRequest, exc: HttpError) -> HttpResponse:
        code = {401: "UNAUTHORIZED", 403: "FORBIDDEN", 404: "NOT_FOUND", 405: "METHOD_NOT_ALLOWED"}
        return respond(
            request,
            exc.status_code,
            error_body(code.get(exc.status_code, "HTTP_ERROR"), str(exc.message)),
        )

    @api.exception_handler(Exception)
    def on_unexpected(request: HttpRequest, exc: Exception) -> HttpResponse:
        logger.exception("Unhandled API error on %s %s", request.method, request.path)
        return respond(
            request, 500, error_body("INTERNAL_ERROR", "Something went wrong. Please try again.")
        )
