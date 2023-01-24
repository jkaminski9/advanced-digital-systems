library ieee;
use ieee.std_logic_1164.all;

library ads;
use ads.ads_fixed.all;
use ads.ads_complex_pkg.all;

entity seed_fsm is
	port (
		clock:		in	std_logic;
		reset:			in	std_logic;
		toggle:        in std_logic;
		seed :			out	ads_complex
	);
end entity seed_fsm;

architecture fsm of seed_fsm is

	type state is (state0, state1, state2, state3, state4, state5, state6, state7);
	signal pr_state : state := state0;
		
begin
	
	process(reset, toggle, clock)
	begin
		if (reset = '0') then
			pr_state <= state0;
			seed <= (re => to_ads_sfixed(-0.7), im => to_ads_sfixed(0.6));
		elsif (rising_edge(clock)) then
			case pr_state is
				when state0 =>
					seed <= (re => to_ads_sfixed(-0.7), im => to_ads_sfixed(0.6));
					if (toggle = '1') then
						pr_state <= state1;
					else
						pr_state <= state0;
					end if;
				when state1 =>
					seed <= (re => to_ads_sfixed(-0.6), im => to_ads_sfixed(0.6));
					if (toggle = '1') then
						pr_state <= state2;
					else
						pr_state <= state1;
					end if;
				when state2 =>
					seed <= (re => to_ads_sfixed(-0.5), im => to_ads_sfixed(0.6));
					if (toggle = '1') then
						pr_state <= state3;
					else
						pr_state <= state2;
					end if;
				when state3 =>
					seed <= (re => to_ads_sfixed(-0.4), im => to_ads_sfixed(0.6));
					if (toggle = '1') then
						pr_state <= state4;
					else
						pr_state <= state3;
					end if;
				when state4 =>
					seed <= (re => to_ads_sfixed(-0.8), im => to_ads_sfixed(0.3));
					if (toggle = '1') then
						pr_state <= state5;
					else
						pr_state <= state4;
					end if;
				when state5 =>
					seed <= (re => to_ads_sfixed(-0.8), im => to_ads_sfixed(0.2));
					if (toggle = '1') then
						pr_state <= state6;
					else
						pr_state <= state5;
					end if;
				when state6 =>
					seed <= (re => to_ads_sfixed(-0.6), im => to_ads_sfixed(0.5));
					if (toggle = '1') then
						pr_state <= state7;
					else
						pr_state <= state6;
					end if;
				when state7 =>
					seed <= (re => to_ads_sfixed(-0.3), im => to_ads_sfixed(0.6));
					if (toggle = '1') then
						pr_state <= state0;
					else
						pr_state <= state7;
					end if;
			end case;
		end if;
	end process;
end architecture fsm;
