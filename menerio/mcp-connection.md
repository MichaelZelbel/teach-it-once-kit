# One memory, every tool (Chapter 26)

MCP is a standard socket. Any AI tool that speaks it can read the same notebook. One key, and
every tool you use answers from the same notes. No tool gets a copy; every tool reads the
same shelf.

## Make the key

Menerio, then **Settings**, then the **API Keys** tab. Press **Generate new API key**. Name it
after the tool or machine that will use it, because in six months you will want to know which
key belongs where.

The grid under **This key may touch** starts with every box ticked. For your own hub or
assistant, leave it that way: full access is the right shape for the key you hold yourself.
Untick boxes only for a key you hand to somebody else's app, and that key can never do more,
whatever the app asks. (A refused tool call names the missing box, so a too-narrow key is a
one-line fix, not a mystery.)

The dialog then says, verbatim:

> Copy this key now, you won't be able to see it again

Believe it. Copy it into your password manager immediately. Never into your folder.

**One key, not two.** Until 2026-08-16 Menerio handed out a separate `mnr_mcp_` token for the
connector and an `mnr_` key for the API. Since 2026-08-18 any API key opens the connector, and
the boxes on the key decide which tools answer, so there is one key and one off-switch. Old
`mnr_mcp_` tokens still work, and the **MCP Server** tab still lists them so any of them can be
revoked; it no longer makes new ones.

## The connection facts

- Endpoint: `https://mcp.menerio.com`, exactly this. No `/mcp`, `/sse` or `/v1` on the end.
- Transport: MCP Streamable HTTP.
- Auth header: `Authorization: Bearer <key>`. Keys start `mnr_`.
- Tools with nowhere to put a header: append `?key=<key>` to the URL instead.
- If a tool call is refused with a message naming a box (for example "This key's boxes don't
  include Notes"), the key is real and too narrow. Edit the key on the **API Keys** tab and
  tick the named box.

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
