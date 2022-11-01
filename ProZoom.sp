#include <sourcemod>
#include <cstrike>
#include <sdktools>
#include <sdkhooks>
#include <sdktools_hooks>

#include <ProZoom.inc>

public Plugin myinfo = { name = "Pro Zoom", author = "Vishus", description = "Tracks scoped weapons for nopscope kills", version = "0.1.0", url = "" };

// Prevent using scopes:
// https://github.com/Bara/NoScope/blob/master/addons/sourcemod/scripting/noscope.sp

int zoom_levels[MAXPLAYERS+1];

bool scopes_disabled = false;

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max) {
    RegPluginLibrary("pro_zoom");
    CreateNative("ProZoom_GetZoomLevel", Native_GetZoomLevel);
    CreateNative("ProZoom_DisableScopes", Native_DisableScopes);
    CreateNative("ProZoom_EnableScopes", Native_EnableScopes);
    CreateNative("ProZoom_AreScopesEnabled", Native_AreScopesEnabled);
    CreateNative("ProZoom_IsSniperRifle", Native_IsSniperRifle);
    return APLRes_Success;
}

public void OnPluginStart() {
    HookEvent("player_spawn", EventPlayerSpawn);
    HookEvent("weapon_zoom", EventWeaponZoom, EventHookMode_Pre);
}

public Action EventPlayerSpawn(Handle event, const char[] name, bool dontBroadcast) {
    int client = GetClientOfUserId(GetEventInt(event, "userid"));
    zoom_levels[client] = 0;
}
public Action EventWeaponZoom(Handle event, const char[] name, bool dontBroadcast) {
    int client = GetClientOfUserId(GetEventInt(event, "userid"));
    char weapon[48];
    GetClientWeapon(client, weapon, sizeof(weapon));
    
    // GetClientWeapon returns "weapon_<name>" and we're storing just "<name>" so start at offset 7 to remove the "weapon_" part
    if(IsSniperRifle(weapon[7])) {
        if(scopes_disabled) {
            ReEquip(client);
            zoom_levels[client] = 0;
        } else if(IsNoScopeSniperRifle(weapon[7])) {
            if(zoom_levels[client] >= 2) {
                zoom_levels[client] = 0;
            } else {
                zoom_levels[client] += 1;
            }
        }
    }
}

void ReEquip(int client) {
    char classname[MAX_NAME_LENGTH];
    int wep = GetPlayerWeaponSlot(client, CS_SLOT_PRIMARY);
    GetEdictClassname(wep, classname, sizeof(classname));
    if(IsValidEdict(wep)) {
        RemovePlayerItem(client, wep);
        RemoveEdict(wep);
        GivePlayerItem(client, classname);
        ClientCommand(client, "slot1");
    }
    zoom_levels[client] = 0;
}

// This includes awp, scout, and auto snipers (sg550 and g3sg1)
bool IsSniperRifle(const char[] weapon) {
    return StrEqual(weapon, "awp") || StrEqual(weapon, "scout") || StrEqual(weapon, "sg550") || StrEqual(weapon, "g3sg1");
}

// Does the specified weapon count for noscope hits?  For use with Pro XP.
// This only includes awp and scout
bool IsNoScopeSniperRifle(const char[] weapon) {
    // Don't really care about auto sniper noscopes since they're autos but can be added with: || StrEqual(weapon, "weapon_sg550") || StrEqual(weapon, "weapon_g3sg1");
    return StrEqual(weapon, "awp") || StrEqual(weapon, "scout"); 
}


public int Native_GetZoomLevel(Handle plugin, int numParams) {
    int client = GetNativeCell(1);
    return zoom_levels[client];
}

public int Native_DisableScopes(Handle plugin, int numParams) {
    if(scopes_disabled) { return; }
    scopes_disabled = true;
}

public int Native_EnableScopes(Handle plugin, int numParams) {
    scopes_disabled = false;
}
public int Native_AreScopesEnabled(Handle plugin, int numParams) {
    return !scopes_disabled;
}
public int Native_IsSniperRifle(Handle plugin, int numParams) {
    int len;
    GetNativeStringLength(1, len);
    if(len <= 0) {
        return 0;
    }
    
    char[] weapon = new char[len + 1];
    GetNativeString(1, weapon, len + 1);
    
    return IsNoScopeSniperRifle(weapon);
}

