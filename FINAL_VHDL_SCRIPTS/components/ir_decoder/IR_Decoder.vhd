----------------------------------------------------------------------------------
-- Create Date:    13:22:22 09/28/2020 
-- Design Name: 
-- Module Name:		IR_Decoder - Behavioral 
-- Project Name:	Media Controller Box
-- Course:			COMP3601
-- Team:			Violet
-- Description:		State Machine to control the decoding of Sony IR signals

-- Inputs:			clk - must be 100MHz from FPGA
--					reset - active high, fsm resets when reset is set to 0
-- 					ir - data signal line from the ir receiver

-- Outputs:			data - 16 bit register with bits 12 downto 0 containing decoded ir command
--					done - done signal to indicate when the output data is updated
-------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity IR_Decoder is
    port(   clk     	: in    STD_LOGIC;
            reset   	: in    STD_LOGIC;
			ir			: in	STD_LOGIC;
            data    	: inout   STD_LOGIC_VECTOR(11 DOWNTO 0);			--Changed from 15 downto 0 to 11 downto 0
			busy		: out	STD_LOGIC;
			done    	: out   STD_LOGIC;
			
			-- Debugging Singals
--			 nBits_out	: out std_logic_vector(7 downto 0);
			 curstate 	: out std_logic_vector(6 downto 0)
		);
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
		port (	w, Clock, resetn	: in	STD_LOGIC;
				En 					: in	STD_LOGIC;
				Q					: out	STD_LOGIC_VECTOR(1 TO 12));
	end component;
	
	component up_counter IS
		PORT (  clk     : in    std_logic;
				en      : in    std_logic;
				reset   : in    std_logic;
				cout    : out   std_logic_vector(7 downto 0));
	END component;
	
    type state is (S1, S2, S3, S4, S5, S6, S7);
    signal y    : state;

    -- Datapath signals
	signal EC, RC, EA, w, resetn    : std_logic; -- Load, enable, write and reset for L-Shift Register A
    signal ET, RT       			: std_logic; -- Enable and reset for timer
	signal nBits 					: integer;
	signal data_buffer				: std_logic_vector(11 downto 0);
    
	-- Timer signals
	signal sig_usec			: integer;
	signal sig_msec			: integer;
	
	signal nBit_counter		: std_logic_vector(7 downto 0);
	
	signal update_en		: std_logic;
		
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
						if sig_msec = 2 and (sig_usec < 450 and sig_usec > 350) then
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
					if nBit_counter > "00001011" then
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
						if sig_msec = 0 and sig_usec < 850 and sig_usec > 350 then
							y <= S5;                    -- if 0 for 0.6ms then go to state 5
						elsif sig_msec = 1 and sig_usec > 0 and sig_usec < 500 then
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
					
				-- Wait at least 30ms before attempting to read a new signal
				when S7 =>
					if sig_msec = 30 then
						y <= S1;
					else
						y <= S7;
					end if;
            end case;
        end if;
    end process;

    fsm_outputs: process(y, data_buffer)
	begin
        EA <= '0'; ET <= '0'; RT <= '0'; resetn <= '1'; EC <= '0'; RC <= '0'; update_en <= '0'; curstate <= "0000000";
		busy <= '0';
		
		-- Debugging signals
--		curstate <= (others => '0');
        case y is
            -- State 1
            -- Reset state
            when S1 =>
                RT <= '1';      -- reset timer
				curstate(0) <= '1';
            -- State 2
            -- Time 2.6ms to initialise reading command
            when S2 =>
				busy <= '1';
                RT <= '0';       -- Stop reset timer
                ET <= '1';       -- Enable timer
				resetn <= '0';		-- Reset shift reg
				curstate(1) <= '1';
				
				RC <= '1';			-- Reset counter for shift reg
            -- State 3
            -- Ready to receive bit
            when S3 =>
				busy <= '1';
                ET <= '0';       -- Stop timer
                RT <= '1';       -- reset timer
				curstate(2) <= '1';
            when S4 =>
				busy <= '1';
                ET <= '1';       -- Start timer
				curstate(3) <= '1';
            when S5 =>
				busy <= '1';
				w <= '0';		-- Bit to be shifter into buffer
                ET <= '0';       -- Stop timer but don't reset it
                EA <= '1';       -- Enable left shift register to load the received bit
				curstate(4) <= '1';
				EC <= '1';
			when S6 =>
				busy <= '1';
				w <= '1';
				ET <= '0';       -- Stop timer but don't reset it
				EA <= '1';       -- Enable left shift register to load the received bit
				curstate(5) <= '1';
				EC <= '1';
			when S7 =>
				busy <= '1';
				ET <= '1';
				curstate(6) <= '1';
				
				update_en <= '1';
        end case;
    end process;

    IR_Timer: Timer
		port map (clk, ET, RT, sig_usec, sig_msec);
				
	ShiftRegBuffer: lshift12
		port map ( w, clk, resetn, EA, data_buffer(11 downto 0));
				
	nBit_Up_Counter: up_counter
		port map (clk, EC, RC, nBit_counter);
		
	Update: process(clk, update_en)
	begin
--		data(11 downto 0) <= data(11 downto 0);
		--	Only update the output register if it's a known command
		if (clk'event and clk = '1') then
			done <= '0';
			if update_en = '1' then
				if data_buffer = X"A70" or		--Enter
					data_buffer = X"C90" or		-- Volume down
					data_buffer = X"490" or		-- Volume Up
					data_buffer = X"CD0" or		-- Right arrow
					data_buffer = X"2F0" or		-- Up arrow
					data_buffer = X"AF0" or		-- Down arrow
					data_buffer = X"2D0" or		-- Left arrow
					data_buffer = X"290" or		-- mute
					data_buffer = X"5BA" or		-- Play arrow
					data_buffer = X"39D" or		-- fast forward
					data_buffer = X"D9D" or		-- rewind
					data_buffer = X"A90" then	-- power
					data(11 downto 0) <= data_buffer;
					done <= '1';
				else
					data(11 downto 0) <= data(11 downto 0);
				end if;
	--			data(11 downto 0) <= data_buffer;

			else
				data(11 downto 0) <= data(11 downto 0);
			end if;
		end if;
	end process;
				
	-- Data is output as 16 bits but only bottom 12 bits matter
	--data(15 downto 12) <= "0000";

	-- Debugging signals
--	nBits_out <= nBit_counter;
	
end Behavioral;

