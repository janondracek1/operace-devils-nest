_taskStayHiddenName = "TASK_HIDDEN";
[independent, _taskStayHiddenName, ["Pokuste se po celou dobu zůstat neodhalení ruskými jednotkami", "Zůstaňte neodhalení", ""], objNull, "ASSIGNED"] call BIS_fnc_taskCreate;

_firstCityTrigger = missionNamespace getVariable 'firstCityTrigger';
[independent, "TASK_FIRST_CITY", ["Vyčistěte první město a vybavte se", "Vyčistěte město", ""], position _firstCityTrigger, "CREATED"] call BIS_fnc_taskCreate;
["TASK_FIRST_CITY", "ASSIGNED"] call BIS_fnc_taskSetState;

_secondCityTrigger = missionNamespace getVariable 'secondCityTrigger';
_units = (units east inAreaArray _firstCityTrigger) + (units east inAreaArray _secondCityTrigger);
{
	if(side _x == east) then {
		
		[_x] spawn {
			params ["_unit"];
			_unit execVM 'initSoldierHitHandler.sqf';
			_unit execVM 'soldierWatchForArmedPlayers.sqf';
		};
	};
} forEach (units east inAreaArray _firstCityTrigger);

_units = [];
{
	if(side _x == east) then {
		[_x] spawn {
			params ["_unit"];
			_unit execVM 'initSoldierHitHandler.sqf';
			_unit execVM 'soldierWatchForArmedPlayers.sqf';
		};
	};
} forEach (units east inAreaArray _secondCityTrigger);

[_taskStayHiddenName] spawn {
	params ["_taskName"];
	waitUntil{sleep 1; [independent, east] call BIS_fnc_sideIsEnemy;};
	
	[_taskName, "FAILED"] call BIS_fnc_taskSetState;
	execVM 'playersCompromised.sqf';
};

_ammoTruck = missionNamespace getVariable 'ammoTruck';
[_ammoTruck] spawn {
	params ["_ammoTruck"];
	waitUntil{sleep 1; !alive _ammoTruck};

	"EveryoneLost" call BIS_fnc_endMissionServer;
};