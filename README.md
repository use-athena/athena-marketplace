# Imprint plugin marketplace

The Imprint plugin connects Claude to the Imprint app running on your Mac, using local port 4173. Claude calls Imprint by itself in Cowork tasks with a folder (any folder). For tasks without one, Imprint's setup copies a line for your Claude preferences that asks Claude to call Imprint in every task.

Imprint's setup opens Claude's install dialog for the `imprint` plugin. To add it by hand, add `use-athena/athena-marketplace` under **Customize > Plugins > Add > Add marketplace**, then install and enable `imprint`. Keep Imprint and Claude Desktop running.

## Version 0.3.0

Imprint used to be called Athena, and this release gives new setups Imprint's names. The marketplace now has two plugins:

- `imprint`, new: what every new setup installs. Its tools are named `imprint_capture_turn`, `imprint_get_rules`, `imprint_log_event`, `imprint_import_from_claude` and `imprint_status`, its skill `imprint`.
- `athena-cowork`, for Cowork set up before the rename. Its tools keep their `athena_` names, because the line its owner pasted into Claude's preferences names them, so nothing an existing user set up stops working. Only its documentation changed. Imprint's setup keeps offering it to those users until a guided switch.

Existing users: nothing to do. **Check for updates** brings `athena-cowork` to 0.3.0 with the same tools. Don't install `imprint` next to it, or Claude gets both sets of tools.

All 62 connector tests pass. The `imprint` plugin was checked against the released Imprint 0.1.10 (daemon 0.5.29).

## Version 0.2.5

Cowork without a folder. Cowork runs the plugin's hook, whose note asks Claude to call Imprint, only in tasks with a folder; in a task without one Claude did not call Imprint (checked live on October 17). The Imprint app's Cowork setup now has a third step that copies a line for Claude's preferences and opens Claude's settings, so every task calls Imprint. In this release:

- `athena_capture_turn`'s description asks for one call per owner message, instead of only when the hook's note asks.
- When the message asks for a draft, a capture also returns the owner's writing guide from Imprint (Imprint versions without it just return the usual notes).
- The skill no longer says folderless tasks work by themselves.

Existing users: **Customize > Plugins > Yours**, **... > Check for updates**, then **Update**, and start a new task. All 59 connector tests pass. Tool identifiers are unchanged.

## Version 0.2.2

Renames the plugin to Imprint and includes the approved fingerprint artwork, matching the macOS icon. The plugin manifest, bundled desktop connector and MCP server supply the branding. Claude controls which icons appear on each surface; its local desktop-connector preview renders the fingerprint, while an uploaded-plugin card may retain a generic icon.

Existing users: open your marketplace plugin under **Customize > Plugins > Yours**, choose **... > Check for updates**, then **Update**. Confirm version **0.2.2** and start a new session. Refresh Claude if the details still show the previous version. The old entry may be called **Athena cowork** until updated.

A manually uploaded ZIP is a separate installation. Replace it with the new ZIP or switch to the marketplace copy, and keep only one copy enabled. Publishing a marketplace update does not force every client to refresh immediately.

The local connector was tested against daemon 0.5.18. All 57 connector tests pass. This release preserves the existing capture behavior and tool identifiers. Capture depends on Claude calling the tools and is not guaranteed for every turn. See the [plugin documentation](plugins/athena-cowork/README.md) for privacy details and the connection-check fallback.
