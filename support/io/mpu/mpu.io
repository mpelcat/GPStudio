<?xml version="1.0" encoding="UTF-8"?>
<io driver="mpu" categ="" pi_size_addr_rel="4" desc="">
  <svg width="160" height="110">
		<rect width="160" height="110" x="0" y="0" fill="lightgray"/>
		<text x="50" y="50">MPU</text>
  </svg>
  <files>
    <file name="mpu_acqui.vhd" type="vhdl" group="hdl" path="hdl/mpu_acqui.vhd" desc=""/>
    <file name="mpu_i2c.vhd" type="vhdl" group="hdl" path="hdl/mpu_i2c.vhd" desc=""/>
    <file name="mpu_i2c_master.vhd" type="vhdl" group="hdl" path="hdl/mpu_i2c_master.vhd" desc=""/>
    <file name="mpu_fifo.vhd" type="vhdl" group="hdl" path="hdl/mpu_fifo.vhd" desc=""/>
    <file name="mpu_pkg.vhd" type="vhdl" group="hdl" path="hdl/mpu_pkg.vhd" desc=""/>
    <file name="mpu.vhd" type="vhdl" group="hdl" path="hdl/mpu.vhd" desc=""/>
    <file name="mpu_slave.vhd" type="vhdl" group="hdl" path="hdl/mpu_slave.vhd" desc=""/>
    <file name="mpu_offset_correction.vhd" type="vhdl" group="hdl" path="hdl/mpu_offset_correction.vhd" desc=""/>
  </files>
  <resets>
    <reset name="reset_n" group="reset_n" direction="in" desc=""/>
  </resets>
  <flows>
    <flow name="accelero" size="8" type="out" desc="">
      <properties>
        <property name="datatype" value="vector" caption="datatype" type="flowtype" min="" max="" step="" assert="" propertymap="" onchange="" desc=""/>
        <property name="itemdatatype" value="s16" caption="itemdatatype" type="hwtype" min="" max="" step="" assert="" propertymap="" onchange="" desc=""/>
        <property name="swtype" value="float" caption="swtype" type="swtype" min="" max="" step="" assert="" propertymap="" onchange="" desc=""/>
        <property name="scaling" value="item.value*2" caption="scaling" type="function" min="" max="" step="" assert="" propertymap="" onchange="" desc=""/>
      </properties>
    </flow>
    <flow name="gyroscope" size="8" type="out" desc="">
      <properties>
        <property name="datatype" value="vector" caption="datatype" type="flowtype" min="" max="" step="" assert="" propertymap="" onchange="" desc=""/>
        <property name="itemdatatype" value="s16" caption="itemdatatype" type="hwtype" min="" max="" step="" assert="" propertymap="" onchange="" desc=""/>
        <property name="swtype" value="float" caption="swtype" type="swtype" min="" max="" step="" assert="" propertymap="" onchange="" desc=""/>
        <property name="scaling" value="item.value*2" caption="scaling" type="function" min="" max="" step="" assert="" propertymap="" onchange="" desc=""/>
      </properties>
    </flow>
    <flow name="compass" size="8" type="out" desc="">
      <properties>
        <property name="datatype" value="vector" caption="datatype" type="flowtype" min="" max="" step="" assert="" propertymap="" onchange="" desc=""/>
        <property name="itemdatatype" value="s16" caption="itemdatatype" type="hwtype" min="" max="" step="" assert="" propertymap="" onchange="" desc=""/>
        <property name="swtype" value="float" caption="swtype" type="swtype" min="" max="" step="" assert="" propertymap="" onchange="" desc=""/>
        <property name="scaling" value="item.value*2" caption="scaling" type="function" min="" max="" step="" assert="" propertymap="" onchange="" desc=""/>
      </properties>
    </flow>
  </flows>
  <params>
    <param name="enable_reg" value="" regaddr="0" propertymap="enable.value" default="" min="" max="" desc=""/>
    <param name="gyro_config_reg" value="" regaddr="1" propertymap="gyro.gyro_config.bits" default="" min="" max="" desc=""/>
    <param name="accel_config_reg" value="" regaddr="2" propertymap="accel.accel_config.bits" default="" min="" max="" desc=""/>
    <param name="spl_rate_reg" value="" regaddr="3" propertymap="sample_rate.value" default="" min="" max="" desc=""/>
    <param name="gain_compass_reg" value="" regaddr="4" propertymap="comp.gain_compass.bits" default="" min="" max="" desc=""/>
    <param name="fz_compass_reg" value="" regaddr="5" propertymap="comp.fz_compass.bits" default="" min="" max="" desc=""/>
    <param name="accel_off_x_reg" value="" regaddr="6" propertymap="accel.accel_offx.value" default="" min="" max="" desc=""/>
    <param name="accel_off_y_reg" value="" regaddr="7" propertymap="accel.accel_offy.value" default="" min="" max="" desc=""/>
    <param name="accel_off_z_reg" value="" regaddr="8" propertymap="accel.accel_offz.value" default="" min="" max="" desc=""/>
    <param name="gyro_off_x_reg" value="" regaddr="9" propertymap="gyro.gyro_offx.value" default="" min="" max="" desc=""/>
    <param name="gyro_off_y_reg" value="" regaddr="10" propertymap="gyro.gyro_offy.value" default="" min="" max="" desc=""/>
    <param name="gyro_off_z_reg" value="" regaddr="11" propertymap="gyro.gyro_offz.value" default="" min="" max="" desc=""/>
  </params>
  <properties>
    <property name="enable" value="" caption="Enable device" type="bool" min="" max="" step="" assert="" propertymap="" onchange="" desc=""/>
    <property name="gyro" value="" caption="Gyroscope" type="group" min="" max="" step="" assert="" propertymap="" onchange="" desc="">
      <properties>
        <property name="gyro_config" value="" caption="Sensibility" type="enum" min="" max="" step="" assert="" propertymap="" onchange="" desc="">
          <enums>
            <enum name="g0" value="0" caption="± 250 °/s" desc=""/>
            <enum name="g1" value="1" caption="± 500 °/s" desc=""/>
            <enum name="g2" value="2" caption="± 1000 °/s" desc=""/>
            <enum name="g3" value="3" caption="± 2000 °/s" desc=""/>
          </enums>
        </property>
        <property name="gyro_offx" value="0" caption="Offset X" type="int" min="-16384" max="+16384" step="1" assert="" propertymap="" onchange="" desc=""/>
        <property name="gyro_offy" value="0" caption="Offset Y" type="int" min="-16384" max="+16384" step="1" assert="" propertymap="" onchange="" desc=""/>
        <property name="gyro_offz" value="0" caption="Offset Z" type="int" min="-16384" max="+16384" step="1" assert="" propertymap="" onchange="" desc=""/>
      </properties>
    </property>
    <property name="accel" value="" caption="Accelerometer" type="group" min="" max="" step="" assert="" propertymap="" onchange="" desc="">
      <properties>
        <property name="accel_config" value="" caption="Sensibility" type="enum" min="" max="" step="" assert="" propertymap="" onchange="" desc="">
          <enums>
            <enum name="a0" value="0" caption="± 2g" desc=""/>
            <enum name="a1" value="1" caption="± 4g" desc=""/>
            <enum name="a2" value="2" caption="± 8g" desc=""/>
            <enum name="a3" value="3" caption="± 16g" desc=""/>
          </enums>
        </property>
        <property name="accel_offx" value="0" caption="Offset X" type="int" min="-16384" max="+16384" step="1" assert="" propertymap="" onchange="" desc=""/>
        <property name="accel_offy" value="0" caption="Offset Y" type="int" min="-16384" max="+16384" step="1" assert="" propertymap="" onchange="" desc=""/>
        <property name="accel_offz" value="0" caption="Offset Z" type="int" min="-16384" max="+16384" step="1" assert="" propertymap="" onchange="" desc=""/>
      </properties>
    </property>
    <property name="sample_rate" value="30" caption="Sample rate" type="int" min="1" max="100" step="1" assert="" propertymap="" onchange="" desc=""/>
    <property name="comp" value="" caption="Compass" type="group" min="" max="" step="" assert="" propertymap="" onchange="" desc="">
      <properties>
        <property name="gain_compass" value="" caption="Sensibility" type="enum" min="" max="" step="" assert="" propertymap="" onchange="" desc="">
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
        <property name="fz_compass" value="" caption="Update rate" type="enum" min="" max="" step="" assert="" propertymap="" onchange="" desc="">
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
    </property>
  </properties>
  <ports>
    <port name="ad0" type="out" size="1" desc=""/>
    <port name="sda" type="inout" size="1" desc=""/>
    <port name="scl" type="inout" size="1" desc=""/>
  </ports>
  <pins/>
</io>
