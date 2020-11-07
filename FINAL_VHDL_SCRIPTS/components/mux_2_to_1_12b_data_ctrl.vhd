----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:06:43 11/07/2020 
-- Design Name: 
-- Module Name:    mux_2_to_1_12b_data_ctrl - Behavioral 
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

entity mux_2_to_1_12b_data_ctrl is
    Port ( clk : in STD_LOGIC;
			  data0 : in  STD_LOGIC_VECTOR (11 downto 0); 		--ir_mapped
           data1 : in  STD_LOGIC_VECTOR (11 downto 0);		--button_mapped
           mux_select : in  STD_LOGIC;
           data_out : out  STD_LOGIC_VECTOR (11 downto 0));
end mux_2_to_1_12b_data_ctrl;

architecture Behavioral of mux_2_to_1_12b_data_ctrl is

begin
	data_control: process(clk)
	begin
	
	if (clk'event and clk = '1') then
		if (mux_select = '1') then 
			data_out <= data1;
		else
			if (data0(11 downto 8) /= "0100") then
				data_out <= data0;
			end if;
		end if;
	end if;
	
	end process;
	
end Behavioral;

