# Project instructions

A personal website built with Astro. The host (for example AWS Amplify) deploys every push to `main`.
The publishing pipeline is the project skill `website-content-sync` (`.claude/skills/website-content-sync/SKILL.md`). Follow it for any content, résumé, or LinkedIn sync work.
User-specific values (Notion IDs, live URL, LinkedIn URL, sensitive terms) live in `pipeline.config.json`.

## First run

If any Notion value in `pipeline.config.json` is empty, offer to run the skill's Setup section before anything else.

## New chat rule

At the start of every new chat, before other work:
1. Fetch the Site Log page (`notion.site_log_page`) and read its latest entries.
2. Run website-content-sync Stage 1 (Publishing, Ideas Library, loose pages, and LinkedIn drift if configured).
3. Report the Stage 2 summary and open items.

Publish, commit, or push only after the user confirms. LinkedIn: if a sign-in wall shows, ask the user to sign in. Never type credentials.
Skip the check only if the user's first message says so.

## Pipeline change rule

The pipeline is: the skill's SKILL.md, this CLAUDE.md, `pipeline.config.json`, `.claude/hooks/*`, and `.claude/settings.json`.
After any edit to one of these, add a dated entry to the Site Log in the same turn: what changed, why, and any commit hash.

Hooks in `.claude/settings.json` inject both reminders. They only remind; Claude does the reads and writes. Personal permissions belong in the untracked `.claude/settings.local.json`.
