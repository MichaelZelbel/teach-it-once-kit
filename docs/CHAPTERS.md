# Chapter map

One row per chapter that uses the kit. Status: **ready** = verified and final for the current draft; **building** = the chapter is in production and the asset lands with it.

> **Renumbering (2026-07-26).** The book was restructured files-first. Every row below carries the
> new chapter numbers, and the old numbering is gone from this file.

> **Part III flip (2026-07-30).** Part III now runs app-first: Chapter 10 has the reader build a
> Skill with the app's own form and take it apart; Chapter 11 moves the master copy into the
> reader's folder (interview, naming, packaging, upload); the old Chapter 14 is gone, absorbed
> into Chapters 10 and 11. Chapters 12 to 14 are the old 11 to 13, one number up. The two
> "building" rows wait on the real runs marked [REAL RUN NEEDED] in the manuscript.

> **Renumbering (2026-08-19, Batch AA).** The developer detour became Chapter 5, and every later
> chapter moved one up. The rows below carry the new numbers, the Part VI rows were also one
> behind since Batch W's insert and are now correct, and the two installer chapters (3 and 26)
> gained the rows this file always owed them. The dated notes above keep the numbering of their
> own day.

## Parts I to V (restructured, final)

| Chapter | Kit asset | Status |
|---|---|---|
| 1. What Your AI Already Knows About You | `profile/bring-your-context-with-you.md` (the export prompt), `profile/about-you-template.md` (fallback only) | ready |
| 3. Give It a Desk and a House | `HubSetup.exe` on the Releases page, and the `kit-bootstrap` one-line installer; both lay down `starter-hub/` | ready |
| 4. The Folder Is the System | `starter-hub/` (the rooms, including `starter-hub/observations/` and `starter-hub/prompts/library/` + `starter-hub/prompts/archive/`) | ready |
| 5. The Workshop Inside the House | `starter-hub/dev/README.md`, `starter-hub/.gitignore` | ready |
| 6. The People Who Matter | `profile/people-interview.md` | ready |
| 7. Projects and Priorities | `profile/projects-interview.md` | ready |
| 8. Your Voice | `profile/voice-extraction-prompt.md` | ready |
| 9. Capture as You Live | `profile/capture-checklist.md`, `starter-hub/observations/MEMORY.md` (the notebook the assistant keeps) | ready |
| 10. Keeping It True | `profile/mirror-test.md`, `profile/spring-clean-checklist.md` | ready |
| 11. Your App Builds the First One | `skills/practice-texts.md` | building |
| 12. Own the Recipe | `skills/skill-interview.md`, `skills/package-a-skill.md`, `skills/practice-texts.md` | building |
| 13. Your First Five Skills | `skills/first-five-skills.md`, `starter-hub/skills/` | ready |
| 14. Skills for Your Craft | `skills/craft-skill-interview.md` | ready |
| 15. Test Like a Pro | `skills/skill-test-checklist.md` | ready |
| 16. The Red Lines | `procedures/red-lines-template.md`, `procedures/red-lines-interview.md` | ready |
| 17. The Safety Net | `procedures/safety-net-setup.md` | ready |
| 18. Private Things Stay Private | `living/privacy-audit-checklist.md` | ready |
| 19. The Clock Changes Everything | `procedures/procedure-register.md`, `starter-hub/procedures.md` | ready |
| 20. The Morning Brief | `procedures/morning-brief-setup.md`, `procedures/where-it-runs.md` | ready |
| 21. The Weekly Review That Runs Itself | `procedures/weekly-review-setup.md`, `procedures/outside-ai-check.md` (the monthly branch) | ready |
| 22. Watchdogs | `procedures/watchdog-setup.md` | ready |
| 23. Trust, but Verify | `living/two-questions-card.md` | ready |

## Part VI (restructured, final)

All optional. The book works without every row below.

> **Chapter 23 rewritten (2026-08-13).** Menerio is taught as the notebook notes are born in,
> never as a copy of the profile folder. `menerio/folder-to-memory.md` (the import prompt, the
> "change it in the folder first" rule and the quarterly re-import) is removed, replaced by
> `menerio/the-notebook.md`. Chapter 24's stranger test now runs on captured notes.

> **`menerio/ai-memory-transport.md` and `menerio/interview-transfer.md` have no chapter row on
> purpose.** They are the Menerio-specific versions of the same move. The general one, which works
> with no extra product at all, is Chapter 1's `profile/bring-your-context-with-you.md`. Restored
> 2026-08-09: the 2026-07-26 files-first renumbering left Chapter 1 holding only the FALLBACK
> template, so the kit taught the reader to fill a folder by hand while the prompt that empties
> their old AI into it sat in a folder nothing pointed at.

| Chapter | Kit asset | Status |
|---|---|---|
| 24. When the Folder Outgrows Itself | `menerio/the-notebook.md` | ready |
| 25. One Memory, Every Tool | `menerio/mcp-connection.md` | ready |
| 26. Install Your Hub on Every Machine | `HubSetup.exe` on the Releases page, and the printed `setup-hub.sh` line | ready |
| 27. The Always-On Server | `server/install.sh`, `server/steps/build-the-server.md`, `server/setup.md`, `server/brief.sh`, `server/three-traps.md` | ready |
| 28. Your Assistant on Telegram, with Hermes | `server/install.sh`, `server/install-hermes.sh` | ready |
| 29. The Swap Test | `swap/opencode.json`, `swap/three-questions.md`, `swap/openrouter-notes.md` | ready |
| 30. Your Saved Prompts, Anywhere | `living/saved-prompt-card.md`, `starter-hub/prompts/README.md`, `starter-hub/prompts/library/README.md`, `starter-hub/prompts/archive/README.md` | ready |
| 31. A Tour of My Hub, and the Road On | none (prose) | ready |

## Back matter

| Chapter | Kit asset | Status |
|---|---|---|
| Appendix C. What You Get, In Order | `living/build-order-card.md` | ready |

Removed 2026-07-26 (R8): `living/one-month-plan.md`. Founder decision D-047 cut the one-month plan
from the book: nothing in the reader's text states a total duration for building the system. The
replacement card carries the same build order measured in sittings and in what the reader has at
the end of each one, with no days, weeks or months anywhere on it.

Removed 2026-07-26: `people-brief-template.md` (then in `context/`, now `profile/`), superseded by
`profile/people-interview.md`.
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
`profile/bring-your-context-with-you.md` (the four wording fixes: ask for a file, say what to do
when it runs long, ask for prompts by job rather than by count, and ban keys outright; plus filing
into `prompts/library/` rather than `skills/`), `procedures/outside-ai-check.md` (new, the monthly
question carried inside Chapter 20's weekly review), `starter-hub/observations/MEMORY.md` (the example
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
