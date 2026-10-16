---
description: Report the result of an on-phone test so Claude can fix issues and finish the phase.
argument-hint: <phase number> <what worked / what failed, error text>
---
Here is my on-phone test result for the current phase:

$ARGUMENTS

1. Match each point to the exit criteria in `docs/PHASES.md` for the phase in progress.
2. For anything that failed: find the cause, fix it, re-run the related checks, and tell me exactly what to test again on the phone.
3. For anything that passed: record it as verified "on device".
4. When every exit criterion has passed, finish the phase as described in CLAUDE.md: write the report, update PROGRESS.md and offer a commit.
