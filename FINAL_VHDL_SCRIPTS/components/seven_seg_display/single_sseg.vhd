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
    Port ( input : in  STD_LOGIC_VECTOR (4 downto 0);
           segments : out  STD_LOGIC_VECTOR (6 downto 0));
end single_sseg;

architecture Behavioral of single_sseg is

COMPONENT single_sseg
	PORT(
		input : IN std_logic_vector(4 downto 0);          
		segments : OUT std_logic_vector(6 downto 0)
		);
	END COMPONENT;



begin
    with input select
        segments <=
            "1000000" when "00000",  -- 0
            "1111001" when "00001",	 -- 1
            "0100100" when "00010",	 -- 2
            "0110000" when "00011",  -- 3
            "0011001" when "00100",	 -- 4
            "0010010" when "00101",  -- 5
            "0000010" when "00110",  -- 6
            "1111000" when "00111",  -- 7
            "0000000" when "01000",  -- 8
            "0010000" when "01001",  -- 9
            "0001000" when "01010",  -- A 
            "0000011" when "01011",  -- B
            "1000110" when "01100",  -- C
            "0100001" when "01101",  -- D
            "0000110" when "01110",  -- E
            "0001110" when "01111",  -- F
				
				-- THESE VALUES ARE USED FOR BUTTON MESSAGES WHEN A BUTTON IS PRESSED
				"0001000" when "10000",  -- A
				"0000011" when "10001",  -- b
				"1000110" when "10010",  -- C
				"0100001" when "10011",  -- d
				"0000110" when "10100",  -- E
				"0001001" when "10101",  -- K
				"1000111" when "10110",  -- L
				"1000000" when "10111",  -- O
				"0001100" when "11000",  -- P
				"0010010" when "11001",	 -- S
				"0000111" when "11010",	 -- T
				"0010001" when "11011",  -- y
				"1001000" when "11100",  -- n
				"0001001" when "11101",  -- X
				"1111111" when others;


end Behavioral;


