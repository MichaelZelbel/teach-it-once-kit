# Chapter map

One row per chapter that uses the kit. Status: **ready** = verified and final for the current draft; **building** = the chapter is in production and the asset lands with it.

> **Renumbering (2026-07-26).** The book was restructured files-first. Every row below carries the
> new chapter numbers, and the old numbering is gone from this file.

> **Part III flip (2026-07-30).** Part III now runs app-first: Chapter 10 has the reader build a
> Skill with the app's own form and take it apart; Chapter 11 moves the master copy into the
> reader's folder (interview, naming, packaging, upload); the old Chapter 14 is gone, absorbed
> into Chapters 10 and 11. Chapters 12 to 14 are the old 11 to 13, one number up. The two
> "building" rows wait on the real runs marked [REAL RUN NEEDED] in the manuscript.

## Parts I to V (restructured, final)

| Chapter | Kit asset | Status |
|---|---|---|
| 1. What Your AI Already Knows About You | `context/bring-your-context-with-you.md` (the export prompt), `context/about-you-template.md` (fallback only) | ready |
| 4. The Folder Is the System | `starter-hub/` (eight names, including `starter-hub/memory/` and `starter-hub/prompts/library/` + `starter-hub/prompts/archive/`) | ready |
| 5. The People Who Matter | `context/people-interview.md` | ready |
| 6. Projects and Priorities | `context/projects-interview.md` | ready |
| 7. Your Voice | `context/voice-extraction-prompt.md` | ready |
| 8. Capture as You Live | `context/capture-checklist.md`, `starter-hub/memory/MEMORY.md` (the notebook the assistant keeps) | ready |
| 9. Keeping It True | `context/mirror-test.md`, `context/spring-clean-checklist.md` | ready |
| 10. Your App Builds the First One | `skills/practice-texts.md` | building |
| 11. Own the Recipe | `skills/skill-interview.md`, `skills/package-a-skill.md`, `skills/practice-texts.md` | building |
| 12. Your First Five Skills | `skills/first-five-skills.md`, `starter-hub/skills/` | ready |
| 13. Skills for Your Craft | `skills/craft-skill-interview.md` | ready |
| 14. Test Like a Pro | `skills/skill-test-checklist.md` | ready |
| 15. The Red Lines | `procedures/red-lines-template.md`, `procedures/red-lines-interview.md` | ready |
| 16. The Safety Net | `procedures/safety-net-setup.md` | ready |
| 17. Private Things Stay Private | `living/privacy-audit-checklist.md` | ready |
| 18. The Clock Changes Everything | `procedures/procedure-register.md`, `starter-hub/procedures.md` | ready |
| 19. The Morning Brief | `procedures/morning-brief-setup.md`, `procedures/where-it-runs.md` | ready |
| 20. The Weekly Review That Runs Itself | `procedures/weekly-review-setup.md`, `procedures/outside-ai-check.md` (the monthly branch) | ready |
| 21. Watchdogs | `procedures/watchdog-setup.md` | ready |
| 22. Trust, but Verify | `living/two-questions-card.md` | ready |

## Part VI (restructured, final)

All optional. The book works without every row below.

> **`menerio/ai-memory-transport.md` and `menerio/interview-transfer.md` have no chapter row on
> purpose.** They are the Menerio-specific versions of the same move. The general one, which works
> with no extra product at all, is Chapter 1's `context/bring-your-context-with-you.md`. Restored
> 2026-08-09: the 2026-07-26 files-first renumbering left Chapter 1 holding only the FALLBACK
> template, so the kit taught the reader to fill a folder by hand while the prompt that empties
> their old AI into it sat in a folder nothing pointed at.

| Chapter | Kit asset | Status |
|---|---|---|
| 23. When the Folder Outgrows Itself | `menerio/folder-to-memory.md` | ready |
| 24. One Memory, Every Tool | `menerio/mcp-connection.md` | ready |
| 25. The Always-On Server | `server/install.sh`, `server/steps/build-the-server.md`, `server/setup.md`, `server/brief.sh`, `server/three-traps.md` | ready |
| 26. Your Assistant on Telegram, with Hermes | `server/install.sh`, `server/install-hermes.sh` | ready |
| 27. The Swap Test | `swap/opencode.json`, `swap/three-questions.md`, `swap/openrouter-notes.md` | ready |
| 28. The Prompts You Carry | `living/carried-prompt-card.md` | ready |
| 29. A Tour of My Hub, and the Road On | none (prose) | ready |

## Back matter

| Chapter | Kit asset | Status |
|---|---|---|
| Appendix C. What You Get, In Order | `living/build-order-card.md` | ready |

Removed 2026-07-26 (R8): `living/one-month-plan.md`. Founder decision D-047 cut the one-month plan
from the book: nothing in the reader's text states a total duration for building the system. The
replacement card carries the same build order measured in sittings and in what the reader has at
the end of each one, with no days, weeks or months anywhere on it.

Removed 2026-07-26: `context/people-brief-template.md`, superseded by `context/people-interview.md`.
Removed 2026-07-26 (R4b): `skills/skill-library-template.md`. The folder is the library now, so a
separate master-copy document has nothing left to do. What survived of it (naming rules, the
master-copy habit) moved into Chapters 10 and 14.

Rewritten 2026-07-26 (R5): `procedures/red-lines-template.md` (now eight rules, and the install
step that was missing), `living/privacy-audit-checklist.md` (folder drawer added, Claude's real
screens), `starter-hub/AGENTS.md` (honesty rules 6 to 8). New: `procedures/safety-net-setup.md`.

Rewritten 2026-07-26 (R6): `procedures/procedure-register.md` (the register is now `procedures.md`
in the reader's own folder, not a document kept somewhere), `procedures/morning-brief-setup.md`
(recipe first, then Claude's Scheduled tasks, against the folder), `procedures/weekly-review-setup.md`,
`procedures/watchdog-setup.md` (cloud watchdog, plus the connectors-are-hands boundary),
`starter-hub/procedures.md` (the empty template row moved inside a comment, so it can never be
mistaken for a real procedure), `living/two-questions-card.md` (the half-right trap).
New: `procedures/where-it-runs.md`, the local-versus-cloud rule that decides what any procedure can
touch.

New and rewritten 2026-08-09 (batch T, "the folder that does not start empty"):
`starter-hub/prompts/library/README.md` and `starter-hub/prompts/archive/README.md` (the two
drawers, seeded and self-explaining; the library is not `skills/`, and the archive carries the
honest limit that Claude Desktop keeps no local conversation store to harvest),
`starter-hub/AGENTS.md` (the never-load-`prompts/` rule),
`context/bring-your-context-with-you.md` (the four wording fixes: ask for a file, say what to do
when it runs long, ask for prompts by job rather than by count, and ban keys outright; plus filing
into `prompts/library/` rather than `skills/`), `procedures/outside-ai-check.md` (new, the monthly
question carried inside Chapter 20's weekly review), `starter-hub/memory/MEMORY.md` (the example
row moved inside a comment after a cold run left it sitting in the list like a real memory, the
same defect R6 fixed in `procedures.md`).

Rewritten 2026-07-26 (R7): `menerio/README.md` and `menerio/mcp-connection.md` (the connector
panel moved to **Customize**, and the app's dialog has no header field, so the token goes in the
URL), `server/README.md`, `swap/README.md`, `swap/openrouter-notes.md` (prices re-read live; the
unit is tokens, not words, and the budget sibling is about a quarter of the price, not a third).
New: `menerio/folder-to-memory.md` (the folder is the import source, not the chat history),
`server/setup.md`, `server/brief.sh`, `server/three-traps.md`, `swap/opencode.json`,
`swap/three-questions.md`.
Removed: `swap/opencode-config.example.jsonc`, replaced by a real `swap/opencode.json` that can be
copied straight into a folder.
