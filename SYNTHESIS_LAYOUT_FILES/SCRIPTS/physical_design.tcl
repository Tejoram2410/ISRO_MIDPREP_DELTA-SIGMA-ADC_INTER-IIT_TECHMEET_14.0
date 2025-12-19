set init_gnd_net {VSS_CORE VSSO_CORE}
set init_lef_file {/mnt/cadence_win/SCLPDK_V3.0_KIT/scl180/stdcell/fs120/4M1IL/lef/scl18fs120_tech.lef lef/tsl18cio150_4lm.lef /mnt/cadence_win/SCLPDK_V3.0_KIT/scl180/stdcell/fs120/4M1IL/lef/scl18fs120_std.lef}
set init_verilog netlist.v
set init_mmmc_file MMMC.view
set init_io_file topfinal.io
set init_top_cell top_module
set init_pwr_net {VDD_CORE VDDO_CORE}
init_design


getIoFlowFlag
setIoFlowFlag 0

floorPlan -site CoreSite -s 1940 1940 125 125 125 125
uiSetTool select
getIoFlowFlag
fit
addIoFiller -cell pfeed30000 pfeed10000 pfeed02000 pfeed01000 pfeed00540
addIoFiller -cell pfeed30000 pfeed10000 pfeed02000 pfeed01000 pfeed00540 pfeed00040 pfeed00010 -prefix FILLER -side n
addIoFiller -cell pfeed30000 pfeed10000 pfeed02000 pfeed01000 pfeed00540 pfeed00040 pfeed00010 -prefix FILLER -side s
addIoFiller -cell pfeed30000 pfeed10000 pfeed02000 pfeed01000 pfeed00540 pfeed00040 pfeed00010 -prefix FILLER -side w
addIoFiller -cell pfeed30000 pfeed10000 pfeed02000 pfeed01000 pfeed00540 pfeed00040 pfeed00010 -prefix FILLER -side e
fit
saveDesign top_module.enc
globalNetConnect VDD_CORE -type pgpin -pin VDD -all
globalNetConnect VSS_CORE -type pgpin -pin VSS -all
globalNetConnect VDDO_CORE -type pgpin -pin VDDO -all
globalNetConnect VSSO_CORE -type pgpin -pin VSSO -all
globalNetConnect VDD_CORE -type tiehi
globalNetConnect VSS_CORE -type tielo


set sprCreateIeRingOffset 1.0
set sprCreateIeRingThreshold 1.0
set sprCreateIeRingJogDistance 1.0
set sprCreateIeRingLayers {}
set sprCreateIeRingOffset 1.0
set sprCreateIeRingThreshold 1.0
set sprCreateIeRingJogDistance 1.0
set sprCreateIeRingLayers {}
set sprCreateIeStripeWidth 10.0
set sprCreateIeStripeThreshold 1.0
set sprCreateIeStripeWidth 10.0
set sprCreateIeStripeThreshold 1.0
set sprCreateIeRingOffset 1.0
set sprCreateIeRingThreshold 1.0
set sprCreateIeRingJogDistance 1.0
set sprCreateIeRingLayers {}
set sprCreateIeStripeWidth 10.0
set sprCreateIeStripeThreshold 1.0
setAddRingMode -ring_target default -extend_over_row 0 -ignore_rows 0 -avoid_short 0 -skip_crossing_trunks none -stacked_via_top_layer TOP_M -stacked_via_bottom_layer M1 -via_using_exact_crossover_size 1 -orthogonal_only true -skip_via_on_pin {  standardcell } -skip_via_on_wire_shape {  noshape }
addRing -nets {VDD_CORE VSS_CORE} -type core_rings -follow core -layer {top TOP_M bottom TOP_M left M3 right M3} -width {top 25 bottom 25 left 25 right 25} -spacing {top 10 bottom 10 left 10 right 10} -offset {top 1.8 bottom 1.8 left 1.8 right 1.8} -center 1 -threshold 0 -jog_distance 0 -snap_wire_center_to_grid None

set sprCreateIeRingOffset 1.0
set sprCreateIeRingThreshold 1.0
set sprCreateIeRingJogDistance 1.0
set sprCreateIeRingLayers {}
set sprCreateIeRingOffset 1.0
set sprCreateIeRingThreshold 1.0
set sprCreateIeRingJogDistance 1.0
set sprCreateIeRingLayers {}
set sprCreateIeStripeWidth 10.0
set sprCreateIeStripeThreshold 1.0
set sprCreateIeStripeWidth 10.0
set sprCreateIeStripeThreshold 1.0
set sprCreateIeRingOffset 1.0
set sprCreateIeRingThreshold 1.0
set sprCreateIeRingJogDistance 1.0
set sprCreateIeRingLayers {}
set sprCreateIeStripeWidth 10.0
set sprCreateIeStripeThreshold 1.0

setAddStripeMode -ignore_block_check false -break_at none -route_over_rows_only false -rows_without_stripes_only false -extend_to_closest_target none -stop_at_last_wire_for_area false -partial_set_thru_domain false -ignore_nondefault_domains false -trim_antenna_back_to_shape none -spacing_type edge_to_edge -spacing_from_block 0 -stripe_min_length stripe_width -stacked_via_top_layer TOP_M -stacked_via_bottom_layer M1 -via_using_exact_crossover_size false -split_vias false -orthogonal_only true -allow_jog { padcore_ring  block_ring } -skip_via_on_pin {  standardcell } -skip_via_on_wire_shape {  noshape   }
addStripe -nets {VDD_CORE VSS_CORE} -layer TOP_M -direction vertical -width 10 -spacing 10 -set_to_set_distance 100 -start_from left -switch_layer_over_obs false -max_same_layer_jog_length 2 -padcore_ring_top_layer_limit TOP_M -padcore_ring_bottom_layer_limit M1 -block_ring_top_layer_limit TOP_M -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid None


setSrouteMode -viaConnectToShape { noshape }
sroute -connect { padPin corePin floatingStripe } -layerChangeRange { M1(1) TOP_M(4) } -blockPinTarget { nearestTarget } -padPinPortConnect { allPort oneGeom } -padPinTarget { nearestTarget } -corePinTarget { firstAfterRowEnd } -floatingStripeTarget { blockring padring ring stripe ringpin blockpin followpin } -allowJogging 1 -crossoverViaLayerRange { M1(1) TOP_M(4) } -nets { VDD_CORE VSS_CORE } -allowLayerChange 1 -targetViaLayerRange { M1(1) TOP_M(4) }


saveDesign top_module_powerplan.enc


setRouteMode -earlyGlobalHonorMsvRouteConstraint false -earlyGlobalRoutePartitionPinGuide true
setEndCapMode -reset
setEndCapMode -boundary_tap false
setNanoRouteMode -quiet -droutePostRouteSpreadWire 1
setNanoRouteMode -quiet -timingEngine {}
setUsefulSkewMode -maxSkew false -noBoundary false -useCells {dl03d2 buffd1 bufbd2 buffd7 dl01d1 bufbd1 bufbd3 dl01d2 bufbd4 dl02d4 dl04d4 buffd4 bufbdk bufbda buffd3 dl01d4 dl02d1 dl04d2 dl03d4 dl02d2 buffda bufbdf dl03d1 buffd2 bufbd7 dl04d1 inv0d4 invbdf invbd7 inv0d0 invbd2 invbd4 inv0d7 inv0d1 invbdk inv0da invbda inv0d2} -maxAllowedDelay 1
setPlaceMode -reset
setPlaceMode -congEffort high -timingDriven 1 -clkGateAware 1 -powerDriven 0 -ignoreScan 1 -reorderScan 1 -ignoreSpare 0 -placeIOPins 0 -moduleAwareSpare 0 -preserveRouting 1 -rmAffectedRouting 0 -checkRoute 0 -swapEEQ 0
setPlaceMode -fp false
place_design

saveDesign top_module_placement.enc

source cts.tcl

source cts_sta.tcl


setNanoRouteMode -reset
setNanoRouteMode -routeTopRoutingLayer 4
setNanoRouteMode -routeBottomRoutingLayer 1
setNanoRouteMode -routeWithTimingDriven true
setNanoRouteMode -routeWithSiDriven true

setNanoRouteMode -drouteFixAntenna true
setNanoRouteMode -routeInsertAntennaDiode true
setNanoRouteMode -routeAntennaCellName adiode

setNanoRouteMode -drouteEndIteration default   ;
setNanoRouteMode -drouteAutoStop 0

routeDesign -globalDetail
verify_drc


# Enable antenna fixing modes
setNanoRouteMode -drouteFixAntenna true
setNanoRouteMode -routeInsertAntennaDiode true
setNanoRouteMode -routeAntennaCellName adiode

# Run ECO routing (this WILL fix antenna)
ecoRoute



