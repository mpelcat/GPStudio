#!/usr/bin/tclsh

proc inst_scan {inst_name} {
  set sub_inst_list [lsort [find instances -recursive "$inst_name/*"]]
  set inst ""
  foreach inst $sub_inst_list {
    puts "Instance found: $inst"
    add_group $inst
    # inst_scan $inst
  }
}

#-----------------------------------------------------------------------------
# proc: add_wave
#
# Add wave in waveform window
#-----------------------------------------------------------------------------
proc add_wave {group_def inst_name} {
 set obj_type_list  {
  {-ports} {"I/O ports"}
  {-internal} {Internals}
  }
  foreach {obj_type obj_group_name} $obj_type_list {
    set sig_list [lsort [find signals $inst_name/*]]
    foreach sig $sig_list {
       set CMD "add wave -noupdate -hex $group_def -group $obj_group_name $obj_type $sig"
       # puts $CMD
       if { [catch {eval $CMD} fid] } {
       }
    }
  }
}

#-----------------------------------------------------------------------------
# proc: add_group
#
# Add group in waveform window
#-----------------------------------------------------------------------------
proc add_group {inst_name} {
  set ggg [split $inst_name "\ "]
  set inst_path [lindex $ggg 0]
  set group_list [split $inst_path "/"]
  # puts "group_list: $group_list"
  # puts "ggg: [lindex $ggg 0]"
  set group_def ""
  foreach i $group_list {
    if {$i != ""} {
      # puts "group: $i"
      append group_def "\-group\ \"$i\" "
    }
  }
  # puts "group_def: $group_def"
  add_wave $group_def $inst_path
}

#-----------------------------------------------------------------------------
# proc: auto_vaves
#
# Populate waveform window
#-----------------------------------------------------------------------------
proc auto_waves {} {
  # Scan instances in current directory
  inst_scan ""

  # Wave display configuration
  configure wave -namecolwidth 220
  configure wave -valuecolwidth 100
  configure wave -justifyvalue left
  configure wave -signalnamewidth 1
  configure wave -snapdistance 10
  configure wave -datasetprefix 0
  configure wave -rowmargin 4
  configure wave -childrowmargin 2
  configure wave -gridoffset 0
  configure wave -gridperiod 1
  configure wave -griddelta 40
  configure wave -timeline 0
  configure wave -timelineunits us
}

#-----------------------------------------------------------------------------
# proc: c_lib
#
# Launch libraries compilation
# Needs to be launch ones
#-----------------------------------------------------------------------------
proc c_lib {} {
  set path_to_quartus C:/Altera/13.1/quartus/
  # set path_to_quartus D:/Logiciels/Altera/13.1/quartus/
  
  vlib altera_mf
	vmap altera_mf altera_mf
	vcom -work altera_mf -2002 -explicit $path_to_quartus/eda/sim_lib/altera_mf_components.vhd
	#vlog -work altera_mf  $path_to_quartus/eda/sim_lib/altera_mf.v
	vcom -work altera_mf  $path_to_quartus/eda/sim_lib/altera_mf.vhd
  
  # vlib synplify
  # vmap synplify synplify
	# vcom -work altera_mf -2002 -explicit $path_to_quartus/eda/synthesis/lpm.vhd
  vlib lpm
  vmap lpm lpm
  # vlog -work altera_mf  $path_to_quartus/eda/synthesis/lpm.v
  vcom -work lpm  $path_to_quartus/eda/sim_lib/220pack.vhd
  vcom -work lpm  $path_to_quartus/eda/sim_lib/220model.vhd
}

#-----------------------------------------------------------------------------
# proc: c
#
# Launch hdl compilation
#-----------------------------------------------------------------------------
proc c {} {

  
  vlib work
  vmap work work
  vcom -93 -work work ../../src/fifo_com_rx.vhd
  vcom -93 -work work ../../src/com_flow_fifo_rx.vhd
  # vcom -93 -work work ../../src/read_flow.vhd
  vcom -93 -work work ../../../ReadFlow/src/read_flow.vhd
  vcom -93 -work work ../../tb/tb_comflow_fifo.vhd

}

#-----------------------------------------------------------------------------
# proc: s
#
# Launc simulation
#-----------------------------------------------------------------------------
proc s {} {
  vsim -gFIFO_DEPTH=255 -gFLOW_ID=2 -novopt -t 10ps work.tb_comflow_fifo(behavioral)

   auto_waves

	run 250 us

}

#-----------------------------------------------------------------------------
# proc: cs
#
# Launch compil & simulation
#-----------------------------------------------------------------------------
proc cs {} {
  c
  s
}

proc rs {} {
  restart
  run 200 us
}

proc clean {} {


vmap -del caph_top_lib
vdel -all -lib caph_top_lib

vmap -del caph
vdel -all -lib caph


vmap -del work
vdel -all -lib work

}

#-----------------------------------------------------------------------------
# proc: mnu
#
# Display help menu
#-----------------------------------------------------------------------------
proc mnu {} {
	puts "------------"
	puts "Command list"
	puts "------------"
	puts ""
	puts " mnu   display this menu"
	puts " c_lib launch libraries compilation"
	puts " c     launch hdl compilation"
	puts " s     launch simulation"
	puts " cs    launch compil and simulation"
}

mnu