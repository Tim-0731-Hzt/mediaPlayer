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
use IEEE.NUMERIC_STD.ALL;


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
				curstate : out std_logic_vector(6 downto 0);
            data    : OUT   STD_LOGIC_VECTOR(11 DOWNTO 0);
            done    : OUT   STD_LOGIC);
end IR_Decoder;

architecture Behavioral of IR_Decoder is
	
	component Timer
        port(   clk     : in std_logic;
                en      : in std_logic;
                reset   : in std_logic;
				usec    : inout integer;
				msec    : inout integer);
	end component;
	
	component lshift12 is
		PORT (w, Clock, resetn		: IN	STD_LOGIC;
				En 			: IN	STD_LOGIC;
				Q			: OUT	STD_LOGIC_VECTOR(1 TO 12));
	end component;
	
    type state is (S1, S2, S3, S4, S5, S6, S7);
    signal y    : state;

    -- Datapath signals
    signal LA, EA, w, resetn    : STD_LOGIC; -- Load, enable, write and reset for L-Shift Register A
    signal ET, RT       : STD_LOGIC; -- Enable and reset for timer
	 signal nBits : integer := 0;
    
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
					-- if timer < 2.4ms
						if ir = '1' then
                    if msec_out = 2 and (usec_out < 450 and usec_out > 350) then
								y <= S3;
                    else                    -- the ir signal has been 0 for 2.6ms, begin reading a command
								y <= S1;
                    end if;
					   else
							y <= S2;
						end if;
                
                -- State 3
                -- Ready to receive a bit
                when S3 =>
--							y <= S4;
						if nBits = 11 then
							y <= S7;
						else
							if ir = '1' then
								y <= S3;
							else
								y <= S4;
							end if;
						end if;

                -- State 4 
                -- time the 0 ir signal
                when S4 =>
					  if ir = '1' then                    -- switch to state 5/6 to stop timer
--							if usec_out = 600 then
							if usec_out < 650 and usec_out > 550 then
								y <= S5;                    -- if 0 for 0.6ms then go to state 5
							elsif msec_out = 1 and usec_out > 150 and usec_out < 250 then
--							elsif msec_out = 1 and usec_out = 200 then
								y <= S6;                    -- if 0 for 1.2ms then go to state 6
							else 
								y <= S1;
							end if;
					  elsif ir = '0' then                 -- otherwise remain in state 4 to keep timing
							y <= S4;
					  end if;
                    
				-- Load the bit 0 into the shift register
				when S5 =>
					y <= S3;
					
				-- Load the bit 1 into the shift register
				when S6 =>
					y <= S3;
					
				when S7 =>
					if msec_out = 45 then
						y <= S1;
					else
						y <= S7;
					end if;
					
                -- Add ending state
            end case;
        end if;
    end process;

    fsm_outputs: process(y)
    begin
        LA <= '0'; EA <= '0'; ET <= '0'; RT <= '0'; resetn <= '1'; curstate <= (others => '0');
        
        case y is
            -- State 1
            -- Reset state
            when S1 =>
                LA <= '1';      -- load 0 into left shift register
                RT <= '1';      -- reset timer
					 curstate(0) <= '1';
            -- State 2
            -- Time 2.6ms to initialise reading command
            when S2 =>
                RT <= '0';       -- Stop reset timer
                ET <= '1';       -- Enable timer
					 resetn <= '0';
					 nBits <= 0;
					 curstate(1) <= '1';
            -- State 3
            -- Ready to receive bit
            when S3 =>
                LA <= '0';       -- Stop loading 0 into left shift register
                ET <= '0';       -- Stop timer
                RT <= '1';       -- reset timer
					 curstate(2) <= '1';
            when S4 =>
                ET <= '1';       -- Start timer
					 curstate(3) <= '1';
            when S5 =>
					 w <= '0';
                ET <= '0';       -- Stop timer but don't reset it
                EA <= '1';       -- Enable left shift register to load the received bit
					 curstate(4) <= '1';
					 nBits <= nBits + 1;
				when S6 =>
					 w <= '1';
					 ET <= '0';       -- Stop timer but don't reset it
					 EA <= '1';       -- Enable left shift register to load the received bit
					 curstate(5) <= '1';
					 nBits <= nBits + 1;
				 when S7 =>
					 ET <= '1';
					 curstate(6) <= '1';
        end case;
    end process;

    Counter: Timer
            port map (clk, ET, RT, usec_out, msec_out);
				
	 ShiftReg: lshift12
				port map ( w, clk, resetn, EA, data );

end Behavioral;

