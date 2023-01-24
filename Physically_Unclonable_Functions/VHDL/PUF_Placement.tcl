set osc_root "|toplevel|ro_puf:puf|ring_oscillator:"
set osc_pattern_group1  "cir_gen:%s:ro_g1|chain\[%s\]"
set osc_pattern_group2  "cir_gen:%s:ro_g2|chain\[%s\]"

set count_root "|toplevel|ro_puf:puf|counter:"
set count_pattern_group1  "cir_gen:%s:c_g1|"
set count_pattern_group2  "cir_gen:%s:c_g2|"

set osc_group1_pattern "${osc_root}\\${osc_pattern_group1}"
set osc_group2_pattern "${osc_root}\\${osc_pattern_group2}"

set count_group1_pattern "${count_root}\\${count_pattern_group1}"
set count_group2_pattern "${count_root}\\${count_pattern_group2}"

set puf_list [ list 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15]

set const_row 53

proc get_row { chain_idx } {
	return [expr ${chain_idx} + 54]
}

proc get_n1 { puf } {
	return [expr 4 * ${puf}]
}

proc get_n2 { puf } {
	return [expr 4 * ${puf} + 2]
}

foreach puf ${puf_list} {
    foreach chain_idx {0 1 2 3 4 5 6 7 8 9 10 11 12} {
	    set ring_group1 [ format ${osc_group1_pattern} ${puf} ${chain_idx} ]
	    set row [ get_row ${chain_idx} ]
		 set n1 [ get_n1 ${puf}]
		 set ring1_loc "LCCOMB_X${row}_Y${const_row}_N${n1}"
		 set_location_assignment ${ring1_loc} -to ${ring_group1}
	    		 
		 set ring_group2 [ format ${osc_group2_pattern} ${puf} ${chain_idx} ] 
		 set n2 [ get_n2 ${puf}]
		 set ring2_loc "LCCOMB_X${row}_Y${const_row}_N${n2}"
	    set_location_assignment ${ring2_loc} -to ${ring_group2}
    }	    
}    
