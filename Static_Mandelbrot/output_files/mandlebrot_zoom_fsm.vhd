library ieee;
use ieee.std_logic_1164.all;

library ads;
use ads.ads_fixed.all;
use ads.ads_complex_pkg.all;

library work;
use work.mandlebrot_pkg.all;

entity mandlebrot_zoom_fsm is
	port (
		-- Inputs --
		reset  : in std_logic;
		zoom   : in std_logic;
		-- Outputs --
		xmax   : out ads_sfixed;
		xmin   : out ads_sfixed;
		ymax   : out ads_sfixed;
		ymin   : out ads_sfixed;
		deltax : out ads_sfixed;
		deltay  : out ads_sfixed
	);
end entity mandlebrot_zoom_fsm;

architecture rtl of mandlebrot_zoom_fsm is

	type state is (zoom_out_state, zoom_in_state);
	signal pr_state : state := zoom_out_state; 
	
	signal xmax_tmp : real := 3.0;
	signal xmin_tmp : real := -3.0;
	signal ymax_tmp : real := 2.0;
	signal ymin_tmp : real := -2.0;

begin
	
	process(reset, clock, zoom) is
	begin
		if (reset = '0') then
			pr_state <= zoom_out_state;
			xmax <= to_ads_sfixed(3.0);
			xmin <= to_ads_sfixed(-3.0);
			ymax <= to_ads_sfixed(2.0);
			ymin <= to_ads_sfixed(-2.0);
			deltax <= to_ads_sfixed(0.009375);
			deltay <= to_ads_sfixed(0.008333);	
		elsif (rising_edge(clock)) then
			case pr_state is
				when zoom_out_state =>
					if (falling_edge(zoom)) then
						pr_state <= zoom_in_state;
					else 
						pr_state <= zoom_out_state;
					end if;
					xmax <= to_ads_sfixed(3.0);
					xmin <= to_ads_sfixed(-3.0);
					ymax <= to_ads_sfixed(2.0);
					ymin <= to_ads_sfixed(-2.0);
					deltax <= to_ads_sfixed(0.009375);
					deltay <= to_ads_sfixed(0.008333);
				when zoom_in_state =>
					if (falling_edge(zoom)) then
						pr_state <= zoom_out_state;
					else 
						pr_state <= zoom_in_state;
					end if;
					xmax <= to_ads_sfixed(-0.6);
					xmin <= to_ads_sfixed(-0.9);
					ymax <= to_ads_sfixed(0.0);
					ymin <= to_ads_sfixed(-0.15);
					deltax <= to_ads_sfixed(0.00046875);
					deltay <= to_ads_sfixed(0.000234375);
			end case;
		end if;
	end process;
end architecture rtl;

	
	