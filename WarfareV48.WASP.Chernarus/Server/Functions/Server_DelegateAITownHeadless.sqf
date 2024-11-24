/*
	Delegate town AI creation to a headless client.
	 Parameters:
		- Town
		- Side
		- Groups
		- Spawn positions
		- Teams
*/

Private ["_clients", "_groups", "_positions", "_side", "_teams", "_town", "_currentClientIndex", "_selectedClient"];

_town = _this select 0;
_side = _this select 1;
_groups = +(_this select 2);
_positions = +(_this select 3);
_teams = +(_this select 4);

// Initialize or retrieve the global index for sequential delegation
if (isNil "WFBE_CURRENT_CLIENT_INDEX_AITOWNHEADLESS") then {
	WFBE_CURRENT_CLIENT_INDEX_AITOWNHEADLESS = 0; // Start at the first client
};

//--- Delegate the groups to the headless clients in a round-robin manner
for '_i' from 0 to (count _groups) - 1 do {
	_clients = missionNamespace getVariable "WFBE_HEADLESSCLIENTS_ID";

		// Log the values of the variables
	diag_log format ["DEBUG: _clients = %1", _clients];
	diag_log format ["DEBUG: _groups = %1", _groups];
	diag_log format ["DEBUG: _positions = %1", _positions];
	diag_log format ["DEBUG: _side = %1", _side];
	diag_log format ["DEBUG: _teams = %1", _teams];
	diag_log format ["DEBUG: _town = %1", _town];
	diag_log format ["DEBUG: WFBE_HEADLESSCLIENTS_ID = %1", WFBE_HEADLESSCLIENTS_ID];

	if (count _clients > 0) then {
		// Get the current client in the list
		_currentClientIndex = WFBE_CURRENT_CLIENT_INDEX_AITOWNHEADLESS;
		_selectedClient = _clients select _currentClientIndex;

		// Log the selected client
		diag_log format ["DEBUG: Selected client for delegation: %1 (Index: %2)", _selectedClient, _currentClientIndex];

		// Delegate the current group to the selected client
		[leader _selectedClient, "HandleSpecial", ['delegate-townai', _town, _side, [_groups select _i], [_positions select _i], [_teams select _i]]] call WFBE_CO_FNC_SendToClient;

		// Increment the index and reset if necessary
		WFBE_CURRENT_CLIENT_INDEX_AITOWNHEADLESS = (_currentClientIndex + 1) mod (count _clients);
	};
};
