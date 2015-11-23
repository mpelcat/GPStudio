<?xml version="1.0" encoding="UTF-8" ?>
<io driver="mt9" categ="imagesensor" pi_size_addr_rel="5">
	<svg width="160" height="110">
		<rect width="160" height="110" x="0" y="0" fill="lightgray"/>
		<text x="50" y="50">MT9</text>
	</svg>
	<files>
		<file name="mt9.sdc" path="hdl/mt9.sdc" type="sdc" group="hdl" desc=""/>
		<file name="video_sampler.v" path="hdl/video_sampler.v" type="verilog" group="hdl" desc=""/>
		<file name="mt9.vhd" path="hdl/mt9.vhd" type="vhdl" group="hdl" desc=""/>
		<file name="mt9_config_slave.vhd" path="hdl/mt9_config_slave.vhd" type="vhdl" group="hdl" desc=""/>
		<file name="mt9_config_i2c.vhd" path="hdl/mt9_config_i2c.vhd" type="vhdl" group="hdl" desc=""/>
		<file name="MT9 datasheet" path="doc/MT9M031_DS_Rev. A 1009 EN.pdf" type="doc" group="doc" desc=""/>
	</files>
	<flows>
		<flow name="out" type="out" size="8" desc="image flow from MT9 image sensor">
			<properties>
				<property name="datatype" value="image" type="flowtype"/>
				<property name="width" value="roi1.w.value/(binning.value ? 2 : 1)" type="int"/>
				<property name="height" value="roi1.h.value/(binning.value ? 2 : 1)" type="int"/>
			</properties>
		</flow>
	</flows>
	<ports>
		<port name="data_i" type="in" size="12" desc=""/>
		<port name="fval_i" type="in" size="1" desc=""/>
		<port name="lval_i" type="in" size="1" desc=""/>
		<port name="pixclk_i" type="in" size="1" desc=""/>
		<port name="extclk_o" type="out" size="1" desc=""/>
		<port name="reset_n_o" type="out" size="1" desc=""/>
		<port name="standby_o" type="out" size="1" desc=""/>
		<port name="oe_n_o" type="out" size="1" desc=""/>
		<port name="trigger_o" type="out" size="1" desc=""/>
		<port name="saddr_o" type="out" size="1" desc=""/>
		<port name="sdata_io" type="inout" size="1" desc=""/>
		<port name="sclk_o" type="out" size="1" desc=""/>
	</ports>
	<params>
		<param name="ENABLE" regaddr="0">
			<bitfields>
				<bitfield name="enable" type="int" bitfield="0" default="0" propertymap="enable.value" desc="Enable bit"/>
			</bitfields>
		</param>
		<param name="FLOWLENGHT" regaddr="1" propertymap="(roi1.w.value*roi1.h.value)/(binning.value ? 4 : 1)"/>
		<param name="XSTART" regaddr="2" propertymap="roi1.x.value"/>
		<param name="YSTART" regaddr="3" propertymap="roi1.y.value"/>
		<param name="XEND" regaddr="4" propertymap="roi1.x.value+roi1.w.value-1"/>
		<param name="YEND" regaddr="5" propertymap="roi1.y.value+roi1.h.value-1"/>
		<param name="MODE" regaddr="6">
			<bitfields>
				<bitfield name="autoexp" type="int" bitfield="0" default="0" propertymap="autoexposure.enable.value" desc="Auto exposure bit"/>
				<bitfield name="flipy" type="int" bitfield="1" default="0" propertymap="flipy.value" desc="flipy"/>
				<bitfield name="flipx" type="int" bitfield="2" default="0" propertymap="flipx.value" desc="flipx"/>
				<bitfield name="binning" type="int" bitfield="3" default="0" propertymap="binning.value" desc="flipx"/>
			</bitfields>
		</param>
		<param name="INTEGTIME" regaddr="7" propertymap="exposuretime.value"/>
		<param name="LINELENGHT" regaddr="8" propertymap="linelenght.value"/>
		<param name="AUTOEXPTARGET" regaddr="9" propertymap="autoexposure.target.value"/>
		<param name="AUTOEXPVMIN" regaddr="10" propertymap="autoexposure.min.value"/>
		<param name="AUTOEXPVMAX" regaddr="11" propertymap="autoexposure.max.value"/>
		<param name="AUTOEXPMINSTEP" regaddr="12" propertymap="autoexposure.stepmin.value"/>
		<param name="AUTOEXPMAXSTEP" regaddr="13" propertymap="autoexposure.stepmax.value"/>
		<param name="AUTOEXPDAMPOFSET" regaddr="14" propertymap="autoexposure.dampofset.value"/>
		<param name="AUTOEXPDAMPGAIN" regaddr="15" propertymap="autoexposure.dampgain.value"/>
		<param name="AUTOEXPDAMPMAX" regaddr="16" propertymap="autoexposure.dampmax.value"/>
	</params>
	<properties>
		<property name="enable" caption="enable" type="bool" desc="Enable or disable image sensor"/>
		<property name="roi1" type="group">
			<properties>
				<property name="x" value="0" type="int" assert="" min="0" max="1280"/>
				<property name="y" value="0" type="int" assert="" min="0" max="960"/>
				<property name="w" value="320" type="int" step="2" assert="roi.w%2==0" min="2" max="1280"/>
				<property name="h" value="240" type="int" step="2" assert="roi.h%2==0" min="2" max="960"/>
			</properties>
		</property>
		<property name="flipx" caption="X mirror" type="bool"/>
		<property name="flipy" caption="Y flip" type="bool"/>
		<property name="binning" caption="binning (/2)" type="bool"/>
		<property name="autoexposure" type="group">
			<properties>
				<property name="enable" caption="enable" type="bool"/>
				<property name="target" value="1280" type="sint" assert="" min="0" max="65000"/>
				<property name="min" value="1" type="sint" assert="" min="0" max="65000"/>
				<property name="max" value="672" type="sint" assert="" min="0" max="65000"/>
				<property name="stepmin" value="112" type="sint" assert="" min="0" max="255"/>
				<property name="stepmax" value="8" type="sint" assert="" min="0" max="255"/>
				<property name="dampofset" value="512" type="sint" assert="" min="0" max="65000"/>
				<property name="dampgain" value="512" type="sint" assert="" min="0" max="65000"/>
				<property name="dampmax" value="320" type="sint" assert="" min="0" max="65000"/>
			</properties>
		</property>
		<property name="exposuretime" value="1000" caption="exposure time" type="sint" min="0" max="4500"/>
		<property name="linelenght" value="1650" type="int" assert="" min="1650" max="4500"/>
	</properties>
	<resets>
		<reset name="reset_n" group="reset_n" direction="in" desc=""/>
	</resets>
	<clocks>
		<clock name="clk_img" direction="in" typical="9M" desc=""/>
		<clock name="clk_50k" direction="in" typical="50k" domain="i2c" desc=""/>
		<clock name="clk_100k" direction="in" typical="100k" domain="i2c" shift="180" desc=""/>
	</clocks>
</io>
