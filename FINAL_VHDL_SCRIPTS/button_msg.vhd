----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:06:07 10/18/2020 
-- Design Name: 
-- Module Name:    button_msg - Behavioral 
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

entity button_msg is
    Port ( button_addr : in  STD_LOGIC_VECTOR (1 downto 0);
           button_msg : out  STD_LOGIC_VECTOR (15 downto 0));
end button_msg;

architecture Behavioral of button_msg is

begin
	button_msg_mapping : process(button_addr)
	begin
		if button_addr = "00" then
			button_msg <= "1111010001000011"; -- FFD
		elsif button_addr = "01" then
			button_msg <= "1000011000001011"; -- PLAY
		elsif button_addr = "10" then
			button_msg <= "1001101001111000"; -- STOP
		elsif button_addr = "11" then
			button_msg <= "0001000000100101"; -- BACK
		end if;
	end process;
end Behavioral;

