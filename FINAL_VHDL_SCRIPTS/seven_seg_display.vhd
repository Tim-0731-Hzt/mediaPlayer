----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:32:06 10/07/2020 
-- Design Name: 
-- Module Name:    seven_seg_display - Behavioral 
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

entity seven_seg_display is
    Port ( input 		: in  STD_LOGIC_VECTOR (11 downto 0);
			  clk 		: in STD_LOGIC ;
			  segment_output 	: out std_logic_vector (3 downto 0);
			  anode_out		: out std_logic_vector (3 downto 0));
end seven_seg_display;

architecture Behavioral of seven_seg_display is
	
	COMPONENT mux_4_to_1
	PORT(
		data0 : IN std_logic_vector(3 downto 0);
		data1 : IN std_logic_vector(3 downto 0);
		data2 : IN std_logic_vector(3 downto 0);
		data3 : IN std_logic_vector(3 downto 0);
		mux_select : IN std_logic_vector(1 downto 0);          
		data_out : OUT std_logic_vector(3 downto 0)
		);
	END COMPONENT;
	
	COMPONENT refresh_counter
	PORT(
		clk : IN std_logic;          
		counter_out : OUT std_logic_vector(1 downto 0)
		);
	END COMPONENT;
	
	signal sig_mux_select : std_logic_vector(1 downto 0);
	signal mux_data_out : std_logic_vector (3 downto 0);
begin

	mux_4_to_1_segments: mux_4_to_1 PORT MAP(
		data0 => input(3 downto 0),
		data1 => input(7 downto 4),
		data2 => input(11 downto 8),
		data3 => "0000",
		mux_select => sig_mux_select,
		data_out => segment_output
	);
	
	mux_4_to_1_anode: mux_4_to_1 PORT MAP(
		data0 => "1110",
		data1 => "1101",
		data2 => "1011",
		data3 => "0111",
		mux_select => sig_mux_select,
		data_out => anode_out
	);
	
	Inst_refresh_counter: refresh_counter PORT MAP(
		clk => clk,
		counter_out => sig_mux_select
	);
	
end Behavioral;

