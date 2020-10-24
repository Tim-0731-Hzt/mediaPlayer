--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   11:31:46 10/14/2020
-- Design Name:   
-- Module Name:   C:/Users/seanw/Local Documents/UNSW/COMP3601/COMP3601/VHDL/spi_master_tb.vhd
-- Project Name:  spi
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: spi_master
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
 
ENTITY spi_master_tb IS
END spi_master_tb;
 
ARCHITECTURE behavior OF spi_master_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT spi_master
    PORT(
         clk : IN  std_logic;
         reset_n : IN  std_logic;
         en : IN  std_logic;
         miso : IN  std_logic;
         busy : OUT  std_logic;
         mosi : OUT  std_logic;
         rx_data : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset_n : std_logic := '0';
   signal en : std_logic := '0';
   signal miso : std_logic := '0';

 	--Outputs
   signal busy : std_logic;
   signal mosi : std_logic;
   signal rx_data : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: spi_master PORT MAP (
          clk => clk,
          reset_n => reset_n,
          en => en,
          miso => miso,
          busy => busy,
          mosi => mosi,
          rx_data => rx_data
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
	  reset_n <= '0';
	  miso <= '1';
      wait for 100 ns;	

      wait for clk_period*10;
	  reset_n <= '1';

		wait for 100 ns;
		miso <= '0';
		wait for 20 ns;
		miso <= '1';
		wait for 20 ns;
		miso <= '0';
		wait for 20 ns;
		miso <= '1';
		wait for 20 ns;
		miso <= '0';
      -- insert stimulus here 
		
      wait;
   end process;

END;
