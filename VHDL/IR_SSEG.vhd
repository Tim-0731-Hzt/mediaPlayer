----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:16:43 10/10/2020 
-- Design Name: 
-- Module Name:    IR_SSEG - Behavioral 
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

entity IR_SSEG is
	 port(   clk     : in    std_logic;
				ir		: in	std_logic;
				done    : out   std_logic;
				led	: out std_logic_vector(7 downto 0); 
			   sw	: in std_logic_vector(7 downto 0);
			   btn	: in std_logic_vector(3 downto 0);
			   an: out std_logic_vector(3 downto 0);
			   ssg : out std_logic_vector (6 downto 0);
			   s_out : out std_logic );
end IR_SSEG;

architecture Behavioral of IR_SSEG is

   COMPONENT IR_Decoder
   PORT(
        clk : IN  std_logic;
        reset : IN  std_logic;
        ir : IN  std_logic;
		  curstate : out std_logic_vector(6 downto 0);
        data : OUT  std_logic_vector(11 downto 0);
        done : OUT  std_logic
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

	signal data : std_logic_vector(11 downto 0);
	signal sig_sseg : std_logic_vector (3 downto 0);
	signal curstate : std_logic_vector (6 downto 0);
	signal reset : std_logic;

begin

	Inst_seven_seg_display: seven_seg_display PORT MAP(
			input => data,
			clk => clk,
			segment_output => sig_sseg,
			anode_out => an
		);
	
	Inst_single_sseg: single_sseg PORT MAP(
			input => sig_sseg,
			segments => ssg
		);
	
	uut: IR_Decoder PORT MAP (
		 clk => clk,
		 reset => reset,
		 ir => ir,
		 curstate => curstate,
		 data => data,
		 done => done
	  );
	  

	led(0) <= not(ir);
	led(7 downto 1) <= curstate;
	reset <= not(btn(0));

end Behavioral;

