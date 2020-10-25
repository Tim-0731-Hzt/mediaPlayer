--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   12:49:39 10/25/2020
-- Design Name:   
-- Module Name:   C:/Users/brayd/Dropbox/UNSW/y3_t3/COMP3601/COMP3601/FINAL_VHDL_SCRIPTS/testbench/add_sub_testbench.vhd
-- Project Name:  media_control_box
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: adder_subtractor
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
 
ENTITY add_sub_testbench IS
END add_sub_testbench;
 
ARCHITECTURE behavior OF add_sub_testbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT adder_subtractor
    PORT(clk : in std_logic;
         pot_data : IN  std_logic_vector(7 downto 0);
         pot_en : IN  std_logic;
         ir_data : IN  std_logic_vector(7 downto 0);
         ir_en : IN  std_logic;
         add_sub_out : OUT  std_logic_vector(11 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal pot_data : std_logic_vector(7 downto 0) := (others => '0');
   signal pot_en : std_logic := '0';
   signal ir_data : std_logic_vector(7 downto 0) := (others => '0');
   signal ir_en : std_logic := '0';
	signal clk : std_logic;

 	--Outputs
   signal add_sub_out : std_logic_vector(11 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: adder_subtractor PORT MAP (
          clk => clk,
			 pot_data => pot_data,
          pot_en => pot_en,
          ir_data => ir_data,
          ir_en => ir_en,
          add_sub_out => add_sub_out
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
      pot_data <= "01100100";
		ir_data 	<= "00000100";
		wait for 100 ns;	

      wait for clk_period*10;

      pot_en <= '1';
		
		wait for clk_period;
		
		pot_en <= '0';
		ir_en <= '1';
		
		wait for clk_period;
		ir_en <= '0';
		pot_en <= '1';

      wait;
   end process;

END;
