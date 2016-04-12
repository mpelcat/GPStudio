#!/bin/bash
	
	gpdevice new -n gps

	#Files
	gpdevice addfile -p hdl/gps_acqui.vhd -t vhdl -g hdl
	gpdevice addfile -p hdl/gps_receiver.vhd -t vhdl -g hdl
	gpdevice addfile -p hdl/gps_fifo.vhd -t vhdl -g hdl
	gpdevice addfile -p hdl/gps_transmitter.vhd -t vhdl -g hdl
	gpdevice addfile -p hdl/gps_clkgen.vhd -t vhdl -g hdl
	gpdevice addfile -p hdl/gps.vhd -t vhdl -g hdl
	gpdevice addfile -p hdl/gps_slave.vhd -t vhdl -g hdl
	gpdevice addfile -p hdl/gps_pkg.vhd -t vhdl -g hdl

	#Flows
	gpdevice addflow -n out -d out -s 8

	#Flow properties
	gpdevice addproperty -n out.datatype -t flowtype -v vector
	gpdevice addproperty -n out.itemdatatype -t hwtype -v s16
	gpdevice addproperty -n out.swtype -t swtype -v float
	gpdevice addproperty -n out.scaling -t function -v item.value*2

	#Reset
	gpdevice addreset -n reset_n -d in -g reset_n

	#External ports
	gpdevice addextport -n RXD -t in -s 1
	gpdevice addextport -n TXD -t out -s 1

	gpdevice setpisizeaddr -v 3
	
	#Enable
	gpdevice addparam -n enable_reg -r 0 -m enable.value
	gpdevice addproperty -n enable -t bool
	gpdevice setproperty -n enable -l "Enable"
	
	#Acquisition
	gpdevice addparam -n acqui_reg -r 1 -m acqui.value
	gpdevice addproperty -n acqui -t bool
	gpdevice setproperty -n acqui -l "Acquisition"

	#Satellite mode
	gpdevice addparam -n sat_reg -r 2 -m sat_mode.bits
	gpdevice addproperty -n sat_mode -t enum
	gpdevice addenum -n sat_mode.s0 -l "GPS/Glonass" -v 0 
	gpdevice addenum -n sat_mode.s1 -l "GPS" -v 1 
	gpdevice setproperty -n sat_mode -l "Mode"

	#Update rate
	gpdevice addparam -n update_reg -r 3 -m update.bits
	gpdevice addproperty -n update -t enum
	gpdevice addenum -n update.u1 -l "1 Hz" -v 1 
	gpdevice addenum -n update.u2 -l "2 Hz" -v 2 
	gpdevice addenum -n update.u4 -l "4 Hz" -v 4
	gpdevice addenum -n update.u5 -l "5 Hz" -v 5
	gpdevice addenum -n update.u8 -l "8 Hz" -v 8
	gpdevice addenum -n update.u10 -l "10 Hz" -v 10 
	gpdevice addenum -n update.u20 -l "20 Hz" -v 20 
	gpdevice addenum -n update.u25 -l "25 Hz" -v 25 
	gpdevice addenum -n update.u40 -l "40 Hz" -v 40    
	gpdevice setproperty -n update -l "Update rate"

	#Generate device
	gpdevice generate -o build/
	

