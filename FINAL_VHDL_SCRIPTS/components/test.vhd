----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:13:06 11/04/2020 
-- Design Name: 
-- Module Name:    test - Behavioral 
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

entity test is
    Port ( clk : in  STD_LOGIC;
           btn : in  STD_LOGIC;
           output : out  STD_LOGIC);
end test;

architecture Behavioral of test is

begin

	test_process: process(clk)
	variable cnt : integer := 0;
	begin
	
	if (clk'event and clk = '1') then
		output <= '0';
		if (btn = '1') then
			cnt := cnt + 1;					
				if (cnt = 100000000) then
						cnt := 0;
						output <= '1';
				end if;
		end if;
	end if; 
	end process;

end Behavioral;

