<?xml version="1.0" encoding="UTF-8"?>
<io driver="gps" categ="" pi_size_addr_rel="2" desc="">
  <parts>
    <part name="main">
      <svg width="160" height="110">
        <rect width="160" height="110" x="0" y="0" fill="lightgray"/>
        <text x="50" y="50">GPS</text>
      </svg>
    </part>
  </parts>
  <files>
    <file name="gps_acqui.vhd" type="vhdl" group="hdl" path="hdl/gps_acqui.vhd"/>
    <file name="gps_receiver.vhd" type="vhdl" group="hdl" path="hdl/gps_receiver.vhd"/>
    <file name="gps_fifo.vhd" type="vhdl" group="hdl" path="hdl/gps_fifo.vhd"/>
    <file name="gps_transmitter.vhd" type="vhdl" group="hdl" path="hdl/gps_transmitter.vhd"/>
    <file name="gps_clkgen.vhd" type="vhdl" group="hdl" path="hdl/gps_clkgen.vhd"/>
    <file name="gps.vhd" type="vhdl" group="hdl" path="hdl/gps.vhd"/>
    <file name="gps_slave.vhd" type="vhdl" group="hdl" path="hdl/gps_slave.vhd"/>
    <file name="gps_pkg.vhd" type="vhdl" group="hdl" path="hdl/gps_pkg.vhd"/>
    <file name="gps.md" type="doc" group="doc" path="doc/gps.md"/>
    <file name="schema_gps.tex" type="doc" group="doc" path="doc/schema_gps.tex"/>
    <file name="gps_schema_global.tex" type="doc" group="doc" path="doc/gps_schema_global.tex"/>
    <file name="gps.io" type="io" group="blockdef" path="gps.io"/>
  </files>
  <resets>
    <reset name="reset_n" group="reset_n" direction="in"/>
  </resets>
  <flows>
    <flow name="out" size="8" type="out">
      <properties>
        <property name="datatype" caption="datatype" type="flowtype" value="vector"/>
        <property name="itemdatatype" caption="itemdatatype" type="hwtype" value="s16"/>
        <property name="swtype" caption="swtype" type="swtype" value="float"/>
        <property name="scaling" caption="scaling" type="function" value="item.value*2"/>
      </properties>
    </flow>
  </flows>
  <params>
    <param name="enable_reg" regaddr="0" propertymap="enable.value"/>
    <param name="sat_reg" regaddr="1" propertymap="sat_mode.bits"/>
    <param name="update_reg" regaddr="2" propertymap="update.bits"/>
  </params>
  <properties>
    <property name="enable" caption="Enable" type="bool"/>
    <property name="sat_mode" caption="Mode" type="enum">
      <enums>
        <enum name="s0" value="0" caption="GPS/Glonass" desc=""/>
        <enum name="s1" value="1" caption="GPS" desc=""/>
      </enums>
    </property>
    <property name="update" caption="Update rate" type="enum">
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
