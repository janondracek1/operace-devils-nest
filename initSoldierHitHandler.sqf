params ["_unit"];
if(!isServer) exitWith{false};

_unit addEventHandler ["Hit", {
	params ["_unit", "_source", "_damage", "_instigator"];

	if(isPlayer _instigator && rating _instigator < 0) then{
		[_instigator, 1000] remoteExec ['addRating'];
	};

	_soldiersAround = units east inAreaArray [
		getPosASL _unit,
		20,
		20,
		0,
		false
	];
	if(!alive _unit) then {
		[_soldiersAround] spawn {
			params ["_soldiersAround"];
			sleep 1.5;
			{
				_x doFollow leader group _x;
				_sadWaypoint = group _x addWaypoint [
					position _x,
					30,
					0
				];
				_sadWaypoint setWaypointType "SAD";
				_sadWaypoint setWaypointSpeed "FULL";
				_sadWaypoint setWaypointBehaviour "AWARE";
			} forEach _soldiersAround;
		};
	
	} else {
		if(_unit knowsAbout _instigator > 3.5) then {
			[_unit, _instigator, _soldiersAround, _thisEventHandler] spawn {
				params ["_unit", "_instigator", "_soldiersAround", "_thisEventHandler"];
				sleep 3;
				{
					if(
						(
							side _x == east
							&& _x knowsAbout _instigator > 3.5
							&& _x getRelDir _instigator < 120
							&& alive _x
							&& _x knowsAbout _unit > 3.5
						)
						|| alive _unit
					) then {
						resistance setFriend [east, 0];
						east setFriend [resistance, 0];
						_unit removeEventHandler ["Hit", _thisEventHandler];
					}
				} forEach _soldiersAround;
			};
		};
	}
	
}];