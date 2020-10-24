----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:35:41 10/17/2020 
-- Design Name: 
-- Module Name:    reg_for_comparator - Behavioral 
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

entity reg_for_comparator is
    Port ( clk 	: in STD_LOGIC;
			  reg_in : in  STD_LOGIC_VECTOR (11 downto 0);
           reg_out : out  STD_LOGIC_VECTOR (11 downto 0));
end reg_for_comparator;

architecture Behavioral of reg_for_comparator is
signal sig_reg_out : std_logic_vector(11 downto 0):= "000000000000";

begin
	update_reg: process(clk)
	begin
		if (clk'event and clk = '1') then
			sig_reg_out <= reg_in;
		end if;
	end process;
	
	reg_out <= sig_reg_out;
end Behavioral;

