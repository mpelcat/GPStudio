<?xml version="1.0" encoding="UTF-8" ?>
<io driver="usb_cypress_CY7C68014A" categ="communication" pi_size_addr_rel="4" master_count="1">
	<svg width="160" height="150">
		<rect width="160" height="150" x="0" y="0" fill="lightgray"/>
		<g id="usb" transform="translate(30,30) scale(0.2)">
			<path d="M393.221,56.001H81.224c-13.202,0-24.002,10.795-24.002,24.001v311.999c0,13.202,10.8,24.002,24.002,24.002h311.998   c13.203,0,24.002-10.8,24.002-24.002V80.002C417.223,66.796,406.424,56.001,393.221,56.001z M316.239,203.177c0,2.209-1.791,4-4,4   h-9.76l0.01,16.667c0,11.14-6.158,21.546-11.951,27.608c-0.031,0.034-0.074,0.077-0.104,0.112c-0.01,0-0.01,0.013-0.01,0.013   c-0.043,0.047-0.086,0.077-0.129,0.125c-0.738,0.737-38.58,39.392-38.58,39.392c-2.18,2.735-3.625,6.467-3.711,9.971v13.138   c16.123,4.72,27.51,19.674,27.51,36.721c0,21.11-17.172,38.282-38.274,38.282c-21.103,0-38.266-17.172-38.266-38.282   c0-17.047,11.373-31.983,27.483-36.721v-0.764c-0.086-3.409-1.531-7.158-3.961-10.187c-0.056,0-37.562-35.375-38.312-36.078   c-0.107-0.112-0.211-0.203-0.314-0.328c-6.835-7.235-11.93-23.363-11.93-33.049l0.008-7.701   c-8.326-4.082-13.741-12.568-13.741-21.943c0-13.522,11.002-24.524,24.523-24.524c13.526,0,24.523,11.002,24.523,24.524   c0,9.375-5.423,17.861-13.75,21.943c0.009,1.247,0.009,4.388,0.009,13.591c0.077,3.391,1.522,7.14,3.969,10.203l28.977,27.268   V136.66h-20.912c-1.488,0-2.852-0.828-3.542-2.14c-0.695-1.32-0.592-2.917,0.25-4.134l31.703-45.863   c0.742-1.078,1.976-1.726,3.292-1.726c1.312,0,2.536,0.647,3.287,1.726l31.798,45.854c0.842,1.226,0.945,2.813,0.254,4.134   c-0.693,1.32-2.062,2.148-3.547,2.148h-21.037v127.48l29.209-29.985c2.188-2.749,3.633-6.498,3.715-9.997   c0-8.763,0-13.944,0.004-16.981H271.2c-2.209,0-4-1.791-4-4v-41.048c0-2.209,1.791-4,4-4h41.039c2.209,0,4,1.791,4,4V203.177z"/>
		</g>
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
