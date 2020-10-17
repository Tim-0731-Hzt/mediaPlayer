----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:55:50 10/05/2020 
-- Design Name: 
-- Module Name:    media_control_box - Behavioral 
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

entity media_control_box is
    Port (
		clk 	: in std_logic;
        DB		: inout std_logic_vector(7 downto 0);
        EppASTB 	: in std_logic;
        EppDSTB 	: in std_logic;
        EppWRITE 	: in std_logic;
        EppWAIT 	: out std_logic;
 		  Led	: out std_logic_vector(7 downto 0); 
		  sw	: in std_logic_vector(7 downto 0);
		  btn	: in std_logic_vector(3 downto 0);
		  an: out std_logic_vector(3 downto 0);
		  ssg : out std_logic_vector (6 downto 0);
		  speaker_audio : out std_logic
	);
end media_control_box;

architecture Behavioral of media_control_box is

	COMPONENT speaker
	PORT(
		clk : IN std_logic;
		speaker_en : IN std_logic_vector(1 downto 0);          
		speaker_out : OUT std_logic
		);
	END COMPONENT;
	
	COMPONENT button_mapping
	PORT(
		clk : IN std_logic;
		btn : IN std_logic_vector(3 downto 0);          
		button_en : OUT std_logic;
		button_mapping : OUT std_logic_vector(11 downto 0)
		);
	END COMPONENT;

	COMPONENT seven_seg_display
	PORT(
		input : IN std_logic_vector(11 downto 0);   
		clk		: IN std_logic;
		segment_output : OUT std_logic_vector(3 downto 0);
		anode_out : out std_logic_vector(3 downto 0)
		);
	END COMPONENT;
	
	COMPONENT single_sseg
	PORT(
		input : IN std_logic_vector(3 downto 0);          
		segments : OUT std_logic_vector(6 downto 0)
		);
	END COMPONENT;
	
	COMPONENT EPP_Communication_Module
	PORT(
		clk : IN std_logic;
		EppASTB : IN std_logic;
		EppDSTB : IN std_logic;
		EppWrite : IN std_logic;
		vol_en	: IN std_logic;
		data_to_send : IN std_logic_vector(11 downto 0);    
		DB : INOUT std_logic_vector(7 downto 0);      
		EppWait : OUT std_logic
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
	
	COMPONENT volume_control
	PORT(
		volume_data : IN std_logic_vector(9 downto 0);
		clk : IN std_logic;          
		vol_en_out : OUT std_logic;
		vol_out : OUT std_logic_vector(11 downto 0)
		);
	END COMPONENT;
	
	signal sig_btn_en				: std_logic;
	signal sig_ir_en				: std_logic;
	signal sig_sseg 				: std_logic_vector (3 downto 0);
	signal ir_mapped 				: std_logic_vector (11 downto 0);
	signal buttons_mapped 		: std_logic_vector (11 downto 0);	
	signal mux_out_epp_in 		: std_logic_vector (11 downto 0);
	signal vol_data_out			: std_logic_vector (11 downto 0);
	signal vol_en_out				: std_logic;
begin
	Inst_speaker: speaker PORT MAP(
		clk => clk,
		speaker_en(1) => sig_btn_en,
		speaker_en(0) => sig_ir_en,
		speaker_out => speaker_audio
	);
	
	Inst_button_mapping: button_mapping PORT MAP(
		clk => clk,
		btn => btn,
		button_en => sig_btn_en,
		button_mapping => buttons_mapped
	);
	
	Inst_single_sseg: single_sseg PORT MAP(
		input => sig_sseg,
		segments => ssg
		
	);
	
	Inst_seven_seg_display: seven_seg_display PORT MAP(
		input => "101110101001",
		clk => clk,
		segment_output => sig_sseg,
		anode_out => an
	);

	Inst_EPP_Communication_Module: EPP_Communication_Module PORT MAP(
		clk => clk,
		DB => DB,
		EppASTB => EppASTB,
		EppDSTB => EppDSTB,
		EppWrite => EppWrite,
		vol_en	=> vol_en_out,
		EppWait => EppWait,
		data_to_send => mux_out_epp_in
	);

	Inst_mux_2_to_1_12b: mux_2_to_1_12b PORT MAP(
		--data0 => ir_mapped,
		data1 => buttons_mapped,
		data0 => vol_data_out,
		mux_select => sig_btn_en,
		data_out => mux_out_epp_in
	);
	
	Inst_volume_control: volume_control PORT MAP(
		volume_data(9 downto 8) => "00",
		volume_data(7 downto 0) => sw,
		clk => clk,
		vol_en_out => vol_en_out,
		vol_out => vol_data_out
	);
	
	led <= "11111111";
end Behavioral;

