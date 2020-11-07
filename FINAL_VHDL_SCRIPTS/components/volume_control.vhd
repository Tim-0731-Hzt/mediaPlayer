----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:18:17 10/25/2020 
-- Design Name: 
-- Module Name:    volume_control - Behavioral 
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

entity volume_control is
    Port ( clk : in  STD_LOGIC;
           pot_data : in  STD_LOGIC_VECTOR (9 downto 0);
           ir_data : in  STD_LOGIC_VECTOR (11 downto 0);
           ir_en : in  STD_LOGIC;
           vol_data_out : out  STD_LOGIC_VECTOR (11 downto 0));
end volume_control;

architecture Behavioral of volume_control is

COMPONENT pot_control
	
	PORT(
		clk : IN std_logic;
		pot_data : IN std_logic_vector(9 downto 0);          
		pot_en_out : OUT std_logic;
		pot_out : OUT std_logic_vector(11 downto 0)
		);
	END COMPONENT;
	
	COMPONENT adder_subtractor
	PORT(clk : in std_logic;
		pot_data : IN std_logic_vector(7 downto 0);
		pot_en : IN std_logic;
		ir_data : IN std_logic_vector(11 downto 0);
		ir_en : IN std_logic;          
		add_sub_out : OUT std_logic_vector(11 downto 0)
		);
	END COMPONENT;
	
	COMPONENT mux_2_to_1_12b
	PORT(
		data0 : IN std_logic_vector(11 downto 0);
		data1 : IN std_logic_vector(11 downto 0);
		mux_select : IN std_logic;          
		data_out : OUT std_logic_vector(11 downto 0)
		);
	END COMPONENT;
	
	signal sig_pot_data_mapped : std_logic_vector(11 downto 0);
	signal sig_pot_en_out		: std_logic;
	signal sig_add_sub_out		: std_logic_vector(11 downto 0);
	signal sig_vol_out			: std_logic_vector(11 downto 0);
begin

	Inst_pot_control: pot_control PORT MAP(
		clk => clk,
		pot_data => pot_data,
		pot_en_out => sig_pot_en_out,
		pot_out => sig_pot_data_mapped
	);
	
	Inst_adder_subtractor: adder_subtractor PORT MAP(
		clk => clk,
		pot_data => sig_pot_data_mapped(7 downto 0),
		pot_en => sig_pot_en_out,
		ir_data => ir_data,
		ir_en => ir_en,
		add_sub_out => sig_add_sub_out
	);

	Inst_mux_2_to_1_12b: mux_2_to_1_12b PORT MAP(
		data0 => sig_add_sub_out,
		data1 => sig_pot_data_mapped,
		mux_select => sig_pot_en_out,
		data_out => sig_vol_out
	);

	vol_data_out <= sig_vol_out;
end Behavioral;

