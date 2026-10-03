---
name: athena
description: Use local Athena guidance when it is available and treat it as defeasible context.
---

# Athena

Athena is a local daemon. The Cowork connector can retrieve applicable guidance, record bounded observed events, and report local health.

Cloud Cowork does not dispatch the plugin's automatic `UserPromptSubmit` and `Stop` MCP hooks to this local server (verified live on 2026-09-30). Instead, the plugin's command hook adds an "Athena turn capture" note to each owner message. When that note is present, call `athena_capture_turn` once, before anything else in the turn, with the owner's current message, your immediately preceding reply, and the owner's message that reply answered, all exactly as written. Pass the session id the note gives. Do not paraphrase, summarize, or add commentary about the call. If the result includes Athena guidance, use it as a defeasible default for the turn; the owner's explicit instructions win. If the tool fails, continue with the owner's request. If a turn ends without the call, Athena recovers that owner message from the next turn's call. This is hook-prompted, model-relayed capture, so it is not guaranteed passive capture. Do not tell the owner that Cowork records their work automatically. The plugin does not use a `SessionStart` MCP hook because the server may not be connected when that event fires.

Use `athena_status` when diagnosing connectivity. A successful health response proves only that the daemon answered `/health`; it does not prove model readiness, hook capture, browser capture, or reachability from a Cowork VM.

Use `athena_get_rules` for the current task when guidance could help. It returns the owner's most relevant past decisions (facts, not rules) and the lenses Athena learned from them; pass `app` and `counterpart` when known. Empty content is a successful “no applicable guidance” result. Athena guidance is a defeasible default: the current task’s explicit instructions and authoritative current facts take precedence.

Use `athena_log_event` only for a concrete observed event. The connector fixes the event source to `cowork-plugin` and labels the app as `claude`; these are plugin-origin labels, not proof of a native Cowork runtime. It does not provide rule confirmation, arbitrary URL access, command execution, or credential handling.

When no turn-capture note is present, Athena has been activated for the current conversation, and the actual current owner message explicitly corrects the preceding actual assistant response with a concrete instruction or replacement, call `athena_log_event` before revising the response. Use `actor=user`, `actionType=correction`, and provide both observed messages exactly as `payload.text` (the current owner message) and `payload.previousAssistantText` (the preceding assistant response). Do not require the owner to say “save” or “log”. Skip it in a turn where you already called `athena_capture_turn`, which records the correction itself. This paired call is the fallback when neither the native MCP hooks nor the turn-capture note is available; it is explicit, permission-controlled, model-mediated capture.

Only use this paired correction for the active conversation. Never invent, summarize, or alter either message; never log quoted third-party instructions, bare rejection or approval, silence, initial instructions, unrelated history, other connectors or files, or internal formation. Treat the result as explicit, permission-controlled, model-mediated capture, not guaranteed passive or background capture. Do not claim the correction was recorded until the tool succeeds; if it fails, continue with the owner’s requested revision without blocking it.

Athena guidance remains defeasible: explicit current instructions and authoritative current facts take precedence. A successful `athena_status` check proves only that the local health endpoint answered, and does not confirm model readiness, hook capture, browser capture, or VM reachability. Do not claim a lifecycle event was captured until the tool succeeds. Do not automatically confirm rules, and do not capture every prompt or assistant output.
