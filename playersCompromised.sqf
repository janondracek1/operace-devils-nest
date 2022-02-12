params ["_triggeredBy"];

if(!isServer) exitWith{false};

_firstCityTrigger = missionNamespace getVariable 'firstCityTrigger';
_secondCityTrigger = missionNamespace getVariable 'secondCityTrigger';
_assaultSquadFirstCityTrigger = missionNamespace getVariable 'assaultSquadFirstCityTrigger';

//if players were spotted in first city
if(count (allPlayers inAreaArray _firstCityTrigger) > 0 && isNil{missionNamespace getVariable "arePlayersCompromisedFirstCity"}) then {
	missionNamespace setVariable ["arePlayersCompromisedFirstCity", true];
	_loudspeakers = missionNamespace getVariable 'loudspeakersFirstCity';
	_alarm = createSoundSource ["Sound_Alarm", position _loudspeakers, [], 0];

	private _position = nil;
	if(isNil "_triggeredBy") then {
		_position = position _firstCityTrigger;
	}else{
		_position = position _triggeredBy;
	};

	{
		if (side _x == east) then {
			while {(count(waypoints group _x))>0} do 
			{
				deleteWaypoint ((waypoints group _x) select 0);	
			};

			_x doFollow leader group _x;
			_waypoint = group _x addWaypoint [
				_position,
				(triggerArea _firstCityTrigger) select 0,
				0
			];
			_waypoint setWaypointType "SAD";
			_waypoint setWaypointBehaviour "AWARE";
			group _x setCurrentWaypoint [group _x, 0];
		};
	} foreach (units east inAreaArray _firstCityTrigger);

	_leaders = [];
	{
		if(leader _x inArea _assaultSquadFirstCityTrigger && side leader _x == east) then {
			_leaders = _leaders + [leader _x];
		};
	} forEach allGroups;

	{
		_group = group _x;
		_group enableDynamicSimulation false;

		{
			_unit = _x;
			_unit doFollow leader _group;
		} forEach units _group;

		while {(count(waypoints _group))>0} do 
		{
			deleteWaypoint ((waypoints _group) select 0);	
		};

		_moveWaypoint = _group addWaypoint [
			position leader _group,
			0,
			0
		];
		_moveWaypoint setWaypointType "GETIN NEAREST";
		_moveWaypoint setWaypointSpeed "FULL";

		_getInWaypoint = _group addWaypoint [
			_position,
			0,
			1
		];
		_getInWaypoint setWaypointType "MOVE";
		_getInWaypoint setWaypointSpeed "FULL";

		_dismountWaypoint = _group addWaypoint [
			_position,
			0,
			2
		];
		_dismountWaypoint setWaypointType "UNLOAD";

		_sadWaypoint = _group addWaypoint [
			_position,
			(triggerArea _firstCityTrigger) select 0,
			3
		];
		_sadWaypoint setWaypointType "SAD";
		_sadWaypoint setWaypointBehaviour "AWARE";
	} foreach _leaders;
};

//if players were spotted in second city
if(count (allPlayers inAreaArray _secondCityTrigger) > 0 && isNil{missionNamespace getVariable "arePlayersCompromisedSecondCity"}) then {
	missionNamespace setVariable ["arePlayersCompromisedSecondCity", true];
	_loudspeakers = missionNamespace getVariable 'loudspeakersSecondCity';
	_alarm = createSoundSource ["Sound_Alarm", position _loudspeakers, [], 0];

	private _position = nil;
	if(isNil "_triggeredBy") then {
		_position = position _secondCityTrigger;
	}else{
		_position = position _triggeredBy;
	};

	_leaders = [];
	{
		if(leader _x inArea _secondCityTrigger && side leader _x == east) then {
			_leaders = _leaders + [leader _x];
		};
	} forEach allGroups;
	{
		private _group = group _x;
		if(_x inArea _secondCityTrigger) then {
			_group enableDynamicSimulation false;

			{
				_unit = _x;
				_unit doFollow leader _group;
			} forEach units _group;

			while {(count(waypoints _group)) > 0} do 
			{
				deleteWaypoint ((waypoints _group) select 0);	
			};

			_sadWaypoint = _group addWaypoint [
				_position,
				((triggerArea _secondCityTrigger) select 0) / 2,
				3
			];
			_sadWaypoint setWaypointType "SAD";
			_sadWaypoint setWaypointBehaviour "AWARE";

			_group setCurrentWaypoint [_group, 0];
		};
	} foreach _leaders;
};
