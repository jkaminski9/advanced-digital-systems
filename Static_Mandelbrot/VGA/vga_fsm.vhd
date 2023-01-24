library ieee;
use ieee.std_logic_1164.all;

library vga;
use vga.vga_data.all;

entity vga_fsm is
	generic (
		vga_res:	vga_timing := vga_res_default
	);
	port (
		vga_clock:		in	std_logic;
		reset:			in	std_logic;
		enable:        in std_logic;
		point:			out	coordinate;
		point_valid:	out	boolean;

		h_sync:			out	std_logic;
		v_sync:			out std_logic
	);
end entity vga_fsm;

architecture fsm of vga_fsm is

	signal tmp_point: 		coordinate := (x => 0, y => 0);
	signal tmp_hsync: 		std_logic;
	signal tmp_vsync: 		std_logic;
	signal tmp_point_valid: boolean;
		
begin
	
	point  		<= tmp_point;
	h_sync 		<= tmp_hsync;
	v_sync		<= tmp_vsync;
	point_valid <= tmp_point_valid;
	process(reset, vga_clock)
	begin
		if (reset = '0') then
			tmp_point.x <= 0;
			tmp_point.y <= 0;
		elsif (rising_edge(vga_clock)) then
			if (enable = '1') then
				tmp_vsync <= do_vertical_sync(tmp_point, vga_res);
				tmp_hsync <= do_horizontal_sync(tmp_point, vga_res);
				tmp_point_valid <= point_visible(tmp_point, vga_res);
				tmp_point <= next_coordinate(tmp_point, vga_res);
			else
				tmp_point.x <= 0;
				tmp_point.y <= 0;
			end if;
		end if;
	end process;
end architecture fsm;
