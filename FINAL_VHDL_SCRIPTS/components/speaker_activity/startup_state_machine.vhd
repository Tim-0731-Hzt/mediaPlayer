----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:13:17 10/19/2020 
-- Design Name: 
-- Module Name:    startup_state_machine - Behavioral 
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

entity startup_state_machine is
    Port ( clk : in  STD_LOGIC;
			  startup_noise_en : out STD_LOGIC;
           speaker_out : out  STD_LOGIC);
end startup_state_machine;

architecture Behavioral of startup_state_machine is

COMPONENT music_note_middle_C_generator
	PORT(
		clk : IN std_logic;
		signal_en : IN std_logic;          
		gen_middle_C : OUT std_logic
		);
	END COMPONENT;
	
COMPONENT music_note_E_generator
	PORT(
		clk : IN std_logic;
		signal_en : IN std_logic;          
		gen_E : OUT std_logic
		);
	END COMPONENT;
	
COMPONENT music_note_G_generator
	PORT(
		clk : IN std_logic;
		signal_en : IN std_logic;          
		gen_g : OUT std_logic
		);
	END COMPONENT;

	type state is (S1, S2, S3, S4 ,S5, S6);
	signal y 	: state;
	
	signal start				: std_logic := '1';
	signal sig_start_en		: std_logic := '1';
	signal e_start				: std_logic;
	signal g_start				: std_logic;
	signal e_start_again		: std_logic;
	signal c_start_again		: std_logic;
	
	signal c_finish			: std_logic := '0';
	signal e_finish			: std_logic := '0';
	signal g_finish			: std_logic := '0';
	signal e_finish_again	: std_logic := '0';
	signal c_finish_again	: std_logic := '0';
	
	signal c_enable			: std_logic := '0';
	signal e_enable			: std_logic := '0';
	signal g_enable			: std_logic := '0';
	
	signal sig_c_gen			: std_logic := '0';
	signal sig_e_gen			: std_logic := '0';
	signal sig_g_gen			: std_logic := '0';
begin


	fsm_transitions: process(clk)
	begin
		if (clk'event and clk = '1') then
			case y is
				when S1 =>
					if c_finish = '1' then			--Finished Playing C, Move onto playing D
						y <= S2;
					else 
						y <= S1;
					end if;
				when S2 => 
					if e_finish = '1' then			--Finished Playing D, Move onto playing E
						y <= S3;
					else 
						y <= S2;
					end if;
				when S3 =>
					if g_finish = '1' then			--Finished Playing E, Move onto playing D again
						y <= S4;
					else 
						y <= S3;
					end if;
				when S4 =>
					if e_finish_again = '1' then	--Finished Playing D, Move onto playing C again
						y <= S5;
					else
						y <= S4;
					end if;
				when S5 => 								--Finished Playing C, Tune has finished, do nothing else
					if c_finish_again = '1' then
						y <= S6;
					else
						y <= S5;
					end if;
				when S6 =>
					sig_start_en <= '0';	
			end case;
		end if;
	end process;

	fsm_outputs: process(y)
	begin
		start <= '0'; e_start <= '0'; g_start <= '0'; e_start_again <= '0'; c_start_again <= '0';
		
		case y is
			when S1 =>
				start <= '1';
			when S2 =>
				e_start <= '1';
			when S3 =>
				g_start <= '1';
			when S4 =>
				e_start_again <= '1';
			when S5 => 
				c_start_again <= '1';
			when S6 =>
		end case;
	end process;
	
	c_playing: process(clk)
		variable cnt : integer := 0;
		begin	
			if (clk'event and clk = '1') then
				if (start = '1') then
					cnt := cnt + 1;
					if (cnt = 25000000) then
						cnt := 0;
						c_finish <= '1';
					end if;
				end if;
			end if;
		end process;
	
	e_playing: process(clk)
		variable cnt : integer := 0;
		begin	
			if (clk'event and clk = '1') then
				if (e_start  = '1') then
					cnt := cnt + 1;				
					
					if (cnt = 25000000) then
						cnt := 0;
						e_finish <= '1';
					end if;
				end if;
			end if;
	end process;
	
	g_playing: process(clk)
		variable cnt : integer := 0;
		begin	
			if (clk'event and clk = '1') then
				if (g_start = '1') then
					cnt := cnt + 1;				
					if (cnt = 25000000) then
						g_finish <= '1';
					end if;
				end if;
			end if;
	end process;
	
	e_playing_again: process(clk)
		variable cnt : integer := 0;
		begin	
			if (clk'event and clk = '1') then
				if (e_start_again  = '1') then
					cnt := cnt + 1;				
					
					if (cnt = 25000000) then
						cnt := 0;
						e_finish_again <= '1';
					end if;
				end if;
			end if;
	end process;

	c_playing_again: process(clk)
		variable cnt : integer := 0;
		begin	
			if (clk'event and clk = '1') then
				if (c_start_again = '1') then
					cnt := cnt + 1;
					if (cnt = 100000000) then
						cnt := 0;
						c_finish_again <= '1';
					end if;
				end if;
			end if;
		end process;

Inst_music_note_middle_C_generator: music_note_middle_C_generator PORT MAP(
		clk => clk ,
		signal_en => c_enable,
		gen_middle_C => sig_c_gen
	);
	
	Inst_music_note_E_generator: music_note_E_generator PORT MAP(
		clk => clk,
		signal_en => e_enable,
		gen_E => sig_e_gen
	);
	
Inst_music_note_G_generator: music_note_G_generator PORT MAP(
		clk => clk,
		signal_en => g_enable,
		gen_G => sig_g_gen
	);
	



speaker_out <= (sig_c_gen and c_enable) or (sig_e_gen and e_enable) or (sig_g_gen and g_enable);
c_enable <= start or c_start_again;
e_enable <= e_start or e_start_again;
g_enable <= g_start;

startup_noise_en <= sig_start_en;
end Behavioral;

