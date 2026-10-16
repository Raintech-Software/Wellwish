---
description: Continue the WellWish phase that is in progress (for a new chat after a session ended mid-phase).
---
Continue the phase marked 🟨 *In progress* in `docs/PROGRESS.md`. If no phase is in progress, say so and suggest `/phase-start`.

1. Read that phase in `docs/PHASES.md`. List which tasks are ticked and which aren't.
2. Quickly verify the ticked tasks still work: run `.\ww.ps1 check` (or the relevant tests) and fix anything that broke before going on.
3. Tell me in 2–3 lines where things stand and which task is next.
4. Carry on from the first unticked task, following the phase workflow in CLAUDE.md, until the phase is complete:
   - all exit criteria checked
   - report written in `docs/phases/`
   - PROGRESS.md updated
   - commit offered
