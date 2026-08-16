# One memory, every tool (Chapter 24)

MCP is a standard socket. Any AI tool that speaks it can read the same notebook. One key, and
every tool you use answers from the same notes. No tool gets a copy; every tool reads the
same shelf.

## Make the key

Menerio, then **Settings**, then **MCP** (the sidebar calls it **Connect AI**), then
**Create token**. Name it after the tool or machine that will use it, because in six months you
will want to know which key belongs where.

The dialog says, verbatim:

> This is the only time the full token will be shown. Treat it like a password.

Believe it. Copy it into your password manager immediately. Never into your folder.

## The connection facts

- Endpoint: `https://mcp.menerio.com`, exactly this. No `/mcp`, `/sse` or `/v1` on the end.
- Transport: MCP Streamable HTTP.
- Auth header: `Authorization: Bearer <token>`. Tokens start `mnr_mcp_`.
- Tools with nowhere to put a header: append `?key=<token>` to the URL instead.

## Door one: the chat app (no header field, so the key goes in the URL)

**Settings**, then under the **Customize** heading, **Connectors**. (It used to sit under
Settings directly; the old entry now only tells you it moved.) Then **Add**, then
**Add custom connector**.

The dialog asks for a **Name** and a **Remote MCP server URL**, and nothing else that matters.
There is nowhere to put a token, so use the URL form, all one line:

```
https://mcp.menerio.com?key=PASTE-YOUR-TOKEN-HERE
```

Press **Add**. Verified 2026-07-26: the connector reaches **Connected** and exposes 53 tools,
each marked **Needs approval**. Leave that setting alone. It means the tool has to ask you
before it touches your memory.

## Door two: a terminal tool (header, properly)

```
claude mcp add --transport http memory https://mcp.menerio.com --header "Authorization: Bearer PASTE-YOUR-TOKEN-HERE"
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
agent tool and it installs the server and writes the standing rules (read the profile at session
start, search before answering from memory, capture new facts) into that tool's instructions
file. It asks for your token as its first step.

## Housekeeping

- **One key per place.** Retire a machine, revoke that one key, everything else keeps working.
- **The token page is the off-switch.** Deleting a token cuts that tool off at once. Know where
  the page is before you need it.
- **Keep write tools on approval.** A tool that can save notes can save the wrong note forever.
