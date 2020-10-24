--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   11:39:47 10/21/2020
-- Design Name:   
-- Module Name:   C:/Users/seanw/Local Documents/UNSW/COMP3601/COMP3601/VHDL/ir_decoder_tb.vhd
-- Project Name:  IR_SSEG_3
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: IR_Decoder
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
 
ENTITY ir_decoder_tb IS
END ir_decoder_tb;
 
ARCHITECTURE behavior OF ir_decoder_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT IR_Decoder
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         ir : IN  std_logic;
         curstate : OUT  std_logic_vector(6 downto 0);
         data : OUT  std_logic_vector(15 downto 0);
         done : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal ir : std_logic := '0';

 	--Outputs
   signal curstate : std_logic_vector(6 downto 0);
   signal data : std_logic_vector(15 downto 0);
   signal done : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: IR_Decoder PORT MAP (
          clk => clk,
          reset => reset,
          ir => ir,
          curstate => curstate,
          data => data,
          done => done
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

      -- insert stimulus here 
	  reset <= '1';
	  ir <= '1';
	  
	  wait for 1 ms;
	  
	  ir <= '0';
	  wait for 2.4 ms;
	  ir <= '1';
	  wait for 0.6 ms;
	  ir <= '0';
	  wait for 0.6 ms;	-- 0
	  ir <= '1';
	  wait for 0.6 ms;
	  ir <= '0';
	  wait for 1.2 ms;	-- 1
	  ir <= '1';
	  wait for 0.6 ms;
	  ir <= '0';
	  wait for 0.6 ms;	-- 0
	  ir <= '1';
	  wait for 0.6 ms;
	  ir <= '0';
	  wait for 0.6 ms;	-- 0
	  ir <= '1';
	  wait for 0.6 ms;
	  ir <= '0';
	  wait for 1.2 ms;	-- 1
	  ir <= '1';
	  wait for 0.6 ms;
	  ir <= '0';
	  wait for 0.6 ms;	-- 0
	  ir <= '1';
	  wait for 0.6 ms;
	  ir <= '0';
	  wait for 0.6 ms;	-- 0
	  ir <= '1';
	  wait for 0.6 ms;
	  ir <= '0';
	  wait for 1.2 ms;	-- 1
	  ir <= '1';
	  wait for 0.6 ms;
	  ir <= '0';
	  wait for 0.6 ms;	-- 0
	  ir <= '1';
	  wait for 0.6 ms;
	  ir <= '0';
	  wait for 0.6 ms;	-- 0
	  ir <= '1';
	  wait for 0.6 ms;
	  ir <= '0';
	  wait for 0.6 ms;	-- 0
	  ir <= '1';
	  wait for 0.6 ms;
	  ir <= '0';
	  wait for 0.6 ms;	-- 0
	  
	  ir <= '1';
	  wait for 45 ms;
	
	  ir <= '0';
	  wait for 2.4 ms;
	  ir <= '1';
	  wait for 0.6 ms;
	  ir <= '0';
	  wait for 0.6 ms;	-- 0
	  ir <= '1';
	  wait for 0.6 ms;
	  ir <= '0';
	  wait for 1.2 ms;	-- 1
	  ir <= '1';
	  wait for 0.6 ms;
	  ir <= '0';
	  wait for 0.6 ms;	-- 0
	  ir <= '1';
	  wait for 0.6 ms;
	  ir <= '0';
	  wait for 0.6 ms;	-- 0
	  ir <= '1';
	  wait for 0.6 ms;
	  ir <= '0';
	  wait for 1.2 ms;	-- 1
	  ir <= '1';
	  wait for 0.6 ms;
	  ir <= '0';
	  wait for 0.6 ms;	-- 0
	  ir <= '1';
	  wait for 0.6 ms;
	  ir <= '0';
	  wait for 0.6 ms;	-- 0
	  ir <= '1';
	  wait for 0.6 ms;
	  ir <= '0';
	  wait for 1.2 ms;	-- 1
	  ir <= '1';
	  wait for 0.6 ms;
	  ir <= '0';
	  wait for 0.6 ms;	-- 0
	  ir <= '1';
	  wait for 0.6 ms;
	  ir <= '0';
	  wait for 0.6 ms;	-- 0
	  ir <= '1';
	  wait for 0.6 ms;
	  ir <= '0';
	  wait for 0.6 ms;	-- 0
	  ir <= '1';
	  wait for 0.6 ms;
	  ir <= '0';
	  wait for 0.6 ms;	-- 0
	  
      wait;
   end process;

END;
