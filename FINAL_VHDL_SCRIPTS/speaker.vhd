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
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;


--For a 100MHz clock
--When speaker_en is active, a square wave will be the output for 0.5s


entity speaker is
    Port ( clk : in  STD_LOGIC;
           speaker_en : in  STD_LOGIC_VECTOR(1 downto 0);
           speaker_out : out  STD_LOGIC);
end speaker;

architecture Behavioral of speaker is
	--square_wave_count : std_logic_vector(16 downto 0) := "00000000000000000";
	signal output_sig : std_logic := '0';
	signal hold_en : std_logic := '0';
begin
	
	square_wave_gen : process(clk)
	variable cnt : integer := 0;
	begin
	
		if (clk'event and clk = '1') then
			if (hold_en = '1') then
				if(cnt = 100000) then 
					cnt := 0;
					if (output_sig = '0') then
						output_sig <= '1';
					else 
						output_sig <= '0';
					end if;
				else 
					cnt := cnt + 1;
				end if;
			end if;
		end if;
	end process;
	
	speaker_out <= output_sig;
	
	
	-- speaker_en should only be a pulse
	-- this process will hold an enable for the duration of the 0.5s
	-- set signal hold_en to '1' when pulse occurs, wait 0.5s, return hold_en to '0'
	signal_en_latch : process(clk)
	variable cnt : integer := 0;
	begin	
		if (clk'event and clk = '1') then
			if (speaker_en(0) = '1' or speaker_en(1) = '1') then
				hold_en <= '1';
			end if;
			if (hold_en = '1') then
			cnt := cnt + 1;
			end if;
			
			if (cnt = 50000000) then
				hold_en <= '0';
				cnt := 0;
			
			end if;
		end if;
	end process;
end Behavioral;

