library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;

library work;
use work.project_pkg.all;

entity ro_puf is
	generic (
		ro_length : positive := 13;
		ro_count  : positive := 16
		);
	port (
			-- Inputs --
			reset_l   : in  std_logic;
			enable    : in  std_logic;
			challenge : in  std_logic_vector(2*(integer(log2(real(ro_count)))-1)-1 downto 0); -- Solving for b
			-- Outputs --
			response  : out std_logic
	);
end entity ro_puf;

architecture rtl of ro_puf is
-- Types --
type counter_array is array (0 to (ro_count/2)-1) of
			natural;

-- Signals --
signal oscillator_outputs_group1 : std_logic_vector((ro_count/2)-1 downto 0);
signal oscillator_outputs_group2 : std_logic_vector((ro_count/2)-1 downto 0);
signal counter_outputs_group1    : counter_array;
signal counter_outputs_group2    : counter_array;
signal select_a           			: std_logic_vector((challenge'length/2)-1 downto 0);
signal select_b           			: std_logic_vector((challenge'length/2)-1 downto 0);

-- Power of 2 Check Function --
function power_of_two(vector : std_logic_vector) return boolean is
	variable result : boolean;
	variable count  : integer := 0;
begin
	for i in 0 to vector'length - 1 loop
		if vector(i) = '1' then count := count + 1;
		end if;
	end loop;
	if count = 1 then result := true;
	else result := false;
	end if;
	return result;
end function;

begin
	assert power_of_two(vector => std_logic_vector(to_unsigned(ro_count, 1 + integer(ceil(log2(real(ro_count))))))) = true 
	report "Number of Oscillators must be a power of 2" 
	severity failure;
	
	-- Select A&B choose which counter to pull the value from
	select_a <= challenge((challenge'length/2)-1 downto 0);
	select_b <= challenge(challenge'length-1 downto challenge'length/2);
	-- Generate n/2 oscillators and connect them to n/2 counters for each of the two groups
	cir_gen: for count in 0 to (ro_count/2)-1 generate
		ro_g1: ring_oscillator
		    generic map(
					n => ro_length
			 )
			 port map (
				  sig_in  => enable,
				  sig_out => oscillator_outputs_group1(count)
			);
		ro_g2: ring_oscillator
		    generic map(
					n => ro_length
			 )
			 port map (
				  sig_in  => enable,
				  sig_out => oscillator_outputs_group2(count)
			);
		c_g1: counter
		    port map (
					clk    => oscillator_outputs_group1(count),
					reset_l=> reset_l,
					enable => enable,
					cout   => counter_outputs_group1(count)
			);
		c_g2: counter
		    port map (
					clk    => oscillator_outputs_group2(count),
					reset_l=> reset_l,
					enable => enable,
					cout   => counter_outputs_group2(count)
			);
	end generate cir_gen;
	response <= '1' when counter_outputs_group1(to_integer(unsigned(select_a))) < counter_outputs_group2(to_integer(unsigned(select_b))) else
					'0';
end rtl;