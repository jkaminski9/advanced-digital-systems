library ieee;
use ieee.std_logic_1164.all;

package project_extras is
	component control_unit is
		generic (
			bram_address_width : positive := 6;
			num_clock_cycles   : positive := 150000
		);
		port (
			-- Inputs --
			reset       : in  std_logic;
			clock       : in  std_logic;
			-- Outputs --
			enable_puf    : out std_logic;
			reset_l_puf   : out std_logic;
			puf_challenge : out std_logic_vector(bram_address_width-1 downto 0);
			wren          : out std_logic;
			done          : out std_logic
		);
	end component control_unit;
	

	component bram is
		generic (
			bram_address_width:	positive := 5;
			bram_data_width:	positive := 9
		);
		port (
			address:	in	std_logic_vector(bram_address_width - 1 downto 0);
			data_in:	in	std_logic_vector(bram_data_width - 1 downto 0);
			clock:		in	std_logic;
			wren:		in	std_logic;
	
			data_out:	out	std_logic_vector(bram_data_width - 1 downto 0)
		);
	end component bram;
	
	component bram_ip
	PORT
	(
		address		: IN STD_LOGIC_VECTOR (5 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		data		: IN STD_LOGIC_VECTOR (0 DOWNTO 0);
		wren		: IN STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (0 DOWNTO 0)
	);
	end component;
end package project_extras;

package body project_extras is
end package body project_extras;
