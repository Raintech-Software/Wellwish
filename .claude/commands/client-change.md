---
description: Record a change requested by the client in the docs (no code changes).
argument-hint: <what the client changed>
---
The client changed this:

$ARGUMENTS

Update the documentation only. **Don't change any code yet.**
1. Explain in a few lines how this affects the current design: which ARCHITECTURE.md sections, screens, APIs, database tables and phases. Point out any conflict with work already done (check the completed phase reports in `docs/phases/`).
2. If anything is unclear, ask me before editing.
3. Then update:
   - `docs/ARCHITECTURE.md`: bump the version and add a "Changed in" line at the top. Update every affected section, and §17 if it answers an open point.
   - `docs/PHASES.md`: add, change or remove tasks in the phases that aren't done yet. If a completed phase needs rework, add a clearly marked task to the next phase and don't untick finished work.
   - `docs/PROGRESS.md`: add a row to the decisions log.
4. Finish with a short list of what changed in each file.
