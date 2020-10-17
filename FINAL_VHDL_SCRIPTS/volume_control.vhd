----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:00:21 10/17/2020 
-- Design Name: 
-- Module Name:    Volume_Control - Behavioral 
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

entity volume_control is
    Port ( volume_data : in  STD_LOGIC_VECTOR (9 downto 0);
           clk : in  STD_LOGIC;
			  vol_en_out : out std_logic;
           vol_out : out  STD_LOGIC_VECTOR (11 downto 0));
end volume_control;

architecture Behavioral of volume_control is

	COMPONENT ADC_Protocol_Module
		PORT(
			ADC_in : IN std_logic_vector(9 downto 0);
			clk : IN std_logic;        
			output : OUT std_logic_vector(11 downto 0)
			);
		END COMPONENT;
	
	COMPONENT comparator
		PORT(
			ADC_input : IN std_logic_vector(11 downto 0);
			old_input : IN std_logic_vector(11 downto 0);        
			update_reg_en : OUT std_logic;
			output : OUT std_logic_vector(11 downto 0)
			);
		END COMPONENT;
		
	COMPONENT reg_for_comparator
		PORT(
			clk : IN std_logic;
			reg_in : IN std_logic_vector(11 downto 0);          
			reg_out : OUT std_logic_vector(11 downto 0)
			);
		END COMPONENT;
		
	signal protocol_module_out : std_logic_vector(11 downto 0);
	signal sig_reg_out			: std_logic_vector(11 downto 0);
	signal sig_update_reg		: std_logic;
	signal comparator_out		: std_logic_vector(11 downto 0);
	
begin

	-- Actually takes in output from ADC
	Inst_ADC_Protocol_Module: ADC_Protocol_Module PORT MAP(
			ADC_in => volume_data,
			clk => clk,
			output => protocol_module_out
	);
	
	Inst_comparator: comparator PORT MAP(
		ADC_input => protocol_module_out,
		old_input => sig_reg_out,
		update_reg_en => sig_update_reg,
		output => comparator_out
	);
	
	Inst_reg_for_comparator: reg_for_comparator PORT MAP(
		clk => clk,
		reg_in => comparator_out,
		reg_out => sig_reg_out
	);
	
	vol_out <= comparator_out;
	
	vol_en_out_process: process(clk)
	begin
		if (clk'event and clk = '1') then
			vol_en_out <= '0';
			if (sig_update_reg = '1') then 
			vol_en_out <= '1';
			end if;
		end if;
	end process;

end Behavioral;

