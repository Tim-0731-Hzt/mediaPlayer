----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:48:53 11/01/2020 
-- Design Name: 
-- Module Name:    btn_3_noise_state_machine - Behavioral 
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

entity btn_3_noise_state_machine is
    Port ( clk : in  STD_LOGIC;
           signal_en : in  STD_LOGIC;
           sound_out : out  STD_LOGIC);
end btn_3_noise_state_machine;

architecture Behavioral of btn_3_noise_state_machine is

COMPONENT music_note_middle_C_generator
	PORT(
		clk : IN std_logic;
		signal_en : IN std_logic;          
		gen_middle_C : OUT std_logic
		);
	END COMPONENT;

COMPONENT music_note_D_generator
	PORT(
		clk : IN std_logic;
		signal_en : IN std_logic;          
		gen_D : OUT std_logic
		);
	END COMPONENT;
	
COMPONENT music_note_E_generator
	PORT(
		clk : IN std_logic;
		signal_en : IN std_logic;          
		gen_E : OUT std_logic
		);
	END COMPONENT;

type state is (S1, S2, S3, S4, S5, S6);
	signal y 	: state;
	
	signal c_start				: std_logic;
	signal d_start				: std_logic;
	signal e_start				: std_logic;
	
	signal c_finish			: std_logic := '0';
	signal d_finish			: std_logic := '0';
	signal e_finish			: std_logic := '0';

	signal sig_c_gen			: std_logic := '0';
	signal sig_d_gen			: std_logic := '0';
	signal sig_e_gen			: std_logic := '0';
	
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
					if c_finish = '1' then			--Finished Playing C, Move on to Playing E
						y <= S3;
					else 
						y <= S2;
					end if;
				when S3 =>
					if e_finish = '1' then			--Finished Playing E, Move on to Playing D
						y <= S4;
					else 
						y <= S3;
					end if;
				when S4 =>
					if d_finish = '1' then			--Finished Playing D, We are done, check if signal is still enabled
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
		c_start <= '0'; d_start <= '0'; e_start <= '0'; sig_delay_start <= '0';
		
		case y is
			when S1 => 
			when S2 =>
				c_start <= '1';
			when S3 =>
				e_start <= '1';
			when S4 =>
				d_start <= '1';
			when S5 =>
			when S6 =>
				sig_delay_start <= '1';
				
		end case;
	end process;
	
	c_playing: process(clk)
		variable cnt : integer := 0;
		begin	
			if (clk'event and clk = '1') then
				c_finish <= '0';
				if (c_start = '1') then
					cnt := cnt + 1;
					if (cnt = 10000000) then
						cnt := 0;
						c_finish <= '1';
					end if;
				end if;
			end if;
		end process;
	
	d_playing: process(clk)
		variable cnt : integer := 0;
		begin	
			if (clk'event and clk = '1') then
			d_finish <= '0';
				if (d_start  = '1') then
					cnt := cnt + 1;				
					
					if (cnt = 20000000) then
						cnt := 0;
						d_finish <= '1';
					end if;
				end if;
			end if;
	end process;
	
	e_playing: process(clk)
		variable cnt : integer := 0;
		begin	
			if (clk'event and clk = '1') then
			e_finish <= '0';
				if (e_start  = '1') then
					cnt := cnt + 1;				
					
					if (cnt = 15000000) then
						cnt := 0;
						e_finish <= '1';
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
	
Inst_music_note_middle_C_generator: music_note_middle_C_generator PORT MAP(
		clk => clk ,
		signal_en => c_start,
		gen_middle_C => sig_c_gen
	);

Inst_music_note_D_generator: music_note_D_generator PORT MAP(
	clk => clk,
	signal_en => d_start,
	gen_d => sig_d_gen
);

Inst_music_note_E_generator: music_note_E_generator PORT MAP(
	clk => clk,
	signal_en => e_start,
	gen_e => sig_e_gen
);

sound_out <= (sig_c_gen and c_start) or (sig_d_gen and d_start) or (sig_e_gen and e_start);



end Behavioral;

