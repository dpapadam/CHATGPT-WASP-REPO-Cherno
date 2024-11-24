/*
	Client receives PVF Here.
	 Parameters:
		- Client PVF
*/

Private ["_destination","_exit","_parameters","_publicVar","_script"];

_publicVar = _this;
_exit = true;

isHeadlessClient = false;
isHeadlessClient = Call Compile preprocessFileLineNumbers "Headless\Functions\HC_IsHeadlessClient.sqf";

_destination = _publicVar select 0;
if (isNil '_destination') then {_destination = 0;_exit = false};

diag_log format ["DEBUG: client_handlepvf.sqf _publicVar = %1", _publicVar];
diag_log format ["DEBUG: client_handlepvf.sqf _destination = %1", _destination];																		

if (typeName(_destination) == 'SIDE' && !(isHeadlessClient)) then {if (sideJoined == _destination) then {_exit = false}};
if (typeName(_destination) == 'STRING') then {if (isMultiplayer) then {if (getPlayerUID player == _destination) then {_exit = false}} else {_exit = true}};

if (_exit) exitWith {};

_script = _publicVar select 1;
_parameters = if (count _this > 2) then {_publicVar select 2} else {[]};

_parameters Spawn (Call Compile _script);