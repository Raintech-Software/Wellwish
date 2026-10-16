---
description: Check this Windows PC is ready for WellWish development (Docker Desktop + WSL 2, Android, Node). Run once before Phase 0.
---
Check that my Windows machine is ready for WellWish Phase 0. Local development uses **Docker Desktop on WSL 2** for PostgreSQL, Redis, the Django API and Celery. The Flutter apps and the admin panel run directly on Windows (see CLAUDE.md and docs/ARCHITECTURE.md §3.2, §13).

Check each of these and report a table: tool · required · found (version or "missing") · OK / action needed.
- Git
- WSL 2 installed (`wsl --status`)
- Docker Desktop installed **and running**: `docker version` shows a server, `docker compose version` works, and `docker run --rm hello-world` succeeds
- WSL memory: is there a `%USERPROFILE%\.wslconfig` with a memory cap (suggest 4 GB, so the Android emulator still has room)?
- Node.js LTS + npm
- Flutter (`flutter doctor`), Android SDK, Android licences accepted, and at least one Android emulator
- PowerShell can run local scripts (execution policy), so `ww.ps1` will work
- Ports 8000 (API), 5432 (PostgreSQL) and 6379 (Redis) free on the PC, so the containers can use them
- Python on Windows is optional (the backend runs in a container). Just report the version.

For anything missing, give me the exact install steps (winget commands where possible) in the order to do them, including any restart needed.

**Do not install anything, and do not start Phase 0.** Only check and tell me.
