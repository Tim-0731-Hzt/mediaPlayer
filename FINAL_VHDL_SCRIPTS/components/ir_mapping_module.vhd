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
		   ir_vol_en : out std_logic;
           ir_mapped_out : out  STD_LOGIC_VECTOR (11 downto 0));
end ir_mapping_module;

architecture Behavioral of ir_mapping_module is

signal sig_ir_mapped_out : std_logic_vector(15 downto 0);
signal hold_ir_en			 : std_logic;

constant next_sig_ir		 : std_logic_vector(11 downto 0) := X"CD0";
constant play_sig_ir		 : std_logic_vector(11 downto 0) := X"A70";
constant stop_sig_ir		 : std_logic_vector(11 downto 0) := X"AF0"; -- Just using enter for this
constant prev_sig_ir		 : std_logic_vector(11 downto 0) := X"2D0";
constant vol_up_sig_ir	 : std_logic_vector(11 downto 0) := X"490";
constant vol_down_sig_ir : std_logic_vector(11 downto 0) := X"C90";

constant next_button 	 : std_logic_vector(11 downto 0) := "000000000001";
constant play_button		 : std_logic_vector(11 downto 0) := "000100000010"; 
constant stop_button		 : std_logic_vector(11 downto 0) := "001000000001";
constant back_button		 : std_logic_vector(11 downto 0) := "001100000001";
constant vol_up			 : std_logic_vector(11 downto 0) := "010100000001";
constant vol_down			 : std_logic_vector(11 downto 0) := "010100000010";
begin
	ir_mapping_process : process(clk)
	begin
	if (clk'event and clk = '1') then
		ir_vol_en <= '0';
		ir_mapped_en <= '0';
		ir_mapped_out <= (others => '0');
		if (hold_ir_en = '1') then
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
			elsif (ir_signal = vol_up_sig_ir) then
--				ir_mapped_en <= '1';
				ir_vol_en <= '1';
				ir_mapped_out <= vol_up;
			elsif (ir_signal = vol_down_sig_ir) then
--				ir_mapped_en <= '1';
				ir_vol_en <= '1';
				ir_mapped_out <= vol_down;
			end if;
		else
			ir_mapped_out <= (others => '0');
		end if;
	end if;
	
	end process;

	signal_en_latch : PROCESS(clk)
	variable cnt : integer := 0;
	begin	
		IF (clk'event and clk = '1') THEN
			IF (ir_en = '1') THEN
				hold_ir_en <= '1';
			END IF;
			IF (hold_ir_en = '1') THEN
			cnt := cnt + 1;
			END IF;
--			35000000
			IF (cnt = 35000000) THEN
				hold_ir_en <= '0';
				cnt := 0;
			
			END IF;
		END IF;
	end process;
	
end Behavioral;

