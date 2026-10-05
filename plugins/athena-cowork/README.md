# Athena Cowork plugin

This package connects Cowork to the one Athena daemon already running on the host. It contains a local MCPB server and one command hook; it does not start a second daemon, import Athena internals, run formation, or expose the daemon on a network interface.

## Install

Install and start the current Athena macOS app in `Applications`. Athena's setup opens Claude's install dialog for this plugin from the public `use-athena/athena-marketplace` repository; choose **Install**. As a fallback, in Claude use **Customize > Plugins > Add > Upload plugin** and choose the supplied `athena-cowork.plugin.zip`. Cowork can use Athena with or without a folder, inside or outside a project. Athena’s tools may be deferred: the turn-capture note asks Claude to find them with ToolSearch before recording. If no event arrives, use the task’s + menu > Plugins > Athena cowork > athena, then ask Claude to check Athena’s connection and follow the turn-capture instructions. In the October 5 live tests, Sonnet captured fresh no-folder tasks on the first turn; Haiku skipped some first turns, including one with Athena’s skill selected, and needed an explicit connection check. Do not promise automatic recording in every task. A successful status check alone does not prove capture.

Developers build the ZIP from `connectors/cowork` with `npm ci` and `npm run build`; `npm run build -- --marketplace-dir <dir>` also writes the marketplace repository layout to publish. Users install the ZIP bundled with the Athena app without building it.

## How capture works

Claude Desktop runs the MCPB server on the host with the system Node or its own, so the plugin ships no runtime, and a cloud Cowork task can call it. Cloud Cowork runs the plugin's `UserPromptSubmit` command hook (`scripts/cloud-capture.sh`, POSIX `sh`) in a Linux container that cannot reach the daemon, so the hook adds a turn-capture note and Claude relays the turn through the bridged `athena_capture_turn` tool, which returns Athena's guidance for that message. A turn whose capture Claude skips is recovered on the next captured turn. On macOS the hook stays silent, since Athena's own hooks capture Claude Code. This is hook-prompted, model-relayed capture that the owner approves on first use, not guaranteed passive capture; a health check or an installed plugin does not prove it.

## Privacy and provenance

- Requests go only to `http://127.0.0.1:4173`, or the numeric port in `ATHENA_PORT`.
- No credentials, tokens, redirects, arbitrary URLs, arbitrary shell commands, or external network endpoints are accepted by the connector.
- Events use source `cowork-plugin` and app `claude`. Relayed turns carry `captureMethod=hook-prompted`; a correction logged through `athena_log_event` with the preceding reply carries `captureMethod=model-mediated`. These values describe the plugin and capture path; they do not prove that the session is local.
- A relayed message is classified as a correction only when a heuristic candidate trigger is followed by concrete replacement or instruction content, after a reply. Approval, silence, and bare rejections such as `No, seriously` or `not what I wanted` are not evidence of a correction; concrete instructions such as `Don't merge this PR until I explicitly approve` may be.
- The connector records the message texts Claude relays, not tool output, transcripts, or files. Each relayed turn also carries the owner's previous message, so a turn whose capture Claude skipped is recorded on the next one; its own preceding reply is not recovered.
- Formation still uses the separately configured provider. This plugin does not grant background access to a desktop subscription or configure a provider.

The plugin archive retains `LICENSES/DEPENDENCIES.md` notices for the bundled SDK, schema, and validation dependencies.
