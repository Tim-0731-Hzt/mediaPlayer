----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:02:37 10/17/2020 
-- Design Name: 
-- Module Name:    comparator - Behavioral 
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

entity comparator is
    Port ( ADC_input : in  STD_LOGIC_VECTOR (11 downto 0);
           old_input : in  STD_LOGIC_VECTOR (11 downto 0);
			  update_reg_en : out std_logic;
           output : out  STD_LOGIC_VECTOR (11 downto 0));
end comparator;

architecture Behavioral of comparator is

begin
	comparing: process(ADC_input, old_input)
	begin
		update_reg_en <= '0';
		if(ADC_input /= old_input) then 
			output <= ADC_input;
			update_reg_en <= '1';
		end if;
	end process;
	
end Behavioral;

