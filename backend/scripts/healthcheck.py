"""Docker health checks: `python scripts/healthcheck.py api|worker|beat`. Exit 0 = healthy."""

import os
import socket
import sys
import urllib.request


def check_api() -> bool:
    with urllib.request.urlopen("http://127.0.0.1:8000/v1/health", timeout=5) as resp:
        return bool(resp.status == 200)


def check_worker() -> bool:
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "config.settings.dev")
    sys.path.insert(0, "/app")
    from config.celery import app

    replies = app.control.ping(destination=[f"worker@{socket.gethostname()}"], timeout=5)
    return bool(replies)


def check_beat() -> bool:
    for pid in os.listdir("/proc"):
        if not pid.isdigit():
            continue
        try:
            with open(f"/proc/{pid}/cmdline", "rb") as f:
                cmd = f.read().replace(b"\x00", b" ")
        except OSError:
            continue
        if b"celery" in cmd and b" beat" in cmd:
            return True
    return False


if __name__ == "__main__":
    checks = {"api": check_api, "worker": check_worker, "beat": check_beat}
    try:
        healthy = checks[sys.argv[1]]()
    except Exception as exc:
        print(f"unhealthy: {exc}")
        healthy = False
    sys.exit(0 if healthy else 1)
