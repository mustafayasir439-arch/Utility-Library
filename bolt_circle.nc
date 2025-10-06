(PARAMETRIC BOLT CIRCLE DRILLING SUBROUTINE)
(TITLE: Universal Macro for Bolt Hole Pattern Generation)
(CREATED AND SPONSORED BY: [YOUR COMPANY NAME] - [YOUR WEBSITE URL])

(*** 1. INITIALIZATION BLOCK - ADJUST THESE VALUES ***)
#101 = 100.0   (X-CENTER OF CIRCLE)
#102 = 100.0   (Y-CENTER OF CIRCLE)
#103 = 50.0    (RADIUS OF BOLT CIRCLE in MM or INCH)
#104 = 6       (NUMBER OF HOLES)
#105 = 0.0     (STARTING ANGLE IN DEGREES: 0=3 o'clock, positive is CCW)
#106 = -15.0   (FINAL DRILLING DEPTH Z - ABSOLUTE)
#107 = 5.0     (R-PLANE HEIGHT FOR PECK CYCLE - ABSOLUTE or INCREMENTAL)
#108 = 2.0     (PECK DEPTH - Q VALUE, Incremental)

(*** 2. SETUP ***)
G90 G17 (Absolute Mode, XY Plane Selection)
T01 M06 (Tool Change to Drill)
S2000 M03 (Spindle On CW)
G00 Z50.0 (Safe Z height)
G43 H01 (Activate Tool Length Compensation)

(*** 3. CALCULATION BLOCK ***)
#110 = 360.0 / #104  (ANGLE INCREMENT BETWEEN HOLES)
#111 = 1             (HOLE COUNTER START)

G00 X#101 Y#102 (RAPID TO CENTER OF CIRCLE)
Z#107 (Rapid to R-Plane)

(*** 4. MAIN LOOP ***)
WHILE [#111 LE #104] DO 1

  (CALCULATE CURRENT ANGLE)
  #120 = [#105 + [#110 * [#111 - 1]]] 
  
  (CONVERT ANGLE TO RADIANS FOR TRIG FUNCTIONS - Fanuc uses degrees, but this is a safety check)
  (If your control requires radians, the conversion factor is 57.2958)
  
  (CALCULATE X AND Y COORDINATES)
  #130 = #101 + [#103 * COS[#120]] (FINAL X POSITION)
  #131 = #102 + [#103 * SIN[#120]] (FINAL Y POSITION)
  
  G00 X#130 Y#131 (RAPID TO HOLE POSITION)
  
  (DRILLING CYCLE - USING G83 PECK DRILL)
  G99 G83 Z#106 R#107 Q#108 F100 (EXECUTE PECK DRILLING CYCLE: Z-Depth, R-Plane, Q-Peck Depth, F-Feedrate)
  
  #111 = #111 + 1 (INCREMENT HOLE COUNTER)
  
END 1 (END WHILE LOOP)

G80 (CANCEL CANNED CYCLE)
G00 Z50.0 (Rapid Retract to Safe Height)
M05 (Spindle Stop)
M30 (Program End and Rewind)