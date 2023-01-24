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
	
	component Vga_Pll_40MHz IS
	PORT
	(
		areset		: IN STD_LOGIC  := '0';
		inclk0		: IN STD_LOGIC  := '0';
		c0		: OUT STD_LOGIC ;
		locked		: OUT STD_LOGIC 
	);
	end component;
	
	component VGA_PLL_148MHz IS
	PORT
	(
		areset		: IN STD_LOGIC  := '0';
		inclk0		: IN STD_LOGIC  := '0';
		c0		: OUT STD_LOGIC ;
		locked		: OUT STD_LOGIC 
	);
	end component;
	
	component global_clock_mgmt is
		port (
			inclk  : in  std_logic := '0'; --  altclkctrl_input.inclk
			outclk : out std_logic         -- altclkctrl_output.outclk
		);
	end component global_clock_mgmt;
	
end package project_extras;

package body project_extras is
end package body project_extras;