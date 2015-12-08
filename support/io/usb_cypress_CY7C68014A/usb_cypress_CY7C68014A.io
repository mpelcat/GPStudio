<?xml version="1.0" encoding="UTF-8" ?>
<io driver="usb_cypress_CY7C68014A" categ="communication" pi_size_addr_rel="4" master_count="1">
	<svg width="160" height="110">
		<rect width="160" height="110" x="0" y="0" fill="lightgray"/>
		<text x="50" y="50">USB</text>
	</svg>
	<files>
		<file name="USB datasheet" path="doc/CY7C68013A_14A_15A_16A_38-08032.pdf" type="doc" group="doc" desc=""/>
		<file name="usb.sdc" path="usb.sdc" type="sdc" group="hdl" desc=""/>
		<file name="usb_cypress_CY7C68014A.vhd" path="hdl/usb/src/usb_cypress_CY7C68014A.vhd" type="vhdl" group="hdl" desc=""/>
		<file name="usb_sm.vhd" path="hdl/usb/src/usb_sm.vhd" type="vhdl" group="hdl" desc=""/>
		
		<file name="fifo_com_rx.vhd" path="hdl/flow_in/src/fifo_com_rx.vhd" type="vhdl" group="hdl" desc=""/>
		<file name="com_flow_fifo_rx.vhd" path="hdl/flow_in/src/com_flow_fifo_rx.vhd" type="vhdl" group="hdl" desc=""/>
		<file name="read_flow.vhd" path="hdl/flow_in/src/read_flow.vhd" type="vhdl" group="hdl" desc=""/>
		<file name="read_flow_nbits.vhd" path="hdl/flow_in/src/read_flow_nbits.vhd" type="vhdl" group="hdl" desc=""/>
		<file name="flow_in.vhd" path="hdl/flow_in/src/flow_in.vhd" type="vhdl" group="hdl" desc=""/>
		
		<file name="fifo_com_tx.vhd" path="hdl/flow_out/src/fifo_com_tx.vhd" type="vhdl" group="hdl" desc=""/>
		<file name="com_flow_fifo_tx.vhd" path="hdl/flow_out/src/com_flow_fifo_tx.vhd" type="vhdl" group="hdl" desc=""/>
		<file name="write_flow.vhd" path="hdl/flow_out/src/write_flow.vhd" type="vhdl" group="hdl" desc=""/>
		<file name="flow_out.vhd" path="hdl/flow_out/src/flow_out.vhd" type="vhdl" group="hdl" desc=""/>
		
		<file name="flow_wishbone.vhd" path="hdl/flowtobus/src/flow_wishbone.vhd" type="vhdl" group="hdl" desc=""/>
		<file name="params_flow_decoder.vhd" path="hdl/flowtobus/src/params_flow_decoder.vhd" type="vhdl" group="hdl" desc=""/>
		
		<file name="ComFlow_pkg.vhd" path="hdl/utils/src/ComFlow_pkg.vhd" type="vhdl" group="hdl" desc=""/>
		<file name="synchronizer.vhd" path="hdl/utils/src/synchronizer.vhd" type="vhdl" group="hdl" desc=""/>
		<file name="slave_usb.vhd" path="hdl/utils/src/slave_usb.vhd" type="vhdl" group="hdl" desc=""/>
		<file name="fv_synchro_signal.vhd" path="hdl/utils/src/fv_synchro_signal.vhd" type="vhdl" group="hdl" desc=""/>
		<file name="flow_out_arb.vhd" path="hdl/utils/src/flow_out_arb.vhd" type="vhdl" group="hdl" desc=""/>
		<file name="flow_out_arb4.vhd" path="hdl/utils/src/flow_out_arb4.vhd" type="vhdl" group="hdl" desc=""/>
		<file name="usbnto16bits.vhd" path="hdl/utils/src/usbnto16bits.vhd" type="vhdl" group="hdl" desc=""/>		
	</files>

	<flows>
		<flow name="in0" type="in" size="8" desc="flow 0 return for supervise results of process"/>
		<flow name="in1" type="in" size="8" desc="flow 1 return for supervise results of process"/>
		<flow name="in2" type="in" size="8" desc="flow 2 return for supervise results of process"/>
		<flow name="in3" type="in" size="8" desc="flow 3 return for supervise results of process"/>
		
		<flow name="out0" type="out" size="8" desc="flow 0 return for supervise results of process"/>
		<flow name="out1" type="out" size="8" desc="flow 1 return for supervise results of process"/> 
	</flows>
	<params>
		<param name="IN0_NBWORDS" hard="1" value="32768" type="int"/>
		<param name="IN1_NBWORDS" hard="1" value="32768" type="int"/>
		<param name="IN2_NBWORDS" hard="1" value="32768" type="int"/>
		<param name="IN3_NBWORDS" hard="1" value="32768" type="int"/>
		<param name="OUT0_NBWORDS" hard="1" value="1024" type="int"/>
		<param name="OUT1_NBWORDS" hard="1" value="1024" type="int"/>
		
		<param name="status" regaddr="0"> 
			<bitfields> 
				<bitfield name="enable" bitfield="0" propertymap="enable.value"/>
			</bitfields>
		</param>
		<param name="flow_in0" regaddr="1">
			<bitfields> 
				<bitfield name="enable" bitfield="0" propertymap="enableflow1.value"/>
			</bitfields>
		</param>
		<param name="flow_in1" regaddr="2">
			<bitfields> 
				<bitfield name="enable" bitfield="0" propertymap="enableflow2.value"/>
			</bitfields>
		</param>
		<param name="flow_in2" regaddr="3">
			<bitfields> 
				<bitfield name="enable" bitfield="0" propertymap="enableflow3.value"/>
			</bitfields>
		</param>
		<param name="flow_in3" regaddr="4">
			<bitfields> 
				<bitfield name="enable" bitfield="0" propertymap="enableflow4.value" />
			</bitfields>
		</param>
	</params>

	<properties>
		<property name="enable" caption="Global enable" value="1" type="bool" desc="Enable or disable process"/>
		<property name="enableflow1" caption="Enable Flow 1"  value="1" type="bool" desc=""/>
		<property name="enableflow2" caption="Enable Flow 2"  value="1" type="bool" desc=""/>
		<property name="enableflow3" caption="Enable Flow 3"  value="1" type="bool" desc=""/>
		<property name="enableflow4" caption="Enable Flow 4"  value="1" type="bool" desc=""/>		
	</properties>
	<ports>
		<port name="rst" type="in" size="1" desc=""/>
		<port name="ifclk" type="in" size="1" desc=""/>
		<port name="flaga" type="in" size="1" desc=""/>
		<port name="flagb" type="in" size="1" desc=""/>
		<port name="flagc" type="in" size="1" desc=""/>
		<port name="flagd" type="in" size="1" desc=""/>
		<port name="fd_io" type="inout" size="16" desc=""/>
		<port name="sloe" type="out" size="1" desc=""/>
		<port name="slrd" type="out" size="1" desc=""/>
		<port name="slwr" type="out" size="1" desc=""/>
		<port name="pktend" type="out" size="1" desc=""/>
		<port name="addr" type="out" size="2" desc=""/>
	</ports>
	<resets>
		<reset name="reset" group="reset_n" direction="out" desc=""/>
	</resets>
	<clocks>
		<clock name="clk_usb" direction="out" typical="48000000" desc=""/>
	</clocks>
	
	<com_connects driverio="usb">
		<com_connect link="out0" id="0" type="flow"/>
		<com_connect link="out1" id="1" type="flow"/>
		<com_connect link="in0" id="128" type="flow"/>
		<com_connect link="in1" id="129" type="flow"/>
		<com_connect link="in2" id="130" type="flow"/>
		<com_connect link="in3" id="131" type="flow"/>
		<com_connect link="" id="15" type="paramout"/>
<!--	<com_connect link="" id="143" type="paramin"/>	-->
	</com_connects>
</io>
