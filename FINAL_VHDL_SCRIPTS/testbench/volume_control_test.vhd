--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   18:20:31 10/17/2020
-- Design Name:   
-- Module Name:   C:/Users/brayd/Dropbox/UNSW/y3_t3/COMP3601/COMP3601/FINAL_VHDL_SCRIPTS/volume_control_test.vhd
-- Project Name:  media_control_box
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: volume_control
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
 
ENTITY volume_control_test IS
END volume_control_test;
 
ARCHITECTURE behavior OF volume_control_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT volume_control
    PORT(
         volume_data : IN  std_logic_vector(9 downto 0);
         clk : IN  std_logic;
			vol_en_out : out std_logic;
         vol_out : OUT  std_logic_vector(11 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal volume_data : std_logic_vector(9 downto 0) := (others => '0');
   signal clk : std_logic := '0';

 	--Outputs
   signal vol_out : std_logic_vector(11 downto 0);
	signal vol_en_out : std_logic;
   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: volume_control PORT MAP (
          volume_data => volume_data,
          clk => clk,
			 vol_en_out => vol_en_out,
          vol_out => vol_out
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

      volume_data <= "0000000001";
		
		wait for clk_period*10;
		
		volume_data <= "0011111111";

      wait;
   end process;

END;
