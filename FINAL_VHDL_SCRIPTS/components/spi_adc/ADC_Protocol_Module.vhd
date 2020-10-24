----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:58:31 10/17/2020 
-- Design Name: 
-- Module Name:    ADC_Protocol_Module - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ADC_Protocol_Module is
    Port ( ADC_in : in  		STD_LOGIC_VECTOR (9 downto 0);
			  clk		: in 			STD_LOGIC;
           output : out  		STD_LOGIC_VECTOR (11 downto 0));
end ADC_Protocol_Module;

architecture Behavioral of ADC_Protocol_Module is

begin
	adc_mapping: process(clk)
		begin	
			if (clk'event and clk = '1') then
				if(ADC_in = std_logic_vector(to_unsigned(0, 10))) then
					output(7 downto 0) <= std_logic_vector(to_unsigned(1, 8));
					
				elsif(ADC_in < std_logic_vector(to_unsigned(50, 10))) then
					output(7 downto 0) <= std_logic_vector(to_unsigned(5, 8));
					
				elsif (ADC_in < std_logic_vector(to_unsigned(100, 10))) then
					output(7 downto 0) <= std_logic_vector(to_unsigned(10, 8));
					
				elsif (ADC_in < std_logic_vector(to_unsigned(150, 10))) then
					output(7 downto 0) <= std_logic_vector(to_unsigned(15, 8));
					
				elsif (ADC_in < std_logic_vector(to_unsigned(200, 10))) then
					output(7 downto 0) <= std_logic_vector(to_unsigned(20, 8));
					
				elsif (ADC_in < std_logic_vector(to_unsigned(250, 10))) then
					output(7 downto 0) <= std_logic_vector(to_unsigned(25, 8));
					
				elsif (ADC_in < std_logic_vector(to_unsigned(300, 10))) then
					output(7 downto 0) <= std_logic_vector(to_unsigned(30, 8));
					
				elsif (ADC_in < std_logic_vector(to_unsigned(350, 10))) then
					output(7 downto 0) <= std_logic_vector(to_unsigned(35, 8));
					
				elsif (ADC_in < std_logic_vector(to_unsigned(400, 10))) then
					output(7 downto 0) <= std_logic_vector(to_unsigned(40, 8));
					
				elsif (ADC_in < std_logic_vector(to_unsigned(450, 10))) then
					output(7 downto 0) <= std_logic_vector(to_unsigned(45, 8));
					
				elsif (ADC_in < std_logic_vector(to_unsigned(500, 10))) then
					output(7 downto 0) <= std_logic_vector(to_unsigned(50, 8));
					
				elsif (ADC_in < std_logic_vector(to_unsigned(550, 10))) then
					output(7 downto 0) <= std_logic_vector(to_unsigned(55, 8));
					
				elsif (ADC_in < std_logic_vector(to_unsigned(600, 10))) then
					output(7 downto 0) <= std_logic_vector(to_unsigned(60, 8));
					
				elsif (ADC_in < std_logic_vector(to_unsigned(650, 10))) then
					output(7 downto 0) <= std_logic_vector(to_unsigned(65, 8));
					
				elsif (ADC_in < std_logic_vector(to_unsigned(700, 10))) then
					output(7 downto 0) <= std_logic_vector(to_unsigned(70, 8));
					
				elsif (ADC_in < std_logic_vector(to_unsigned(750, 10))) then
					output(7 downto 0) <= std_logic_vector(to_unsigned(75, 8));
					
				elsif (ADC_in < std_logic_vector(to_unsigned(800, 10))) then
					output(7 downto 0) <= std_logic_vector(to_unsigned(80, 8));
					
				elsif (ADC_in < std_logic_vector(to_unsigned(850, 10))) then
					output(7 downto 0) <= std_logic_vector(to_unsigned(85, 8));
					
				elsif (ADC_in < std_logic_vector(to_unsigned(900, 10))) then
					output(7 downto 0) <= std_logic_vector(to_unsigned(90, 8));
					
				elsif (ADC_in < std_logic_vector(to_unsigned(950, 10))) then
					output(7 downto 0) <= std_logic_vector(to_unsigned(95, 8));
				
				else
					output(7 downto 0) <= std_logic_vector(to_unsigned(100, 8));	
					
				end if;		
			end if;
		end process;
		
		output(11 downto 8) <= "0100";
end Behavioral;

