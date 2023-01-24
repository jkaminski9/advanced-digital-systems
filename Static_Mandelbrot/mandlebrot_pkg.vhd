library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;

library ads;
use ads.ads_fixed.all;
use ads.ads_complex_pkg.all;

library vga;
use vga.vga_pkg.all;
use vga.vga_data.all;

package mandlebrot_pkg is
	
	-- Constants and types -- 
	
	constant max_iterations     : integer    := 25;
	constant threshold          : ads_sfixed := to_ads_sfixed(4);		
	constant vga_width          : natural    := 640;
	constant vga_height         : natural    := 480;
	constant mandlebrot_vga_res : vga_timing := vga_res_default;
	
	constant mandlebrot_xmax    : integer := 3;
	constant mandlebrot_xmin    : integer := -3;
	
	constant mandlebrot_xmax_sfixed    : ads_sfixed := to_ads_sfixed(mandlebrot_xmax);
	constant mandlebrot_xmin_sfixed    : ads_sfixed := to_ads_sfixed(mandlebrot_xmin);

	constant mandlebrot_ymax    : integer := 2;
	constant mandlebrot_ymin    : integer := -2;
	
	constant mandlebrot_ymax_sfixed    : ads_sfixed := to_ads_sfixed(mandlebrot_ymax);
	constant mandlebrot_ymin_sfixed    : ads_sfixed := to_ads_sfixed(mandlebrot_ymin);
		
	constant mandlebrot_delta_x : ads_sfixed := to_ads_sfixed(0.009375); --"00000000000000000011001100110"; -- 4 / 640 = 0.00625
	constant mandlebrot_delta_y : ads_sfixed := to_ads_sfixed(0.00833); -- 4 / 480 = 0.00833
		
	type map_array is array (0 to max_iterations -1 ) of 
							std_logic_vector(3 downto 0);					
	
	type stage_type is
	record
		z: ads_complex;
		c: ads_complex;
		stage_data: natural;
		stage_overflow: boolean;
		stage_valid : boolean;
	end record stage_type;
	
	constant cmap_blue : map_array := (
				('1', '1', '1', '1'),
				('1', '1', '1', '1'),
				('1', '0', '0', '0'),
				('1', '1', '1', '1'),
				('0', '0', '0', '0'),
				('0', '0', '0', '0'),
				('1', '1', '1', '1'),
				('0', '1', '1', '0'),
				('1', '1', '0', '0'),
				('1', '0', '0', '1'),
				('0', '0', '1', '1'),
				('0', '0', '0', '0'),
				('1', '1', '1', '1'),
				('0', '1', '1', '0'),
				('1', '1', '0', '0'),
				('1', '0', '0', '1'),
				('0', '0', '1', '1'),
				('0', '0', '0', '0'),
				('1', '1', '1', '1'),
				('0', '1', '1', '0'),
				('1', '1', '0', '0'),
				('1', '0', '0', '1'),
				('0', '0', '0', '0'),
				('1', '0', '0', '1'),
				('0', '0', '0', '0'));
		constant cmap_red : map_array := (
				('0', '0', '0', '0'),
				('0', '0', '0', '0'),
				('1', '1', '1', '1'),
				('1', '0', '0', '0'),
				('1', '1', '1', '1'),
				('1', '0', '0', '0'),
				('0', '0', '1', '1'),
				('1', '1', '0', '0'),
				('0', '0', '0', '0'),
				('1', '0', '0', '1'),
				('0', '0', '0', '1'),
				('0', '1', '1', '0'),
				('0', '0', '1', '1'),
				('1', '1', '0', '0'),
				('0', '0', '0', '0'),
				('1', '0', '0', '1'),
				('0', '0', '0', '1'),
				('0', '1', '1', '0'),
				('0', '0', '1', '1'),
				('1', '1', '0', '0'),
				('0', '0', '0', '0'),
				('1', '0', '0', '1'),
				('0', '1', '1', '0'),
				('1', '0', '0', '1'),
				('0', '0', '0', '0'));
		constant cmap_green : map_array := (
				('0', '0', '0', '0'),
				('0', '0', '0', '0'),
				('0', '0', '0', '0'),
				('0', '0', '0', '0'),
				('1', '0', '0', '0'),
				('1', '1', '1', '1'),
				('1', '0', '0', '1'),
				('0', '0', '0', '0'),
				('1', '1', '0', '0'),
				('0', '0', '0', '0'),
				('1', '0', '0', '1'),
				('1', '1', '0', '0'),
				('1', '0', '0', '1'),
				('0', '0', '0', '0'),
				('1', '1', '0', '0'),
				('0', '0', '0', '0'),
				('1', '0', '0', '1'),
				('1', '1', '0', '0'),
				('1', '0', '0', '1'),
				('0', '0', '0', '0'),
				('1', '1', '0', '0'),
				('0', '0', '0', '0'),
				('1', '1', '0', '0'),
				('0', '0', '0', '0'),
				('0', '0', '0', '0'));
		-- Components -- 
		
		component pipeline_stage is
			generic(
				threshold : ads_sfixed := to_ads_sfixed(4);
				stage_number : natural := 0
			);
			port(
				clock : in std_logic;
				reset : in std_logic;
				enable : in std_logic;
				stage_input : in stage_type;
				stage_output : out stage_type
			);
		end component pipeline_stage;
		
		component pipeline is 
			generic (
				num_stages : positive := 23
			);
			port (
					-- Inputs --
					reset : in std_logic;
					clock : in std_logic;
					enable : in std_logic;
					seed  : in ads_complex;
					-- Outputs --
					iteration : out natural range 0 to num_stages-1;
					output_valid : out std_logic
			);
		end component pipeline;
		
end package mandlebrot_pkg;

package body mandlebrot_pkg is

end package body mandlebrot_pkg;