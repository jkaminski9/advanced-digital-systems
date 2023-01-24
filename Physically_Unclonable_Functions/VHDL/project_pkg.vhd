library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;

package project_pkg is
	---- component declarations
	-- ring_oscillator
	component ring_oscillator is
		generic (
			n : positive := 13
		);
		port (
			-- Inputs --
			sig_in  : in  std_logic;
			-- Outputs --
			sig_out : out std_logic
		);
	end component ring_oscillator;
	-- counter
	component counter is
		port (
			-- Inputs --
			clk     : in  std_logic;
			reset_l : in  std_logic;
			enable  : in  std_logic;
			-- Outputs --
			cout    : out natural range 0 to (2 ** 16) - 1
		);
	end component counter;
	-- ro_puf
	component ro_puf is
		generic (
			ro_length : positive := 13;
			ro_count  : positive := 16
			);
		port (
				-- Inputs --
				reset_l   : in  std_logic;
				enable    : in  std_logic;
				challenge : in  std_logic_vector(2*(integer(log2(real(ro_count)))-1)-1 downto 0);
				-- Outputs --
				response  : out std_logic
		);
	end component ro_puf;
	
end package project_pkg;

package body project_pkg is
end package body project_pkg;