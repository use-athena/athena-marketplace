# Athena Cowork plugin

This package connects local Cowork to the one Athena daemon already running on the host. The connector uses a local MCPB and bounded lifecycle hooks; it does not start a second daemon, import Athena internals, run formation, or expose the daemon on a network interface.

## Install locally

Install and start the current Athena macOS app in `Applications`, then in Claude use **Customize > Plugins > Add > Upload plugin** and choose the supplied `athena-cowork.plugin.zip`. The plugin registers `UserPromptSubmit` and `Stop` `mcp_tool` hooks against the bundled local MCP server; Claude Code dispatches them, but live cloud Cowork tasks on 2026-09-30 did not, under either the plugin-scoped or the bridged `remote-devices` server name. For cloud Cowork, a POSIX `sh` command hook (`scripts/cloud-capture.sh`) adds a turn-capture note on Linux, and Claude relays each turn through the bridged `athena_capture_turn` tool, which returns Athena's guidance for that message. A turn whose capture Claude skips is recovered on the next captured turn. This is hook-prompted, model-relayed capture, and the owner approves the tool on first use. It is not guaranteed passive capture. The MCPB uses Claude Desktop's own Node, so the plugin ships no runtime. The package deliberately does not use a `SessionStart` MCP hook because Anthropic documents that event as firing before MCP servers are necessarily connected.

Developers build the ZIP from `connectors/cowork` with `npm ci` and `npm run build`. Users install the ZIP bundled with the Rust Athena app without building it. A desktop Cowork task can call this host-local MCP connector even while its agent task runs in the cloud, as the live status and write calls showed. A successful health check or an installed plugin does not prove automatic capture.

## Privacy and provenance

- Requests go only to `http://127.0.0.1:4173` by default. `ATHENA_PORT` is an optional developer override for the numeric local port only.
- No credentials, tokens, redirects, arbitrary URLs, arbitrary shell commands, or external network endpoints are accepted by the connector.
- The hook records only bounded prompt/session/assistant lifecycle fields and asks for guidance using the current prompt. Prompt text is sent to the local daemon when a prompt is submitted; it is not read from transcripts or arbitrary files.
- Native MCP hook events and explicit MCP calls use source `cowork-plugin` and app `claude`. Hook-generated events carry `captureMethod=hook-mediated`; paired corrections recorded by the skill carry `captureMethod=model-mediated`. These values describe the plugin integration origin and capture path; they do not prove that the session is local.
- A correction is classified only when a heuristic candidate trigger is followed by concrete replacement/instruction content and the same session has prior agent activity. Approval, silence, and bare rejections such as `No, seriously` or `not what I wanted` are not evidence of a correction; concrete instructions such as `Don't merge this PR until I explicitly approve` may be.
- Stop capture preserves bounded `last_assistant_message` as `payload.text` and an optional reason. The connector does not capture tool output. In cloud Cowork, each relayed turn also carries the owner's previous message, so a turn whose capture Claude skipped is recorded on the next one; its own preceding reply is not recovered.
- Formation still uses the separately configured existing provider. This plugin does not grant background access to a desktop subscription or configure a provider.

## Limitations

This is a Cowork MCP connector. An explicit tool call from a desktop Cowork task reached the host-local daemon, but the same task's lifecycle hooks produced no events. A shell hook in Cowork's Linux code VM cannot use the host's macOS binary or reach host loopback directly; the local MCP connector runs on the host and can. A health check does not prove prompt or correction capture. Activate the Athena skill and use its paired `athena_log_event` instruction; the skill records exact messages only after the tool succeeds. This plugin does not silently change daemon binding or expose it over a network.

The plugin archive retains the plugin `LICENSES/DEPENDENCIES.md` notices for the bundled SDK, schema, and validation dependencies.
