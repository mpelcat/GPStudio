#!/bin/bash

rm threshold.proc
#rm -rf hdl

# block and flows
gpproc new -n threshold
gpproc sethelp -v "Simple process to create binary image from grayscale"
gpproc setcateg -v "morpho"
gpproc addflow -n in -d in -s 8
gpproc addflow -n out -d out -s 8
gpproc showblock

# IP infos
gpproc setinfo -n "author" -v "Sebastien CAUX"
gpproc setinfo -n "company" -v "Institut Pascal"
gpproc setinfo -n "revision" -v "1.0"
gpproc setinfo -n "releasedate" -v "2016-08-22"

# properties on flow out
gpproc addproperty -n out.datatype -t flowtype -v image
gpproc addproperty -n out.width -t int -m in.width.value
gpproc addproperty -n out.height -t int -m in.height.value

# register threshold
gpproc addproperty -n threshold -t sint -v 0
gpproc setproperty -n threshold -r 0:255
gpproc addparam -n threshold_reg -m threshold.value -r 0
gpproc setpisizeaddr -v 2

# visual settings
gpproc setdraw -f threshold.svg

# generate patterns files
gpproc generate -o hdl
gpproc addfile -p hdl/threshold.vhd -t vhdl -g hdl
gpproc addfile -p hdl/threshold_process.vhd -t vhdl -g hdl
gpproc addfile -p hdl/threshold_slave.vhd -t vhdl -g hdl
