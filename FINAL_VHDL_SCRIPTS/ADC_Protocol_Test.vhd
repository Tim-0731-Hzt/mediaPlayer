--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   14:06:08 10/17/2020
-- Design Name:   
-- Module Name:   C:/Users/brayd/Dropbox/UNSW/y3_t3/COMP3601/COMP3601/FINAL_VHDL_SCRIPTS/ADC_Protocol_Test.vhd
-- Project Name:  media_control_box
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ADC_Protocol_Module
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY ADC_Protocol_Test IS
END ADC_Protocol_Test;
 
ARCHITECTURE behavior OF ADC_Protocol_Test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ADC_Protocol_Module
    PORT(
         ADC_in : IN  std_logic_vector(9 downto 0);
			clk	 : IN  std_logic;
         enable : IN  std_logic;
         output : OUT  std_logic_vector(11 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal ADC_in : std_logic_vector(9 downto 0) := (others => '0');
	signal clk 	  : std_logic := '0';
   signal enable : std_logic := '0';

 	--Outputs
   signal output : std_logic_vector(11 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ADC_Protocol_Module PORT MAP (
          ADC_in => ADC_in,
			 clk => clk,
          enable => enable,
          output => output
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_period*10;
		ADC_in <= "1111111111";
      -- insert stimulus here 

      wait;
   end process;

END;
