# OpenRouter notes (Chapter 33)

OpenRouter (openrouter.ai) sells access to models from many companies
through one account and one key. It is the neutral option for the swap
test: no single vendor owns your login.

## Setup

1. Create an account at openrouter.ai and add a few dollars of credit.
2. Create an API key (dashboard → Keys → Create API Key). Copy it once,
   store it like a password.
3. Connect it to OpenCode: `opencode auth login`, choose OpenRouter,
   paste the key.

## Model ids used in the book

Prices move; these were checked 2026-07-18 on openrouter.ai/models.
Always check live before relying on them.

- `moonshotai/kimi-k3` — the swap-test model. Huge context (about one
  million tokens), roughly $3 per million tokens read and $15 per
  million written.
- `moonshotai/kimi-k2.7-code` — the budget sibling for mechanical work,
  roughly a third of the price.

## Cost hygiene

- An agent reads far more than it writes. Sessions in a big folder cost
  more than chat ever did.
- The OpenRouter dashboard shows spending live, per request. Look at it
  after your first session, on purpose.
- Set a monthly credit limit on the key when you create it. A leash for
  the budget, next to the leash for the actions.
