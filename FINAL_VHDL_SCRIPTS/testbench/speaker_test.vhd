--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   17:49:11 10/05/2020
-- Design Name:   
-- Module Name:   C:/Users/brayd/Dropbox/UNSW/y3_t3/COMP3601/COMP3601/media_control_box/speaker_test.vhd
-- Project Name:  media_control_box
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: speaker
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
 
ENTITY speaker_test IS
END speaker_test;
 
ARCHITECTURE behavior OF speaker_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT speaker
    PORT(
         clk : IN  std_logic;
         speaker_en : IN  std_logic_vector(1 downto 0);
         speaker_out : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal speaker_en : std_logic := "00";

 	--Outputs
   signal speaker_out : std_logic;

   -- Clock period definitions
   constant clk_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: speaker PORT MAP (
          clk => clk,
          speaker_en => speaker_en,
          speaker_out => speaker_out
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

      speaker_en <= '1';
		wait for clk_period;
		speaker_en <= '0';
		
		wait for 1000000000 ns;
		
		speaker_en <= '1';
		wait for clk_period;
		speaker_en <= '0';

      wait;
   end process;

END;
