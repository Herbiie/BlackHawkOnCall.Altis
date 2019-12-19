private _helicopters = "((configName _x) isKindOf ['vtx_H60_base', configFile >> 'CfgVehicles']) && (getNumber (_x >> 'scope') == 2)" configClasses (configFile >> "CfgVehicles");
bocMissionFunctions = "true" configClasses (missionConfigFile >> "CfgFunctions" >> "boc" >> "missions");
if (isServer) then {
	missionNameSpace setVariable ["currentHeli",objNull,true];
	missionNameSpace setVariable ["onCall",false,true];
	missionNameSpace setVariable ["missionOn",false,true];
	missionNameSpace setVariable ["bocMissions",0,true];
	if ("Arsenal" call BIS_fnc_getParamValue == 1) then {
		[box, true] call ace_arsenal_fnc_initBox;
	};
	{} spawn {
		while {true} do {
			waitUntil {(missionNameSpace getVariable "onCall")};
			sleep 10;
			private _a = random 100;
			if ((_a < 50) && (missionNameSpace getVariable "onCall")) then {
				missionNameSpace setVariable ["onCall",false,true];
				private _function = selectRandom bocMissionFunctions;
				private _name = format ["boc_fnc_%1",configName _function];
				[true] remoteExec [_name,2];
			};
		};
	};
};

_mainAction = ["boc_OnCall", "Toggle on Call", "", {if (missionNameSpace getVariable "onCall") then {missionNameSpace setVariable ["onCall",false,true]} else {missionNameSpace setVariable ["onCall",true,true]}}, {((leader group player) == player) && !(missionNameSpace getVariable "missionOn")}] call ace_interact_menu_fnc_createAction;
["CAManBase", 1, ["ACE_SelfActions"], _mainAction, true] call ace_interact_menu_fnc_addActionToClass;

_missionsAction = ["boc_Missions", "Request Mission", "", {}, {((leader group player) == player) && !(missionNameSpace getVariable "missionOn")}] call ace_interact_menu_fnc_createAction;
["CAManBase", 1, ["ACE_SelfActions"], _missionsAction, true] call ace_interact_menu_fnc_addActionToClass;

{
	private _text = getText (_x >> "missionName");
	private _name = format ["boc_fnc_%1",configName _x];
	_thisAction = [format ["boc_Mission%1",_forEachIndex], _text, "", {
		params ["_target", "_player", "_name"];
		[(missionNameSpace getVariable "onCall")] remoteExec [_name,2];
	}, {((leader group player) == player) && !(missionNameSpace getVariable "missionOn")},{},_name] call ace_interact_menu_fnc_createAction;
	["CAManBase", 1, ["ACE_SelfActions","boc_Missions"], _thisAction, true] call ace_interact_menu_fnc_addActionToClass;
} forEach bocMissionFunctions;

{
	private _name = getText (_x >> "displayName");
	private _type = configName _x;
	private _thisAction = [format ["boc_Heli%1",_forEachIndex], _name, "", {
		params ["_target", "_player", "_type"];
		if (((nearestObject getMarkerPos "heli") distance getMarkerPos "heli") > 7) then {
			private _heli = _type createVehicle getMarkerPos "heli";
			missionNameSpace setVariable ["currentHeli",_heli,true];
			_heli addEventHandler ["Killed", {
				missionNameSpace setVariable ["currentHeli",objNull,true];
			}];
		} else {
			hint "No space";
		};
	}, {((leader group player) == player) && isNull (missionNameSpace getVariable "currentHeli")},{},_type] call ace_interact_menu_fnc_createAction;
	[heliSelector,0,["ACE_MainActions"],_thisAction] call ace_interact_menu_fnc_addActionToObject;
} forEach _helicopters;

private _byeHeli = ["boc_byeHeli","Return current helicopter","",{
	private _heli = (missionNameSpace getVariable "currentHeli");
	if ((_heli distance getMarkerPos "heli") < 20) then {
		if ((count crew _heli) > 0) then {
			hint "Someone is in the helicopter";		
		} else {			
			deleteVehicle _heli;
			missionNameSpace setVariable ["currentHeli",objNull,true];
		};
	} else {
		hint "Helicopter is not close enough";
	};
},{((leader group player) == player) && !(isNull (missionNameSpace getVariable "currentHeli"))}] call ace_interact_menu_fnc_createAction;
[heliSelector,0,["ACE_MainActions"],_byeHeli] call ace_interact_menu_fnc_addActionToObject;

{} spawn {
	while {true} do {
		private _onCall = "No";
		if (missionNameSpace getVariable "onCall") then {_onCall = "Yes"};
		private _text = format ["<t size='0.5'>On Call: %1.",_onCall];
		if (missionNameSpace getVariable "missionOn") then {_text = "<t size='0.5'>On Mission."};
		if (!(isNull (missionNameSpace getVariable "currentHeli"))) then {
			private _heliType = typeOf (missionNameSpace getVariable "currentHeli");
			private _heliName = getText (configFile >> "CfgVehicles" >> _heliType >> "displayName");
			_text = _text + format ["<br/>Current Helicopter: %1</t>",_heliName];
		} else {
			_text = _text + "</t>";		
		};
		[_text, safezoneX+safeZoneW-0.75,safezoneY+safezoneH-1.61833, 0.5, 0] spawn BIS_fnc_dynamicText;
		sleep 0.5;
	};
};

[player,"BluFor","playerLoudout"] call tb3_fnc_Loadout;