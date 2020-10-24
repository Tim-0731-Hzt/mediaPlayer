----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:24:30 10/09/2020 
-- Design Name: 
-- Module Name:    generic_counter - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;


--
entity refresh_counter is
	 Port ( clk : in  STD_LOGIC;
           counter_out : out  STD_LOGIC_VECTOR (1 downto 0));
end refresh_counter;

architecture Behavioral of refresh_counter is
signal refresh_rate: std_logic_vector (17 downto 0) := "000000000000000000";

begin
	counting : process(clk)
		variable counter : integer := 0;
		begin
			if (clk'event and clk = '1') then
				if (refresh_rate = "111111111111111111") then
					refresh_rate <= (others => '0');
				else
					refresh_rate <= std_logic_vector(unsigned(refresh_rate) + 1);
				end if;
			end if;
		end process;
	
	counter_out <= refresh_rate(17 downto 16);
end Behavioral;

