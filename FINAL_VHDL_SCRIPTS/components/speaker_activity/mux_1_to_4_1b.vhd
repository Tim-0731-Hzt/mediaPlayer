----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:17:45 11/02/2020 
-- Design Name: 
-- Module Name:    mux_4_to_1_1b - Behavioral 
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

entity mux_1_to_4_1b is
    Port ( clk			: in STD_LOGIC;
			  data_in 	: in STD_LOGIC;
           mux_select: in  STD_LOGIC_VECTOR (3 downto 0);
           data_out0 : out STD_LOGIC;
			  data_out1 : out STD_LOGIC;
			  data_out2 : out STD_LOGIC;
			  data_out3 : out STD_LOGIC);
end mux_1_to_4_1b;

architecture Behavioral of mux_1_to_4_1b is

begin

	mux_process: process(clk)
	begin
	
	if (clk'event and clk = '1') then
		data_out0 <= '0'; data_out1 <= '0'; data_out2 <= '0'; data_out3 <= '0';
		if (data_in = '1') then
			if (mux_select = "0001") then
				data_out0 <= '1';
			elsif (mux_select = "0010") then
				data_out1 <= '1';
			elsif (mux_select = "0100") then
				data_out2 <= '1';
			elsif (mux_select = "1000") then
				data_out3 <= '1';
			end if;
		end if;
	end if;
	
	end process;
					 

end Behavioral;

