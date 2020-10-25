----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:31:49 10/25/2020 
-- Design Name: 
-- Module Name:    mux_2_to_1_1b - Behavioral 
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

entity mux_2_to_1_1b is
    Port ( data0 : in  STD_LOGIC;
           data1 : in  STD_LOGIC;
           mux_select : in  STD_LOGIC;
           data_out : out  STD_LOGIC);
end mux_2_to_1_1b;

architecture Behavioral of mux_2_to_1_1b is

begin
	data_out <= data0 when mux_select = '0' else
					data1 when mux_select = '1';

end Behavioral;

