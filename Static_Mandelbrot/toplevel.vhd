library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.mandlebrot_pkg.all;
use work.project_extras.all;

library vga;
use vga.vga_data.all;
use vga.vga_pkg.all;

library ads;
use ads.ads_fixed.all;
use ads.ads_complex_pkg.all;

entity toplevel is 
	generic (
		vga_res:	vga_timing := vga_res_default;
		num_stages: positive := 25
	);
	port (
			-- Inputs --
			reset : in std_logic;
			clock : in std_logic;
			-- Outputs --
			vga_red   : out std_logic_vector(3 downto 0);
			vga_green : out std_logic_vector(3 downto 0);
			vga_blue  : out std_logic_vector(3 downto 0);
			vga_vsync : out std_logic;
			vga_hsync : out std_logic
	);
end entity toplevel;

architecture arch of toplevel is 
	-- VGA clock derived from the PLL --
	signal vga_clock   : std_logic;
	
	-- Outputs from VGA Driver -- 
	signal point       : coordinate;
	signal seed        : ads_complex;
	signal point_valid : boolean;
	signal direction   : integer := 1;
	
	-- Reset Signals for the PLL and the VGA Driver are Active High
	signal reset_high       : std_logic;

	-- Signal to / from pipeline
	signal pixel_data           : natural range 0 to num_stages - 1;	
   signal output_valid         : std_logic := '0';	
	signal enable      : std_logic := '0';
	signal pipeline_point : coordinate := (x => 0, y => 0);

begin
	reset_high       <= not reset;
  enable  <= '1';
	
	pll: VGA_PLL
			port map (
				areset		=> reset_high,
				inclk0		=> clock,
				c0				=> vga_clock
			);
			
	vga_driver: vga_fsm
			generic map (
				vga_res    => vga_res
			)
			port map (
				vga_clock   =>	vga_clock,
				reset       =>	reset,
				enable      =>  output_valid,
				point       =>	point,
				point_valid =>	point_valid,
				h_sync      =>	vga_hsync,
				v_sync      =>	vga_vsync
			);
	
	engine: pipeline 
			generic map (
				num_stages => num_stages
			)
			port map (
				clock => vga_clock,
				reset => reset,
				enable =>  enable,
				seed  => seed,
				iteration => pixel_data,
				output_valid => output_valid
			);

	process(reset, vga_clock)
	begin
		if (reset = '0') then
			pipeline_point <= (x => 0, y => 0);
			seed <= (re => mandlebrot_xmin_sfixed,
						im => mandlebrot_xmax_sfixed);
		elsif (rising_edge(vga_clock)) then
			pipeline_point <= next_coordinate(pipeline_point, vga_res);
			seed <= (re =>  mandlebrot_xmin_sfixed + to_ads_sfixed(pipeline_point.x)*mandlebrot_delta_x,
						im => mandlebrot_ymax_sfixed - to_ads_sfixed(pipeline_point.y)*mandlebrot_delta_y);	
		end if;
	end process;
	
	-- Process to drive the VGA signals -- 
	process(reset, vga_clock)
	begin
		if (reset = '0') then
			vga_red   <= (others => '0');
			vga_green <= (others => '0');
			vga_blue  <= (others => '0');
		elsif (rising_edge(vga_clock)) then
			if point_valid = true then
				vga_red   <= cmap_red(pixel_data);
				vga_green <= cmap_green(pixel_data);
				vga_blue  <= cmap_blue(pixel_data);
			else
				vga_red   <= (others => '0');
				vga_green <= (others => '0');
				vga_blue  <= (others => '0');
			end if;
		end if;
	end process;
end arch;