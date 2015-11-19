<?xml version="1.0" encoding="UTF-8" ?>
<io driver="leds" categ="imagesensor" pi_size_addr_rel="2">
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
		<port name="led_o" type="out" size="1" desc=""/>
	</ports>
	<params>
		<param name="ENABLE" regaddr="0" propertymap="enable.value"/>
	</params>
	<properties>
		<property name="enable" caption="enable" type="bool" desc="Enable or disable led"/>
	</properties>
	<resets>
		<reset name="reset_n" group="reset_n" direction="in" desc=""/>
	</resets>
</io>
