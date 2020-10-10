----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:50:04 10/09/2020 
-- Design Name: 
-- Module Name:    single_sseg - Behavioral 
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

entity single_sseg is
    Port ( input : in  STD_LOGIC_VECTOR (3 downto 0);
           segments : out  STD_LOGIC_VECTOR (6 downto 0));
end single_sseg;

architecture Behavioral of single_sseg is

COMPONENT single_sseg
	PORT(
		input : IN std_logic_vector(3 downto 0);          
		segments : OUT std_logic_vector(6 downto 0)
		);
	END COMPONENT;



begin
    with input select
        segments <=
            "1000000" when X"0",
            "1111001" when X"1",
            "0100100" when X"2",
            "0110000" when X"3",
            "0011001" when X"4",
            "0010010" when X"5",
            "0000010" when X"6",
            "1111000" when X"7",
            "0000000" when X"8",
            "0010000" when X"9",
            "0001000" when X"a",
            "0000011" when X"b",
            "1000110" when X"c",
            "0100001" when X"d",
            "0000110" when X"e",
            "0001110" when X"f",
				"1111111" when others;


end Behavioral;


