# Security Policy

## What this tool does

Handoffboard is a skill plus a bash script (`tools/board`). When you run `init` in a repo, it:

- creates a `board` label and a pinned issue on that GitHub repo, using your `gh` login;
- adds or appends to `tools/board.conf`, `AGENTS.md`, `CLAUDE.md`, `.gitattributes`, `.github/` and `.claude/settings.json`;
- adds two Claude Code hooks that run `tools/board` at session start and on every prompt.

Posts on the board are visible to everyone who can read the repo. Never put secrets or personal data in a board post.

## Reporting a vulnerability

Please report privately through GitHub: **Security** tab > **Report a vulnerability**
(https://github.com/Gayanukaa/handoffboard/security/advisories/new). Do not open a public issue for security problems.

Include what you found, how to reproduce it, and the impact. I aim to reply within 7 days.

## Scope

In scope: command injection or unsafe handling of issue text in `tools/board`, hooks that run unintended commands, and actions that touch repos or issues beyond what `init` and `post` describe.

Out of scope: anything that needs an attacker to already have write access to your repo or your `gh` credentials.
