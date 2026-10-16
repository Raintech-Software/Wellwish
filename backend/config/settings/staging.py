"""Staging server: production-like, Razorpay test mode, API docs available, seeded test
numbers allowed (ARCHITECTURE §6.2, §13)."""

from .deployed import *  # noqa: F403
from .deployed import env

API_DOCS_ENABLED = env.bool("API_DOCS_ENABLED", default=True)
