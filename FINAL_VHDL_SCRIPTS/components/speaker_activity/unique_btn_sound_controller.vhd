----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:55:21 11/01/2020 
-- Design Name: 
-- Module Name:    unique_btn_sound_controller - Behavioral 
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

entity unique_btn_sound_controller is
    Port ( clk : in  STD_LOGIC;
           btn_addr : in  STD_LOGIC_VECTOR (1 downto 0);
           btn_en : in  STD_LOGIC;
           sound_out : out  STD_LOGIC);
end unique_btn_sound_controller;

architecture Behavioral of unique_btn_sound_controller is

COMPONENT btn_0_noise_state_machine
	PORT(
		clk : IN std_logic;
		signal_en : IN std_logic;          
		sound_out : OUT std_logic
		);
	END COMPONENT;

COMPONENT btn_1_noise_state_machine
	PORT(
		clk : IN std_logic;
		signal_en : IN std_logic;          
		sound_out : OUT std_logic
		);
	END COMPONENT;

COMPONENT btn_2_noise_state_machine
	PORT(
		clk : IN std_logic;
		signal_en : IN std_logic;          
		sound_out : OUT std_logic
		);
	END COMPONENT;

COMPONENT btn_3_noise_state_machine
	PORT(
		clk : IN std_logic;
		signal_en : IN std_logic;          
		sound_out : OUT std_logic
		);
	END COMPONENT;

COMPONENT mux_1_to_4_1b
	PORT(
		clk 	  : IN std_logic;
		data_in : IN std_logic;
		mux_select : IN std_logic_vector(3 downto 0);          
		data_out0 : OUT std_logic;
		data_out1 : OUT std_logic;
		data_out2 : OUT std_logic;
		data_out3 : OUT std_logic
		);
	END COMPONENT;

COMPONENT btn_addr_mapper
	PORT(
		clk : IN std_logic;
		btn_en : IN std_logic;
		addr_in : IN std_logic_vector(1 downto 0);          
		addr_mapped_out : OUT std_logic_vector(3 downto 0)
		);
	END COMPONENT;
	
	signal sig_btn_0  	: std_logic;
	signal sig_btn_1  	: std_logic;
	signal sig_btn_2  	: std_logic;
	signal sig_btn_3  	: std_logic;
	
	signal sig_btn_0_out	: std_logic;
	signal sig_btn_1_out	: std_logic;
	signal sig_btn_2_out	: std_logic;
	signal sig_btn_3_out	: std_logic;
	
	signal sig_btn_addr_mapped	: std_logic_vector(3 downto 0);
	
begin

Inst_btn_0_noise_state_machine: btn_0_noise_state_machine PORT MAP(
		clk => clk,
		signal_en => sig_btn_0,
		sound_out => sig_btn_0_out
	);
	
Inst_btn_1_noise_state_machine: btn_1_noise_state_machine PORT MAP(
		clk => clk,
		signal_en => sig_btn_1,
		sound_out => sig_btn_1_out
	);

Inst_btn_2_noise_state_machine: btn_2_noise_state_machine PORT MAP(
		clk => clk,
		signal_en => sig_btn_2,
		sound_out => sig_btn_2_out
	);

Inst_btn_3_noise_state_machine: btn_3_noise_state_machine PORT MAP(
		clk => clk,
		signal_en => sig_btn_3,
		sound_out => sig_btn_3_out
	);
	
Inst_mux_1_to_4_1b: mux_1_to_4_1b PORT MAP(
		clk => clk,
		data_in => btn_en,
		mux_select => sig_btn_addr_mapped,
		data_out0 => sig_btn_0,
		data_out1 => sig_btn_1,
		data_out2 => sig_btn_2,
		data_out3 => sig_btn_3
	);

Inst_btn_addr_mapper: btn_addr_mapper PORT MAP(
		clk => clk,
		btn_en => btn_en,
		addr_in => btn_addr,
		addr_mapped_out => sig_btn_addr_mapped
	);
	
	sound_out <= sig_btn_0_out or sig_btn_1_out or sig_btn_2_out or sig_btn_3_out;
end Behavioral;

