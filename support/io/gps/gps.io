<?xml version="1.0" encoding="UTF-8"?>
<io driver="gps" categ="" pi_size_addr_rel="8" desc="">
  <files>
    <file name="gps_acqui.vhd" type="vhdl" group="hdl" path="hdl/gps_acqui.vhd" desc=""/>
    <file name="gps_receiver.vhd" type="vhdl" group="hdl" path="hdl/gps_receiver.vhd" desc=""/>
    <file name="gps_fifo.vhd" type="vhdl" group="hdl" path="hdl/gps_fifo.vhd" desc=""/>
    <file name="gps_transmitter.vhd" type="vhdl" group="hdl" path="hdl/gps_transmitter.vhd" desc=""/>
    <file name="gps_clkgen.vhd" type="vhdl" group="hdl" path="hdl/gps_clkgen.vhd" desc=""/>
    <file name="gps.vhd" type="vhdl" group="hdl" path="hdl/gps.vhd" desc=""/>
    <file name="gps_slave.vhd" type="vhdl" group="hdl" path="hdl/gps_slave.vhd" desc=""/>
    <file name="gps_pkg.vhd" type="vhdl" group="hdl" path="hdl/gps_pkg.vhd" desc=""/>
  </files>
  <resets>
    <reset name="reset_n" group="reset_n" direction="in" desc=""/>
  </resets>
  <flows>
    <flow name="gps_out" size="8" type="out" desc=""/>
  </flows>
  <params>
    <param name="enable_reg" value="" regaddr="0" propertymap="Enable.value" default="" min="" max="" desc=""/>
    <param name="acqui_reg" value="" regaddr="1" propertymap="acqui.value" default="" min="" max="" desc=""/>
    <param name="sat_reg" value="" regaddr="2" propertymap="sat_mode.bits" default="" min="" max="" desc=""/>
    <param name="update_reg" value="" regaddr="3" propertymap="update.bits" default="" min="" max="" desc=""/>
  </params>
  <properties>
    <property name="Enable" value="" caption="Enable" type="bool" min="" max="" step="" assert="" propertymap="" onchange="" desc=""/>
    <property name="acqui" value="" caption="acqui" type="bool" min="" max="" step="" assert="" propertymap="" onchange="" desc=""/>
    <property name="sat_mode" value="" caption="Mode" type="enum" min="" max="" step="" assert="" propertymap="" onchange="" desc="">
      <enums>
        <enum name="s0" value="0" caption="GPS/Glonass" desc=""/>
        <enum name="s1" value="1" caption="GPS" desc=""/>
      </enums>
    </property>
    <property name="update" value="" caption="Update rate" type="enum" min="" max="" step="" assert="" propertymap="" onchange="" desc="">
      <enums>
        <enum name="u1" value="1" caption="1 Hz" desc=""/>
        <enum name="u2" value="2" caption="2 Hz" desc=""/>
        <enum name="u4" value="4" caption="4 Hz" desc=""/>
        <enum name="u5" value="5" caption="5 Hz" desc=""/>
        <enum name="u8" value="8" caption="8 Hz" desc=""/>
        <enum name="u10" value="10" caption="10 Hz" desc=""/>
        <enum name="u20" value="20" caption="20 Hz" desc=""/>
        <enum name="u25" value="25" caption="25 Hz" desc=""/>
        <enum name="u40" value="40" caption="40 Hz" desc=""/>
      </enums>
    </property>
  </properties>
  <ports>
    <port name="RXD" type="in" size="1" desc=""/>
    <port name="TXD" type="out" size="1" desc=""/>
  </ports>
  <pins/>
</io>
