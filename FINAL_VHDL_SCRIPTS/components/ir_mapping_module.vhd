----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    08:09:13 11/06/2020 
-- Design Name: 
-- Module Name:    ir_mapping_module - Behavioral 
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

entity ir_mapping_module is
    Port ( clk : in STD_LOGIC;
			  ir_signal : in  STD_LOGIC_VECTOR (11 downto 0);
           ir_en : in  STD_LOGIC;
           ir_mapped_en : out  STD_LOGIC;									-- It's essentially just ir_en, just thought there might be clock sync issues
           ir_mapped_out : out  STD_LOGIC_VECTOR (11 downto 0));
end ir_mapping_module;

architecture Behavioral of ir_mapping_module is

signal sig_ir_mapped_out : std_logic_vector(15 downto 0);

constant next_sig_ir		 : std_logic_vector(11 downto 0) := X"39D";
constant play_sig_ir		 : std_logic_vector(11 downto 0) := X"5BA";
constant stop_sig_ir		 : std_logic_vector(11 downto 0) := X"A70"; -- Just using enter for this
constant prev_sig_ir		 : std_logic_vector(11 downto 0) := X"D9D";

constant next_button 	 : std_logic_vector(11 downto 0) := "000000000001";
constant play_button		 : std_logic_vector(11 downto 0) := "000100000010"; 
constant stop_button		 : std_logic_vector(11 downto 0) := "001000000001";
constant back_button		 : std_logic_vector(11 downto 0) := "001100000001";
begin
	ir_mapping_process : process(clk)
	begin
	if (clk'event and clk = '1') then
		ir_mapped_en <= '0';
		if (ir_en = '1') then
			if (ir_signal = next_sig_ir) then 
				ir_mapped_en <= '1';
				ir_mapped_out <= next_button;
			elsif (ir_signal = play_sig_ir) then	
				ir_mapped_en <= '1';
				ir_mapped_out <= play_button;
			elsif (ir_signal = stop_sig_ir) then
				ir_mapped_en <= '1';
				ir_mapped_out <= stop_button;
			elsif (ir_signal = prev_sig_ir) then
				ir_mapped_en <= '1';
				ir_mapped_out <= back_button;
			end if;
		end if;
	end if;
	
	end process;


end Behavioral;

