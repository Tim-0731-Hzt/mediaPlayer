--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   16:58:10 10/14/2020
-- Design Name:   
-- Module Name:   C:/Users/seanw/Local Documents/UNSW/COMP3601/COMP3601/VHDL/top_spi_master_tb.vhd
-- Project Name:  spi
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: top_spi_master
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
 
ENTITY top_spi_master_tb IS
END top_spi_master_tb;
 
ARCHITECTURE behavior OF top_spi_master_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT top_spi_master
    PORT(
         clk : IN  std_logic;
         ir : IN  std_logic;
         done : OUT  std_logic;
         miso : IN  std_logic;
         mosi : OUT  std_logic;
         nCS : OUT  std_logic;
         sclk : OUT  std_logic;
         busy : OUT  std_logic;
         rx_data : OUT  std_logic_vector(7 downto 0);
         led : OUT  std_logic_vector(7 downto 0);
         swt : IN  std_logic_vector(1 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal ir : std_logic := '0';
   signal miso : std_logic := '0';
   signal swt : std_logic_vector(1 downto 0) := (others => '0');

 	--Outputs
   signal done : std_logic;
   signal mosi : std_logic;
   signal nCS : std_logic;
   signal sclk : std_logic;
   signal busy : std_logic;
   signal rx_data : std_logic_vector(7 downto 0);
   signal led : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
   constant sclk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: top_spi_master PORT MAP (
          clk => clk,
          ir => ir,
          done => done,
          miso => miso,
          mosi => mosi,
          nCS => nCS,
          sclk => sclk,
          busy => busy,
          rx_data => rx_data,
          led => led,
          swt => swt
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 
   sclk_process :process
   begin
		sclk <= '0';
		wait for sclk_period/2;
		sclk <= '1';
		wait for sclk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
	  swt(0) <= '1';
      wait for 100 ns;	

      wait for clk_period*10;
		swt(1) <= '1';
		swt(0) <= '0';
      -- insert stimulus here 

      wait;
   end process;

END;
