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
    type state is (S1, S2, S3, S4);
    signal y    : State_type;
    signal counter  : STD_LOGIC_VECTOR(7 DOWNTO 0);
    
begin
    fsm_transitions: process(reset, clk)
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
                    if timer < 2.6ms then
                        if ir = '1' then
                            y <= S1;
                        else
                            y <= s2;
                        end if;
                    else
                        y <= S3;
                    end if;
                
                -- State 3
                -- Ready to receive a bit
                when S3 =>
                    if ir = '1' then
                        y <= S3;
                    elsif ir = '0' then
                        y <= S4;
                    end if;

                -- State 4 
                -- time the 0 ir signal
                when S4 =>
                    if ir = '1' then
                        y <= S3;
                    elsif ir = '0' then
                        y <= S4;
                    end if;
                    
                -- Add ending state
            end case;
        end if;
    end process;

    fsm_outputs: process(y)

end Behavioral;

