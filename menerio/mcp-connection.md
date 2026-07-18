# Connect Menerio through MCP (Chapter 28)

MCP is a standard socket: any AI tool that speaks it can use your Menerio
memory. One token, every tool.

## The connection facts (from Settings → MCP)

- Endpoint: `https://mcp.menerio.com` — exactly this. No `/mcp`, `/sse`,
  or `/v1` at the end.
- Transport: MCP Streamable HTTP.
- Auth header: `Authorization: Bearer <your token>` — the token starts
  with `mnr_mcp_` and is shown only once when you create it.
- Tools that cannot set custom headers (ChatGPT custom connectors):
  append `?key=<your token>` to the URL instead.

## Create the token

Menerio → **Settings** → **MCP** (the sidebar calls it **Connect AI**) →
**Create token**. Give it the name of the tool that will use it, copy it
immediately (one-time display), and store it like a password. One token
per tool; revoke any one of them without touching the others.

## Wire an agent tool automatically

The same MCP page has an **Agent Setup Prompt** with a **Copy prompt**
button. Paste it into your agent tool (Chapter 29) and it installs the
server AND writes the standing rules (read your profile at session start,
search before answering from memory, capture new facts) into the tool's
instructions file. It asks for your token as its first step.

## Sanity check

After connecting, ask your tool: "Call get_user_profile and tell me what
Menerio knows about me." A fresh account answers honestly that the
profile is empty. That empty answer is your proof the pipe works.
