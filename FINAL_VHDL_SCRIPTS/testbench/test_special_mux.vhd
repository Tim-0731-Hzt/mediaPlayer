
--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   17:11:23 11/07/2020
-- Design Name:   
-- Module Name:   C:/Users/brayd/Dropbox/UNSW/y3_t3/COMP3601/COMP3601/FINAL_VHDL_SCRIPTS/testbench/test_special_mux.vhd
-- Project Name:  media_control_box
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: mux_2_to_1_12b_data_ctrl
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
 
ENTITY test_special_mux IS
END test_special_mux;
 
ARCHITECTURE behavior OF test_special_mux IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT mux_2_to_1_12b_data_ctrl
    PORT(
         clk : IN  std_logic;
         data0 : IN  std_logic_vector(11 downto 0);
         data1 : IN  std_logic_vector(11 downto 0);
         mux_select : IN  std_logic;
         data_out : OUT  std_logic_vector(11 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal data0 : std_logic_vector(11 downto 0) := (others => '0');
   signal data1 : std_logic_vector(11 downto 0) := (others => '0');
   signal mux_select : std_logic := '0';

 	--Outputs
   signal data_out : std_logic_vector(11 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: mux_2_to_1_12b_data_ctrl PORT MAP (
          clk => clk,
          data0 => data0,
          data1 => data1,
          mux_select => mux_select,
          data_out => data_out
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

      data0 <= "000000000111";
		data1 <= "000000001111";
		mux_select <= '0';
		
		wait for clk_period*10;
		data0 <= "010000001111";

      wait;
   end process;

END;
