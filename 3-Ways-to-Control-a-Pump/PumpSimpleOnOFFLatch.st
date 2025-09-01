PROGRAM PumpSimpleOnOFFLatch
(* METHOD 1 — Simple ON/OFF Latch *)
VAR
 	xStartCmd: BOOL := FALSE; // operator start button (or PLC logic)
 	xStopCmd: BOOL := FALSE; // operator stop button
 	xPumpRun: BOOL := FALSE; // pump output
END_VAR

BEGIN

// Latch: pump runs when xStartCmd is true, stays on until xStopCmd
xPumpRun := (xStartCmd OR xPumpRun) AND NOT xStopCmd;

END_PROGRAM