library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;

library work;
use work.project_pkg.all;
use work.project_extras.all;

entity control_unit is
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
end entity control_unit;

architecture rtl of control_unit is	
	-- control states --
	type state is (init_state, enable_state, wait_state, write_state, done_state);
	signal pr_state, next_state  : state := done_state;
	
	constant maximum_challenge  : positive := integer(2**real(puf_challenge'length));
	signal clock_iter           : natural range 0 to num_clock_cycles;
	signal challenge_int        : natural range 0 to maximum_challenge;
	
begin		
		-- Transitions Between States in State Flow Diagram --
		transition_function: process(reset, clock) is
		begin
			case pr_state is
				when init_state	=> next_state <= enable_state;
				when enable_state	=> next_state <= wait_state;
				when wait_state =>
						if clock_iter = num_clock_cycles then
							next_state <= write_state;
						else
							next_state <= wait_state;
						end if;
				when write_state =>
						if challenge_int = maximum_challenge then
							next_state <= done_state;
						else
							next_state <= init_state;
						end if;
				when done_state => next_state <= done_state;
			end case;
		end process transition_function;
		-- Saving the present state to the determined next state --
		save_state: process(clock) is
		begin
			if rising_edge(clock) then
				if reset = '0' then
					pr_state <= init_state;
				else 
					pr_state <= next_state;
				end if;
			end if;
		end process save_state;
		-- When in the init_state, we assert the reset to the RO_PUF Counter and increment to the next challenge -- 
		clear_puf: process(clock) is
		begin
			if rising_edge(clock) then
				if reset = '0' then
				   reset_l_puf <= '1';
					challenge_int <= 0;
				else
					if pr_state = init_state then
						reset_l_puf <= '0';
						challenge_int <= challenge_int + 1;
					else
						challenge_int <= challenge_int;
						reset_l_puf <= '1';
					end if;
				end if;
			end if;
			puf_challenge <= std_logic_vector(to_unsigned(challenge_int, puf_challenge'length));
		end process clear_puf;
		-- When in the enable state or wait_state we assert the enable signal to the PUF ring oscillator and counter
		drive_puf: process(clock) is
		begin
			if rising_edge(clock) then
				if reset = '0' then
				   enable_puf <= '0';
				else
					if (pr_state = enable_state) or (pr_state = wait_state) then
						enable_puf <= '1';
					else
						enable_puf <= '0';
					end if;
				end if;
			end if;		
		end process drive_puf;
		-- When in the wait_state, we increment the clock counter
		inc_clock: process(clock) is
		begin
			if rising_edge(clock) then
				if reset = '0' then
				   clock_iter <= 0;
				else 
					if pr_state = wait_state then
						clock_iter <= clock_iter + 1;
					else
						clock_iter <= 0;
					end if;
				end if;
			end if;		
		end process inc_clock;
		-- When in the write_state, we assert the write enable signal
		write_to_bram: process(clock) is
		begin
			if rising_edge(clock) then
				if reset = '0' then
					wren <= '0';
				else 
					if pr_state = write_state then
						wren <= '1';
					else
						wren <= '0';
					end if;
				end if;
			end if;		
		end process write_to_bram;
		-- When in the done
		output_function: process(clock) is
		begin
			if rising_edge(clock) then
				if reset = '0' then
					done <= '0';
				else
					if pr_state = done_state then
						done <= '1';
					else
						done <= '0';
					end if;
				end if;
			end if;
		end process output_function;
end rtl;