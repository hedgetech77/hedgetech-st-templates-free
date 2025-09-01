PROGRAM PumpMinRunTime
(* METHOD 2 — Minimum Run Time with TON *)
VAR
	xStartCmd: BOOL := FALSE; // start request
	xStopCmd: BOOL := FALSE; // stop request
	xStopReq: BOOL := FALSE; // internal stop request latch
	xPumpRun: BOOL := FALSE; // pump output
	tonMinRun: TON; // timer instance
	timMinRun: TIME := T#10s; // minimum runtime
	tonMinRunTT: BOOL;
END_VAR
BEGIN
(* Start request: run pump and clear any stop request *)
xPumpRun := (xStartCmd AND NOT xStopCmd) OR tonMinRunTT;

(* TON timming bit *)
tonMinRunTT := (tonMinRun.ET > T#0s) AND (tonMinRun.PT <> tonMinRun.ET);

(* Start timer while pump is running *)
tonMinRun(IN := xPumpRun, PT := timMinRun);
END_PROGRAM