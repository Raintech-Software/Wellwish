"""Load test (PHASES 9.4): the dev settings, run like production (no DEBUG, no auto-reload),
on their own database and Redis numbers (set in infra/docker-compose.yml), so the developer's
data is never touched. Only `ww.ps1 loadtest` uses it."""

from .dev import *  # noqa: F403

DEBUG = False
LOADTEST = True
# every simulated phone comes from the one Locust container: the per-IP write limit would
# count them all as one person (the per-person limit stays on)
WRITE_RATE_LIMIT_PER_IP_MINUTE = 0
# the people's tokens are made before the run starts: long enough for any run length
ACCESS_TOKEN_TTL_SECONDS = 3 * 3600
