# Pro Zoom

A plugin for Counter-Strike source to allows scopes to be disabled and tracks zoom levels for players.  CSGO is not supported yet.  Help making it compatible with CSGO would be appreciated.

The goal of this plugin is to allow other plugins to check for noscopes and also allow scopes to be disabled (disallow using scopes).

Interacting with the plugin is accomplished via natives.  By itself this plugin will just track zoom levels in the background and is not very useful.

## Plugins

Plugins that use this:

- [ProXP](https://github.com/vishusandy/ProXP): to give information on noscope hits.
  
  - https://github.com/vishusandy/ProXP

Only works with: awp, scout, sg550, and the g3sg1 (the others require dhooks to work and thus not implemented yet).
