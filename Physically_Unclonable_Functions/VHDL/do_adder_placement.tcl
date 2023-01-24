set signal_root "|toplevel|carry_select_adder:adder|ripple_carry_adder:"
set rca_pattern "select_chain:%s:adders:%s:rca|adder:"
set psum_pattern "adder_chain:%s:u0|p_sum\[%s\]"
set pcarry_pattern "adder_chain:%s:u0|p_carry\[%s\]"

set net_psum_pattern "${signal_root}\\${rca_pattern}\\${psum_pattern}"
set net_pcarry_pattern "${signal_root}\\${rca_pattern}\\${pcarry_pattern}"

set select_chain_list [ list 0 1 ]
set adder_list [ list 0 1 2 ]
set adder_chain_list { { 0 1 } { 0 1 2 } { 0 1 2 3 } }

set adders_row 53

proc get_adder_column { select_chain } {
	set base 54
	return [ expr ${base} - 2 * ${select_chain} ]
}

proc get_carry_column { select_chain } {
	set base 56
	return [ expr ${base} - 6 * ${select_chain} ]
}

proc get_row { adder adder_chain } {
	set base [ list 0 2 5 ]
	set offset [ lindex ${base} ${adder} ]
	return [ expr 2 * (${offset} + ${adder_chain}) ]
}

foreach select_chain ${select_chain_list} {
	foreach adder ${adder_list} {
		set adder_chain [ lindex ${adder_chain_list} ${adder} ]
		foreach adder_chain_instance ${adder_chain} {
			foreach element { 0 1 } {
				set adder_n [ get_row ${adder} ${adder_chain_instance} ]
				set adder_x [ get_adder_column ${select_chain} ]
				set carry_x [ get_carry_column ${select_chain} ]
				if { ${select_chain} == 0 } {
					set adder_x [ expr ${adder_x} + ${element} ]
					set carry_x [ expr ${carry_x} + ${element} ]
				} else {
					set adder_x [ expr ${adder_x} - ${element} ]
					set carry_x [ expr ${carry_x} - ${element} ]
				}

				set net_sum [ format ${net_psum_pattern} ${select_chain} \
							${adder} ${adder_chain_instance} \
										${element} ]
				set net_carry [ format ${net_pcarry_pattern} ${select_chain} \
							${adder} ${adder_chain_instance} \
										${element} ]


				set sum_loc "LCCOMB_X${adder_x}_Y${adders_row}_N${adder_n}"
				set carry_loc "LCCOMB_X${carry_x}_Y${adders_row}_N${adder_n}"
				
				puts "${sum_loc}"
				
			}
		}
	}
}

