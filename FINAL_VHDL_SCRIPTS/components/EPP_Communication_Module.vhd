----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:02:48 10/14/2020 
-- Design Name: 
-- Module Name:    EPP_Communication_Module - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity EPP_Communication_Module is
    Port ( clk : in  STD_LOGIC;
           DB : inout  STD_LOGIC_VECTOR (7 downto 0);
           EppASTB : in  STD_LOGIC;
           EppDSTB : in  STD_LOGIC;
           EppWrite : in  STD_LOGIC;
			  vol_ctrl	: in STD_LOGIC_VECTOR (7 downto 0);
           EppWait : out  STD_LOGIC;
           data_to_send : in  STD_LOGIC_VECTOR (11 downto 0));
end EPP_Communication_Module;

architecture Behavioral of EPP_Communication_Module is
------------------------------------------------------------------------
-- Component Declarations
------------------------------------------------------------------------

------------------------------------------------------------------------
-- Local Type Declarations
------------------------------------------------------------------------

------------------------------------------------------------------------
--  Constant Declarations
------------------------------------------------------------------------

	-- The following constants define state codes for the EPP port interface
	-- state machine. The high order bits of the state number give a unique
	-- state identifier. The low order bits are the state machine outputs for
	-- that state. This type of state machine implementation uses no
	-- combination logic to generate outputs which should produce glitch
	-- free outputs.
	constant	stEppReady	: std_logic_vector(7 downto 0) := "0000" & "0000";
	constant	stEppAwrA	: std_logic_vector(7 downto 0) := "0001" & "0100";
	constant	stEppAwrB	: std_logic_vector(7 downto 0) := "0010" & "0001";
	constant	stEppArdA	: std_logic_vector(7 downto 0) := "0011" & "0010";
	constant	stEppArdB	: std_logic_vector(7 downto 0) := "0100" & "0011";
	constant	stEppDwrA	: std_logic_vector(7 downto 0) := "0101" & "1000";
	constant	stEppDwrB	: std_logic_vector(7 downto 0) := "0110" & "0001";
	constant	stEppDrdA	: std_logic_vector(7 downto 0) := "0111" & "0010";
	constant	stEppDrdB	: std_logic_vector(7 downto 0) := "1000" & "0011";

------------------------------------------------------------------------
-- Signal Declarations
------------------------------------------------------------------------

	-- State machine current state register
	signal	stEppCur	: std_logic_vector(7 downto 0) := stEppReady;

	signal	stEppNext	: std_logic_vector(7 downto 0);

	signal	clkMain		: std_logic;


	-- Internal control signales
	signal	ctlEppWait	: std_logic;
	signal	ctlEppAstb	: std_logic;
	signal	ctlEppDstb	: std_logic;
	signal	ctlEppDir	: std_logic;
	signal	ctlEppWr	: std_logic;
	signal	ctlEppAwr	: std_logic;
	signal	ctlEppDwr	: std_logic;
	signal	busEppOut	: std_logic_vector(7 downto 0);
	signal	busEppIn	: std_logic_vector(7 downto 0);
	signal	busEppData	: std_logic_vector(7 downto 0);

	-- Registers
	signal	regEppAdr	: std_logic_vector(3 downto 0);
	signal	regData0	: std_logic_vector(7 downto 0);
	signal	regData1	: std_logic_vector(7 downto 0);
   signal   regData2	: std_logic_vector(7 downto 0); 
   signal   regData3	: std_logic_vector(7 downto 0);
   signal   regData4	: std_logic_vector(7 downto 0);
	signal	regData5	: std_logic_vector(7 downto 0);
	signal	regData6	: std_logic_vector(7 downto 0);
	signal	regData7	: std_logic_vector(7 downto 0);

------------------------------------------------------------------------
-- Module Implementation
------------------------------------------------------------------------

begin

    ------------------------------------------------------------------------
	-- Map basic status and control signals
    ------------------------------------------------------------------------
	clkMain <= clk;

	ctlEppAstb <= EppASTB;
	ctlEppDstb <= EppDSTB;
	ctlEppWr   <= EppWRITE;
	EppWAIT    <= ctlEppWait;	-- drive WAIT from state machine output
	-- Data bus direction control. The internal input data bus always
	-- gets the port data bus. The port data bus drives the internal
	-- output data bus onto the pins when the interface says we are doing
	-- a read cycle and we are in one of the read cycles states in the
	-- state machine.
	busEppIn <= DB;
	DB <= busEppOut when ctlEppWr = '1' and ctlEppDir = '1' else "ZZZZZZZZ";

	-- Select either address or data onto the internal output data bus.
	busEppOut <= "0000" & regEppAdr when ctlEppAstb = '0' else busEppData;

	-- Decode the address register and select the appropriate data register
	busEppData <=	regData0 when regEppAdr = "0000" else
					   regData1 when regEppAdr = "0001" else
					   regData2 when regEppAdr = "0010" else
					   regData3 when regEppAdr = "0011" else
					   regData4 when regEppAdr = "0100" else
					   regData5 when regEppAdr = "0101" else
					   regData6 when regEppAdr = "0110" else
					   regData7 when regEppAdr = "0111" else
					   "00000000";

    ------------------------------------------------------------------------
	-- EPP Interface Control State Machine
    ------------------------------------------------------------------------

	-- Map control signals from the current state
	ctlEppWait <= stEppCur(0);
	ctlEppDir  <= stEppCur(1);
	ctlEppAwr  <= stEppCur(2);
	ctlEppDwr  <= stEppCur(3);

	-- This process moves the state machine to the next state
	-- on each clock cycle
	process (clkMain)
		begin
			if clkMain = '1' and clkMain'Event then
				stEppCur <= stEppNext;
			end if;
		end process;

	-- This process determines the next state machine state based
	-- on the current state and the state machine inputs.
	process (stEppCur, stEppNext, ctlEppAstb, ctlEppDstb, ctlEppWr)
		begin
			case stEppCur is
				-- Idle state waiting for the beginning of an EPP cycle
				when stEppReady =>
					if ctlEppAstb = '0' then
						-- Address read or write cycle
						if ctlEppWr = '0' then
							stEppNext <= stEppAwrA;
						else
							stEppNext <= stEppArdA;
						end if;

					elsif ctlEppDstb = '0' then
						-- Data read or write cycle
						if ctlEppWr = '0' then
							stEppNext <= stEppDwrA;
						else
							stEppNext <= stEppDrdA;
						end if;

					else
						-- Remain in ready state
						stEppNext <= stEppReady;
					end if;											

				-- Write address register
				when stEppAwrA =>
					stEppNext <= stEppAwrB;

				when stEppAwrB =>
					if ctlEppAstb = '0' then
						stEppNext <= stEppAwrB;
					else
						stEppNext <= stEppReady;
					end if;		

				-- Read address register
				when stEppArdA =>
					stEppNext <= stEppArdB;

				when stEppArdB =>
					if ctlEppAstb = '0' then
						stEppNext <= stEppArdB;
					else
						stEppNext <= stEppReady;
					end if;

				-- Write data register
				when stEppDwrA =>
					stEppNext <= stEppDwrB;

				when stEppDwrB =>
					if ctlEppDstb = '0' then
						stEppNext <= stEppDwrB;
					else
 						stEppNext <= stEppReady;
					end if;

				-- Read data register
				when stEppDrdA =>
					stEppNext <= stEppDrdB;
										
				when stEppDrdB =>
					if ctlEppDstb = '0' then
						stEppNext <= stEppDrdB;
					else
				  		stEppNext <= stEppReady;
					end if;

				-- Some unknown state				
				when others =>
					stEppNext <= stEppReady;

			end case;
		end process;
		
    ------------------------------------------------------------------------
	-- EPP Address register
    ------------------------------------------------------------------------

	process (clkMain, ctlEppAwr)
		begin
			if clkMain = '1' and clkMain'Event then
				if ctlEppAwr = '1' then
					regEppAdr <= busEppIn(3 downto 0);
				end if;
			end if;
		end process;

    ------------------------------------------------------------------------
	-- EPP Data registers
    ------------------------------------------------------------------------
 	-- The following processes implement the interface registers. These
	-- registers just hold the value written so that it can be read back.
	-- In a real design, the contents of these registers would drive additional
	-- logic.
	-- The ctlEppDwr signal is an output from the state machine that says
	-- we are in a 'write data register' state. This is combined with the
	-- address in the address register to determine which register to write.

	sending_button_remote_data: process(clk)
		begin
			if clk = '1' and clk'event then
			regData0 <= "00000000";
			regData1 <= "00000000";
			regData2 <= "00000000";
			regData3 <= "00000000";
			regData5 <= "00000000";
			regData6 <= "00000000";
				if data_to_send(11 downto 8) = "0000" then
					regData0 <= data_to_send(7 downto 0);
				elsif data_to_send(11 downto 8) = "0001" then
					regData1 <= data_to_send(7 downto 0);
				elsif data_to_send(11 downto 8) = "0010" then
					regData2 <= data_to_send(7 downto 0);
				elsif data_to_send(11 downto 8) = "0011" then
					regData3 <= data_to_send(7 downto 0);
				elsif data_to_send(11 downto 8) = "0101" then
					regData5 <= data_to_send(7 downto 0);
				elsif data_to_send(11 downto 8) = "0110" then
					regData6 <= data_to_send(7 downto 0);
					--if (vol_en = '1') then 
--						regData4 <= vol_ctrl(7 downto 0);
					--end if;
				end if;
				regData4 <= vol_ctrl(7 downto 0);
			end if;
	end process;


----------------------------------------------------------------------------

end Behavioral;


