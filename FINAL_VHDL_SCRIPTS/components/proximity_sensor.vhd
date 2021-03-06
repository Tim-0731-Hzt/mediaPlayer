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
	signal counter_en	: std_logic;
	signal sig_toggle	: std_logic;
	signal busy			: std_logic;
begin

	main: process(clk, busy, ir_prox)
	begin
--		counter_rst <= '0';
		if (clk'event and clk = '1') then 
			if ir_prox = '0' and busy <= '0' then
				counter_rst <= '1';
				sig_toggle <= '1';
			else
				 counter_rst <= '0';
				sig_toggle <= '0';
			end if;
		end if;
		
--		if ir_prox = '0' then
--			counter_en <= '1';
--		else
--			counter_en <= '0';
--		end if;
	end process;
	
	counter_process: process(clk, counter_rst)
    begin
		if counter_rst = '1' then
			counter <= 0;
			busy <= '1';
        elsif(clk'event and clk = '1') then
			if counter = 100000000 then
				busy <= '0';
--				sig_toggle <= '1';
				counter <= 0;
			else
--				sig_toggle <= '0';
				counter <= counter + 1;
			end if;
        end if;
    end process;
	
	toggle <= sig_toggle;

end Behavioral;

