set init_top_cell top_module
set_global report_timing_format {instance arc net cell slew delay arrival required} 

source config.tcl
create_ccopt_clock_tree_spec -file /ClockTreeSynthesis/${init_top_cell}_ccopt.spec 
source /ClockTreeSynthesis/${init_top_cell}_ccopt.spec 
ctd_win -id before_ccopt 

# Transition limit settings
set_ccopt_property -delay_corner max_delay -net_type top   target_max_trans 2 
set_ccopt_property -delay_corner min_delay -net_type top   target_max_trans 2 
set_ccopt_property -delay_corner max_delay -net_type trunk target_max_trans 2 
set_ccopt_property -delay_corner min_delay -net_type trunk target_max_trans 2 
set_ccopt_property -delay_corner max_delay -net_type leaf  target_max_trans 2 
set_ccopt_property -delay_corner min_delay -net_type leaf  target_max_trans 2 

# Skew group and source driver settings
set_ccopt_property -skew_group clk_a/all -delay_corner min_delay target_skew 0.6 
set_ccopt_property -delay_corner min_delay target_skew 0.6
set_ccopt_property source_driver pc3d01/CIN -clock_tree clk_a

# Cluster mode CTS
set_ccopt_property balance_mode cluster 
ccopt_design -cts 
ctd_win -id cluster_mode 

# Trial mode CTS
set_ccopt_property balance_mode trial 
ccopt_design -cts 
ctd_win -id trial_mode 

# Full mode CTS
set_ccopt_property balance_mode full 
ccopt_design -cts 
ctd_win -id full_mode 

# Reports
report_ccopt_clock_trees -summary -file ./ClockTreeSynthesis_15/${init_top_cell}_clock_trees.rpt 
report_ccopt_skew_groups -summary -file ./ClockTreeSynthesis_15/${init_top_cell}_skew_group.rpt 
reportCongestion -overflow -hotSpot > ./ClockTreeSynthesis_15/${init_top_cell}_congestion.rpt

