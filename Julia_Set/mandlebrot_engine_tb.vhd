library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use std.textio.all;

library work;
use work.mandlebrot_pkg.all;

library vga;
use vga.vga_data.all;
use vga.vga_pkg.all;

library ads;
use ads.ads_fixed.all;
use ads.ads_complex_pkg.all;

entity mandlebrot_engine_tb is
end entity mandlebrot_engine_tb;

architecture behavior of mandlebrot_engine_tb is
	signal iteration_tb: natural range 0 to max_iterations + 1;

	signal seed_tb  :  ads_complex;
	signal z0_tb    : ads_complex;
	signal vga_clock_tb : std_logic := '0';
	signal reset_tb: std_logic		:= '0';
    signal enable_tb : std_logic := '0';
    signal output_valid_tb : std_logic := '0';
	signal finished: boolean	:= false;
    constant threshold          : ads_sfixed := to_ads_sfixed(4);		
    constant vga_clock_period : time := 40 ns;
	 
begin

      vga_clock_process : process
      begin
        vga_clock_tb <= '1';
        wait for vga_clock_period/2;
        vga_clock_tb <= '0';
        wait for vga_clock_period/2;
      end process;

	generator: pipeline
		generic map (
			num_stages => max_iterations
		)
		port map (
			clock => vga_clock_tb,
			reset => reset_tb,
            enable => enable_tb,
			seed => seed_tb,
			z0   => z0_tb,
			iteration => iteration_tb,
            output_valid => output_valid_tb
		);
	
	make_pgm: process
		variable output_line: line;
        file out_file: text open write_mode is "julia_tb_output_point8.ppm";
		  variable r, g, b: natural range 0 to max_iterations-1;
        --variable x_coord: sfixed(seed.re'range);
		--variable y_coord: sfixed(seed.re'range);
	begin
		-- header information
		---- P2
		write(out_file, "P3" & LF);
		write(out_file, "640 480" & LF);
		write(out_file, "23" & LF);
      seed_tb <= (re => to_ads_sfixed(-0.3), im => to_ads_sfixed(0.6));
        enable_tb <= '0';
		-- reset generator
		wait for vga_clock_period;
		reset_tb <= '0';
		wait for vga_clock_period;
		reset_tb <= '1';
      wait for vga_clock_period * 2;
      enable_tb <= '1';
		for y_pt in 0 to vga_height-1 loop
			for x_pt in 0 to vga_width-1 loop
				-- set seed
				z0_tb <= (re =>  mandlebrot_xmax_sfixed - to_ads_sfixed(x_pt)*mandlebrot_delta_x,
						im => mandlebrot_ymax_sfixed - to_ads_sfixed(y_pt)*mandlebrot_delta_y);
                
				wait for vga_clock_period;
				if output_valid_tb = '1' then
						  write(output_line, integer'image(y_pt) & " " & integer'image(x_pt) & " " & integer'image(max_iterations - 1 - iteration_tb));
						  writeline(output, output_line);
						  flush(output);
						  r := cmap_red(iteration_tb);
						  g := cmap_green(iteration_tb);
						  b := cmap_blue(iteration_tb);
                    write(output_line, integer'image(r) & " " & integer'image(g) & " "& integer'image(b));
                    writeline(out_file, output_line);
					--flush(output);
				end if;
			end loop;
		end loop;

		for i in 0 to max_iterations - 1 loop
			wait for vga_clock_period;
			write(output_line, integer'image(max_iterations - 1 - iteration_tb));
			writeline(out_file, output_line);
			--flush(output);
		end loop;

		-- all done
		finished <= true;
		wait;
	end process make_pgm;

end architecture behavior;
