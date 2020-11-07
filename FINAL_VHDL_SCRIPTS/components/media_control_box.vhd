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

-- Top Module for Project
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
		speaker_audio : out std_logic;
		--IR inputs/outputs
		ir		: in std_logic;
		-- SPI inputs/outputs
		miso    	: IN    std_logic;
		mosi    	: OUT   std_logic;
		sclk		: OUT	std_logic;
		nCS			: OUT	std_logic
	);
end media_control_box;

architecture Behavioral of media_control_box is

	COMPONENT speaker														--Original speaker module
	PORT(																		--Makes beep noise for duration of speaker_en at 500Hz
		clk : IN std_logic;												--Will be used to indicate that the remote control signal has been decoded
		speaker_en : IN std_logic;   									--NOTE: Different for startup sound and unique button noises       
		speaker_out : OUT std_logic
		);
	END COMPONENT;
	
	COMPONENT button_mapping											--Button mapping to indicate what signal needs to be
	PORT(																		--Sent for each button
		clk : IN std_logic;												--OUTPUT: 4 bit addr (11 downto 8) and 8 bit data (7 downto 0)
		btn : IN std_logic_vector(3 downto 0);          	
		button_en : OUT std_logic;
		button_mapping : OUT std_logic_vector(11 downto 0)
		);
	END COMPONENT;

	COMPONENT seven_seg_display										--Controller for the seven-segment display
	PORT(																		--Use this if you need to display something on the board
		input : IN std_logic_vector(15 downto 0);   				--OUTPUT: which segment to display and which anode should be connected
		clk		: IN std_logic;
		segment_output : OUT std_logic_vector(3 downto 0);
		anode_out : out std_logic_vector(3 downto 0)
		);
	END COMPONENT;
	
	COMPONENT single_sseg												--Display component for seven-segment display
	PORT(																		--No need to touch this for anything else, it's already connected
		input : IN std_logic_vector(4 downto 0);          
		segments : OUT std_logic_vector(6 downto 0)
		);
	END COMPONENT;
	
	COMPONENT EPP_Communication_Module								--The brains of the operation. Used for communication to PC
	PORT(																		--Only thing that needs to be altered in data_to_send
		clk : IN std_logic;												--This will contain the address at top 4 bits and data in bottom 8 bits
		EppASTB : IN std_logic;											--No need to change anything else
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
	
	COMPONENT volume_control is
    PORT ( clk : in  STD_LOGIC;
           pot_data : in  STD_LOGIC_VECTOR (9 downto 0);
           ir_data : in  STD_LOGIC_VECTOR (7 downto 0);
           ir_en : in  STD_LOGIC;
           vol_data_out : out  STD_LOGIC_VECTOR (11 downto 0));
			  
	END COMPONENT;
	
	COMPONENT button_msg														--Stored values for what should be displayed when a button is pressed
	PORT(																			--The address is basically the 9th and 8th bit from button mapping
		button_addr : IN std_logic_vector(1 downto 0);           --Used to display "PLAY", "STOP", "FFD" AND "BACK"
		button_msg : OUT std_logic_vector(15 downto 0)
		);
	END COMPONENT;
	
	COMPONENT mux_2_to_1_16b
	PORT(
		data0 : IN std_logic_vector(15 downto 0);
		data1 : IN std_logic_vector(15 downto 0);
		mux_select : IN std_logic;          
		data_out : OUT std_logic_vector(15 downto 0)
		);
	END COMPONENT;
	
	COMPONENT startup_state_machine										--Start up music when the board is first turned on
	PORT(																			--Only needs to clk, everything else is taken care of
		clk : IN std_logic;      
		startup_noise_en : out STD_LOGIC;		
		speaker_out : OUT std_logic
		);
	END COMPONENT;

	COMPONENT spi_master														--Module used for the SPI with the ADC
	PORT(																			--Gets the value based on the rotational angle of
		clk 		: IN std_logic;													--the potentiometer. Returns value between 0 and 1023
		reset_n 	: IN std_logic;
		miso 		: IN std_logic;          
		busy 		: OUT std_logic;
		mosi 		: OUT std_logic;
		sclk_out 	: OUT std_logic;
		nCS_out 	: OUT std_logic;
		state_out 	: OUT std_logic_vector(4 downto 0);
		rx_data 	: OUT std_logic_vector(9 downto 0)
		);
	END COMPONENT;
	
	COMPONENT mux_2_to_1_1b
	PORT(
		data0 : IN std_logic;
		data1 : IN std_logic;
		mux_select : IN std_logic;          
		data_out : OUT std_logic
		);
	END COMPONENT;
	
	COMPONENT unique_btn_sound_controller
	PORT(
		clk : IN std_logic;
		btn_addr : IN std_logic_vector(1 downto 0);
		btn_en : IN std_logic;   
		sound_en_out : OUT std_logic;
		sound_out : OUT std_logic
		);
	END COMPONENT;

	COMPONENT IR_decoder
	PORT(
		clk     	: in    STD_LOGIC;
		reset   	: in    STD_LOGIC;
		ir			: in	STD_LOGIC;
		data    	: inout   STD_LOGIC_VECTOR(11 DOWNTO 0);
		busy		: out	STD_LOGIC;
		done    	: out   STD_LOGIC;
		curstate	: out	STD_LOGIC_VECTOR(6 DOWNTO 0)
		);
	END COMPONENT;
	
	COMPONENT ir_mapping_module
	PORT(
		clk		 : IN std_logic;
		ir_signal : IN std_logic_vector(11 downto 0);
		ir_en : IN std_logic;          
		ir_mapped_en : OUT std_logic;
		ir_mapped_out : OUT std_logic_vector(11 downto 0)
		);
	END COMPONENT;
	
	COMPONENT swtiching_btn_function_module
	PORT(
		clk : IN std_logic;
		btn : IN std_logic_vector(3 downto 0);
		sw : IN std_logic_vector(3 downto 0);          
		btn_out : OUT std_logic_vector(3 downto 0)
		);
	END COMPONENT;
	
	signal sig_btn_en				: std_logic; 
	signal sig_ir_en				: std_logic;
	signal sig_sseg 				: std_logic_vector (3 downto 0);
	signal ir_mapped 				: std_logic_vector (11 downto 0);
	signal ir_mapped_test		: std_logic_vector (7 downto 0);
	signal ir_decoded				: std_logic_vector (11 downto 0);
	signal buttons_mapped 		: std_logic_vector (11 downto 0);	
	signal mux_out_epp_in 		: std_logic_vector (11 downto 0);
	signal vol_data_out			: std_logic_vector (11 downto 0);
	signal vol_en_out				: std_logic;
	signal buttons_msg_sig		: std_logic_vector (15 downto 0);
	signal mux_out_segments_in	: std_logic_vector (15 downto 0);
	signal sw_btn_out				: std_logic_vector (3 downto 0);
	
	signal sig_ir_beep			: std_logic;
	signal sig_startup_noise	: std_logic;
	signal sig_startup_en		: std_logic;
	signal sig_btn_noise			: std_logic;
	signal sig_btn_noise_en		: std_logic;
	signal sig_ir_btn_noise		: std_logic;
	signal sig_noise_toggle		: std_logic;
	signal ir_mapped_en			: std_logic;
	-- Internal IR Signals
	signal sig_ir_done			: std_logic;
	signal sig_ir_busy			: std_logic;
	signal sig_ir_state			: std_logic_vector(6 downto 0);

	-- Internal SPI Signals
	signal sig_pot_data			: std_logic_vector(9 downto 0);
	signal sig_spi_state		: std_logic_vector(4 downto 0);
	signal sig_spi_busy			: std_logic;

	
	signal debug					: std_logic_vector(7 downto 0);
	signal sig_test				: std_logic_vector(11 downto 0);
begin
	
	-- REASON FOR HAVING 2 2-1 MUX's instead of 3-1:
	-- IR BEEP WAS INTERRUPTING STARTUP NOISE FOR SOME REASON
	-- HAVING IR BEEP AS ONE OF THE MUX SELECT WOULD ONLY PLAY BEEP FOR DURATION
	-- OF HOLDING DOWN THE BUTTON RATHER THAN THE 0.5s DELAY 

	Inst_Single_Noises_mux_2_to_1_1b: mux_2_to_1_1b PORT MAP(
			data0 => sig_ir_beep,
			data1 => sig_btn_noise,
			mux_select => sig_btn_noise_en,
			data_out => sig_ir_btn_noise
		);

	Inst_Single_Noise_Startup_mux_2_to_1_1b: mux_2_to_1_1b PORT MAP(
		data0 => sig_ir_btn_noise,
		data1 => sig_startup_noise,
		mux_select => sig_startup_en,
		data_out => sig_noise_toggle
	);
	
	Inst_speaker: speaker PORT MAP(	
		clk => clk,
		speaker_en => sig_ir_done,
		speaker_out => sig_ir_beep
	);
	
	Inst_startup_state_machine: startup_state_machine PORT MAP(
		clk => clk,
		startup_noise_en => sig_startup_en,
		speaker_out => sig_startup_noise
	);
	
	Inst_unique_btn_sound_controller: unique_btn_sound_controller PORT MAP(
		clk => clk,
		btn_addr => buttons_mapped(9 downto 8),
		btn_en => sig_btn_en,
		sound_en_out => sig_btn_noise_en,
		sound_out => sig_btn_noise
	);

	Inst_button_mapping: button_mapping PORT MAP(
		clk => clk,
		btn => sw_btn_out,
		button_en => sig_btn_en,
		button_mapping => buttons_mapped
	);
	
	Inst_single_sseg: single_sseg PORT MAP(
		input(4) => sig_btn_en,
		input(3 downto 0) => sig_sseg(3 downto 0),
		segments => ssg
		
	);
	
	Inst_seven_seg_display: seven_seg_display PORT MAP(
		input => mux_out_segments_in,
		clk => clk,
		segment_output => sig_sseg,
		anode_out => an
	);
	
		Inst_button_msg: button_msg PORT MAP(
		button_addr => buttons_mapped(9 downto 8),
		button_msg => buttons_msg_sig
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
		data0 => ir_mapped,
		data1 => buttons_mapped,
--		data0 => vol_data_out,
		mux_select => sig_btn_en,
		data_out => mux_out_epp_in
	);
	
-- Add another mux for vol_data to intersect with mux above
	
	 Inst_volume_control: volume_control PORT MAP(
	 	clk => clk,
	 	pot_data => sig_pot_data,
	 	ir_data => ir_mapped_test,
	 	ir_en => btn(3),
	 	vol_data_out => vol_data_out
	 );

	Inst_mux_2_to_1_16b: mux_2_to_1_16b PORT MAP(
		data0(15 downto 12) => "0000",
		data0(11 downto 0)  => ir_mapped,
		data1 => buttons_msg_sig,
		mux_select => sig_btn_en,
		data_out => mux_out_segments_in
	);
	
	Inst_spi_master: spi_master PORT MAP(				--THE OUTPUT OF THIS IS VOLUME_CONTROL POT_DATA
		clk 		=> clk,
		reset_n 	=> not(sig_ir_busy),
		miso 		=> miso,
		busy 		=> sig_spi_busy,
		mosi 		=> mosi,
		sclk_out 	=> sclk,
		nCS_out 	=> nCS,
		state_out 	=> sig_spi_state,
		rx_data 	=> sig_pot_data
	);
	
	Inst_Noise_Off_Mux_2_to_1_1b: mux_2_to_1_1b PORT MAP(
			data0 => sig_noise_toggle,
			data1 => '0',
			mux_select => sw(7),
			data_out => speaker_audio
		);

	Inst_IR_decoder: ir_decoder PORT MAP(
		clk		=>	clk,
		reset	=>	sw(0),
		ir		=>	ir,
		data	=>	ir_decoded,
		busy	=>	sig_ir_busy,
		done	=>	sig_ir_done,
		curstate => sig_ir_state
	);
	
	Inst_ir_mapping_module: ir_mapping_module PORT MAP(
		clk => clk,
		ir_signal => ir_decoded,
		ir_en => sig_ir_done,
		ir_mapped_en => ir_mapped_en,
		ir_mapped_out => ir_mapped
	);

	Inst_swtiching_btn_function_module: swtiching_btn_function_module PORT MAP(
		clk => clk,
		btn => btn,
		sw => sw(3 downto 0),
		btn_out => sw_btn_out
	);
	led <= sig_pot_data(7 downto 0);

	
end Behavioral;

