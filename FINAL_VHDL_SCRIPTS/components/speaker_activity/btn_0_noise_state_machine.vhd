----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:34:17 11/01/2020 
-- Design Name: 
-- Module Name:    btn_0_noise_state_machine - Behavioral 
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

entity btn_0_noise_state_machine is
    Port ( clk : in  STD_LOGIC;
           signal_en : in  STD_LOGIC;
			  sound_en_out : out STD_LOGIC;
           sound_out : out  STD_LOGIC);
end btn_0_noise_state_machine;

architecture Behavioral of btn_0_noise_state_machine is

COMPONENT music_note_C6_generator
	PORT(
		clk : IN std_logic;
		signal_en : IN std_logic;          
		gen_c6 : OUT std_logic
		);
	END COMPONENT;

COMPONENT music_note_E6_generator
	PORT(
		clk : IN std_logic;
		signal_en : IN std_logic;          
		gen_e6 : OUT std_logic
		);
	END COMPONENT;

COMPONENT music_note_G6_generator
	PORT(
		clk : IN std_logic;
		signal_en : IN std_logic;          
		gen_g6 : OUT std_logic
		);
	END COMPONENT;
	
type state is (S1, S2, S3, S4, S5, S6);
	signal y 	: state;
	
	signal c6_start				: std_logic;
	signal e6_start				: std_logic;
	signal g6_start				: std_logic;
	
	signal c6_finish			: std_logic := '0';
	signal e6_finish			: std_logic := '0';
	signal g6_finish			: std_logic := '0';

	signal sig_c6_gen			: std_logic := '0';
	signal sig_e6_gen			: std_logic := '0';
	signal sig_g6_gen			: std_logic := '0';
	
	signal sig_delay_start	: std_logic := '0';
	signal sig_delay_fin		: std_logic := '0';

begin

	fsm_transitions: process(clk)
	begin
		if (clk'event and clk = '1') then
			case y is
				when S1 =>
					sound_en_out <= '0';
					if signal_en = '1' then			--Waiting to receive an enable for the state machine
						y <= S2;
					else 
						y <= S1;
					end if;
				when S2 => 
					sound_en_out <= '1';
					if c6_finish = '1' then			--Finished Playing C6, Move on to Playing E6
						y <= S3;
					else 
						y <= S2;
					end if;
				when S3 =>
					if e6_finish = '1' then			--Finished Playing E6, Move on to Playing G6
						y <= S4;
					else 
						y <= S3;
					end if;
				when S4 =>
					if g6_finish = '1' then			--Finished Playing G6, We are done, check if signal is still enabled
						y <= S5;
					else 
						y <= S4;
					end if;
				when S5 =>								-- Add delay to avoid 2nd triggering when releasing
					sound_en_out <= '0';
					if signal_en = '1' then
						y <= S5;
					else 
						y <= S6;
					end if;		
				when S6 =>
					if sig_delay_fin = '1' then
						y <= S1;
					else
						y <= S6;
					end if;
			end case;
		end if;
	end process;

	fsm_outputs: process(y)
	begin
		c6_start <= '0'; e6_start <= '0'; g6_start <= '0'; sig_delay_start <= '0';
		
		case y is
			when S1 => 
			when S2 =>
				c6_start <= '1';
			when S3 =>
				e6_start <= '1';
			when S4 =>
				g6_start <= '1';
			when S5 =>
			when S6 =>
				sig_delay_start <= '1';
				
		end case;
	end process;
	
	c6_playing: process(clk)
		variable cnt : integer := 0;
		begin	
			if (clk'event and clk = '1') then
				c6_finish <= '0';
				if (c6_start = '1') then
					cnt := cnt + 1;
					if (cnt = 10000000) then
						cnt := 0;
						c6_finish <= '1';
					end if;
				end if;
			end if;
		end process;
	
	e6_playing: process(clk)
		variable cnt : integer := 0;
		begin	
			if (clk'event and clk = '1') then
			e6_finish <= '0';
				if (e6_start  = '1') then
					cnt := cnt + 1;				
					
					if (cnt = 10000000) then
						cnt := 0;
						e6_finish <= '1';
					end if;
				end if;
			end if;
	end process;
	
	g6_playing: process(clk)
		variable cnt : integer := 0;
		begin	
			if (clk'event and clk = '1') then
			g6_finish <= '0';
				if (g6_start  = '1') then
					cnt := cnt + 1;				
					
					if (cnt = 20000000) then
						cnt := 0;
						g6_finish <= '1';
					end if;
				end if;
			end if;
	end process;
	
	delay_counter: process(clk)
		variable cnt : integer := 0;
		begin	
			if (clk'event and clk = '1') then
			sig_delay_fin <= '0';
				if (sig_delay_start  = '1') then
					cnt := cnt + 1;				
					
					if (cnt = 1000000) then						-- Trial and error number, this works best
						cnt := 0;
						sig_delay_fin <= '1';
					end if;
				end if;
			end if;
	end process;
	
Inst_music_note_C6_generator: music_note_C6_generator PORT MAP(
	clk => clk,
	signal_en => c6_start,
	gen_c6 => sig_c6_gen
);

Inst_music_note_E6_generator: music_note_E6_generator PORT MAP(
	clk => clk,
	signal_en => e6_start,
	gen_e6 => sig_e6_gen
);

Inst_music_note_G6_generator: music_note_G6_generator PORT MAP(
	clk => clk,
	signal_en => g6_start,
	gen_g6 => sig_g6_gen
);

sound_out <= (sig_c6_gen and c6_start) or (sig_e6_gen and e6_start) or (sig_g6_gen and g6_start);end Behavioral;

