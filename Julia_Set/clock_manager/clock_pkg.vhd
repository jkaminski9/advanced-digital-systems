library ieee;
use ieee.std_logic_1164.all;

package clock_pkg is
	component clock_mgmt is
		port (
			inclk  : in  std_logic := 'X'; -- inclk
			outclk : out std_logic         -- outclk
		);
	end component clock_mgmt;
	
end package clock_pkg;

package body clock_pkg is
end package body clock_pkg;

