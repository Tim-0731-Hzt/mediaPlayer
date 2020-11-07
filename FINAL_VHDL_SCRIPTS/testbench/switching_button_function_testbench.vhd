--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   21:23:47 11/06/2020
-- Design Name:   
-- Module Name:   C:/Users/brayd/Dropbox/UNSW/y3_t3/COMP3601/COMP3601/FINAL_VHDL_SCRIPTS/testbench/switching_button_function_testbench.vhd
-- Project Name:  media_control_box
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: swtiching_btn_function_module
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
 
ENTITY switching_button_function_testbench IS
END switching_button_function_testbench;
 
ARCHITECTURE behavior OF switching_button_function_testbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT swtiching_btn_function_module
    PORT(
         clk : IN  std_logic;
         btn : IN  std_logic_vector(3 downto 0);
         sw : IN  std_logic_vector(3 downto 0);
         btn_out : OUT  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal btn : std_logic_vector(3 downto 0) := (others => '0');
   signal sw : std_logic_vector(3 downto 0) := (others => '0');

 	--Outputs
   signal btn_out : std_logic_vector(3 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: swtiching_btn_function_module PORT MAP (
          clk => clk,
          btn => btn,
          sw => sw,
          btn_out => btn_out
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

      sw <= "0011";
		btn <= "0010";

      wait for clk_period*2;
		sw <= "0000";
   end process;

END;
