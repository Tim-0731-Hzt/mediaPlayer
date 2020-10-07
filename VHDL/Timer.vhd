----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:49:01 10/05/2020 
-- Design Name: 
-- Module Name:    Timer - Behavioral 
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

entity Timer is
    --generic(ClockFrequencyHz    : integer);
    port(   clk     : in std_logic;
            reset   : in std_logic;
            usec    : inout integer;
            msec    : inout integer);
end Timer;

architecture Behavioral of Timer is
	-- signal for counting clock ticks
    signal ticks    : integer;
begin
    process(clk) is
    begin
        if (clk'event and clk = '1') then
            if reset = '1' then
                ticks <= 0;
                usec <= 0;
                msec <= 0;
            else
                if ticks = 10 - 1 then
                    ticks <= 0;
                    
                    if usec = 999 then
                        usec <= 0;

                        if msec = 999 then
                            msec <= 0;
                        else
                            msec <= msec + 1;
                        end if;
                    else 
                        usec <= usec + 1;
                    end if;
                else
                    ticks <= ticks + 1;
                end if;
            end if;
        end if;
	end process;
end Behavioral;

