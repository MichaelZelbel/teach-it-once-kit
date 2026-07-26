# Install a Recipe as a Skill (Chapter 14)

A recipe in `skills/` runs when you say its name. A recipe installed as a
**Skill** in the app runs when the job comes up, because the app matches
what you asked for against the skill's description. This is how you stop
having to remember your own skills exist.

Your folder keeps the master copy. The app gets a copy.

## What the app expects

A folder with one file in it called `SKILL.md`, starting with a block of
labels between two lines of three dashes:

```
---
name: summarize-for-me
description: Turns a pasted email, newsletter or long document into a
  short brief of actions, money and deadlines. Use whenever the user
  pastes long content and wants to know what to do about it.
---
```

Then your recipe underneath, unchanged.

Rules from Anthropic's documentation, all of which the upload enforces:

- `name`: lowercase letters, numbers and hyphens only, 64 characters max.
- The folder must be named the same as the skill.
- `description`: one sentence that says both **what it does** and **when
  to use it**. This sentence is what triggers the skill, so it is the
  most important line in the file. Keep it under 200 characters.
- The zip must contain the folder, not the loose files.

## Let your assistant do it

In a session with your folder attached:

```
Turn skills/summarize-for-me.md into a Claude Skill I can upload. Make a
folder called summarize-for-me with one file in it called SKILL.md. The
file starts with a YAML block between two lines of three dashes, holding
name: summarize-for-me and description: one sentence saying what the
skill does and when to use it. Put my recipe underneath. Then zip the
folder so that the folder itself sits inside the zip, and tell me exactly
where the zip file is.
```

It will ask permission before zipping, because zipping runs a command.
Say yes. What you get is one small `.zip` next to your folder.

## Install it

Two visits, once each.

1. **Settings > Capabilities**, and make sure **Code execution and file
   creation** is on. Skills ride on it. On a Team or Enterprise account
   an owner has to enable it for the organisation first.
2. **Customize > Skills**, click **+**, choose **+ Create skill**, then
   **Upload a skill**, and pick the zip. The skill appears in the list
   with a switch. Leave it on.

## The rule to keep afterwards

Anthropic state that custom skills do not sync across surfaces. Nothing
you change in the app comes back to your folder, and nothing you change
in your folder reaches the app until you upload again.

So: edit the file in `skills/` first, always. Re-package and re-upload
when the change is worth it. The folder is the book of recipes. The app
is the card taped above the stove.
