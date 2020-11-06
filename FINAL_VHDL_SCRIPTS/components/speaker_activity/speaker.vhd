----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:10:15 10/05/2020 
-- Design Name: 
-- Module Name:    speaker - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- DepENDencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration IF using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration IF instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;


--For a 100MHz clock
--When speaker_en is active, a square wave will be the output for 0.5s


entity speaker is
    Port ( clk : in  STD_LOGIC;
           speaker_en : in  STD_LOGIC;
           speaker_out : out  STD_LOGIC);
END speaker;

architecture Behavioral of speaker is
	signal output_sig : std_logic := '0';
	signal hold_en : std_logic := '0';
begin
	
	square_wave_gen : PROCESS(clk)
	
	variable cnt : integer := 0;
	
	BEGIN
	
		IF (clk'event AND clk = '1') THEN
			IF (hold_en = '1') THEN
				IF(cnt = 100000) THEN 
					cnt := 0;
					IF (output_sig = '0') THEN
						output_sig <= '1';
					ELSE 
						output_sig <= '0';
					END IF;
				ELSE 
					cnt := cnt + 1;
				END IF;
			END IF;
		END IF;
	END PROCESS;
	
	speaker_out <= output_sig;
	
	
	-- speaker_en should only be a pulse
	-- this PROCESS will hold an enable for the duration of the 0.5s
	-- set signal hold_en to '1' when pulse occurs, wait 0.5s, return hold_en to '0'
	signal_en_latch : PROCESS(clk)
	variable cnt : integer := 0;
	begin	
		IF (clk'event and clk = '1') THEN
			IF (speaker_en = '1') THEN
				hold_en <= '1';
			END IF;
			IF (hold_en = '1') THEN
			cnt := cnt + 1;
			END IF;
			
			IF (cnt = 50000000) THEN
				hold_en <= '0';
				cnt := 0;
			
			END IF;
		END IF;
	END PROCESS;
END Behavioral;

