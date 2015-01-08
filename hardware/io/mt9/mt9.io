<?xml version="1.0" encoding="UTF-8" ?>
<io driver="mt9" size_addr_rel="3">
	<files>
		<file name="mt9bricolage.v" path="verilog/mt9bricolage.v" type="verilog" group="hdl" desc=""/>
		<file name="VideoSampler.v" path="verilog/VideoSampler.v" type="verilog" group="hdl" desc=""/>
		<file name="pll.vhd" path="vhdl/pll.vhd" type="vhdl" group="hdl" desc=""/>
		<file name="pll.qip" path="vhdl/pll.qip" type="qip" group="hdl" desc=""/>
		<file name="mt9.vhd" path="vhdl/mt9.vhd" type="vhdl" group="hdl" desc=""/>
		<file name="MT9 datasheet" path="doc/MT9M031_DS_Rev. A 1009 EN.pdf" type="doc" group="doc" desc=""/>
	</files>
	<flows>
		<flow name="out" type="out" size="8" desc="image flow from MT9 image sensor"/>
	</flows>
	<ports>
		<port name="mt9_data_i" type="in" size="12" desc=""/>
		<port name="mt9_fval_i" type="in" size="1" desc=""/>
		<port name="mt9_lval_i" type="in" size="1" desc=""/>
		<port name="mt9_pixclk_i" type="in" size="1" desc=""/>
		<port name="mt9_extclk_o" type="out" size="1" desc=""/>
		<port name="mt9_reset_n_o" type="out" size="1" desc=""/>
		<port name="mt9_standby_o" type="out" size="1" desc=""/>
		<port name="mt9_oe_n_o" type="out" size="1" desc=""/>
		<port name="mt9_trigger_o" type="out" size="1" desc=""/>
		<port name="mt9_saddr_o" type="out" size="1" desc=""/>
		<port name="mt9_sdata_io" type="inout" size="1" desc=""/>
		<port name="mt9_sclk_o" type="out" size="1" desc=""/>
	</ports>
	<params>
		<param name="ENABLE" regaddr="0"/>
		<param name="DATA_WIDTH" hard="1" value="32"/>
		<param name="PIXEL_WIDTH" hard="1" value="8"/>
		<param name="FIFO_DEPTH" hard="1" value="2048"/>
		<param name="DEFAULT_SCR" hard="1" value="0"/>
		<param name="DEFAULT_FLOWLENGHT" hard="1" value="320*240"/>
	</params>
	<resets>
		<reset name="reset_n" group="reset_n" direction="in" desc=""/>
	</resets>
</io>
