LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY up_counter IS
    PORT (  clk     : in    std_logic;
            en      : in    std_logic;
            reset   : in    std_logic;
            cout    : out   std_logic_vector(7 downto 0));
END up_counter;

ARCHITECTURE Behaviour OF up_counter IS
	signal count	: std_logic_vector(7 downto 0);
	
BEGIN 
	process(clk, reset) begin 
		if reset = '1' then
			count <= (others => '0');
		elsif (clk'event and clk = '1') then
			if en = '1' then
				count <= count + 1;
			end if;
		end if; 
	end process;
	cout <= count;
END Behaviour;