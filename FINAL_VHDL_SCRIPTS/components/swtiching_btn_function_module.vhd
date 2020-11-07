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

entity swtiching_btn_function_module is
    Port ( clk : in  STD_LOGIC;
           btn : in  STD_LOGIC_VECTOR (3 downto 0);
           sw : in  STD_LOGIC_VECTOR (3 downto 0);
           btn_out : out  STD_LOGIC_VECTOR (3 downto 0));
end swtiching_btn_function_module;

architecture Behavioral of swtiching_btn_function_module is
	signal sig_out			: std_logic_vector(3 downto 0);
	signal button_sig		: std_logic_vector(3 downto 0);
	signal swap_0_1		: std_logic := '0';
	signal swap_0_2		: std_logic := '0';
	signal init 			: std_logic := '0';

begin
	button_sig <= btn;
	
	swapping_en: process(clk)
	begin
	if (clk'event and clk = '1') then
		swap_0_1 <= '0';
		if (sw(0) = '1' and sw(1) = '1') then
			swap_0_1 <= '1';
			init <= '1';
		end if;
		
		if (sw(0) = '1' and sw(2) = '1') then
			swap_0_2 <= '1';
			init <= '1';
		end if;
	end if;
	
	end process;
	
	
	swapping_prcoess : process(clk)
	begin	
	if (clk'event and clk = '1') then
		if (init = '0') then
		sig_out <= button_sig;
		end if;
		
		if (swap_0_1 = '1') then
			sig_out(3 downto 2) <= button_sig(3 downto 2);
			sig_out(1) <= button_sig(0);
			sig_out(0) <= button_sig(1);
		end if;
		
		if (swap_0_2 = '1') then
			sig_out(3) <= button_sig(3);
			sig_out(2) <= button_sig(0);
			sig_out(1) <= button_sig(1);
			sig_out(0) <= button_sig(2);
		end if;
	end if;
	
	end process;
	
	btn_out <= sig_out;
	
end Behavioral;

