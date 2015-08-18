Scriptname ClutterBusterMenuScript extends SKI_ConfigBase
{ClutterBuster MCM menu script.}

ClutterBusterQuestScript Property ClutterBusterQuest Auto
{The main quest script.}

ClutterBusterPlayerScript Property PlayerScript Auto
{The player script.}

string[] debugLevels
;String representations of debug log levels.

Event OnConfigInit()
; 	{Perform menu setup.}

; 	Pages = new string[3]
; 	Pages[0] = "$Settings"
; 	Pages[1] = "$Blacklists"
; 	Pages[2] = "$Whitelists"

; 	yesOrNo = new string[2]
; 	yesOrNo[0] = "$Yes"
; 	yesOrNo[1] = "$No"

	debugLevels = new string[3]
	debugLevels[0] = "$OFF"
	debugLevels[1] = "$DEBUG"
	debugLevels[2] = "$TRACE"

	ClutterBusterQuest.DebugMsg("ClutterBusterMenuScript intialized.", 0)
EndEvent

Event OnPageReset(string page)
	{Draw the menu.}

	; if page == ""
	; 	LoadCustomContent("ClutterBuster_MCM.dds", 120, 95)
	; 	return
	; else
	; 	UnloadCustomContent()
	; endif

	SetCursorFillMode(TOP_TO_BOTTOM)
	; if page == "$Settings"
		DrawSettingsPage()
	; elseif page == "$Blacklists"
	; 	DrawBlacklistsPage()
	; elseif page == "$Whitelists"
	; 	DrawWhitelistsDropPage()
	; endif
EndEvent

Event OnConfigClose()
	{When the menu is closed, rebind the hotkeys.}

	UnregisterForAllKeys()
	RegisterForKey(ClutterBusterQuest.addHotkey)
	RegisterForKey(ClutterBusterQuest.removeHotkey)
EndEvent

Function DrawSettingsPage()
	{Draw the "Settings" MCM page.}

	AddHeaderOption("$Hotkeys")
	AddKeymapOptionST("AddHotkey", "$Add to List", ClutterBusterQuest.addHotkey)
	AddKeymapOptionST("RemoveHotkey", "$Remove from List", ClutterBusterQuest.removeHotkey)
	AddEmptyOption()
	AddHeaderOption("$Debugging")
	AddTextOptionST("DebugLevel", "$Debug Logging Level", debugLevels[ClutterBusterQuest.debugLevel])
EndFunction

bool Function CheckKeyConflict(string conflictControl, string conflictName)
	{Check for OnKeyMapChange key conflicts and get user input.}

	if conflictControl != ""
		string msg = ""
		if conflictName != ""
			msg = "$CLUTBUST_KEY_CONFLICT_{" + conflictControl + "}_FROM_{" + conflictName +"}"
		else
			msg = "$CLUTBUST_KEY_CONFLICT_{" + conflictControl + "}_FROM_SKYRIM"
		endif
		return ShowMessage(msg, True, "$Yes", "$No")
	endif
	return True
EndFunction

string Function GetCustomControl(int KeyCode)
	{Provide hotkey names to MCM for key conflict notifications.}

	if KeyCode == ClutterBusterQuest.addHotkey
		return "$Add to List"
	elseif KeyCode == ClutterBusterQuest.removeHotkey
		return "$Remove from List"
	endif
	return ""
EndFunction

State AddHotkey
	Event OnKeyMapChangeST(int keyCode, string conflictControl, string conflictName)
		if CheckKeyConflict(conflictControl, conflictName)
			ClutterBusterQuest.addHotkey = keyCode
			SetKeymapOptionValueST(keyCode)

			ClutterBusterQuest.DebugMsg("Set add hotkey to " + keyCode + " from MCM.", 1)
		else
			ClutterBusterQuest.DebugMsg("Failed to set add hotkey to " + keyCode + " from MCM.", 1)
		endif
	EndEvent

	Event OnDefaultST()
		ClutterBusterQuest.addHotkey = -1
		SetKeymapOptionValueST(-1)

		ClutterBusterQuest.DebugMsg("Cleared add hotkey from MCM.", 1)
	EndEvent

	Event OnHighlightST()
		SetInfoText("$CLUTBUST_HIGHLIGHT_ADD_HOTKEY")
	EndEvent
EndState

State RemoveHotkey
	Event OnKeyMapChangeST(int keyCode, string conflictControl, string conflictName)
		if CheckKeyConflict(conflictControl, conflictName)
			ClutterBusterQuest.removeHotkey = keyCode
			SetKeymapOptionValueST(keyCode)

			ClutterBusterQuest.DebugMsg("Set remove hotkey to " + keyCode + " from MCM.", 1)
		else
			ClutterBusterQuest.DebugMsg("Failed to set remove hotkey to " + keyCode + " from MCM.", 1)
		endif
	EndEvent

	Event OnDefaultST()
		ClutterBusterQuest.removeHotkey = -1
		SetKeymapOptionValueST(-1)

		ClutterBusterQuest.DebugMsg("Cleared remove hotkey from MCM.", 1)
	EndEvent

	Event OnHighlightST()
		SetInfoText("$CLUTBUST_HIGHLIGHT_REMOVE_HOTKEY")
	EndEvent
EndState

State DebugLevel
	Event OnSelectST()
		if ClutterBusterQuest.debugLevel >= 2
			ClutterBusterQuest.DebugMsg("Set debug level to 0 from MCM.", 1)
			ClutterBusterQuest.debugLevel = 0
		else
			ClutterBusterQuest.debugLevel += 1
			ClutterBusterQuest.DebugMsg("Set debug level to " + ClutterBusterQuest.debugLevel + " from MCM.", 1)
		endif
		SetTextOptionValueST(debugLevels[ClutterBusterQuest.debugLevel])
	EndEvent

	Event OnDefaultST()
		ClutterBusterQuest.DebugMsg("Set debug level to 0 from MCM.", 1)
		ClutterBusterQuest.debugLevel = 0
		SetTextOptionValueST(debugLevels[0])
	EndEvent

	Event OnHighlightST()
		SetInfoText("$CLUTBUST_HIGHLIGHT_DEBUG_LEVEL")
	EndEvent
EndState