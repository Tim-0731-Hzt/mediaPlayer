LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY lshift12 IS
	PORT (w, Clock		: IN	STD_LOGIC;
			En 			: IN	STD_LOGIC;
			Q				: OUT	STD_LOGIC_VECTOR(1 TO 12));
END lshift12;

ARCHITECTURE Behaviour OF lshift12 IS
	SIGNAL Sreg	:	STD_LOGIC_VECTOR(1 TO 12);
	
BEGIN 
	PROCESS (Clock)
	BEGIN
		IF En = '1' THEN
			IF Clock'EVENT AND Clock = '1' THEN
				Sreg(12) <= w;
				Sreg(11) <= Sreg(12);
				Sreg(10) <= Sreg(11);
				Sreg(9) <= Sreg(10);
				Sreg(8) <= Sreg(9);
				Sreg(7) <= Sreg(8);
				Sreg(6) <= Sreg(7);
				Sreg(5) <= Sreg(6);
				Sreg(4) <= Sreg(5);
				Sreg(3) <= Sreg(4);
				Sreg(2) <= Sreg(3);
				Sreg(1) <= Sreg(2);
			END IF;
		END IF;
	END PROCESS;
	Q <= Sreg;
END Behaviour;