----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:13:48 11/01/2020 
-- Design Name: 
-- Module Name:    music_note_C6_generator - Behavioral 
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

entity music_note_C6_generator is
    Port ( clk : in  STD_LOGIC;
           signal_en : in  STD_LOGIC;
           gen_c6 : out  STD_LOGIC);
end music_note_C6_generator;

architecture Behavioral of music_note_C6_generator is
signal output_sig : std_logic := '0';

begin

	gen_sig : process(clk)
	variable cnt : integer := 0;
	begin
	
		if (clk'event and clk = '1') then
			if (signal_en = '1') then
				if(cnt = 47778) then 
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

	gen_c6 <= output_sig;

end Behavioral;

