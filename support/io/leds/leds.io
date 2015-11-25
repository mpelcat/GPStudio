<?xml version="1.0" encoding="UTF-8" ?>
<io driver="leds" categ="imagesensor" pi_size_addr_rel="2" configscriptfile="config.php">
	<svg width="160" height="110">
		<rect width="160" height="110" x="0" y="0" fill="lightgray"/>
		<text x="50" y="50">MT9</text>
	</svg>
	<files>
		<file name="leds.vhd" path="hdl/leds.vhd" type="vhdl" group="hdl" desc=""/>
	</files>
	<flows>
	</flows>
	<ports>
		<port name="o" type="out" size="LEDCOUNT" desc=""/>
	</ports>
	<params>
		<param name="LEDCOUNT" hard="true" value="1"/>
		<param name="ENABLE" regaddr="0" propertymap=""/>
	</params>
	<properties>
	</properties>
	<resets>
		<reset name="reset_n" group="reset_n" direction="in" desc=""/>
	</resets>
</io>
