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
		  btn	: in std_logic_vector(3 downto 0)
	);
end media_control_box;

architecture Behavioral of media_control_box is

	COMPONENT speaker
	PORT(
		clk : IN std_logic;
		speaker_en : IN std_logic;          
		speaker_out : OUT std_logic
		);
	END COMPONENT;
	
	COMPONENT button_mapping
	PORT(
		clk : IN std_logic;
		btn : IN std_logic_vector(3 downto 0);          
		button_en : OUT std_logic;
		button_mapping : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;


begin
	Inst_speaker: speaker PORT MAP(
		clk => clk,
		speaker_en => '0',
		speaker_out => open
	);
	
	Inst_button_mapping: button_mapping PORT MAP(
		clk => clk,
		btn => btn,
		button_en => open,
		button_mapping => led(7 downto 0)
	);
	
	
	--LED(7 downto 1) <= "0000000";
	EppWAIT <= '0';

	
	
end Behavioral;

