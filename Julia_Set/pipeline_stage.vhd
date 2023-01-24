library ieee;
use ieee.std_logic_1164.all;

library ads;
use ads.ads_fixed.all;
use ads.ads_complex_pkg.all;

library work;
use work.mandlebrot_pkg.all;

entity pipeline_stage is
	generic(
		threshold : ads_sfixed := to_ads_sfixed(4);
		stage_number : natural := 0
	);
	port(
		clock : in std_logic;
		reset : in std_logic;
		enable: in std_logic;
		
		stage_input : in stage_type;
		stage_output : out stage_type
	);
end entity pipeline_stage;

architecture rtl of pipeline_stage is

begin

	process (reset, clock)
	begin
		if (reset = '0') then
			stage_output.stage_data <= 0;
			stage_output.c <= (re => to_ads_sfixed(0), im => to_ads_sfixed(0));
			stage_output.z <= (re => to_ads_sfixed(0), im => to_ads_sfixed(0));
			stage_output.stage_overflow <= false;
			stage_output.stage_valid <= false;
		elsif rising_edge(clock) then
			if (enable = '1') then
				if (stage_input.stage_overflow = true) then
					stage_output.stage_data <= stage_input.stage_data; 
				else
					stage_output.stage_data <= stage_number; 
				end if;
				
				if (stage_input.stage_overflow = true) or (abs2(stage_input.z) > threshold) then
					stage_output.stage_overflow <= true;
				else
					stage_output.stage_overflow <= false;
				end if;
				
				if (stage_input.stage_overflow = true) then
					stage_output.z <= stage_input.z;
				else
					stage_output.z <= (stage_input.z * stage_input.z) + stage_input.c;
				end if;
				
				stage_output.c <= stage_input.c;
				stage_output.stage_valid <= stage_input.stage_valid;
			else
				stage_output.stage_data <= 0;
				stage_output.c <= (re => to_ads_sfixed(0), im => to_ads_sfixed(0));
				stage_output.z <= (re => to_ads_sfixed(0), im => to_ads_sfixed(0));
				stage_output.stage_overflow <= false;
				stage_output.stage_valid <= false;
			end if;
		end if;
	end process;
end architecture rtl;
	
					