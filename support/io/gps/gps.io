<?xml version="1.0" encoding="UTF-8"?>
<io driver="gps" categ="" pi_size_addr_rel="2" desc="">
  <files>
    <file name="gps_acqui.vhd" type="vhdl" group="hdl" path="hdl/gps_acqui.vhd" desc=""/>
    <file name="gps_receiver.vhd" type="vhdl" group="hdl" path="hdl/gps_receiver.vhd" desc=""/>
    <file name="gps_fifo.vhd" type="vhdl" group="hdl" path="hdl/gps_fifo.vhd" desc=""/>
    <file name="gps.vhd" type="vhdl" group="hdl" path="hdl/gps.vhd" desc=""/>
    <file name="gps_slave.vhd" type="vhdl" group="hdl" path="hdl/gps_slave.vhd" desc=""/>
  </files>
  <resets>
    <reset name="reset_n" group="reset_n" direction="in" desc=""/>
  </resets>
  <flows>
    <flow name="gps_out" size="8" type="out" desc=""/>
  </flows>
  <params>
    <param name="enable_reg" value="" regaddr="0" propertymap="enable.value" default="" min="" max="" desc=""/>
  </params>
  <properties>
    <property name="enable" value="" caption="Enable" type="bool" min="" max="" step="" assert="" propertymap="" onchange="" desc=""/>
  </properties>
  <ports>
    <port name="RXD" type="in" size="1" desc=""/>
  </ports>
  <pins/>
</io>
