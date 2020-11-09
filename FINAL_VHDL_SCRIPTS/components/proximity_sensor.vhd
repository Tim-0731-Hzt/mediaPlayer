----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:14:53 11/08/2020 
-- Design Name: 
-- Module Name:    proximity_sensor - Behavioral 
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

entity proximity_sensor is
    port(   clk     	: in    STD_LOGIC;
			ir_prox		: in	STD_LOGIC;
            toggle		: out	STD_LOGIC
    );
end proximity_sensor;

architecture Behavioral of proximity_sensor is

    signal counter      : integer;
	signal counter_rst	: std_logic;
begin

	main: process(clk, ir_prox)
	begin
		counter_en <= '0';
		counter_rst <= '1';
		if ir_prox = '1' then
			counter_en <= '1';
			counter_rst <= '0';
		else
			counter_en <= '0';
			counter_rst <= '1';
		end if;
	end process;
	
	counter: process(clk, counter_rst)
    begin
		toggle <= '0';
		if counter_rst then
			counter <= 0;
        elsif(clk'event and clk = '1') then
			if counter = 1000 then
				toggle <= '1';
				counter <= 0;
			else
				counter <= counter + 1;
			end if;
        end if;
    end process;

end Behavioral;

