#!/bin/bash
# PostToolUse (Edit|Write): after an edit to the publishing pipeline, remind Claude
# to record the change in the Notion Site Log.
f=$(jq -r '.tool_input.file_path // .tool_response.filePath // empty')
case "$f" in
  "$CLAUDE_PROJECT_DIR/.claude/skills/"*|"$CLAUDE_PROJECT_DIR/.claude/hooks/"*|"$CLAUDE_PROJECT_DIR/.claude/settings.json"|"$CLAUDE_PROJECT_DIR/CLAUDE.md"|"$CLAUDE_PROJECT_DIR/pipeline.config.json")
    jq -n --arg f "$f" '{hookSpecificOutput:{hookEventName:"PostToolUse",additionalContext:("PIPELINE CHANGE RULE: you just edited " + $f + ", which is part of the publishing pipeline. Before this turn ends, add a dated entry to the Site Log page (site_log_page in pipeline.config.json): what changed, why, and any commit hash. Batch several edits into one entry.")}}'
    ;;
esac
exit 0
