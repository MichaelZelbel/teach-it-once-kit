# One memory, every tool (Chapter 24)

MCP is a standard socket. Any AI tool that speaks it can read the same notebook. One key, and
every tool you use answers from the same notes. No tool gets a copy; every tool reads the
same shelf.

## Make the key

Menerio, then **Settings**, then the **API Keys** tab. Press **Generate new API key**. Name it
after the tool or machine that will use it, because in six months you will want to know which
key belongs where.

Tick three boxes and leave the rest alone:

- **Hub access** ("Let an assistant such as Claude, ChatGPT or your hub folder read and write
  this memory."). Without this one the key is refused at the connector door.
- **Notes** ("Read/write notes"). What the file sync writes.
- **World** ("Entities, events and claims, read only"). What the world sync reads.

The dialog then says, verbatim:

> Copy this key now, you won't be able to see it again

Believe it. Copy it into your password manager immediately. Never into your folder.

**One key, not two.** Until 2026-08-16 Menerio handed out a separate `mnr_mcp_` token for the
connector and an `mnr_` key for the API. The connector now takes the API key when it carries
**Hub access**, so there is one key and one off-switch. Old `mnr_mcp_` tokens still work, and
the **MCP Server** tab still lists them so any of them can be revoked; it no longer makes new ones.

## The connection facts

- Endpoint: `https://mcp.menerio.com`, exactly this. No `/mcp`, `/sse` or `/v1` on the end.
- Transport: MCP Streamable HTTP.
- Auth header: `Authorization: Bearer <key>`. Keys start `mnr_`.
- Tools with nowhere to put a header: append `?key=<key>` to the URL instead.
- If Menerio answers "This API key does not carry the `hub` scope", the key is real and the
  **Hub access** box is not ticked. Edit the key on the **API Keys** tab.

## Door one: the chat app (no header field, so the key goes in the URL)

**Settings**, then under the **Customize** heading, **Connectors**. (It used to sit under
Settings directly; the old entry now only tells you it moved.) Then **Add**, then
**Add custom connector**.

The dialog asks for a **Name** and a **Remote MCP server URL**, and nothing else that matters.
There is nowhere to put a key, so use the URL form, all one line:

```
https://mcp.menerio.com?key=PASTE-YOUR-KEY-HERE
```

Press **Add**. Verified 2026-07-26: the connector reaches **Connected** and exposes 53 tools,
each marked **Needs approval**. Leave that setting alone. It means the tool has to ask you
before it touches your memory.

## Door two: a terminal tool (header, properly)

```
claude mcp add --transport http memory https://mcp.menerio.com --header "Authorization: Bearer PASTE-YOUR-KEY-HERE"
```

Then `claude mcp list` and look for:

```
memory: https://mcp.menerio.com (HTTP) - Connected
```

## The test that proves it

Make a completely empty folder. Open a session there and ask something only your notebook
knows:

```
Use my memory tools. Who is <person>, what is the latest on <a thing
you took notes about>, and how do they want bad news delivered?
Answer only from memory, and say plainly if you cannot find something.
```

Expect the first attempt to refuse: the memory tools need approving before they can run. That
refusal is the permission model working, not a fault. Approve them and ask again.

## Wire an agent tool automatically

The MCP page also has an **Agent Setup Prompt** with a **Copy prompt** button. Paste it into an
agent tool and it installs the server and writes the rules it should follow every session (read
the profile at session start, search before answering from memory, capture new facts) into that
tool's instructions file. It asks for your key as its first step.

## Housekeeping

- **One key per place.** Retire a machine, revoke that one key, everything else keeps working.
- **The API Keys tab is the off-switch.** Revoking a key cuts that tool off at once. Know where
  the page is before you need it.
- **Keep write tools on approval.** A tool that can save notes can save the wrong note forever.
