# Notion setup

The pipeline reads your writing from Notion. You need one page with two databases and a log page inside it.

## 1. Duplicate the template

1. Open the template: [Website Pipeline template](https://pollen-juice-0d0.notion.site/Website-Pipeline-3fbe8cda24e981d1be88e7b4b11c86ff)
2. Click **Duplicate** (top right). Notion copies it into your workspace.
3. Keep the page name **Website Pipeline**. Claude finds it by that name.
4. Keep your copy private. Do not share it to the web. Your drafts live in it, and a public page would expose them.

You now have:

| Item | What it is for |
|------|----------------|
| **Publishing** database | Anything that may go on the site. Move an entry to `Ready` when you want it published. |
| **Ideas Library** database | Rough ideas and notes. Claude scans it for essays worth drafting. It never publishes from here directly. |
| **Site Log** page | The pipeline's memory. Claude adds a dated entry after each sync, so a new chat can continue where the last one stopped. |

## 2. Connect Notion to Claude

In the Claude app, add the **Notion** connector and allow it to see the **Website Pipeline** page. Claude never asks for a token.

## 3. Let Claude fill the config

Open this project in Claude Code and say:

> Set up my pipeline.

Claude searches for **Website Pipeline**, finds the three items, and writes their IDs to `pipeline.config.json`. It then asks for your live URL, your LinkedIn URL (optional), and any sensitive terms.

## How to publish

1. Write in a **Publishing** entry. Set `Type = Essay` and `Publish To = Blog`.
2. Set `Status = Ready`.
3. In Claude, say: **Sync my site.**
4. Claude shows you what it will publish. Say yes. It builds, checks, pushes, and marks the entry `Published`.

Tick `Confidential` on anything that must never go live. Claude will not publish it.

## Build the databases by hand (if you prefer)

**Publishing**

| Property | Type | Values |
|----------|------|--------|
| Title | Title | |
| Status | Select | Inbox, Refining, Ready, Published |
| Publish To | Multi-select | Blog, About, Projects |
| Type | Select | Essay, Bio, Experience, Project |
| Tags | Multi-select | your own |
| Confidential | Checkbox | |
| Source | Text | |
| Added | Created time | |

**Ideas Library**

| Property | Type | Values |
|----------|------|--------|
| Title | Title | |
| Source Type | Select | Personal Synthesis, Article, Book, Podcast, Conversation |
| Author / Creator | Text | |
| Status | Select | New, Developing, Used |
| Themes / Tags | Multi-select | your own |
| Date Added | Created time | |

**Site Log**: a plain page.
