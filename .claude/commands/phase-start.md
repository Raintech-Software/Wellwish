---
description: Start the next WellWish phase from docs/PROGRESS.md — summarise it, then wait for "go".
---
Read `docs/PROGRESS.md` and find the next phase. If a phase is already 🟨 *In progress*, tell me and suggest `/phase-continue` instead of starting a new one.

For the next phase, read its section in `docs/PHASES.md` and the ARCHITECTURE.md sections it references. Then give me a short summary:
- Phase number, name and goal (1–2 lines)
- Main tasks, grouped by part (backend / patient app / partner app / admin), about 5–8 bullets
- Exit criteria I'll need to help with (anything on a real phone, any accounts or keys needed)
- Anything that blocks starting (missing tools, open client decisions from §17)

Then **stop and wait for me to reply "go"**.

When I say go, follow the phase workflow in CLAUDE.md exactly:
1. Mark the phase 🟨 *In progress* with today's date in PROGRESS.md.
2. Build the tasks in order and tick each one in PHASES.md only when it's done and tested.
3. Run `.\ww.ps1 check` (once it exists) and verify every exit criterion. Ask me to test anything that needs a real phone.
4. Write `docs/phases/phase-NN-<name>.md` from `docs/phases/_TEMPLATE.md`.
5. Mark the phase ✅ *Done* in PROGRESS.md with the date and report link, and set the next phase.
6. Offer a git commit. Don't commit unless I agree.
