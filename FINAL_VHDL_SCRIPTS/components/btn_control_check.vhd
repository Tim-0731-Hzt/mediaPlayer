----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:27:46 11/04/2020 
-- Design Name: 
-- Module Name:    btn_control_check - Behavioral 
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

entity btn_control_check is
    Port ( clk : in STD_LOGIC;
			  btn : in  STD_LOGIC_VECTOR (3 downto 0);
           output : out  STD_LOGIC_VECTOR (15 downto 0));
end btn_control_check;

architecture Behavioral of btn_control_check is
signal sig_out : std_logic_vector (15 downto 0);

begin
	btn_control_process : process(clk)
	begin
	if (clk'event and clk = '1') then
		sig_out <= (others => '0');
		if (btn(0) = '1') then 
			sig_out <= "0000000000000001";
		elsif (btn(1) = '1') then
			sig_out <= "0000000000010000";
		elsif (btn(2) = '1') then
			sig_out <= "0000000100000000";
		elsif (btn(3) = '1') then
			sig_out <= "0001000000000000";
		end if;
	end if;
	
	end process;

	output <= sig_out;
end Behavioral;

