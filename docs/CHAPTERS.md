# Chapter map

One row per chapter that uses the kit. Status: **ready** = verified and final for the current draft; **building** = the chapter is in production and the asset lands with it.

> **Renumbering in progress (2026-07-26).** The book was restructured files-first. Parts I to V
> below carry their new chapter numbers and are final. The remaining rows still carry the **old**
> numbering and get renumbered as each restructure batch lands (R7, then R8). The asset paths are
> stable; only the numbers move.

## Parts I to V (restructured, final)

| Chapter | Kit asset | Status |
|---|---|---|
| 1. What Your AI Already Knows About You | `context/about-you-template.md` (fallback only) | ready |
| 4. The Folder Is the System | `starter-hub/` | ready |
| 5. The People Who Matter | `context/people-interview.md` | ready |
| 6. Projects and Priorities | `context/projects-interview.md` | ready |
| 7. Your Voice | `context/voice-extraction-prompt.md` | ready |
| 8. Capture as You Live | `context/capture-checklist.md` | ready |
| 9. Keeping It True | `context/mirror-test.md`, `context/spring-clean-checklist.md` | ready |
| 10. From Prompt to Skill File | `skills/skill-interview.md`, `skills/practice-texts.md` | ready |
| 11. Your First Five Skills | `skills/first-five-skills.md`, `starter-hub/skills/` | ready |
| 12. Skills for Your Craft | `skills/craft-skill-interview.md` | ready |
| 13. Test Like a Pro | `skills/skill-test-checklist.md` | ready |
| 14. Skills Your App Knows About | `skills/package-a-skill.md` | ready |
| 15. The Red Lines | `procedures/red-lines-template.md` | ready |
| 16. The Safety Net | `procedures/safety-net-setup.md` | ready |
| 17. Private Things Stay Private | `living/privacy-audit-checklist.md` | ready |
| 18. The Clock Changes Everything | `procedures/procedure-register.md`, `starter-hub/procedures.md` | ready |
| 19. The Morning Brief | `procedures/morning-brief-setup.md`, `procedures/where-it-runs.md` | ready |
| 20. The Weekly Review That Runs Itself | `procedures/weekly-review-setup.md` | ready |
| 21. Watchdogs | `procedures/watchdog-setup.md` | ready |
| 22. Trust, but Verify | `living/two-questions-card.md` | ready |

## Not yet renumbered (old scheme)

| Chapter | Kit asset | Status |
|---|---|---|
| 24. The One-Month Plan | `living/one-month-plan.md` | ready |
| 27. A Home for Your Memory (Menerio) | `menerio/` | building |
| 28. Plug the Memory Into Everything (MCP) | `menerio/mcp-connection.md` | building |
| 29. Hire an Agent That Lives in Your Folder | `starter-hub/AGENTS.md` | building |
| 30 (old). Menerio's own GitHub sync | `menerio/github-sync.md` | building |
| 31. Procedures With Real Hands | `procedures/` (file versions) | building |
| 32. The Always-On Server | `server/` | building |
| 33. The Swap Test (OpenCode + Kimi K3) | `swap/` | ready |

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
