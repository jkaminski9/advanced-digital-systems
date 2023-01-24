set_location_assignment PIN_N1 -to vga_vsync;
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to vga_vsync;

set_location_assignment PIN_N3 -to vga_hsync;
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to vga_hsync;

# VGA Color Pins
#RED
set_location_assignment PIN_AA1 -to vga_red[0];
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to vga_red[0];

set_location_assignment PIN_V1 -to vga_red[1];
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to vga_red[1];

set_location_assignment PIN_Y2 -to vga_red[2];
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to vga_red[2];

set_location_assignment PIN_Y1 -to vga_red[3];
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to vga_red[3];
#GREEN
set_location_assignment PIN_W1 -to vga_green[0];
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to vga_green[0];

set_location_assignment PIN_T2 -to vga_green[1];
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to vga_green[1];

set_location_assignment PIN_R2 -to vga_green[2];
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to vga_green[2];

set_location_assignment PIN_R1 -to vga_green[3];
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to vga_green[3];
#BLUE
set_location_assignment PIN_P1 -to vga_blue[0];
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to vga_blue[0];

set_location_assignment PIN_T1 -to vga_blue[1];
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to vga_blue[1];

set_location_assignment PIN_P4 -to vga_blue[2];
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to vga_blue[2];

set_location_assignment PIN_N2 -to vga_blue[3];
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to vga_blue[3];
# Reset Button
set_location_assignment PIN_B8 -to reset;
set_instance_assignment -name IO_STANDARD "3.3 V SCHMITT TRIGGER" -to reset;
# Zoom Button
set_location_assignment PIN_A7 -to zoom;
set_instance_assignment -name IO_STANDARD "3.3 V SCHMITT TRIGGER" -to zoom;
# clock
set_location_assignment PIN_P11 -to clock;
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to clock;