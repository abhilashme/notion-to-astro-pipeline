---
name: website-content-sync
description: Publish writing from Notion to this Astro site, and keep the résumé in step with LinkedIn. Use when the user asks to "check Notion for updates", "publish to my website", "sync my site", "set up my pipeline", or moves a Notion entry to Status = Ready.
---

# Website Content Sync

One pipeline, four stages: **Scan → Decide → Publish → Record.**
Notion is the source of truth for site content. LinkedIn (optional) is the source of truth for the Experience résumé.

All user-specific values live in `pipeline.config.json` at the repo root. Read it first, every time.

## Fixed facts

| Item | Value |
|------|-------|
| Repo | this project folder, branch `main` |
| Deploy | `git push` to `main`. The host (for example AWS Amplify) rebuilds the site. |
| Live URL | `live_url` in `pipeline.config.json` |
| Dev preview | `.claude/launch.json` config `dev` (npm run dev, port 4321) |
| Name and site description | `src/site.ts` |
| Bio and résumé | `intro` and `experience` arrays in `src/pages/index.astro` |
| Projects | `projects` array in `src/pages/projects.astro` |
| Blog posts | `src/content/blog/<slug>.md`, frontmatter `title`, `description`, `pubDate`, `tags`, `draft` |
| Draft filter | Posts with `draft: true` generate no page |

### Notion (from the duplicated template)

| Config key | Notion object | Role |
|------------|---------------|------|
| `notion.publishing_data_source` | **Publishing** database | The publish lane. Only this database triggers publishing. |
| `notion.ideas_data_source` | **Ideas Library** database | Capture layer. Scan for publish-worthy ideas; never publish from it directly. |
| `notion.site_log_page` | **Site Log** page | Memory. Dated entries of what synced and what changed. |

Publishing properties: `Title`, `Status` (Inbox → Refining → Ready → Published), `Publish To` (Blog, About, Projects), `Type` (Essay, Bio, Experience, Project), `Tags`, `Confidential` (checkbox), `Source` (provenance text), `Added`.

Ideas Library properties: `Title`, `Source Type` (Personal Synthesis, Article, Book, Podcast, Conversation), `Author / Creator`, `Status` (New, Developing, Used), `Themes / Tags`, `Date Added`.

## Setup (run once, when any Notion value in the config is empty)

1. Confirm the user has duplicated the Notion template (see `NOTION-SETUP.md`) and connected Notion to Claude. If the Notion tools are missing, stop and ask the user to connect Notion. Do not handle tokens.
2. Search Notion for the page "Website Pipeline". If more than one page matches, list each with its parent path and last-edited date, and ask the user which one to use. Never pick one silently. Fetch the chosen page. Find the Publishing database, the Ideas Library database, and the Site Log page inside it.
3. Fetch each database and take its data source ID (`collection://…`). Write the three IDs to `pipeline.config.json`.
4. Ask the user for `live_url`, an optional `linkedin_url`, and any `sensitive_terms` (for example an employer name or internal project names they never want in an essay). Write them to the config.
5. Show the user the finished config. Commit only when the user asks.

## Hard gates — check before anything goes live

1. `Confidential` checked never publishes. No exceptions.
2. Essay text: scan for every entry in `sensitive_terms`. Remove or generalize each hit, and report it. The user may override this for one named essay, explicitly. Never infer an override. Record it in that entry's `Source` with the date.
3. Text the user wrote in Notion is published as written. Fix only clear editing artifacts (lost punctuation, double spaces) and report each fix.
4. Never add text the user did not approve. If prose is needed (for example a description line), draft it and show it before publishing.
5. Claude never signs in to Notion, LinkedIn, or GitHub for the user, and never types credentials.
6. Never put LinkedIn's "Open to work" badge on the site.
7. Do not publish names of private people, or family details, without the user's explicit consent.

## Stage 1 — Scan (read-only, run in parallel)

**A. Publishing lane.** Query the Publishing data source for `Status = Ready`. Also list `Refining` entries (report only; they are under review).

**B. Ideas Library.** Query entries where `Source Type = Personal Synthesis` (the user's own thinking).
1. Read each one fully with `notion-fetch`. Title and summary are not enough. Say when a body is blank.
2. Compare each against the titles and theses of `src/content/blog/*.md` and the Publishing entries. An item already covered is a duplicate, not a candidate.
3. Tier each item:
   - **Tier 1, ready**: the user's first-person text, complete arc, light editing only.
   - **Tier 2, needs work**: good idea, needs the user's voice, angle, or a claim check.
   - **Duplicate**: already live; name the post.
   - **Hold**: confidential, matches a sensitive term, family content, or names private people. Say which.

Drafting a candidate means: a Publishing entry at `Status = Refining` (Source cites the Ideas page) plus `src/content/blog/<slug>.md` with `draft: true`. The user moves it to Ready.

**C. Loose pages.** Run `notion-search` for recent pages that look like drafts. Report anything new outside both databases.

**D. LinkedIn drift (optional).** Skip if `linkedin_url` is empty.
- Open the profile in the browser available to Claude. If a sign-in wall shows, stop and ask the user to sign in.
- Read the About section and the Experience details page (`/details/experience/`).
- Compare against `intro` and `experience` in `index.astro`. Build a drift table: role, period, bullet added / changed / removed.

## Stage 2 — Decide (ask, do not guess)

Present one summary: Ready entries, Ideas candidates, LinkedIn drift. Ask about real choices, for example:
- A role end date in the future → confirm intent.
- LinkedIn dropped content the site still has → remove or keep.
- Wording that matches a sensitive term → scrub, generalize, or skip.

If nothing is Ready and there is no drift, say so and stop.

## Stage 3 — Publish

**Essay (Status = Ready):**
1. Fetch the Notion page. Its body is the final text. Notion wins over the .md on any drift.
2. Create or update `src/content/blog/<slug>.md`. Set `draft: false` and `pubDate` = publish date.
3. Run the gates.

**Bio or résumé:** edit `index.astro` only. Keep reverse-chronological order and the existing bullet style.

**Verify (all three):**
1. `npm run build` passes.
2. Start the `dev` preview, read the changed page, check the console for errors, and screenshot it for the user.
3. Review `git diff`. Every changed line traces to an approved change.

**Ship (only after the user confirms):** commit with a message naming what synced (for example "Publish essay: …" or "Sync Experience with LinkedIn: …") and push to `main`. After the host rebuilds (a few minutes), confirm the change is live:
```bash
curl -sL <live_url>/blog/<slug>/ | grep -o ".\{20\}<distinctive phrase>.\{20\}"
```

## Stage 4 — Record

1. **Publishing database:** set published entries to `Status = Published`. Update `Source`: file path, commit hash, publish date, live path.
2. **Site Log:** add a dated entry at the end of the Site Log page: what synced, decisions taken, commit hash, anything left open. Update the page; never create a second log.

## Pipeline change rule

The pipeline is: this SKILL.md, `CLAUDE.md`, `pipeline.config.json`, `.claude/hooks/*`, and `.claude/settings.json`.
After any edit to one of these, add a dated entry to the Site Log in the same turn: what changed, why, and any commit hash. A PostToolUse hook reminds Claude; the hook does not write anything itself.

## Final report format

Plain, short sentences. Order:
1. **Summary**: what changed, live or not.
2. **What shipped**: table of item, source, commit, live-verified (yes/no).
3. **Decisions taken**: with the user's choice.
4. **Open items**: things for the user to do, and anything held back, with the reason.
