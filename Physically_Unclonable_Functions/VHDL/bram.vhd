library ieee;
use ieee.std_logic_1164.all;

entity bram is
	generic (
		bram_address_width:	positive := 6;
		bram_data_width:	positive := 1
	);
	port (
		address:	in	std_logic_vector(bram_address_width - 1 downto 0);
		data_in:	in	std_logic_vector(bram_data_width - 1 downto 0);
		clock:		in	std_logic;
		wren:		in	std_logic;

		data_out:	out	std_logic_vector(bram_data_width - 1 downto 0)
	);
end entity bram;

library ieee;
use ieee.numeric_std.all;

architecture rtl of bram is
	type memory_type is array(0 to 2**bram_address_width - 1) of
			std_logic_vector(data_out'range);

	signal memory: memory_type;
begin

	store: process(clock, address, memory)
		variable addr: natural;
	begin
		addr := to_integer(unsigned(address));
		if rising_edge(clock) then
			if wren = '1' then
				memory(addr) <= data_in;
			end if;
		end if;
		data_out <= memory(addr);
	end process store;

end architecture rtl;

library work;
use work.project_extras.all;

architecture ip_core of bram is
begin
	ram0: bram_ip
		port map (
			address	=> address,
			clock	=> clock,
			data	=> data_in,
			wren	=> wren,
			q		=> data_out
		);
end architecture ip_core;
