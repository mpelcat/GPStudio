<?xml version="1.0" encoding="UTF-8" ?>
<io driver="mt9" size_addr_rel="4">
	<files>
		<file name="mt9.sdc" path="hdl/mt9.sdc" type="sdc" group="hdl" desc=""/>
		<file name="video_sampler.v" path="hdl/video_sampler.v" type="verilog" group="hdl" desc=""/>
		<file name="mt9.vhd" path="hdl/mt9.vhd" type="vhdl" group="hdl" desc=""/>
		<file name="pll.vhd" path="hdl/pll.vhd" type="vhdl" group="hdl" desc=""/>
		<file name="pll.qip" path="hdl/pll.qip" type="qip" group="hdl" desc=""/>
		<file name="mt9_config_slave.vhd" path="hdl/mt9_config_slave.vhd" type="vhdl" group="hdl" desc=""/>
		<file name="mt9_config_i2c.vhd" path="hdl/mt9_config_i2c.vhd" type="vhdl" group="hdl" desc=""/>
		<file name="MT9 datasheet" path="doc/MT9M031_DS_Rev. A 1009 EN.pdf" type="doc" group="doc" desc=""/>
	</files>
	<flows>
		<flow name="out" type="out" size="8" desc="image flow from MT9 image sensor"/>
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
		<param name="ENABLE" regaddr="0" propertymap="enable.value"/>
		<param name="FLOWLENGHT" regaddr="1" propertymap="roi1.w.value*roi1.h.value"/>
		<param name="XSTART" regaddr="2" propertymap="roi1.x.value"/>
		<param name="YSTART" regaddr="3" propertymap="roi1.y.value"/>
		<param name="XEND" regaddr="4" propertymap="roi1.x.value+roi1.w.value-1"/>
		<param name="YEND" regaddr="5" propertymap="roi1.y.value+roi1.h.value-1"/>
		<param name="AUTOEXP" regaddr="6" propertymap="auto_exposure.value"/>
		<param name="INTEGTIME" regaddr="7" propertymap="exposuretime.value"/>
		<param name="LINELENGHT" regaddr="8"/>
		
		<param name="DATA_WIDTH" hard="1" value="32"/>
		<param name="PIXEL_WIDTH" hard="1" value="8"/>
	</params>
	<properties>
		<property name="enable" caption="enable" type="bool" desc="Enable or disable image sensor"/>
		<property name="roi1" type="group">
			<properties>
				<property name="x" value="0" type="int" assert="" min="0" max="1280"/>
				<property name="y" value="0" type="int" assert="" min="0" max="960"/>
				<property name="w" value="320" type="int" assert="roi.w%2==0" min="2" max="1280"/>
				<property name="h" value="240" type="int" assert="roi.h%2==0" min="2" max="960"/>
			</properties>
		</property>
		<property name="auto_exposure" caption="auto exposure" type="bool"/>
		<property name="exposuretime" value="200" caption="exposure time" type="sint" min="0" max="4500"/>
	</properties>
	<resets>
		<reset name="reset_n" group="reset_n" direction="in" desc=""/>
	</resets>
</io>
