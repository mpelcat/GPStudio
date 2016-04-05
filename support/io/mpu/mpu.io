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
    <flow name="data_out" size="8" type="out" desc="">
		<properties>
			<property name="datatype" value="vector" type="flowtype"/>
			<property name="itemdatatype" value="s16" type="hwtype"/>
			<property name="swtype" value="float" type="swtype"/>
			<property name="scaling" value="item.value*2" type="function"/>
		</properties>
	</flow>
  </flows>
  <params>
    <param name="enable_reg" value="" regaddr="0" propertymap="Enable.value" default="" min="" max="" desc=""/>
    <param name="auto_reg" value="" regaddr="3" propertymap="Mode_auto.value" default="" min="" max="" desc=""/>
    <param name="gyro_config_reg" value="" regaddr="4" propertymap="gyro_config.bits" default="" min="" max="" desc=""/>
    <param name="accel_config_reg" value="" regaddr="5" propertymap="accel_config.bits" default="" min="" max="" desc=""/>
    <param name="spl_rate_reg" value="" regaddr="6" propertymap="Sample_rate.value" default="" min="" max="" desc=""/>
    <param name="gain_compass_reg" value="" regaddr="7" propertymap="gain_compass.bits" default="" min="" max="" desc=""/>
    <param name="fz_compass_reg" value="" regaddr="8" propertymap="fz_compass.bits" default="" min="" max="" desc=""/>
  </params>
  <properties>
    <property name="Enable" value="" caption="Enable" type="bool" min="" max="" step="" assert="" propertymap="" onchange="" desc=""/>
    <property name="Mode_auto" value="" caption="Mode_auto" type="bool" min="" max="" step="" assert="" propertymap="" onchange="" desc=""/>
    <property name="gyro_config" value="" caption="Gyroscope configuration" type="enum" min="" max="" step="" assert="" propertymap="" onchange="" desc="">
      <enums>
        <enum name="g0" value="0" caption="± 250 °/s" desc=""/>
        <enum name="g1" value="1" caption="± 500 °/s" desc=""/>
        <enum name="g2" value="2" caption="± 1000 °/s" desc=""/>
        <enum name="g3" value="3" caption="± 2000 °/s" desc=""/>
      </enums>
    </property>
    <property name="accel_config" value="" caption="Accelerometer configuration" type="enum" min="" max="" step="" assert="" propertymap="" onchange="" desc="">
      <enums>
        <enum name="a0" value="0" caption="± 2g" desc=""/>
        <enum name="a1" value="1" caption="± 4g" desc=""/>
        <enum name="a2" value="2" caption="± 8g" desc=""/>
        <enum name="a3" value="3" caption="± 16g" desc=""/>
      </enums>
    </property>
    <property name="Sample_rate" value="255" caption="Sample_rate" type="int" min="7" max="255" step="1" assert="" propertymap="" onchange="" desc=""/>
    <property name="gain_compass" value="" caption="Compass range" type="enum" min="" max="" step="" assert="" propertymap="" onchange="" desc="">
      <enums>
        <enum name="c0" value="0" caption="± 0.88 Ga" desc=""/>
        <enum name="c1" value="1" caption="± 1.3 Ga" desc=""/>
        <enum name="c2" value="2" caption="± 1.9 Ga" desc=""/>
        <enum name="c3" value="3" caption="± 2.5 Ga" desc=""/>
        <enum name="c4" value="4" caption="± 4.0 Ga" desc=""/>
        <enum name="c5" value="5" caption="± 4.7 Ga" desc=""/>
        <enum name="c6" value="6" caption="± 5.6 Ga" desc=""/>
        <enum name="c7" value="7" caption="± 8.1 Ga" desc=""/>
      </enums>
    </property>
    <property name="fz_compass" value="" caption="Compass update rate" type="enum" min="" max="" step="" assert="" propertymap="" onchange="" desc="">
      <enums>
        <enum name="c0" value="0" caption="0.75 Hz" desc=""/>
        <enum name="c1" value="1" caption="1.5 Hz" desc=""/>
        <enum name="c2" value="2" caption="3 Hz" desc=""/>
        <enum name="c3" value="3" caption="7.5 Hz" desc=""/>
        <enum name="c4" value="4" caption="15 Hz" desc=""/>
        <enum name="c5" value="5" caption="30 Hz" desc=""/>
        <enum name="c6" value="6" caption="75 Hz" desc=""/>
      </enums>
    </property>
  </properties>
  <ports>
    <port name="ad0" type="out" size="1" desc=""/>
    <port name="sda" type="inout" size="1" desc=""/>
    <port name="scl" type="inout" size="1" desc=""/>
  </ports>
  <pins/>
</io>
