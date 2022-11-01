#if defined _pro_zoom_included
    #endinput
#endif
#define _pro_zoom_included

public SharedPlugin __pl_pro_zoom = 
{
    name = "pro_zoom",
    file = "ProZoom.smx",
#if defined REQUIRE_PLUGIN
    required = 1,
#else
    required = 0,
#endif
};

#if !defined REQUIRE_PLUGIN
public void __pl_pro_zoom_SetNTVOptional()
{
    MarkNativeAsOptional("ProZoom_GetZoomLevel");
    MarkNativeAsOptional("ProZoom_DisableScopes");
    MarkNativeAsOptional("ProZoom_EnableScopes");
    MarkNativeAsOptional("ProZoom_AreScopesEnabled");
    MarkNativeAsOptional("ProZoom_IsSniperRifle");
}
#endif

/**
 * Returns whether a player is currently zoomed in with a scoped weapon
 * 
 * @param client    Client
 * @return     Returns 0 for not zoomed in.  A 1 indicate lowest zoom and 2 is highest level of zoom.
 */
native int ProZoom_GetZoomLevel(int client);

/**
 * Disallows users from using scopes
 */
native void ProZoom_DisableScopes();

/**
 * Allows users to use scopes
 */
native void ProZoom_EnableScopes();

/**
 * Returns whether scopes can be used or not
 * 
 * @return      Returns whether scopes are allowed or not
 */
native bool ProZoom_AreScopesEnabled();

/**
 * Returns whether a given weapon name is being monitored for zoom level changes.  This plugin may only track certain sniper rifles, for example if you wish to exclude autosnipers from noscope events.
 * 
 * @param weapon     Takes the short name, e.g. "scout"
 * @return           Returns whether the weapon is considered a sniper rifles and thus monitored for zoom level changes
 */
native bool ProZoom_IsSniperRifle(const char[] weapon);
