# Copyright (C) 2022  Intel Corporation. All rights reserved.
# Your use of Intel Corporation's design tools, logic functions 
# and other software and tools, and any partner logic 
# functions, and any output files from any of the foregoing 
# (including device programming or simulation files), and any 
# associated documentation or information are expressly subject 
# to the terms and conditions of the Intel Program License 
# Subscription Agreement, the Intel Quartus Prime License Agreement,
# the Intel FPGA IP License Agreement, or other applicable license
# agreement, including, without limitation, that your use is for
# the sole purpose of programming logic devices manufactured by
# Intel and sold by Intel or its authorized distributors.  Please
# refer to the applicable agreement for further details, at
# https://fpgasoftware.intel.com/eula.

# Quartus Prime: Generate Tcl File for Project
# File: Project_1.tcl
# Generated on: Thu Oct  6 15:04:35 2022

# Load Quartus Prime Tcl Project package
package require ::quartus::project

set need_to_close_project 0
set make_assignments 1

# Check that the right project is open
if {[is_project_open]} {
	if {[string compare $quartus(project) "Project_1"]} {
		puts "Project Project_1 is not open"
		set make_assignments 0
	}
} else {
	# Only open if not already open
	if {[project_exists Project_1]} {
		project_open -revision Project_1 Project_1
	} else {
		project_new -revision Project_1 Project_1
	}
	set need_to_close_project 1
}

# Make assignments
if {$make_assignments} {
	set_global_assignment -name FAMILY "MAX 10"
	set_global_assignment -name DEVICE 10M50DAF484C6GES
	set_global_assignment -name TOP_LEVEL_ENTITY toplevel
	set_global_assignment -name ORIGINAL_QUARTUS_VERSION 21.1.1
	set_global_assignment -name PROJECT_CREATION_TIME_DATE "13:03:45  SEPTEMBER 28, 2022"
	set_global_assignment -name LAST_QUARTUS_VERSION "21.1.1 Lite Edition"
	set_global_assignment -name PROJECT_OUTPUT_DIRECTORY output_files
	set_global_assignment -name BOARD "MAX 10 DE10 - Lite"
	set_global_assignment -name VHDL_FILE ring_oscillator.vhd
	set_global_assignment -name VHDL_FILE counter.vhd
	set_global_assignment -name VHDL_FILE project_pkg.vhd
	set_global_assignment -name VHDL_FILE ro_puf.vhd
	set_global_assignment -name VHDL_FILE bram.vhd
	set_global_assignment -name VHDL_FILE project_extras.vhd
	set_global_assignment -name QIP_FILE bram_ip.qip
	set_global_assignment -name TCL_SCRIPT_FILE output_files/Tcl_script1.tcl
	set_global_assignment -name VHDL_FILE toplevel.vhd
	set_global_assignment -name VHDL_FILE control_unit.vhd
	set_global_assignment -name PARTITION_NETLIST_TYPE SOURCE -section_id Top
	set_global_assignment -name PARTITION_FITTER_PRESERVATION_LEVEL PLACEMENT_AND_ROUTING -section_id Top
	set_global_assignment -name PARTITION_COLOR 16764057 -section_id Top
	set_global_assignment -name TCL_SCRIPT_FILE PUF_Placement.tcl
	set_location_assignment PIN_A8 -to done
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to done
	set_location_assignment PIN_B8 -to reset
	set_instance_assignment -name IO_STANDARD "3.3 V SCHMITT TRIGGER" -to reset
	set_location_assignment PIN_P11 -to clock
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to clock
	set_instance_assignment -name PARTITION_HIERARCHY root_partition -to | -section_id Top

	# Including default assignments
	set_global_assignment -name TIMING_ANALYZER_MULTICORNER_ANALYSIS ON -family "MAX 10"
	set_global_assignment -name TIMING_ANALYZER_REPORT_WORST_CASE_TIMING_PATHS OFF -family "MAX 10"
	set_global_assignment -name TIMING_ANALYZER_CCPP_TRADEOFF_TOLERANCE 0 -family "MAX 10"
	set_global_assignment -name TDC_CCPP_TRADEOFF_TOLERANCE 0 -family "MAX 10"
	set_global_assignment -name TIMING_ANALYZER_DO_CCPP_REMOVAL ON -family "MAX 10"
	set_global_assignment -name DISABLE_LEGACY_TIMING_ANALYZER OFF -family "MAX 10"
	set_global_assignment -name SYNTH_TIMING_DRIVEN_SYNTHESIS ON -family "MAX 10"
	set_global_assignment -name SYNCHRONIZATION_REGISTER_CHAIN_LENGTH 2 -family "MAX 10"
	set_global_assignment -name SYNTH_RESOURCE_AWARE_INFERENCE_FOR_BLOCK_RAM ON -family "MAX 10"
	set_global_assignment -name OPTIMIZE_HOLD_TIMING "ALL PATHS" -family "MAX 10"
	set_global_assignment -name OPTIMIZE_MULTI_CORNER_TIMING ON -family "MAX 10"
	set_global_assignment -name AUTO_DELAY_CHAINS ON -family "MAX 10"
	set_global_assignment -name CRC_ERROR_OPEN_DRAIN OFF -family "MAX 10"
	set_global_assignment -name USE_CONFIGURATION_DEVICE ON -family "MAX 10"
	set_global_assignment -name ENABLE_OCT_DONE ON -family "MAX 10"

	# Commit assignments
	export_assignments

	# Close project
	if {$need_to_close_project} {
		project_close
	}
}
