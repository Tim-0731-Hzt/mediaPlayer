----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:22:22 09/28/2020 
-- Design Name: 
-- Module Name:    IR_Decoder - Behavioral 
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

entity IR_Decoder is
    port(   clk     : IN    STD_LOGIC;
            reset   : IN    STD_LOGIC;
			ir		: IN	STD_LOGIC;
            data    : OUT   STD_LOGIC_VECTOR(11 DOWNTO 0);
            done    : OUT   STD_LOGIC);
end IR_Decoder;

architecture Behavioral of IR_Decoder is
	
	component count_timer
		port(   clk     : in std_logic;
				reset   : in std_logic;
				usec    : inout integer;
				msec    : inout integer);
	end component;
	
    type state is (S1, S2, S3, S4, S5);
    signal y    : state;

    -- Datapath signals
    signal LA, EA, w    : STD_LOGIC; -- Load, enable and write for L-Shift Register A
    signal ET, RT       : STD_LOGIC; -- Enable and reset for timer
    
	-- Timer signals
	signal usec_out		: integer;
	signal msec_out		: integer;
	
begin
    fsm_transitions: process(reset, clk, ir)
    begin
        if reset = '0' then
            y <= S1;
        elsif (clk'event and clk = '1') then
            case y is 
                -- State 1
                -- Ready/wait state for ir signal
                when S1 =>
                    if ir = '0' then 
                        y <= S2;
                    else
                        y <= S1;
                    end if;

                -- State 2
                -- Count to 2.4ms to start decoding
                when S2 =>
                -- Check the timer
					-- if timer < 2.6ms
                    if msec_out < 2 then
                        if ir = '1' then    -- If a 1 is read then start again
                            y <= S1;
                        else                -- continue in state 2 to count the 0 signal time
                            y <= S2;
                        end if; 
                    else                    -- the ir signal has been 0 for 2.6ms, begin reading a command
                        y <= S3;
                    end if;
                
                -- State 3
                -- Ready to receive a bit
                when S3 =>
                    if ir = '1' then
                        y <= S3;
                    elsif ir = '0' then
                        y <= S4;            -- switch to state 4 to start timing the 0 signal
                    end if;

                -- State 4 
                -- time the 0 ir signal
                when S4 =>
                    if ir = '1' then        -- switch to state 5 to stop timer and
                        y <= S3;            -- load the bit into the shift register
                    elsif ir = '0' then
                        y <= S4;
                    end if;
                    
                -- Load the received bit into the shift register
                -- then switch back to state 3 and wait for another ir 0 signal
                when S5 =>
                    y <= S3;
                -- Add ending state
            end case;
        end if;
    end process;

    fsm_outputs: process(y)
    begin
        LA <= '0'; EA <= '0'; ET <= '0'; RT <= '0';
        
        case y is
            -- State 1
            -- Reset state
            when S1 =>
                LA <= '1';      -- load 0 into left shift register
                RT <= '1';      -- reset timer
            -- State 2
            -- Time 2.6ms to initialise reading command
            when S2 =>
                RT <= '0';       -- Stop reset timer
                ET <= '1';       -- Enable timer
            -- State 3
            -- Ready to receive bit
            when S3 =>
                LA <= '0';       -- Stop loading 0 into left shift register
                ET <= '0';       -- Stop timer
                RT <= '1';       -- reset timer
            when S4 =>
                RT <= '0';
                ET <= '1';       -- Start timer
            when S5 =>
                ET <= '0';       -- Stop timer but don't reset it
                EA <= '1';       -- Enable left shift register to load the received bit
        end case;
    end process;

end Behavioral;

