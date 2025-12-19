
current_design top_module
create_clock  -name vir_clk_i -period 200.000000 -waveform {0.000000 100.000000}
create_clock [get_ports {clk_pad}]  -name clk_a -period 200.000000 -waveform {0.000000 100.000000}
set_clock_latency -source -early -min  1.25 [get_clocks {clk_a}]
set_clock_latency -source -early -max  1 [get_clocks {clk_a}]
set_clock_latency -source -late -min  0.75 [get_clocks {clk_a}]
set_clock_latency -source -late -max  1.25 [get_clocks {clk_a}]
set_clock_transition  -rise -min 25 [get_clocks {clk_a}]
set_clock_transition  -rise -max 40 [get_clocks {clk_a}]
set_clock_transition  -fall -min 25 [get_clocks {clk_a}]
set_clock_transition  -fall -max 40 [get_clocks {clk_a}]
set_propagated_clock  [get_ports {clk_pad}]
set_clock_uncertainty 5 [get_clocks {clk_a}]
set_clock_latency -source -early -min -rise  -0.143323 [get_ports {clk_pad}] -clock clk_a 
set_clock_latency -source -early -min -fall  -0.669225 [get_ports {clk_pad}] -clock clk_a 
set_clock_latency -source -early -max -rise  -0.393323 [get_ports {clk_pad}] -clock clk_a 
set_clock_latency -source -early -max -fall  -0.919225 [get_ports {clk_pad}] -clock clk_a 
set_clock_latency -source -late -min -rise  -0.643323 [get_ports {clk_pad}] -clock clk_a 
set_clock_latency -source -late -min -fall  -1.16923 [get_ports {clk_pad}] -clock clk_a 
set_clock_latency -source -late -max -rise  -0.143323 [get_ports {clk_pad}] -clock clk_a 
set_clock_latency -source -late -max -fall  -0.669225 [get_ports {clk_pad}] -clock clk_a 
