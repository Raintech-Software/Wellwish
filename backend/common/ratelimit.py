"""Fixed-window counters in the cache (Redis in dev/prod), used for OTP and login limits.

limit = Limit("otp:phone:hour", max_hits=5, window_seconds=3600)
if limit.exceeded(phone): ...   # check without counting
limit.hit(phone)                # count one
"""

import hashlib
import hmac
import time
from dataclasses import dataclass

from django.conf import settings
from django.core.cache import cache


@dataclass(frozen=True)
class Limit:
    name: str
    max_hits: int
    window_seconds: int

    def _key(self, ident: str, now: float) -> str:
        # keyed hash: the cache never holds a phone number or an email, not even one that could
        # be guessed back (Phase 9.11, §12 Logs)
        keyed = hmac.new(settings.SECRET_KEY.encode(), ident.encode(), hashlib.sha256)
        digest = keyed.hexdigest()[:24]
        return f"rl:{self.name}:{digest}:{int(now // self.window_seconds)}"

    def count(self, ident: str) -> int:
        return int(cache.get(self._key(ident, time.time()), 0))

    def exceeded(self, ident: str) -> bool:
        return self.count(ident) >= self.max_hits

    def hit(self, ident: str) -> int:
        """Count one hit and return the total in the current window."""
        now = time.time()
        key = self._key(ident, now)
        cache.add(key, 0, timeout=self.window_seconds + 5)
        return int(cache.incr(key))

    def retry_after(self) -> int:
        """Seconds until the current window ends."""
        now = time.time()
        return int(self.window_seconds - (now % self.window_seconds)) + 1

    def reset(self, ident: str) -> None:
        cache.delete(self._key(ident, time.time()))
