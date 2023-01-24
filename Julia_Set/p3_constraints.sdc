create_clock -period "50.0 MHz" [get_ports clock] 
derive_pll_clocks
derive_clock_uncertainty