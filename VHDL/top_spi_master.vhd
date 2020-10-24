----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:40:56 10/14/2020 
-- Design Name: 
-- Module Name:    top_spi_master - Behavioral 
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

entity top_spi_master is
	port(   clk     : in    std_logic;
			ir		: in	std_logic;
			done    : out   std_logic;
			
			miso 	: in	std_logic;
			mosi	: out	std_logic;
			nCS		: out	std_logic;
			sclk	: out	std_logic;
			
			rx_data	: out	std_logic_vector(9 downto 0);

			led	: out std_logic_vector(7 downto 0);			
			swt	: in std_logic_vector(1 downto 0);
			btn	: in std_logic_vector(3 downto 0);
			an: out std_logic_vector(3 downto 0);
			ssg : out std_logic_vector (6 downto 0);
			s_out : out std_logic
			);
end top_spi_master;

architecture Behavioral of top_spi_master is

	COMPONENT spi_master is
		GENERIC( d  : INTEGER := 10);
		PORT (  clk    : IN    std_logic;
				reset_n : IN    std_logic;
				miso    : IN    std_logic;

				busy    : OUT   std_logic;
				mosi    : OUT   std_logic;
				sclk_out	: OUT	std_logic;
				nCS_out		: OUT	std_logic;
				state_out	: OUT	std_logic_vector(4 downto 0);
				rx_data : OUT   std_logic_vector(d-1 DOWNTO 0));	
	END COMPONENT;

	COMPONENT seven_seg_display
	PORT(
	 	input : IN std_logic_vector(15 downto 0);   
	 	clk		: IN std_logic;
		segment_output : OUT std_logic_vector(3 downto 0);
		anode_out : out std_logic_vector(3 downto 0)
		);
	END COMPONENT;
	
	COMPONENT single_sseg
	PORT(
		input : IN std_logic_vector(4 downto 0);          
		segments : OUT std_logic_vector(6 downto 0)
		);
	END COMPONENT;

	-- signal reset_n_sig : std_logic;
	signal state_out : std_logic_vector(4 downto 0);
	signal sig_rx_data	: std_logic_vector(9 downto 0);
	signal sseg_data	: std_logic_vector(15 downto 0);
	signal busy    : std_logic;
	signal sig_sclk	: std_logic;

	signal sig_sseg : std_logic_vector (3 downto 0);


begin

	Inst_seven_seg_display: seven_seg_display PORT MAP(
		input => sseg_data,
		clk => clk,
		segment_output => sig_sseg,
		anode_out => an
	);

	Inst_single_sseg: single_sseg PORT MAP(
			input(4) => '0',
			input(3 downto 0) => sig_sseg,
			segments => ssg
	);

--	led(6) <= '0';
--	led(5 downto 0) <= state_out;
	sseg_data( 15 downto 10) <= "000000";
	sseg_data( 9 downto 0) <= sig_rx_data;
	rx_data <= sig_rx_data;
	led(4 downto 0) <= state_out;
	led(5) <= sig_sclk;
	sclk <= sig_sclk;
	
	led(6) <= miso;
	led(7) <= '0';
	
	Inst_spi_master: spi_master
		port map(clk, swt(0), miso, busy, mosi, sig_sclk, nCS, state_out, sig_rx_data);

end Behavioral;

