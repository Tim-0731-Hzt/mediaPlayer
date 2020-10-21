----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:40:20 10/07/2020 
-- Design Name: 
-- Module Name:    button_mapping - Behavioral 
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

entity button_mapping is
    Port ( clk : in STD_LOGIC;
			  btn : in  STD_LOGIC_VECTOR (3 downto 0);
           button_en : out  STD_LOGIC;
           button_mapping : out  STD_LOGIC_VECTOR (11 downto 0));
end button_mapping;

architecture Behavioral of button_mapping is
signal button_en_sig	: std_logic;
signal button_sig : std_logic_vector(11 downto 0);
signal addr_0 : 	std_logic_vector (3 downto 0) := "0000";
signal addr_1 : 	std_logic_vector (3 downto 0) := "0001";
signal addr_2 :	std_logic_vector (3 downto 0) := "0010";
signal addr_3 : 	std_logic_vector (3 downto 0) := "0011";


-- Simple process, each top 4 bits is for address, botton 4 bits is for output pulse to indicate what is to be done
begin

	button_mapping_process: process(clk)
		begin
			
			if (clk'event and clk = '1') then 
				button_en_sig <= '0';
				button_sig <= "000000000000";
				if (btn(0) = '1') then
					button_sig(11 downto 8) <= addr_0;
					button_sig(7 downto 0) <= "00000001";
					button_en_sig <= '1';
				elsif (btn(1) = '1') then
					button_sig(11 downto 8) <= addr_1;
					button_sig(7 downto 0) <= "00000010";
					button_en_sig <= '1';
				elsif (btn(2) = '1') then
					button_sig(11 downto 8) <= addr_2;
					button_sig(7 downto 0) <= "00000001";
					button_en_sig <= '1';
				elsif (btn(3) = '1') then
					button_sig(11 downto 8) <= addr_3;
					button_sig(7 downto 0) <= "00000001";
					button_en_sig <= '1';
				else
				end if;
			end if;
		end process;		
		
		button_mapping <= button_sig(11 downto 0);
		button_en <= button_en_sig;
end Behavioral;

