-- clock_mgmt.vhd

-- Generated using ACDS version 21.1 850

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity clock_mgmt is
	port (
		inclk  : in  std_logic := '0'; --  altclkctrl_input.inclk
		outclk : out std_logic         -- altclkctrl_output.outclk
	);
end entity clock_mgmt;

architecture rtl of clock_mgmt is
	component clock_mgmt_altclkctrl_0 is
		port (
			inclk  : in  std_logic := 'X'; -- inclk
			outclk : out std_logic         -- outclk
		);
	end component clock_mgmt_altclkctrl_0;

begin

	altclkctrl_0 : component clock_mgmt_altclkctrl_0
		port map (
			inclk  => inclk,  --  altclkctrl_input.inclk
			outclk => outclk  -- altclkctrl_output.outclk
		);

end architecture rtl; -- of clock_mgmt
