library ieee;
use ieee.std_logic_1164.all;

entity edge_detector is
	port (
		signal_in:	in	std_logic;
		clock:		in	std_logic;
		reset:		in	std_logic;
		edge_out:	out	std_logic
	);
end entity edge_detector;

architecture arch of edge_detector is
	signal shift_register:	std_logic_vector(1 downto 0);
begin
	-- output checks if current cycle is low and previous cycle was high
	edge_out <= (not shift_register(0)) and shift_register(1);

	shift: process(clock) is
	begin
		if rising_edge(clock) then
			if reset = '0' then
				shift_register <= ( others => '1' );
			else
				shift_register <= shift_register(0) & signal_in;
			end if;
		end if;
	end process shift;

end architecture arch;
