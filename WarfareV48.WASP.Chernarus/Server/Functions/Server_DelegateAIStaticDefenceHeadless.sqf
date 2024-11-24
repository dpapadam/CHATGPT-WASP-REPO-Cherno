/*
	Delegate town AI Static Defences creation to an headless client.
	 Parameters:
		- Side
		- Groups
		- Spawn positions
		- Teams
		- Defence
		- Move In Gunner immediately or not
*/

Private ["_clients", "_groups", "_positions", "_side", "_teams", "_currentClientIndex", "_selectedClient"];

_side = _this select 0;
_groups = +(_this select 1);
_positions = +(_this select 2);
_team = _this select 3;
_defence = _this select 4;
_moveInGunner = _this select 5;

// Initialize or retrieve the global index for sequential delegation
if (isNil "WFBE_CURRENT_CLIENT_INDEX_AISTATICDEFENCE") then {
	WFBE_CURRENT_CLIENT_INDEX_AISTATICDEFENCE = 0; // Start at the first client
};

//--- Delegate The groups to the miscelleanous headless clients.
for '_i' from 0 to count(_groups) -1 do {
	_clients = missionNamespace getVariable "WFBE_HEADLESSCLIENTS_ID";

		// Log the values of the variables
	diag_log format ["DEBUG: _side = %1", _side];
	diag_log format ["DEBUG: _groups = %1", _groups];
	diag_log format ["DEBUG: _positions = %1", _positions];
	diag_log format ["DEBUG: _side = %1", _side];
	diag_log format ["DEBUG: _team = %1", _team];
	diag_log format ["DEBUG: _defence = %1", _defence];
	diag_log format ["DEBUG: _moveInGunner = %1", _moveInGunner];
	diag_log format ["DEBUG: WFBE_HEADLESSCLIENTS_ID = %1", WFBE_HEADLESSCLIENTS_ID];

	if (count _clients > 0) then {
		// Get the current client in the list
		_currentClientIndex = WFBE_CURRENT_CLIENT_INDEX_AISTATICDEFENCE;
		_selectedClient = _clients select _currentClientIndex;

		// Log the selected client
		diag_log format ["DEBUG: Selected client for delegation: %1 (Index: %2)", _selectedClient, _currentClientIndex];

		// Delegate the current group to the selected client
		[leader _selectedClient, "HandleSpecial", ['delegate-ai-static-defence', _side, [_groups select _i], [_positions select _i], _team, _defence, _moveInGunner]] Call WFBE_CO_FNC_SendToClient;

		// Increment the index and reset if necessary
		WFBE_CURRENT_CLIENT_INDEX_AISTATICDEFENCE = (_currentClientIndex + 1) mod (count _clients);
	};

};