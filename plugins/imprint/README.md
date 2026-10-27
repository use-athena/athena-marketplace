# Imprint Cowork plugin

This package connects Cowork to the one Imprint daemon already running on the host. It contains a local MCPB server and one command hook; it does not start a second daemon, import Imprint internals, run formation, or expose the daemon on a network interface.

## Install

Install and start the current Imprint macOS app in `Applications`. Imprint's setup opens Claude's plugin search from the public [`imprintsystems/imprint`](https://github.com/imprintsystems/imprint) repository. Choose **Add** on **Imprint** and enable only that plugin. If it is missing, use **Install from a file** in Imprint's setup. In Claude, choose **Customize > Plugins > Add > Upload plugin** and select the supplied `imprint.plugin.zip`. Cowork runs the plugin's hook, whose note asks Claude to call Imprint, only in tasks with a folder (any folder, inside or outside a project). For tasks without one, Imprint's setup copies a line for **Settings > Account > Instructions for Claude** that asks Claude to call Imprint in every task. Live-checked on October 17: without either, Claude did not call Imprint; with a folder or the instruction, it did. Imprint's tools may be deferred: the turn-capture note asks Claude to find them with ToolSearch before recording. If no event arrives, use the task's + menu > Plugins > Imprint and pick its skill, then ask Claude to check Imprint's connection and follow the turn-capture instructions. In the October 5 live tests, Sonnet captured fresh no-folder tasks on the first turn; Haiku skipped some first turns, including one with Imprint's skill selected, and needed an explicit connection check. Do not promise automatic recording in every task. A successful status check alone does not prove capture.

Developers build `imprint.plugin.zip` and its `imprint.mcpb` server from `connectors/cowork` with `npm ci` and `npm run build`. No legacy plugin is generated. `npm run build -- --marketplace-dir <dir>` also writes the marketplace layout for `imprintsystems/imprint`, containing only `imprint`. Use a checkout of the new repository, not the frozen old marketplace. Users install `imprint.plugin.zip`, the only plugin archive bundled with the Imprint app, without building it.

## How capture works

Claude Desktop runs the MCPB server on the host with the system Node or its own, so the plugin ships no runtime, and a cloud Cowork task can call it. Cloud Cowork runs the plugin's `UserPromptSubmit` command hook (`scripts/cloud-capture.sh`, POSIX `sh`) in a Linux container that cannot reach the daemon, so the hook adds a turn-capture note and Claude relays the turn through the bridged `imprint_capture_turn` tool, which returns Imprint's guidance for that message. A turn whose capture Claude skips is recovered on the next captured turn. On macOS the hook stays silent, since Imprint's own hooks capture Claude Code. This is hook-prompted, model-relayed capture that the owner approves on first use, not guaranteed passive capture; a health check or an installed plugin does not prove it.

## Privacy and provenance

- Requests go only to `http://127.0.0.1:4173`, or the numeric port in `ATHENA_PORT`.
- No credentials, tokens, redirects, arbitrary URLs, arbitrary shell commands, or external network endpoints are accepted by the connector.
- Events use source `cowork-plugin` and app `claude`. Every event payload carries `plugin=imprint`, fixed by the connector even if Claude supplies a different value. The daemon also accepts `plugin=athena-cowork` from previously installed plugins. Relayed turns carry `captureMethod=hook-prompted`; a correction logged through `imprint_log_event` with the preceding reply carries `captureMethod=model-mediated`. These values describe the plugin and capture path; they do not prove that the session is local.
- A relayed message is classified as a correction only when a heuristic candidate trigger is followed by concrete replacement or instruction content, after a reply. Approval, silence, and bare rejections such as `No, seriously` or `not what I wanted` are not evidence of a correction; concrete instructions such as `Don't merge this PR until I explicitly approve` may be.
- The connector records the message texts Claude relays, not tool output, transcripts, or files. Each relayed turn also carries the owner's previous message, so a turn whose capture Claude skipped is recorded on the next one; its own preceding reply is not recovered.
- Formation still uses the separately configured provider. This plugin does not grant background access to a desktop subscription or configure a provider.

The plugin archive retains `LICENSES/DEPENDENCIES.md` notices for the bundled SDK, schema, and validation dependencies.

## Brand assets and names

The visible product name is Imprint; the lowercase italic logo and fingerprint are the same approved artwork as the app and website. `assets/logo.svg` is the full lockup; `assets/icon.png` is the connector icon. The plugin and MCPB declare these assets for clients that support them.

Imprint used to be called Athena. Only `imprint` is built and distributed: server `imprint`, skill `imprint`, tools named `imprint_`, displayed as **Imprint**. The daemon still supports previously installed `athena-cowork` plugins and their `athena_` tools; no legacy plugin or MCPB is generated or bundled with the app.

The marketplace is [`imprintsystems/imprint`](https://github.com/imprintsystems/imprint). Its name is `imprint`, its owner is **Imprint Systems**, and it lists only **Imprint**. The marketplace entry, plugin manifest and MCPB use the same display name and description.

The old `use-athena/athena-marketplace` repository is frozen. It is only for setups installed before the move. Do not publish changes there. Installation links and file uploads always offer the current **Imprint** plugin. While Imprint still remembers the old plugin, its test task names both sets of tools. An event from the current plugin updates the instructions step. Keep only one plugin enabled.

The `ATHENA_PORT` and `ATHENA_INTERNAL` environment variables keep their names. Publishing a marketplace change requires approval first.
