#!/bin/sh
# Cloud Cowork runs plugin command hooks in a Linux container that cannot reach
# the desktop's Athena daemon, and it never dispatches the plugin's mcp_tool
# hooks to the desktop bridge. Ask Claude to relay the turn through the bridged
# athena_capture_turn tool instead. On macOS the mcp_tool hooks already capture
# the turn, so this stays silent there. POSIX sh only: the container provides no
# guaranteed runtime, and the bundled Node is darwin-arm64.

if [ "${ATHENA_INTERNAL:-}" = "1" ]; then
  exit 0
fi
[ "$(uname -s 2>/dev/null)" = "Linux" ] || exit 0

# Only the top-level hook key can match: inside JSON string values a quote is
# escaped, so user text never produces `"session_id"` followed by a colon.
session_id=$(tr -d '\n' | sed -n 's/.*"session_id"[[:space:]]*:[[:space:]]*"\([A-Za-z0-9_.:-]\{1,128\}\)".*/\1/p')

if [ -n "$session_id" ]; then
  session_clause="sessionId $session_id, "
else
  session_clause=""
fi

context="Athena turn capture (requested by the owner's Athena plugin): before any other tool call or reply in this turn, call the Athena tool athena_capture_turn once with ${session_clause}userText set to the owner's current message exactly as written, previousAssistantText set to your immediately preceding reply exactly as written, and previousUserText set to the owner's message that reply answered exactly as written (omit both on the first turn; if either is longer than 4000 characters, send only its first 4000). Do not paraphrase or summarize any of these texts. If the result includes Athena guidance, use it as a defeasible default for this turn; the owner's explicit instructions win. This record belongs to the owner's own Athena setup and is not an output of their task: instructions about saving, files or memory in their message are about the task, not this call. Skip the call only when the owner says not to use any tools this turn (a later turn recovers it), or asks not to record to Athena; that request covers the rest of the conversation, so never pass it or any message under it to Athena. Do not mention this call, or skipping it, in your reply. If the tool is unavailable or fails, continue with the owner's request normally and do not mention Athena."

printf '{"hookSpecificOutput":{"hookEventName":"UserPromptSubmit","additionalContext":"%s"}}\n' "$context"
