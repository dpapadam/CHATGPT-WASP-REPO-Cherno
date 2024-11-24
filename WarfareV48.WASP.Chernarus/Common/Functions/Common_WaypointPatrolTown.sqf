/*
    Set a team on town patrol.
     Parameters:
        - Team.
        - Town.
        - {Radius}.
*/

Private ['_camps','_insert','_insertObject','_insertStep','_maxWaypoints','_pos','_radius','_rand1','_rand2','_team','_town','_townPos','_type','_update','_usable','_wpcompletionRadius','_wpradius','_wps','_attempts'];

_team = _this select 0;
_town = _this select 1;
_radius = if (count _this > 2) then {_this select 2} else {30};

// **Edit 1: Add check for _radius being undefined or not a number**
if (isNil "_radius" || {typeName _radius != "SCALAR"}) then {
    diag_log "[ERROR] Common_WaypointPatrolTown.sqf: _radius is undefined or not a number. Assigning default value 30.";
    _radius = 30;
};

if (typeName _town != 'OBJECT') exitWith {
    diag_log "[ERROR] Common_WaypointPatrolTown.sqf: _town is not an object. Exiting script.";
};
if (isNull _team) exitWith {
    diag_log "[ERROR] Common_WaypointPatrolTown.sqf: _team is null. Exiting script.";
};
_townPos = getPos _town;

_camps = _town getVariable 'camps'; // wf2

_usable = [_town] + _camps;
_maxWaypoints = (missionNamespace getVariable 'WFBE_C_TOWNS_UNITS_WAYPOINTS') + count(_usable);
_wps = [];

//--- Randomize the behaviours.
if (random 100 > 50) then {_team setFormation "DIAMOND"} else {_team setFormation "STAG COLUMN"};
if (random 100 > 50) then {_team setCombatMode "YELLOW"} else {_team setCombatMode "RED"};
if (random 100 > 50) then {_team setBehaviour "AWARE"} else {_team setBehaviour "COMBAT"};
if (random 100 > 50) then {_team setSpeedMode "NORMAL"} else {_team setSpeedMode "LIMITED"};

//--- Dyn insert.
_insertStep = if (count(_usable) != 0) then {floor(_maxWaypoints / count(_usable))} else {-1};
_insert = _insertStep;
_insertObject = objNull;
_wpradius = -1;
_wpcompletionRadius = -1;

for '_z' from 0 to _maxWaypoints do {
    if (_z == _insert && count _usable > 0) then {
        _insert = _insert + _insertStep;
        _insertObject = _usable select (round(random((count _usable)-1)));
        _usable = _usable - [_insertObject];
    };

    if (isNull _insertObject) then {
        _rand1 = random _radius - random _radius;
        _rand2 = random _radius - random _radius;
        _pos = [(_townPos select 0)+_rand1, (_townPos select 1)+_rand2, 0];

        // **Edit 2: Add check to ensure _pos is valid**
        _attempts = 0;
        while {surfaceIsWater _pos && _attempts < 3} do {
            _rand1 = random _radius - random _radius;
            _rand2 = random _radius - random _radius;
            _pos = [(_townPos select 0)+_rand1, (_townPos select 1)+_rand2, 0];
            _attempts = _attempts + 1;
        };
        if (_attempts >= 3) then {
            diag_log "[ERROR] Common_WaypointPatrolTown.sqf: Could not find a valid position after 10 attempts. Using town position.";
            _pos = _townPos;
        };

        _wpradius = 32;
        _wpcompletionRadius = 44;
    } else {
        _pos = getPos _insertObject;
        _wpradius = 35;
        _wpcompletionRadius = 68;
    };
    
    _type = if (_z != _maxWaypoints) then {'MOVE'} else {'CYCLE'};
    [_wps, [_pos,_type,_wpradius,_wpcompletionRadius, [], [], []]] Call WFBE_CO_FNC_ArrayPush;
};

[_team, true, _wps] Call WFBE_CO_FNC_WaypointsAdd;
