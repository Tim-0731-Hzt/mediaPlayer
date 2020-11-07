library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY spi_master is
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
END spi_master;

ARCHITECTURE behaviour OF spi_master IS 
    type machine is (reset, start, config, receive, done);
    signal state		: machine;
    
    signal rx_buffer    : std_logic_vector(d-1 DOWNTO 0);
    signal nCS          : std_logic;
    signal sclk         : std_logic;
    signal rx_count        : integer;           -- count the number of received bits
    signal counter      : integer;
	
	signal shift_en		: std_logic;
	signal shift_reset	: std_logic;

BEGIN 
    fsm_transitions: process(clk, reset_n)
    begin

        if (reset_n = '0') then
            state <= reset;
        elsif(clk'event and clk = '1') then
            case state is
                when reset =>
                    state <= start;
                when start =>
                    state <= config;
                when config =>
                    if miso = '0' then          -- Detect null bit to start receiving
                        state <= receive;
					else
						state <= config;
                    end if;
                when receive =>
                    if (rx_count = 10) then      -- if the number of received bits is equal to the register size stop
                        state <= done;
                    else
                        state <= receive;
                    end if;
                when done =>                    -- move the rx_buffer to the rx_data
                    state <= reset;                  -- Stay in done, fix this
            end case;
        end if;
    end process;

    fsm_outputs: process(state, sclk,rx_buffer)
    begin
		state_out <= (others => '0');
        case state is
            when reset =>
                state_out(0) <= '1';

--                rx_data <= (others => '0');
--                rx_buffer <= (others => '0');
--                rx_count <= 0;
				shift_reset <= '1';
                busy <= '0';
				nCS <= '1';						-- Chip select active low
				shift_en <= '0';
            when start =>
                state_out(1) <= '1';

                busy <= '1';
                nCS <= '0';                     -- Bring nCS low before sclk starts to initialise to mode 0,0
				shift_reset <= '0';
            when config =>
                state_out(2) <= '1';
				mosi <= '1';
            when receive =>                             --  In the execute phase read miso on sclk rising edge
                state_out(3) <= '1';

--				rx_data <= rx_buffer;

                nCS <= '0';
				shift_en <= '1';
                -- if (sclk'event and sclk = '1') then
                --     rx_buffer(d-1 downto 1) <= rx_buffer(d-2 downto 0);
                --     rx_buffer(0) <= miso;
                --     rx_count <= rx_count + 1;
                -- end if;
            when done =>
                state_out(4) <= '1';
				rx_data <= rx_buffer;

                busy <= '0';
				shift_en <= '0';
        end case;
    end process;
	
	
	-- Data Path

    system_to_sclk: process(clk, state)
    begin
        if state = reset or state = start then
            sclk <= '0';
			counter <= 0;
        elsif(clk'event and clk = '1') then
--			if counter = 10000000 then
			if counter = 10 then
				sclk <= not sclk;
				counter <= 0;
			else
				counter <= counter + 1;
			end if;
        end if;
    end process;
	
	-- Shift register process
	shift_reg: process(shift_en, sclk, shift_reset)
	begin
		if shift_reset = '1' then
			rx_buffer <= (others => '0');
			rx_count <= 0;
		elsif (shift_en = '1' and sclk'event and sclk = '1') then
			rx_buffer(d-1 downto 1) <= rx_buffer(d-2 downto 0);
			rx_buffer(0) <= miso;
			rx_count <= rx_count + 1;
		end if;
	end process;
	
	
	nCS_out <= nCS;
	sclk_out <= sclk;
end behaviour;


            
    