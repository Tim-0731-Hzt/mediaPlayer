--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:48:29 10/25/2020
-- Design Name:   
-- Module Name:   C:/Users/brayd/Dropbox/UNSW/y3_t3/COMP3601/COMP3601/FINAL_VHDL_SCRIPTS/testbench/volume_testbench.vhd
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
 
ENTITY volume_testbench IS
END volume_testbench;
 
ARCHITECTURE behavior OF volume_testbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT volume_control
    PORT(
         clk : IN  std_logic;
         pot_data : IN  std_logic_vector(9 downto 0);
         ir_data : IN  std_logic_vector(7 downto 0);
         ir_en : IN  std_logic;
         vol_data_out : OUT  std_logic_vector(11 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal pot_data : std_logic_vector(9 downto 0) := (others => '0');
   signal ir_data : std_logic_vector(7 downto 0) := (others => '0');
   signal ir_en : std_logic := '0';

 	--Outputs
   signal vol_data_out : std_logic_vector(11 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: volume_control PORT MAP (
          clk => clk,
          pot_data => pot_data,
          ir_data => ir_data,
          ir_en => ir_en,
          vol_data_out => vol_data_out
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
      pot_data <= "1111111111";
      
		wait for clk_period*10;
	--	ir_en <= '1';
	--	wait for clk_period;	
		ir_en <= '0';
	--	wait for clk_period;
	--	ir_en <= '1';
	--	wait for clk_period;
	--	ir_en <= '0';
		
		

      

      wait;
   end process;

END;
