PROGRAM PumpStaging
(* METHOD 3 — Interlock + Lead/Backup Failover *)
VAR
  (* Commands / inputs *)
  	xLeadCmd: BOOL := FALSE; // request lead pump
  	xBackupCmd: BOOL := FALSE; // request backup pump
  	xLeadFault: BOOL := FALSE; // lead pump fault
  	xBackupFault: BOOL := FALSE; // backup pump fault
  	xLevelOK: BOOL := TRUE; // permissive: level available
  	xLeadOverloadOK: BOOL := TRUE; // permissive: lead pump not overloaded
  	xBackupOverloadOK: BOOL := TRUE; // permissive: backup pump not overloaded

  (* Desired State Logic *)
	xLeadDesired: BOOL;
	xBackupDesired: BOOL;

  (* Outputs *)
  	xLeadRun: BOOL := FALSE; // run lead pump
  	xBackupRun: BOOL := FALSE; // run backup pump

  (* Timers *)
  	tonLeadMin: TON;
  	tonBackupMin: TON;
  	timMinRun: TIME := T#10s; // adjust per equipment
	tonLeadMinTT: BOOL;
	tonBackupMinTT: BOOL;
END_VAR
BEGIN
    (* Selection logic *)
    xLeadDesired := 	xLeadCmd
                        AND
                        NOT xLeadFault AND xLeadOverloadOK AND xLevelOK;

    xBackupDesired := 	((xLeadCmd AND (xLeadFault OR NOT xLeadOverloadOK)) OR
                        (NOT xLeadCmd AND xBackupCmd))
                        AND
                        NOT xBackupFault AND xBackupOverloadOK AND xLevelOK;

    (* Apply minimum runtime using *)
    xLeadRun 		:= xLeadDesired OR tonLeadMinTT;
    xBackupRun		:= xBackupDesired OR tonBackupMinTT;

    (* Prevent backup if lead is running - prevents dual/overlap runs *)
    IF xLeadRun THEN
        xBackupRun := FALSE;
    END_IF

    (* Minimum runtime - It does not override safety/permissive shutdowns *)
    tonLeadMin(IN := xLeadRun AND NOT xLeadFault AND xLeadOverloadOK AND xLevelOK, PT := timMinRun);
    tonBackupMin(IN := xBackupRun AND NOT xBackupFault AND xBackupOverloadOK AND xLevelOK, PT := timMinRun);

    tonLeadMinTT := (tonLeadMin.ET > T#0s) AND (tonLeadMin.ET <> tonLeadMin.PT);
    tonBackupMinTT := (tonBackupMin.ET > T#0s) AND (tonBackupMin.ET <> tonBackupMin.PT);
END_PROGRAM