--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   08:53:00 11/06/2020
-- Design Name:   
-- Module Name:   C:/Users/brayd/Dropbox/UNSW/y3_t3/COMP3601/COMP3601/ir_mapping_testbench.vhd
-- Project Name:  media_control_box
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ir_mapping_module
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
 
ENTITY ir_mapping_testbench IS
END ir_mapping_testbench;
 
ARCHITECTURE behavior OF ir_mapping_testbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ir_mapping_module
    PORT(
         clk : IN  std_logic;
         ir_signal : IN  std_logic_vector(11 downto 0);
         ir_en : IN  std_logic;
         ir_mapped_en : OUT  std_logic;
         ir_mapped_out : OUT  std_logic_vector(11 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal ir_signal : std_logic_vector(11 downto 0) := (others => '0');
   signal ir_en : std_logic := '0';

 	--Outputs
   signal ir_mapped_en : std_logic;
   signal ir_mapped_out : std_logic_vector(11 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ir_mapping_module PORT MAP (
          clk => clk,
          ir_signal => ir_signal,
          ir_en => ir_en,
          ir_mapped_en => ir_mapped_en,
          ir_mapped_out => ir_mapped_out
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
		ir_en <= '1';
		ir_signal <= X"39D";
		
		wait for clk_period;
		ir_en <= '0';      -- insert stimulus here 

      wait;
   end process;

END;
