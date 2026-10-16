# Imprint plugin marketplace

The Imprint plugin connects Claude to the Imprint app running on your Mac, using local port 4173. It works with or without a selected folder or project.

Add `use-athena/athena-marketplace` under **Customize > Plugins > Add > Add marketplace**, then install and enable **Imprint**. Keep Imprint and Claude Desktop running. Existing technical identifiers stay the same for compatibility.

## Version 0.2.2

Renames the plugin to Imprint and includes the approved fingerprint artwork, matching the macOS icon. The plugin manifest, bundled desktop connector and MCP server supply the branding. Claude controls which icons appear on each surface; its local desktop-connector preview renders the fingerprint, while an uploaded-plugin card may retain a generic icon.

Existing users: open your marketplace plugin under **Customize > Plugins > Yours**, choose **... > Check for updates**, then **Update**. Confirm version **0.2.2** and start a new session. Refresh Claude if the details still show the previous version. The old entry may be called **Athena cowork** until updated.

A manually uploaded ZIP is a separate installation. Replace it with the new ZIP or switch to the marketplace copy, and keep only one copy enabled. Publishing a marketplace update does not force every client to refresh immediately.

The local connector was tested against daemon 0.5.18. All 57 connector tests pass. This release preserves the existing capture behavior and tool identifiers. Capture depends on Claude calling the tools and is not guaranteed for every turn. See the [plugin documentation](plugins/athena-cowork/README.md) for privacy details and the connection-check fallback.
