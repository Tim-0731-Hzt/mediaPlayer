----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:19:54 10/09/2020 
-- Design Name: 
-- Module Name:    Mux_4_to_1 - Behavioral 
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

entity mux_4_to_1 is
    Port ( data0 : in  STD_LOGIC_VECTOR (3 downto 0);
           data1 : in  STD_LOGIC_VECTOR (3 downto 0);
           data2 : in  STD_LOGIC_VECTOR (3 downto 0);
           data3 : in  STD_LOGIC_VECTOR (3 downto 0);
           mux_select : in  STD_LOGIC_VECTOR (1 downto 0);
           data_out : out  STD_LOGIC_VECTOR (3 downto 0));
end mux_4_to_1;

architecture Behavioral of Mux_4_to_1 is

begin

	data_out <= data0 when mux_select = "00" else
					data1 when mux_select = "01" else
					data2 when mux_select = "10" else 
					data3 when mux_select = "11";


end Behavioral;

