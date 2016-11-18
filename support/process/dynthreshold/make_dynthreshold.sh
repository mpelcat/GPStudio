#!/bin/bash

rm dynthreshold.proc
rm -rf hdl

# block and flows
gpproc new -n dynthreshold
gpproc sethelp -v "Dynamic threshold based on a desired ratio of white"
gpproc addflow -n in -d in -s 8
gpproc addflow -n out -d out -s 8
gpproc showblock

# properties on flow out
gpproc addproperty -n out.datatype -t flowtype -v image
gpproc addproperty -n out.width -t int -m in.width.value
gpproc addproperty -n out.height -t int -m in.height.value

gpproc setpisizeaddr -v 2

# register threshold
gpproc addproperty -n "DesiredRatio" -t sint -v 5
gpproc setproperty -n "DesiredRatio" -r 0:100
gpproc addparam -n desired_ratio_reg -m "DesiredRatio".value -r 3

# visual settings
gpproc setdraw -f dynthreshold.svg

# generate patterns files
gpproc generate -o hdl
gpproc addfile -p hdl/dynthreshold.vhd -t vhdl -g hdl
gpproc addfile -p hdl/dynthreshold_process.vhd -t vhdl -g hdl
gpproc addfile -p hdl/dynthreshold_slave.vhd -t vhdl -g hdl
