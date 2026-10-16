# WellWish — Claude commands

How to drive the build with Claude, phase by phase. Each command is a file in `.claude/commands/`. Type it in Claude Code in this project folder, for example `/phase-start`.

| Command | When to use it |
|---|---|
| `/setup-check` | **Once, before Phase 0.** Checks your PC has everything: Docker Desktop + WSL 2, Android Studio, Node, Git. |
| `/phase-start` | **Every new phase.** Claude summarises the next phase and waits for you to reply **go**. |
| `/phase-continue` | A chat ended in the middle of a phase. Picks up from the first unticked task. |
| `/phone-test <result>` | Claude asked you to test on a phone. Paste what worked and what failed. |
| `/client-change <change>` | The client changed something. Updates the docs only, no code. |
| `/phase-status` | See where the project stands. Read only. |

---

## The normal cycle

```
/setup-check          (once)
      ↓
/phase-start  →  Claude summarises  →  you reply "go"
      ↓
Claude builds the tasks, ticks them in PHASES.md, runs the checks
      ↓
Claude asks for phone tests if needed  →  /phone-test <result>
      ↓
Claude writes docs/phases/phase-NN-<name>.md, marks ✅ in PROGRESS.md, offers a commit
      ↓
You read the report  →  new chat  →  /phase-start  (next phase)
```

When you reply **"go"**, Claude:
1. marks the phase 🟨 *In progress* in `PROGRESS.md`
2. builds the tasks in order, ticking each one in `PHASES.md` only when it's done and tested
3. runs the checks and verifies every exit criterion
4. writes the report `docs/phases/phase-NN-<name>.md`
5. marks the phase ✅ *Done* in `PROGRESS.md`
6. offers a git commit (it commits only if you agree)

---

## Plain-text versions

Use these if a slash command doesn't show up (for example in an older Claude version). They do the same thing.

**1. Check the machine (once, before Phase 0)**
```text
Check my Windows machine is ready for Phase 0: Git, WSL 2, Docker Desktop running (docker compose works, hello-world runs), Node.js LTS, Flutter + Android SDK + an emulator, PowerShell script execution. Tell me what's missing and how to install it. Don't install anything and don't start the phase.
```

**2. Start a phase (the same prompt for every phase)**
```text
Read docs/PROGRESS.md and start the next phase. Summarise its goal and tasks first, then wait for my go.
```

**3. Continue a phase in a new session**
```text
Continue the phase in progress from docs/PROGRESS.md. Check which tasks in docs/PHASES.md are already ticked, verify they still work, then carry on from the next unticked task.
```

**4. Phone test result**
```text
Phone test result for Phase N: <what worked / what failed, with screenshot or error>. Fix anything that failed, then finish the phase and its report.
```

**5. Client changed something**
```text
Client changed: <the change>. Update ARCHITECTURE.md (new version + "Changed in"), PHASES.md if tasks change, and the decisions log in PROGRESS.md. Don't build anything yet.
```

**6. Project status**
```text
Show me the project status from docs/PROGRESS.md: done phases, current phase, unticked tasks, and any known issues from the reports.
```

---

## Tips

- **Start a new chat for each phase.** Every session reads the same docs (`CLAUDE.md`, `ARCHITECTURE.md`, `PHASES.md`, `PROGRESS.md`), so nothing is lost, and a fresh chat keeps things fast and clean.
- **Read each phase report** in `docs/phases/` before saying go to the next phase. It's your record of what was built, what was tested and what's still open.
- **Phases 7 and 8 need two real Android phones** for the exit criteria: one for the partner app, one for the patient app.
- **Never skip the report.** A phase is only ✅ when its report is written and every exit criterion passed.
- **Client changes go through `/client-change` first.** That way the docs stay the source of truth before any code changes.
