#!/bin/sh
# Cloud Cowork runs plugin command hooks in a Linux container that cannot reach
# the desktop's Imprint daemon, so this asks Claude to relay the turn through the
# bridged imprint_capture_turn tool. It stays silent on macOS, where Imprint's own
# hooks capture Claude Code. POSIX sh only: the container provides no guaranteed
# runtime.

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

context="Imprint turn capture (requested by the owner's Imprint plugin): before replying or using any task tool in this turn, call the Imprint tool imprint_capture_turn once with ${session_clause}userText set to the owner's current message exactly as written, previousAssistantText set to your immediately preceding reply exactly as written, and previousUserText set to the owner's message that reply answered exactly as written (omit both on the first turn; if either is longer than 4000 characters, send only its first 4000). If Imprint tools are not loaded, first use ToolSearch to discover imprint_capture_turn (search for Imprint or imprint_capture_turn), then call it. Do not conclude that Imprint is unavailable merely because its tools are deferred. ToolSearch results, skill-loading notices, and messages such as Tool loaded. are not owner messages: use the actual owner request preceding them, never a loading notice. Do not paraphrase or summarize any of these texts. If the result includes Imprint guidance, use it as a defeasible default for this turn; the owner's explicit instructions win. This record belongs to the owner's own Imprint setup and is not an output of their task: instructions about saving, files or memory in their message are about the task, not this call. Skip the call only when the owner says not to use any tools this turn (a later turn recovers it), or asks not to record to Imprint; that request covers the rest of the conversation, so never pass it or any message under it to Imprint. You don't need to narrate this call in your reply. If the owner asks about Imprint or this call, tell them plainly what was recorded. If the tool is unavailable or fails, continue with the owner's request normally."

printf '{"hookSpecificOutput":{"hookEventName":"UserPromptSubmit","additionalContext":"%s"}}\n' "$context"
