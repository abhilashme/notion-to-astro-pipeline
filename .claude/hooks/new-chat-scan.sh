#!/bin/bash
# SessionStart (startup): at the start of every new chat, tell Claude to resume
# from the Site Log and run the website-content-sync scan before other work.
jq -n '{hookSpecificOutput:{hookEventName:"SessionStart",additionalContext:"NEW CHAT RULE: before other work, run the start-of-chat check in CLAUDE.md. Read pipeline.config.json. If any Notion ID is empty, offer to run the Setup steps in the website-content-sync skill instead. Otherwise: (1) fetch the Site Log page and read its latest entries; (2) run website-content-sync Stage 1; (3) report the Stage 2 summary and open items. Do not publish, commit, or push until the user confirms. If LinkedIn shows a sign-in wall, ask the user to sign in; never type credentials. Skip the check if the user first message asks to."}}'
exit 0
