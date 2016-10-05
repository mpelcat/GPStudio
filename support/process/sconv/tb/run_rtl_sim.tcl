#!/usr/bin/tclsh

proc c_lib {} {
  set path_to_quartus C:/altera/91sp2/quartus

  vlib altera_mf
	vmap altera_mf altera_mf
	vcom -work altera_mf -2002 -explicit $path_to_quartus/eda/sim_lib/altera_mf_components.vhd
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

proc c {} {
	 
  set path_to_projectfiles ./ 

  vlib work
  vmap work work

  

  vcom -93 -work work $path_to_projectfiles/conv.vhd
  vcom -93 -work work $path_to_projectfiles/kernel_3x3.vhd
  vcom -93 -work work $path_to_projectfiles/Pipliner_3x3.vhd
    vcom -93 -work work $path_to_projectfiles/pipline_gen.vhd
  vcom -93 -work work $path_to_projectfiles/tb_conv.vhd

}

proc s {} {
  vsim -novopt -t 1ps -L altera_mf  -L cycloneii work.tb_conv
  
  source auto_wave.tcl

  # run 20 us
  # force -freeze sim:/tb_top/TOP_INST/SWAP_MEM_INST/patch_count_r X\"5\" 0
  
  # force -freeze sim:/tb_top/TOP_INST/SWAP_MEM_INST/patch_x_i x\"1234\" 0
  # force -freeze sim:/tb_top/TOP_INST/SWAP_MEM_INST/patch_y_i x\"5678\" 0
  run 8000 ns

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
