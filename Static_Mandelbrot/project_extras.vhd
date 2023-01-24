library ieee;
use ieee.std_logic_1164.all;

package project_extras is
	component VGA_PLL is
	PORT
	(
		areset		: IN STD_LOGIC  := '0';
		inclk0		: IN STD_LOGIC  := '0';
		c0				: OUT STD_LOGIC ;
		locked		: OUT STD_LOGIC 
	);
	end component;
	
end package project_extras;

package body project_extras is
end package body project_extras;