----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:25:54 11/01/2020 
-- Design Name: 
-- Module Name:    btn_1_noise_state_machine - Behavioral 
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

entity btn_1_noise_state_machine is
    Port ( clk : in  STD_LOGIC;
           signal_en : in  STD_LOGIC;
			  sound_en_out	: out std_logic;
           sound_out : out  STD_LOGIC);
end btn_1_noise_state_machine;

architecture Behavioral of btn_1_noise_state_machine is

COMPONENT music_note_A_generator
	PORT(
		clk : IN std_logic;
		signal_en : IN std_logic;          
		gen_A : OUT std_logic
		);
	END COMPONENT;
	
COMPONENT music_note_B_generator
	PORT(
		clk : IN std_logic;
		signal_en : IN std_logic;          
		gen_B : OUT std_logic
		);
	END COMPONENT;

type state is (S1, S2, S3, S4, S5);
	signal y 	: state;
	
	signal a_start				: std_logic;
	signal b_start				: std_logic;
	
	signal a_finish			: std_logic := '0';
	signal b_finish			: std_logic := '0';

	signal sig_a_gen			: std_logic := '0';
	signal sig_b_gen			: std_logic := '0';
	
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
					if a_finish = '1' then			--Finished Playing A, Move on to Playing B
						y <= S3;
					else 
						y <= S2;
					end if;
				when S3 =>
					if b_finish = '1' then			--Finished Playing B, We are done, check if signal is still enabled
						y <= S4;
					else 
						y <= S3;
					end if;
				when S4 =>								-- Add delay to avoid 2nd triggering when releasing
					sound_en_out <= '0';
					if signal_en = '1' then
						y <= S4;
					else 
						y <= S5;
					end if;		
				when S5 =>
					if sig_delay_fin = '1' then
						y <= S1;
					else
						y <= S5;
					end if;
			end case;
		end if;
	end process;

	fsm_outputs: process(y)
	begin
		a_start <= '0'; b_start <= '0'; sig_delay_start <= '0';
		
		case y is
			when S1 => 
			when S2 =>
				a_start <= '1';
			when S3 =>
				b_start <= '1';
			when S4 =>
			when S5 =>
				sig_delay_start <= '1';
				
		end case;
	end process;
	
	a_playing: process(clk)
		variable cnt : integer := 0;
		begin	
			if (clk'event and clk = '1') then
				a_finish <= '0';
				if (a_start = '1') then
					cnt := cnt + 1;
					if (cnt = 15000000) then
						cnt := 0;
						a_finish <= '1';
					end if;
				end if;
			end if;
		end process;
	
	b_playing: process(clk)
		variable cnt : integer := 0;
		begin	
			if (clk'event and clk = '1') then
			b_finish <= '0';
				if (b_start  = '1') then
					cnt := cnt + 1;				
					
					if (cnt = 15000000) then
						cnt := 0;
						b_finish <= '1';
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
	
Inst_music_note_A_generator: music_note_A_generator PORT MAP(
	clk => clk,
	signal_en => a_start,
	gen_A => sig_a_gen
);

Inst_music_note_B_generator: music_note_B_generator PORT MAP(
	clk => clk,
	signal_en => b_start,
	gen_B => sig_b_gen
);



sound_out <= (sig_a_gen and a_start) or (sig_b_gen and b_start);

end Behavioral;

