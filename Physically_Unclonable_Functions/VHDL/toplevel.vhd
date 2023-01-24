library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;

library work;
use work.project_pkg.all;
use work.project_extras.all;

entity toplevel is
	generic (
		clock_freq  : positive := 50; --Clock is 50MHz
		probe_delay : positive := 30; --Wait for 3000 uS
		ro_length   : positive := 13;
		ro_count    : positive := 16
	);
	port (
		-- Inputs --
		reset       : in  std_logic;
		clock       : in  std_logic;
		-- Outputs --
		done        : out std_logic
	);
end entity toplevel;

architecture arch of toplevel is	
	-- inputs to PUF --
	signal reset_l_puf         : std_logic;
	signal enable_puf          : std_logic;
	signal puf_challenge       : std_logic_vector(2*(integer(log2(real(ro_count)))-1)-1 downto 0);
	
	-- outputs from PUF --
	signal puf_response        : std_logic;
	
	 -- constants --
   constant num_clock_cycles   : positive := (clock_freq*probe_delay);
	
	--bram params
	constant bram_address_width: positive := puf_challenge'length;
	constant bram_data_width   : positive := 1;
	
	-- bram signals --
	signal bram_operand        : std_logic_vector(0 downto 0);
	signal wren 					: std_logic := '0';
	
begin		
      -- RO PUF
		puf: ro_puf
			generic map (
				ro_length => ro_length,
				ro_count  => ro_count
			)
			port map (
				reset_l   => reset_l_puf,
				enable    => enable_puf,
				challenge => puf_challenge,
				response  => puf_response
			);
		-- FSM
		fsm: control_unit
			generic map(
				bram_address_width => bram_address_width,
				num_clock_cycles   => num_clock_cycles
			)
			port map (
				reset         => reset,
				clock         => clock,
				enable_puf    => enable_puf,
				reset_l_puf   => reset_l_puf,
				puf_challenge => puf_challenge,
				wren          => wren,
				done          => done
			);
		-- memory
		ram: bram
			generic map (
				bram_address_width	=> bram_address_width,
				bram_data_width		=> bram_data_width
			)
			port map (
				address		=> puf_challenge,
				data_in		=> "" & puf_response,
				clock		=> clock,
				wren		=> wren
				);
		
end arch;

configuration toplevel_impl of toplevel is
	for arch
		for ram: bram
			use entity work.bram(ip_core);
		end for;
	end for;
end configuration toplevel_impl;
