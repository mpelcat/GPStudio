#!/bin/bash

rm negate.proc
#rm -rf hdl

# block and flows
gpproc new -n negate
gpproc sethelp -v "Negation process from image flow"
gpproc addflow -n in -d in -s 8
gpproc addflow -n out -d out -s 8
gpproc showblock

# IP infos
gpproc setinfo -n "author" -v "Raphael BOUTERIGE"
gpproc setinfo -n "company" -v "Institut Pascal"
gpproc setinfo -n "revision" -v "1.0"
gpproc setinfo -n "releasedate" -v "2016-11-02"

# properties on flow out
gpproc addproperty -n out.datatype -t flowtype -v image
gpproc addproperty -n out.width -t int -m in.width.value
gpproc addproperty -n out.height -t int -m in.height.value
# const negate_strength
#gpproc addparam -n NEGATE_STRENGTH -t INTEGER -v 255

# PI parameters
gpproc setpisizeaddr -v 2

# register status_reg for enable propertY
gpproc addparam -n status_reg -r 0
gpproc addproperty -n enable -t bool -v 1
gpproc addbitfield -n status_reg.enable_bit -b 0 -m enable.value


# visual settings
gpproc setdraw -f negate.svg

# generate patterns files
#gpproc generate -o hdl
gpproc addfile -p hdl/negate.vhd -t vhdl -g hdl
gpproc addfile -p hdl/negate_process.vhd -t vhdl -g hdl
gpproc addfile -p hdl/negate_slave.vhd -t vhdl -g hdl




