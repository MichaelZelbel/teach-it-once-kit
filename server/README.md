# server

Optional. Chapter 25 only. This solves one specific problem and nothing else.

**The problem.** A task that touches a folder on your computer runs on your computer, and a task
that runs while your computer is off cannot touch your folder. So a brief that reads your real
files at 6am needs a machine that is awake at 6am. If you work at a desk machine that stays on,
you never need this folder.

**The answer.** A small rented Linux machine, around five euros a month, holding its own clone of
your folder, kept in step through the private repository you set up in Chapter 16.

| File | What it is for |
|---|---|
| `setup.md` | The build, from a blank Ubuntu machine to a brief on your phone. |
| `brief.sh` | The runner: pull, run the recipe, send it, push the result, shout if it failed. |
| `three-traps.md` | The three things that went wrong building this for real, and the fixes. |

## Read this before you build anything

Three findings from building it on a blank machine on 2026-07-26. Each cost time; none is obvious.

1. **On a server, "ask me first" means "no".** With nobody there to answer a permission prompt,
   the request is auto-rejected and the procedure dies. On a server the leash cannot be a
   question, so it has to be the walls: give the assistant its own user account that can reach
   almost nothing, and grant permission in advance.
2. **`git add -A` will commit your keys.** Keep the key file OUTSIDE the folder, in the home
   directory, and put `.env*` in `.gitignore` as a second net.
3. **A silent failure looks exactly like a quiet morning.** The runner must message you when it
   produced nothing. Build that on day one, not after the first outage.
