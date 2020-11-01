--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   10:07:54 11/01/2020
-- Design Name:   
-- Module Name:   C:/Users/brayd/Dropbox/UNSW/y3_t3/COMP3601/COMP3601/FINAL_VHDL_SCRIPTS/testbench/test_btn_1_sound.vhd
-- Project Name:  media_control_box
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: btn_1_noise_state_machine
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
 
ENTITY test_btn_1_sound IS
END test_btn_1_sound;
 
ARCHITECTURE behavior OF test_btn_1_sound IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT btn_1_noise_state_machine
    PORT(
         clk : IN  std_logic;
         signal_en : IN  std_logic;
         sound_out : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal signal_en : std_logic := '0';

 	--Outputs
   signal sound_out : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: btn_1_noise_state_machine PORT MAP (
          clk => clk,
          signal_en => signal_en,
          sound_out => sound_out
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

      signal_en <= '1';
		
		wait for clk_period;
		signal_en <= '0';

      wait;
   end process;

END;
