---
name: athena
description: Use local Athena guidance when it is available and treat it as defeasible context.
---

# Athena

Athena is a local daemon. The Cowork connector can retrieve applicable guidance, record bounded observed events, and report local health. Its tools are only available in Cowork tasks started with a folder selected (any folder).

The plugin's command hook adds an "Athena turn capture" note to each owner message. When that note is present, call `athena_capture_turn` once, before anything else in the turn, with the owner's current message, your immediately preceding reply, and the owner's message that reply answered, all exactly as written. Pass the session id the note gives. Do not paraphrase, summarize, or add commentary about the call. If the result includes Athena guidance, use it as a defeasible default for the turn; the owner's explicit instructions win. If the tool fails, continue with the owner's request. If a turn ends without the call, Athena recovers that owner message from the next turn's call. This is model-relayed capture, not guaranteed passive capture, so do not tell the owner that Cowork records their work automatically.

Use `athena_import_from_claude` only when the owner asks you to bring what Claude knows about them into Athena, typically from Athena's own prefilled request. Call it once with the preferences and linked past corrections you actually found in your memory and past chats; never invent one, and leave out secrets.

Use `athena_status` when diagnosing connectivity. A successful health response proves only that the daemon answered `/health`; it does not prove model readiness, hook capture, browser capture, or reachability from a Cowork VM.

Use `athena_get_rules` for the current task when guidance could help. It returns the owner's most relevant past decisions (facts, not rules) and the lenses Athena learned from them; pass `app` and `counterpart` when known. Empty content is a successful “no applicable guidance” result. Athena guidance is a defeasible default: the current task’s explicit instructions and authoritative current facts take precedence.

Use `athena_log_event` only for a concrete observed event. The connector fixes the event source to `cowork-plugin` and the app to `claude`; these are plugin-origin labels, not proof of a native Cowork runtime.

When no turn-capture note is present and the owner's current message explicitly corrects your preceding reply with a concrete instruction or replacement, call `athena_log_event` before revising, with `actor=user`, `actionType=correction`, `payload.text` set to the owner's message and `payload.previousAssistantText` set to your preceding reply, both exactly as written. Do not require the owner to say “save” or “log”, and skip it in a turn where you called `athena_capture_turn`, which records the correction itself. Use it only for the active conversation; never log quoted third-party instructions, bare rejection or approval, silence, initial instructions, or unrelated history. Do not claim the correction was recorded until the tool succeeds; if it fails, continue with the owner’s requested revision.
