<?xml version="1.0" encoding="UTF-8"?>
<io driver="mpu" categ="" pi_size_addr_rel="4" desc="">
  <parts>
    <part name="main">
      <svg width="160" height="110">
        <rect width="160" height="110" x="0" y="0" fill="lightgray"/>
        <text x="50" y="50">MPU</text>
      </svg>
    </part>
  </parts>
  <files>
    <file name="mpu_acqui.vhd" type="vhdl" group="hdl" path="hdl/mpu_acqui.vhd"/>
    <file name="mpu_i2c.vhd" type="vhdl" group="hdl" path="hdl/mpu_i2c.vhd"/>
    <file name="mpu_i2c_master.vhd" type="vhdl" group="hdl" path="hdl/mpu_i2c_master.vhd"/>
    <file name="mpu_fifo.vhd" type="vhdl" group="hdl" path="hdl/mpu_fifo.vhd"/>
    <file name="mpu_pkg.vhd" type="vhdl" group="hdl" path="hdl/mpu_pkg.vhd"/>
    <file name="mpu.vhd" type="vhdl" group="hdl" path="hdl/mpu.vhd"/>
    <file name="mpu_slave.vhd" type="vhdl" group="hdl" path="hdl/mpu_slave.vhd"/>
    <file name="mpu_offset_correction.vhd" type="vhdl" group="hdl" path="hdl/mpu_offset_correction.vhd"/>
    <file name="mpu.md" type="doc" group="doc" path="doc/mpu.md"/>
    <file name="mpu_schema.tex" type="doc" group="doc" path="doc/mpu_schema.tex"/>
    <file name="mpu_schema_global.tex" type="doc" group="doc" path="doc/mpu_schema_global.tex"/>
    <file name="mpu.io" type="io" group="blockdef" path="mpu.io"/>
  </files>
  <resets>
    <reset name="reset_n" group="reset_n" direction="in"/>
  </resets>
  <flows>
    <flow name="accelero" size="8" type="out">
      <properties>
        <property name="datatype" caption="datatype" type="flowtype" value="vector"/>
        <property name="itemdatatype" caption="itemdatatype" type="hwtype" value="s16"/>
        <property name="swtype" caption="swtype" type="swtype" value="float"/>
        <property name="scaling" caption="scaling" type="function" value="item.value*2"/>
      </properties>
    </flow>
    <flow name="gyroscope" size="8" type="out">
      <properties>
        <property name="datatype" caption="datatype" type="flowtype" value="vector"/>
        <property name="itemdatatype" caption="itemdatatype" type="hwtype" value="s16"/>
        <property name="swtype" caption="swtype" type="swtype" value="float"/>
        <property name="scaling" caption="scaling" type="function" value="item.value*2"/>
      </properties>
    </flow>
    <flow name="compass" size="8" type="out">
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
    <param name="gyro_config_reg" regaddr="1" propertymap="gyro.gyro_config.bits"/>
    <param name="accel_config_reg" regaddr="2" propertymap="accel.accel_config.bits"/>
    <param name="spl_rate_reg" regaddr="3" propertymap="sample_rate.value"/>
    <param name="gain_compass_reg" regaddr="4" propertymap="comp.gain_compass.bits"/>
    <param name="fz_compass_reg" regaddr="5" propertymap="comp.fz_compass.bits"/>
    <param name="accel_off_x_reg" regaddr="6" propertymap="accel.accel_offx.value"/>
    <param name="accel_off_y_reg" regaddr="7" propertymap="accel.accel_offy.value"/>
    <param name="accel_off_z_reg" regaddr="8" propertymap="accel.accel_offz.value"/>
    <param name="gyro_off_x_reg" regaddr="9" propertymap="gyro.gyro_offx.value"/>
    <param name="gyro_off_y_reg" regaddr="10" propertymap="gyro.gyro_offy.value"/>
    <param name="gyro_off_z_reg" regaddr="11" propertymap="gyro.gyro_offz.value"/>
  </params>
  <properties>
    <property name="enable" caption="Enable device" type="bool"/>
    <property name="gyro" caption="Gyroscope" type="group">
      <properties>
        <property name="gyro_config" caption="Sensibility" type="enum">
          <enums>
            <enum name="g0" value="0" caption="± 250 °/s" desc=""/>
            <enum name="g1" value="1" caption="± 500 °/s" desc=""/>
            <enum name="g2" value="2" caption="± 1000 °/s" desc=""/>
            <enum name="g3" value="3" caption="± 2000 °/s" desc=""/>
          </enums>
        </property>
        <property name="gyro_offx" caption="Offset X" type="int" value="0" min="-16384" max="+16384" step="1"/>
        <property name="gyro_offy" caption="Offset Y" type="int" value="0" min="-16384" max="+16384" step="1"/>
        <property name="gyro_offz" caption="Offset Z" type="int" value="0" min="-16384" max="+16384" step="1"/>
      </properties>
    </property>
    <property name="accel" caption="Accelerometer" type="group">
      <properties>
        <property name="accel_config" caption="Sensibility" type="enum">
          <enums>
            <enum name="a0" value="0" caption="± 2g" desc=""/>
            <enum name="a1" value="1" caption="± 4g" desc=""/>
            <enum name="a2" value="2" caption="± 8g" desc=""/>
            <enum name="a3" value="3" caption="± 16g" desc=""/>
          </enums>
        </property>
        <property name="accel_offx" caption="Offset X" type="int" value="0" min="-16384" max="+16384" step="1"/>
        <property name="accel_offy" caption="Offset Y" type="int" value="0" min="-16384" max="+16384" step="1"/>
        <property name="accel_offz" caption="Offset Z" type="int" value="0" min="-16384" max="+16384" step="1"/>
      </properties>
    </property>
    <property name="sample_rate" caption="Sample rate" type="int" value="30" min="1" max="100" step="1"/>
    <property name="comp" caption="Compass" type="group">
      <properties>
        <property name="gain_compass" caption="Sensibility" type="enum">
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
        <property name="fz_compass" caption="Update rate" type="enum">
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
