params ["_unit"];
if(!isServer) exitWith{false};

private _isPlayerDetected = false;
while{alive _unit && !_isPlayerDetected} do {
	private _targets = nil;
	waitUntil{sleep 1;_targets = _unit targets [false, 20, [independent]]; count _targets > 0};

	sleep 3;
	{
		if(
			alive _unit
			&& _unit knowsAbout _x > 3.5
			&& (currentWeapon  _x != "" || primaryWeapon _x != "")
			&& _unit getRelDir _x < 120
		) then {
			resistance setFriend [east, 0]; 
			east setFriend [resistance, 0];
			_isPlayerDetected = true;
		}
	} forEach _targets;

	sleep 2;
};