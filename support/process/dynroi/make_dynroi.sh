#!/bin/bash

rm dynroi.proc
rm -rf hdl

# block and flows
gpproc new -n dynroi
gpproc sethelp -v "Dynamic region of interest extractor"
gpproc addflow -n in -d in -s 8

gpproc addflow -n in_x -d in -s 16
gpproc addflow -n in_y -d in -s 16
gpproc addflow -n in_w -d in -s 16
gpproc addflow -n in_h -d in -s 16

gpproc addflow -n out -d out -s 8
gpproc showblock

# IP infos
gpproc setinfo -n "author" -v "Raphael Bouterige"
gpproc setinfo -n "company" -v "Institut Pascal"
gpproc setinfo -n "revision" -v "1.0"
gpproc setinfo -n "releasedate" -v "2016-11-25"

# PI parameters
gpproc setpisizeaddr -v 2

# register status_reg for enable and bypass properties
gpproc addparam -n status_reg -r 0
gpproc addproperty -n enable -t bool -v 1
gpproc addbitfield -n status_reg.enable_bit -b 0 -m enable.value
gpproc addproperty -n bypass -t bool -v 0
gpproc addbitfield -n status_reg.bypass_bit -b 1 -m bypass.value

# register input flow size
gpproc addparam -n in_size_reg -r 1
gpproc addbitfield -n in_size_reg.in_w_reg -b 11-0 -m in.width.value
gpproc addbitfield -n in_size_reg.in_h_reg -b 27-16 -m in.height.value

# register output flow size
gpproc addparam -n out_size_reg -r 2

gpproc addbitfield -n out_size_reg.out_w_reg -b 11-0 -m w.value
gpproc addproperty -n w -t int -v 32
gpproc setproperty -n w -r 1:4095

gpproc addbitfield -n out_size_reg.out_h_reg -b 27-16 -m h.value
gpproc addproperty -n h -t int -v 24
gpproc setproperty -n h -r 1:4095

# register output flow offset
gpproc addparam -n out_offset_reg -r 3

gpproc addbitfield -n out_offset_reg.out_x_reg -b 11-0 -m x.value
gpproc addproperty -n x -t int -v 0
gpproc setproperty -n x -r 0:4095

gpproc addbitfield -n out_offset_reg.out_y_reg -b 27-16 -m y.value
gpproc addproperty -n y -t int -v 0
gpproc setproperty -n y -r 0:4095

# properties on flow out
# to export proper resolution for cropped image
gpproc addproperty -n out.datatype -t flowtype -v image
gpproc addproperty -n out.width -t int  -m "enable.value? (bypass.value? (x.value+w.value>in.width.value? (x.value>in.width.value? 0 : in.width.value-x.value ) : (w.value) ) : (in_x+in_w>in.width.value? (in_x>in.width.value? 0 : in.width.value-in_x) : (in_w) )) : in.width.value"
gpproc addproperty -n out.height -t int -m "enable.value? (bypass.value? (y.value+h.value>in.height.value? (y.value>in.height.value? 0 : in.height.value-y.value ) : (h.value) ) : (in_y+in_h>in.height.value? (in_y>in.height.value? 0 : in.height.value-in_y) : (in_h) )) : in.height.value"

# visual settings
gpproc setdraw -f dynroi.svg

gpproc generate -o hdl
gpproc addfile -p hdl/dynroi.vhd -t vhdl -g hdl
gpproc addfile -p hdl/dynroi_process.vhd -t vhdl -g hdl
gpproc addfile -p hdl/dynroi_slave.vhd -t vhdl -g hdl
