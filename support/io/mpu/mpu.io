<?xml version="1.0" encoding="UTF-8"?>
<io driver="mpu" categ="" pi_size_addr_rel="10" desc="">
  <files>
    <file name="mpu_acqui.vhd" type="vhdl" group="hdl" path="hdl/mpu_acqui.vhd" desc=""/>
    <file name="mpu_i2c.vhd" type="vhdl" group="hdl" path="hdl/mpu_i2c.vhd" desc=""/>
    <file name="mpu_i2c_master.vhd" type="vhdl" group="hdl" path="hdl/mpu_i2c_master.vhd" desc=""/>
    <file name="mpu_fifo.vhd" type="vhdl" group="hdl" path="hdl/mpu_fifo.vhd" desc=""/>
    <file name="mpu_pkg.vhd" type="vhdl" group="hdl" path="hdl/mpu_pkg.vhd" desc=""/>
    <file name="mpu.vhd" type="vhdl" group="hdl" path="hdl/mpu.vhd" desc=""/>
    <file name="mpu_slave.vhd" type="vhdl" group="hdl" path="hdl/mpu_slave.vhd" desc=""/>
  </files>
  <resets>
    <reset name="reset_n" group="reset_n" direction="in" desc=""/>
  </resets>
  <flows>
    <flow name="data_out" size="8" type="out" desc=""/>
  </flows>
  <params>
    <param name="enable_reg" value="" regaddr="0" propertymap="enable.value" default="" min="" max="" desc=""/>
    <param name="auto_reg" value="" regaddr="3" propertymap="auto.value" default="" min="" max="" desc=""/>
    <param name="gyro_config_reg" value="" regaddr="4" propertymap="gyro_config.value" default="" min="" max="" desc=""/>
    <param name="accel_config_reg" value="" regaddr="5" propertymap="accel_config.value" default="" min="" max="" desc=""/>
    <param name="spl_rate_reg" value="" regaddr="6" propertymap="spl_rate.value" default="" min="" max="" desc=""/>
    <param name="gain_compass_reg" value="" regaddr="7" propertymap="compass_gain.value" default="" min="" max="" desc=""/>
    <param name="fz_compass_reg" value="" regaddr="8" propertymap="compass_rate.value" default="" min="" max="" desc=""/>
  </params>
  <properties>
    <property name="enable" value="" caption="Enable device" type="bool" min="" max="" step="" assert="" propertymap="" onchange="" desc=""/>
    <property name="auto" value="" caption="Automatic mode" type="bool" min="" max="" step="" assert="" propertymap="" onchange="" desc=""/>
    <property name="gyro_config" value="0" caption="Gyroscope configuration" type="int" min="0" max="3" step="1" assert="" propertymap="" onchange="" desc=""/>
    <property name="accel_config" value="0" caption="Accelero configuration" type="int" min="0" max="3" step="1" assert="" propertymap="" onchange="" desc=""/>
    <property name="spl_rate" value="255" caption="Sample rate" type="int" min="7" max="255" step="1" assert="" propertymap="" onchange="" desc=""/>
    <property name="compass_gain" value="1" caption="Compass gain" type="int" min="0" max="7" step="1" assert="" propertymap="" onchange="" desc=""/>
    <property name="compass_rate" value="6" caption="Compass output rate" type="int" min="0" max="6" step="1" assert="" propertymap="" onchange="" desc=""/>
  </properties>
  <ports>
    <port name="ad0" type="out" size="1" desc=""/>
    <port name="sda" type="inout" size="1" desc=""/>
    <port name="scl" type="inout" size="1" desc=""/>
  </ports>
  <pins/>
</io>
