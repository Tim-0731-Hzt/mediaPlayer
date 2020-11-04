----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:46:30 11/02/2020 
-- Design Name: 
-- Module Name:    btn_addr_mapper - Behavioral 
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

entity btn_addr_mapper is
    Port ( clk		 : in STD_LOGIC;
			  btn_en  : in STD_LOGIC;
			  addr_in : in  STD_LOGIC_VECTOR (1 downto 0);
           addr_mapped_out : out  STD_LOGIC_VECTOR (3 downto 0));
end btn_addr_mapper;

architecture Behavioral of btn_addr_mapper is

begin
	mapping_addr: process(clk)
	begin
	if (clk'event and clk = '1') then
		addr_mapped_out <= "0000";
		if (btn_en = '1') then
			if (addr_in = "00") then
				addr_mapped_out <= "0001";
			elsif (addr_in = "01") then
				addr_mapped_out <= "0010";
			elsif (addr_in = "10") then
				addr_mapped_out <= "0100";
			elsif (addr_in = "11") then
				addr_mapped_out <= "1000";
			end if;
		end if;
	end if;
	
	end process;

end Behavioral;

