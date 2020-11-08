----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:30:48 10/25/2020 
-- Design Name: 
-- Module Name:    adder_subtractor - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity adder_subtractor is
    Port ( clk : in std_logic;
			  pot_data : in  STD_LOGIC_VECTOR (7 downto 0);
           pot_en : in  STD_LOGIC;
           ir_data : in  STD_LOGIC_VECTOR (11 downto 0);
           ir_en : in  STD_LOGIC;
           add_sub_out : out  STD_LOGIC_VECTOR (11 downto 0));
end adder_subtractor;

architecture Behavioral of adder_subtractor is

signal sig_data : std_logic_vector(7 downto 0);
signal vol_busy : std_logic := '0';

begin
	
	dealing_with_en: process(clk)
	begin
		if (clk'event and clk = '1') then
			if (pot_en = '1') then
				sig_data <= pot_data;
			elsif(ir_en = '1') then
				if (ir_data = "010000000001" AND sig_data /= "01100100")  then
					sig_data <= std_logic_vector(unsigned(sig_data) + 5);
				elsif (ir_data = "010000000010" AND sig_data /= "00000000") then 
					sig_data <= std_logic_vector(unsigned(sig_data) - 5);
				end if;
			end if;
		end if;
	end process;
	
	add_sub_out(11 downto 8) <= "0100";
	add_sub_out(7 downto 0) <= sig_data;
	
end Behavioral;

