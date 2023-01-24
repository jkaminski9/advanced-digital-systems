library ieee;
use ieee.std_logic_1164.all;

entity counter is
	port (
			-- Inputs --
			clk     : in  std_logic;
			reset_l : in  std_logic;
			enable  : in  std_logic;
			-- Outputs --
			cout    : out natural range 0 to (2 ** 16) - 1
	);
end entity counter;

architecture rtl of counter is
-- Only signal stores each iteration of the counter
signal counter_up : natural range 0 to (2 ** 16) - 1 := 0;
begin	
	process(clk, reset_l)
	begin
		if reset_l='0' then
			counter_up <= 0;
		elsif (rising_edge(clk)) then
			if (enable='1') then
				if counter_up = (2 ** 16) - 1 then
					counter_up <= 0;
				else
					counter_up <= counter_up + 1;
				end if;
			end if;
		end if;
	end process;
	cout <= counter_up;
end rtl;