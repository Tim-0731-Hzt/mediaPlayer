----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:26:21 11/01/2020 
-- Design Name: 
-- Module Name:    btn_2_noise_state_machine - Behavioral 
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

entity btn_2_noise_state_machine is
    Port ( clk : in  STD_LOGIC;
           signal_en : in  STD_LOGIC;
           sound_out : out  STD_LOGIC);
end btn_2_noise_state_machine;

architecture Behavioral of btn_2_noise_state_machine is
COMPONENT music_note_C5_generator
	PORT(
		clk : IN std_logic;
		signal_en : IN std_logic;          
		gen_c5 : OUT std_logic
		);
	END COMPONENT;

COMPONENT music_note_D5_generator
	PORT(
		clk : IN std_logic;
		signal_en : IN std_logic;          
		gen_d5 : OUT std_logic
		);
	END COMPONENT;

COMPONENT music_note_E5_generator
	PORT(
		clk : IN std_logic;
		signal_en : IN std_logic;          
		gen_e5 : OUT std_logic
		);
	END COMPONENT;

type state is (S1, S2, S3, S4, S5, S6);
	signal y 	: state;
	
	signal c5_start				: std_logic;
	signal d5_start				: std_logic;
	signal e5_start				: std_logic;
	
	signal c5_finish			: std_logic := '0';
	signal d5_finish			: std_logic := '0';
	signal e5_finish			: std_logic := '0';

	signal sig_c5_gen			: std_logic := '0';
	signal sig_d5_gen			: std_logic := '0';
	signal sig_e5_gen			: std_logic := '0';
	
	signal sig_delay_start	: std_logic := '0';
	signal sig_delay_fin		: std_logic := '0';

begin

	fsm_transitions: process(clk)
	begin
		if (clk'event and clk = '1') then
			case y is
				when S1 =>
					if signal_en = '1' then			--Waiting to receive an enable for the state machine
						y <= S2;
					else 
						y <= S1;
					end if;
				when S2 => 
					if e5_finish = '1' then			--Finished Playing A, Move on to Playing B
						y <= S3;
					else 
						y <= S2;
					end if;
				when S3 =>
					if d5_finish = '1' then			--Finished Playing B, We are done, go back to S1
						y <= S4;
					else 
						y <= S3;
					end if;
				when S4 =>
					if c5_finish = '1' then
						y <= S5;
					else 
						y <= S4;
					end if;
				when S5 =>								-- Add delay to avoid 2nd triggering when releasing
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
		c5_start <= '0'; d5_start <= '0'; e5_start <= '0'; sig_delay_start <= '0';
		
		case y is
			when S1 => 
			when S2 =>
				e5_start <= '1';
			when S3 =>
				d5_start <= '1';
			when S4 =>
				c5_start <= '1';
			when S5 =>
			when S6 =>
				sig_delay_start <= '1';
				
		end case;
	end process;
	
	c5_playing: process(clk)
		variable cnt : integer := 0;
		begin	
			if (clk'event and clk = '1') then
				c5_finish <= '0';
				if (c5_start = '1') then
					cnt := cnt + 1;
					if (cnt = 10000000) then
						cnt := 0;
						c5_finish <= '1';
					end if;
				end if;
			end if;
		end process;
	
	d5_playing: process(clk)
		variable cnt : integer := 0;
		begin	
			if (clk'event and clk = '1') then
			d5_finish <= '0';
				if (d5_start  = '1') then
					cnt := cnt + 1;				
					
					if (cnt = 10000000) then
						cnt := 0;
						d5_finish <= '1';
					end if;
				end if;
			end if;
	end process;
	
	e5_playing: process(clk)
		variable cnt : integer := 0;
		begin	
			if (clk'event and clk = '1') then
			e5_finish <= '0';
				if (e5_start  = '1') then
					cnt := cnt + 1;				
					
					if (cnt = 10000000) then
						cnt := 0;
						e5_finish <= '1';
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
					
					if (cnt = 700000) then						-- Trial and error number, this works best
						cnt := 0;
						sig_delay_fin <= '1';
					end if;
				end if;
			end if;
	end process;
	
Inst_music_note_C5_generator: music_note_C5_generator PORT MAP(
	clk => clk,
	signal_en => c5_start,
	gen_c5 => sig_c5_gen
);

Inst_music_note_D5_generator: music_note_D5_generator PORT MAP(
	clk => clk,
	signal_en => d5_start,
	gen_d5 => sig_d5_gen
);

Inst_music_note_E5_generator: music_note_E5_generator PORT MAP(
	clk => clk,
	signal_en => e5_start,
	gen_e5 => sig_e5_gen
);

sound_out <= (sig_c5_gen and c5_start) or (sig_d5_gen and d5_start) or (sig_e5_gen and e5_start);

end Behavioral;

