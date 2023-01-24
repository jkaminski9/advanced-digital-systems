library ieee;
use ieee.std_logic_1164.all;

library ads;
use ads.ads_fixed.all;
use ads.ads_complex_pkg.all;

library work;
use work.mandlebrot_pkg.all;

entity pipeline is 
	generic (
		num_stages : positive := 23
	);
	port (
			-- Inputs --
			reset : in std_logic;
			clock : in std_logic;
         enable : in std_logic;
			seed  : in ads_complex;
			z0    : in ads_complex;
			-- Outputs --
			iteration : out natural range 0 to num_stages-1;
			output_valid : out std_logic
	);
end entity pipeline;

architecture rtl of pipeline is

type stage_array is array (0 to num_stages-1) of stage_type;

signal stage_inputs : stage_array;
signal stage_outputs : stage_array;

begin

	stage_inputs(0) <= (z => z0,
							  c => seed,
							  stage_data => 0,
							  stage_overflow => false,
							  stage_valid => true);

	stage_inputs(1 to num_stages-1) <= stage_outputs(0 to num_stages-2);
	
	iteration <= stage_outputs(num_stages-1).stage_data;
	
	output_valid <= '1' when stage_outputs(num_stages-1).stage_valid = true else
						 '0';
	
	stage_generate: for stage_idx in 0 to num_stages-1 generate
		stage: pipeline_stage
		    generic map(
					threshold    => threshold,
					stage_number => stage_idx
			 )
			 port map (
				  reset  => reset,
				  clock  => clock,
				  enable => enable,
				  stage_input => stage_inputs(stage_idx),
				  stage_output => stage_outputs(stage_idx)
			);
	end generate;
end rtl;
