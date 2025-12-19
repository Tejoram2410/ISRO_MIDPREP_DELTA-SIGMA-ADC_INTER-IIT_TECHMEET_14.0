
set    	MAX_SKEW	false 	; 	#Advances sequential elements more aggressively than it does by default, without degrading the worst negative slack (default=> false).

set 	MAX_DELAY 	1 	; 	#Limits the amount of slack (in nanoseconds) that the software can borrow from neighboring flip-flops when performing useful skew operations (default=> 1). Range : 0.000000 - 9223372036854775808.000000 ns.

set 	MIN_DELAY 	0 	; 	#Allows the tool to skip any skewing that would be smaller than the minimum delay (default=> 0). Range : 0.000000 - 9223372036854775808.000000 ns.

set 	BOUNDARY 	false 	; 	#Excludes or includes boundary sequential cells in addition to ordinary sequential elements in useful skew calculations (default=> false).

set 	ECO_ROUTE 	true 	; 	#Uses the NanoRoute detailed router to route nets that are added or changed during useful skew optimization (default=> false).

set 	MACRO_ONLY 	false 	; 	#Allows you to limit skewing only for macro cells. Regular sequential elements will not be skewed.

set 	CELLS_NAME 	{dl03d2 buffd1 bufbd2 buffd7 dl01d1 bufbd1 bufbd3 dl01d2 bufbd4 dl02d4 dl04d4 buffd4 bufbdk bufbda buffd3 dl01d4 dl02d1 dl04d2 dl03d4 dl02d2 buffda bufbdf dl03d1 buffd2 bufbd7 dl04d1 inv0d4 invbdf invbd7 inv0d0 invbd2 invbd4 inv0d7 inv0d1 invbdk inv0da invbda inv0d2} ; #Specifies the cells to be used during post-CTS buffer insertion.

######################################################
## Sets global parameters for the skewClock command.
######################################################

setUsefulSkewMode \
	-maxSkew $MAX_SKEW \
	-noBoundary $BOUNDARY \
	-useCells $CELLS_NAME \
	-maxAllowedDelay $MAX_DELAY \
	-ecoRoute $ECO_ROUTE \
	-macroOnly $MACRO_ONLY

set 	OPT_EFFORT 	high 	; 	# Specifies high effort level to reach timing closure for challenging designs. This level activates all the physical synthesis optimization transforms. Specifies low effort level. This level triggers global resizing and buffering in order to obtain a good timing result in the fastest run time.

set 	PIN_SWAPING 	true 	; 	# Controls whether timing optimization allows pin swapping (default=> true). **not enabled when -effort is set to low.

set 	RESTRUCTURING 	true 	; 	# Controls whether timing optimization swaps pins and restructures the netlist (default=> true). **not enabled when -effort is set to low.

set 	DOWNSIZING 	true 	; 	# Controls whether timing optimization can downsize instances (default=> true).

set 	DELETE_INST 	true 	; 	# Controls whether timing optimization can delete instances default=> true.

set 	POWER_EFFORT 	NONE 	; 	# TO provide the effort level for optimizing leakage power and dynamic power in the design. Power-driven optimization implies that the optDesign command now performs Power, Performance, and Area (PPA) trade-offs at the transform level at every step of timing optimization.

set 	POWER_RATIO 	1 	; 	# Controls the priority of the power-driven optimization. You can set any value between 0->(dynamic power-driven optimization) and 1->(leakage-power driven optimization). Default value is 1.

set 	RECLAIM_AREA 	true 	; 	# Controls whether timing optimization creates additional space by downsizing gates or deleting buffers, while maintaining worst slack and total negative slack. Used to reclaim area during preRoute stage only.

set 	SIMPLIFY_NETLIST 	true 	; 	# ecovers area, decreases congestion, and improves runtime by simplifying the netlist.

set 	SETUP_SLACK 	0.2 	; 	# Specifies a target slack value in nanoseconds for setup analysis. If we specify this value only the hold target slack will set to 0.

set 	HOLD_SLACK 	0.2 	; 	# Specifies a target slack value in nanoseconds to use for hold analysis only. If you specify -holdTargetSlack only, the -setupTargetSlack value is 0.

set 	MAX_AREA_DENSITY 	0.95 	; 	# Specifies the maximum value for density (area utilization). Netlist will not grow over this value (default => 0.95).

set 	DRV_MARGIN 	0.1 	; 	# Scales the maxCap and maxTran constraints according to the margin decimal value specified.

set 	USEFUL_SKEW 	true 	; 	# This parameter produces scheduling and latency files before CTS runs, or adds buffers and inverters after CTS (default=> true). **Not enabled when -effort is set to low.

set 	USEFUL_SKEW_preCTS 	true 	; 	# Useful skew in preCTS optimization (default=> true).

set 	USEFUL_SKEW_postRoute 	true 	; 	# useful skew in postRoute optimization (default=> true).

setOptMode \
	-effort $OPT_EFFORT \
	-powerEffort $POWER_EFFORT \
	-leakageToDynamicRatio $POWER_RATIO \
	-reclaimArea $RECLAIM_AREA \
	-simplifyNetlist $SIMPLIFY_NETLIST \
	-swapPin $PIN_SWAPING \
	-restruct $RESTRUCTURING \
	-deleteInst $DELETE_INST \
	-downsizeInst $DOWNSIZING \
	-setupTargetSlack $SETUP_SLACK \
	-holdTargetSlack $HOLD_SLACK \
	-maxDensity $MAX_AREA_DENSITY \
	-drcMargin $DRV_MARGIN \
	-usefulSkew $USEFUL_SKEW \
	-usefulSkewPreCTS $USEFUL_SKEW_preCTS \
	-usefulSkewPostRoute $USEFUL_SKEW_postRoute

#########################################################
## SETUP OPTIMIZATION
#########################################################

set timing_report_s [report_timing -collection -late]

set slack_time_s [get_property $timing_report_s slack]

if { $slack_time_s < 0.2 } {
puts "Optimizing for Slack"
optDesign -postCTS -drv
puts "Optimization Complete"
} else {
puts "No SETUP slack violation 1"
}

set timing_report_s [report_timing -collection -late]

set slack_time_s [get_property $timing_report_s slack]

if { $slack_time_s < 0.2 } {
puts "Optimizing for Slack"
optDesign -postCTS -incr
puts "Optimization Complete"
} else {
puts "No SETUP slack violation 2"
}

set timing_report_s [report_timing -collection -late]

set slack_time_s [get_property $timing_report_s slack]

if { $slack_time_s < 0.2 } {
puts "Optimizing for Slack"
optDesign -postCTS -incr
puts "Optimization Complete"
} else {
puts "No SETUP slack violation 3"
}

set timing_report_s [report_timing -collection -late]

set slack_time_s [get_property $timing_report_s slack]

if { $slack_time_s < 0.2 } {
puts "Optimizing for Slack"
optDesign -postCTS -incr
puts "Optimization Complete"
} else {
puts "No SETUP slack violation 4"
}

#########################################################
## HOLD OPTIMIZATION
#########################################################

set timing_report_h [report_timing -collection -early]

set slack_time_h [get_property $timing_report_h slack]

if { $slack_time_h < 0.2 } {
puts "Optimizing for Slack"
optDesign -postCTS -hold 
puts "Optimization Complete"
} else {
puts "No HOLD slack violation 1"
}

set timing_report_h [report_timing -collection -early]

set slack_time_h [get_property $timing_report_h slack]

if { $slack_time_h < 0.2 } {
puts "Optimizing for Slack"
optDesign -postCTS -hold -incr
puts "Optimization Complete"
} else {
puts "No HOLD slack violation 2"
}

set timing_report_h [report_timing -collection -early]

set slack_time_h [get_property $timing_report_h slack]

if { $slack_time_h < 0.2 } {
puts "Optimizing for Slack"
optDesign -postCTS -hold -incr
puts "Optimization Complete"
} else {
puts "No HOLD slack violation 3"
}

set timing_report_h [report_timing -collection -early]

set slack_time_h [get_property $timing_report_h slack]

if { $slack_time_h < 0.2 } {
puts "Optimizing for Slack"
optDesign -postCTS -hold -incr
puts "Optimization Complete"
} else {
puts "No HOLD slack violation 4"
}

