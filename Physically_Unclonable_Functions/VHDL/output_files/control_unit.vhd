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
		probe_delay : positive := 30000; --Wait for 3000 uS
		ro_length   : positive := 13;
		ro_count    : positive := 16
	);
	port (
		-- Inputs --
		reset       : in  std_logic;
		clock       : in  std_logic;
		-- Outputs --
		done        : out std_logic;
		output      : out std_logic
	);
end entity toplevel;

architecture arch of toplevel is	
	-- control states --
	type state is (init_state, enable_state, wait_state, write_state, done_state);
	signal pr_state, next_state  : state := done_state;
	
	-- inputs to PUF --
	constant reset_puf_width   : positive := 1;
	constant enable_puf_width  : positive := 1;
	signal reset_puf           : std_logic;
	signal enable_puf          : std_logic;
	signal puf_challenge       : std_logic_vector(2*(integer(log2(real(ro_count)))-1)-1 downto 0);
	
	-- outputs from PUF --
	constant puf_response_width: positive := 1;
	signal puf_response        : std_logic;
	
	 -- constants --
   constant num_clock_cycles   : positive := (clock_freq*probe_delay);
	constant maximum_challenge  : positive := integer(2**real(puf_challenge'length));
	signal clock_iter           : natural;
	signal challenge_int        : natural;
	
	--bram params
	constant bram_address_width: positive := puf_challenge'length;
	constant bram_data_width   : positive := 1;
	
	-- bram signals --
	constant wren_width        : positive := 1;
	signal bram_operand        : std_logic_vector(0 downto 0);
	signal wren 					: std_logic := '0';
	
	constant done_width        : positive := 1;
begin		
      output <= enable_puf;
      -- RO PUF
		puf: ro_puf
			generic map (
				ro_length => ro_length,
				ro_count  => ro_count
			)
			port map (
				reset     => reset_puf,
				enable    => enable_puf,
				challenge => puf_challenge,
				response  => puf_response
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
				when others => next_state <= done_state;
			end case;
		end process transition_function;
		
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
		
		clear_puf: process(clock) is
		begin
			if rising_edge(clock) then
				if reset = '0' then
				   reset_puf <= '1';
					challenge_int <= 0;
					puf_challenge <= (others => '0');
				else
					if pr_state = init_state then
						reset_puf <= '0';
						challenge_int <= challenge_int + 1;
						puf_challenge <= std_logic_vector(to_unsigned(challenge_int, puf_challenge'length));
					else
						challenge_int <= challenge_int;
						puf_challenge <= puf_challenge;
						reset_puf <= '1';
					end if;
				end if;
			end if;		
		end process clear_puf;
		
		drive_puf: process(clock) is
		begin
			if rising_edge(clock) then
				if reset = '0' then
				   enable_puf <= '0';
				else
					if pr_state = enable_state then
						enable_puf <= '1';
					else
						enable_puf <= '0';
					end if;
				end if;
			end if;		
		end process drive_puf;
		
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
		
end arch;

configuration toplevel_impl of toplevel is
	for arch
		for ram: bram
			use entity work.bram(ip_core);
		end for;
	end for;
end configuration toplevel_impl;