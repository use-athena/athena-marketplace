# Athena plugin marketplace

The Athena Cowork plugin connects Claude Cowork to the Athena app running on your Mac. It uses Athena's local port, 4173.

In Claude Desktop's Cowork tab, open **Customize > Plugins > Add > Add marketplace**, add `use-athena/athena-marketplace`, then install and enable **Athena cowork**. Keep Athena and Claude Desktop running. A folder or project is optional.

## Version 0.2.1

This update tells Claude to find deferred Athena tools before declaring them unavailable, and to record the user's actual request instead of a tool-loading notice. It was tested with Athena 0.1.3 (internal version 0.5.11).

Existing users: open **Customize > Plugins > Yours > Athena cowork (athena-marketplace)**, choose **... > Check for updates**, then click **Update**. Confirm the plugin shows **0.2.1**, then start a new Cowork task. If the details still show the old version just after updating, refresh Claude's page. This update flow was verified in Claude Desktop.

Users who installed a ZIP manually need to replace that uploaded copy with the new ZIP or switch to the marketplace copy; updating the marketplace does not replace a separate upload. Keep only one Athena plugin copy enabled.

Plugin 0.1.9 used test port 4215 and cannot reach an Athena app using the normal port 4173. Versions 0.2.0 and 0.2.1 use 4173. Users still on 0.1.9 should update even if Claude shows the plugin as installed.

Sonnet recorded ordinary tasks without an explicit Athena request in live tests, inside and outside a project with no folder selected. Capture still depends on Claude calling the tools; it is not guaranteed for every turn. See the [plugin documentation](plugins/athena-cowork/README.md) for the connection-check fallback and privacy details.
