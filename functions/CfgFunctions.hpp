class missions {
	class cargoMission {
        file = "functions\fCargoMission.sqf";
		missionName = "Cargo Transport";
		peacemode = 1;
    };
	class casMission {
        file = "functions\fCASMission.sqf";
		missionName = "Close Air Support (Infantry)";
		peacemode = 0;
    };
	class casMission2 {
        file = "functions\fCASMission2.sqf";
		missionName = "Close Air Support (Armour)";
		peacemode = 0;
    };
	class insertMission {
        file = "functions\fInsertMission.sqf";
		missionName = "Air Assault";
		peacemode = 1;
    };
};

class core {
	class setup {
        file = "functions\fSetUp.sqf";
    };
	class playersetup {
        file = "functions\fPlayerSetup.sqf";
    };
	class heliCheck {
        file = "functions\fheliCheck.sqf";
    };
};