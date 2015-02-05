<?xml version="1.0" encoding="UTF-8" ?>
<io driver="usb_cypress_CY7C68014A" size_addr_rel="4" master_count="1">
	<files>
		<file name="USB datasheet" path="doc/CY7C68013A_14A_15A_16A_38-08032.pdf" type="doc" group="doc" desc=""/>
		<file name="usb.sdc" path="usb.sdc" type="sdc" group="hdl" desc=""/>
		<file name="usb.vhd" path="hdl/usb/src/usb.vhd" type="vhdl" group="hdl" desc=""/>
		<file name="usb_sm.vhd" path="hdl/usb/src/usb_sm.vhd" type="vhdl" group="hdl" desc=""/>
		
		<file name="fifo_com_rx.vhd" path="hdl/flow_in/src/fifo_com_rx.vhd" type="vhdl" group="hdl" desc=""/>
		<file name="com_flow_fifo_rx.vhd" path="hdl/flow_in/src/com_flow_fifo_rx.vhd" type="vhdl" group="hdl" desc=""/>
		<file name="read_flow.vhd" path="hdl/flow_in/src/read_flow.vhd" type="vhdl" group="hdl" desc=""/>
		<file name="flow_in.vhd" path="hdl/flow_in/src/flow_in.vhd" type="vhdl" group="hdl" desc=""/>
		
		<file name="fifo_com_tx.vhd" path="hdl/flow_out/src/fifo_com_tx.vhd" type="vhdl" group="hdl" desc=""/>
		<file name="com_flow_fifo_tx.vhd" path="hdl/flow_out/src/com_flow_fifo_tx.vhd" type="vhdl" group="hdl" desc=""/>
		<file name="write_flow.vhd" path="hdl/flow_out/src/write_flow.vhd" type="vhdl" group="hdl" desc=""/>
		<file name="flow_out.vhd" path="hdl/flow_out/src/flow_out.vhd" type="vhdl" group="hdl" desc=""/>
		
		<file name="flow_wishbone.vhd" path="hdl/flowtobus/src/flow_wishbone.vhd" type="vhdl" group="hdl" desc=""/>
		<file name="params_flow_decoder.vhd" path="hdl/flowtobus/src/params_flow_decoder.vhd" type="vhdl" group="hdl" desc=""/>
		
		<file name="ComFlow_pkg.vhd" path="hdl/utils/src/ComFlow_pkg.vhd" type="vhdl" group="hdl" desc=""/>
		<file name="synchronizer.vhd" path="hdl/utils/src/synchronizer.vhd" type="vhdl" group="hdl" desc=""/>
		<file name="enable_gen.vhd" path="hdl/utils/src/enable_gen.vhd" type="vhdl" group="hdl" desc=""/>
		<file name="fv_synchro_signal.vhd" path="hdl/utils/src/fv_synchro_signal.vhd" type="vhdl" group="hdl" desc=""/>
		<file name="flow_out_arb.vhd" path="hdl/utils/src/flow_out_arb.vhd" type="vhdl" group="hdl" desc=""/>
		
	</files>
	<flows>
		<flow name="in0" type="in" desc="flow 0 return for supervise results of process"/>
		<flow name="out0" type="out" desc="flow 0 return for supervise results of process"/>
		<flow name="in1" type="in" desc="flow 1 return for supervise results of process"/>
		<flow name="out1" type="out" desc="flow 1 return for supervise results of process"/> 
	</flows>
	<params>
		<param name="ENABLE" regaddr="0"/>
	</params>
	<ports>
		<port name="usb_rst" type="in" size="1" desc=""/>
		<port name="usb_ifclk" type="in" size="1" desc=""/>
		<port name="usb_flaga" type="in" size="1" desc=""/>
		<port name="usb_flagb" type="in" size="1" desc=""/>
		<port name="usb_flagc" type="in" size="1" desc=""/>
		<port name="usb_flagd" type="in" size="1" desc=""/>
		<port name="usb_fd_io" type="inout" size="16" desc=""/>
		<port name="usb_sloe" type="out" size="1" desc=""/>
		<port name="usb_slrd" type="out" size="1" desc=""/>
		<port name="usb_slwr" type="out" size="1" desc=""/>
		<port name="usb_pktend" type="out" size="1" desc=""/>
		<port name="usb_addr" type="out" size="2" desc=""/>
	</ports>
	<resets>
		<reset name="reset" group="reset_n" direction="out" desc=""/>
	</resets>
</io>
