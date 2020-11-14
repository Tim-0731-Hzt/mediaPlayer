----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:12:05 11/06/2020 
-- Design Name: 
-- Module Name:    swtiching_btn_function_module - Behavioral 
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

entity switching_btn_function_module is
    Port ( clk : in  STD_LOGIC;
           btn : in  STD_LOGIC_VECTOR (3 downto 0);
           sw : in  STD_LOGIC_VECTOR (4 downto 0);
           btn_out : out  STD_LOGIC_VECTOR (3 downto 0));
end switching_btn_function_module;

architecture Behavioral of switching_btn_function_module is
alias prev : std_logic is btn(3);
alias stop : std_logic is btn(2);
alias play : std_logic is btn(1);
alias nxt : std_logic is btn(0);

begin

	
	swapping_prcoess : process(clk)
	begin	
	if (clk'event and clk = '1') then
		if ( sw = "00001") then
			btn_out(3) <= prev;
			btn_out(2) <= stop;
			btn_out(1) <= nxt;
			btn_out(0) <= play;
		elsif ( sw = "00010") then
			btn_out(3) <= prev;
			btn_out(2) <= play;
			btn_out(1) <= stop;
			btn_out(0) <= nxt;
		elsif ( sw = "00011") then
			btn_out(3) <= prev;
			btn_out(2) <= nxt;
			btn_out(1) <= stop;
			btn_out(0) <= play;
		elsif ( sw = "00100") then
			btn_out(3) <= prev;
			btn_out(2) <= play;
			btn_out(1) <= nxt;
			btn_out(0) <= stop;
		elsif ( sw = "00101") then
			btn_out(3) <= prev;
			btn_out(2) <= nxt;
			btn_out(1) <= play;
			btn_out(0) <= stop;
		elsif ( sw = "00110") then
			btn_out(3) <= stop;
			btn_out(2) <= prev;
			btn_out(1) <= play;
			btn_out(0) <= nxt;
		elsif ( sw = "00111") then
			btn_out(3) <= stop;
			btn_out(2) <= prev;
			btn_out(1) <= nxt;
			btn_out(0) <= play;
		elsif ( sw = "01000") then
			btn_out(3) <= play;
			btn_out(2) <= prev;
			btn_out(1) <= stop;
			btn_out(0) <= nxt;
		elsif ( sw = "01001") then
			btn_out(3) <= nxt;
			btn_out(2) <= prev;
			btn_out(1) <= stop;
			btn_out(0) <= play;
		elsif ( sw = "01010") then
			btn_out(3) <= play;
			btn_out(2) <= prev;
			btn_out(1) <= nxt;
			btn_out(0) <= stop;
		elsif ( sw = "01011") then
			btn_out(3) <= nxt;
			btn_out(2) <= prev;
			btn_out(1) <= play;
			btn_out(0) <= stop;
		elsif ( sw = "01100") then
			btn_out(3) <= stop;
			btn_out(2) <= play;
			btn_out(1) <= prev;
			btn_out(0) <= nxt;
		elsif ( sw = "01101") then
			btn_out(3) <= stop;
			btn_out(2) <= nxt;
			btn_out(1) <= prev;
			btn_out(0) <= play;
		elsif ( sw = "01110") then
			btn_out(3) <= play;
			btn_out(2) <= stop;
			btn_out(1) <= prev;
			btn_out(0) <= nxt;
		elsif ( sw = "01111") then
			btn_out(3) <= nxt;
			btn_out(2) <= stop;
			btn_out(1) <= prev;
			btn_out(0) <= play;
		elsif ( sw = "10000") then
			btn_out(3) <= play;
			btn_out(2) <= nxt;
			btn_out(1) <= prev;
			btn_out(0) <= stop;
		elsif ( sw = "10001") then
			btn_out(3) <= nxt;
			btn_out(2) <= play;
			btn_out(1) <= prev;
			btn_out(0) <= stop;
		elsif ( sw = "10010") then
			btn_out(3) <= stop;
			btn_out(2) <= play;
			btn_out(1) <= nxt;
			btn_out(0) <= prev;
		elsif ( sw = "10011") then
			btn_out(3) <= stop;
			btn_out(2) <= nxt;
			btn_out(1) <= play;
			btn_out(0) <= prev;
		elsif ( sw = "10100") then
			btn_out(3) <= play;
			btn_out(2) <= stop;
			btn_out(1) <= nxt;
			btn_out(0) <= prev;
		elsif ( sw = "10101") then
			btn_out(3) <= nxt;
			btn_out(2) <= stop;
			btn_out(1) <= play;
			btn_out(0) <= prev;
		elsif ( sw = "10110") then
			btn_out(3) <= play;
			btn_out(2) <= nxt;
			btn_out(1) <= stop;
			btn_out(0) <= prev;
		elsif ( sw = "10111") then
			btn_out(3) <= nxt;
			btn_out(2) <= play;
			btn_out(1) <= stop;
			btn_out(0) <= prev;
		else
			btn_out <= btn;
		end if;
	end if;
	
	end process;
	
	
end Behavioral;

