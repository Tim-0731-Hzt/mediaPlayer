----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:04:00 10/14/2020 
-- Design Name: 
-- Module Name:    mux_2_to_1_8b - Behavioral 
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

entity mux_2_to_1_12b is
    Port ( data0 : in  STD_LOGIC_VECTOR (11 downto 0);
           data1 : in  STD_LOGIC_VECTOR (11 downto 0);
           mux_select : in  STD_LOGIC;
			  data_out : out  STD_LOGIC_VECTOR (11 downto 0)
           );
end mux_2_to_1_12b;

architecture Behavioral of mux_2_to_1_12b is

begin
	data_out <= data0 when mux_select = '0' else
					data1 when mux_select = '1';

end Behavioral;

