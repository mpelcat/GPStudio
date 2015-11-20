<?xml version="1.0" encoding="UTF-8" ?>
<io driver="arm" categ="hps" pi_size_addr_rel="" master_count="1">
	<svg width="160" height="110">
		<rect width="160" height="110" x="0" y="0" fill="lightgray"/>
		<text x="50" y="50">ARM</text>
	</svg>
	<files>
		<file name="arm.v" path="hdl/arm.v" type="verilog" group="hdl" desc=""/>
		<file name="soc_system.v" path="hdl/synthesis/soc_system.v" type="verilog" group="hdl" desc=""/>
		<file name="soc_system.qip" path="hdl/synthesis/soc_system.qip" type="qip" group="hdl" desc=""/>
		<file name="submodules" path="hdl/synthesis/submodules/" type="directory" group="hdl" desc=""/>
	</files>

	<flows>
		<flow name="in0" type="in" size="16" desc=""/>
		<flow name="in1" type="in" size="16" desc=""/>
		
		<flow name="out0" type="out" size="16" desc=""/>
		<flow name="out1" type="out" size="16" desc=""/> 
	</flows>
	<params>
	</params>

	<properties>
	</properties>
	<ports>
		<port name="memory_mem_a" type="out" size="15" desc=""/>
		<port name="memory_mem_ba" type="out" size="3" desc=""/>
		<port name="memory_mem_ck" type="out" size="1" desc=""/>
		<port name="memory_mem_ck_n" type="out" size="1" desc=""/>
		<port name="memory_mem_cke" type="out" size="1" desc=""/>
		<port name="memory_mem_cs_n" type="out" size="1" desc=""/>
		<port name="memory_mem_ras_n" type="out" size="1" desc=""/>
		<port name="memory_mem_cas_n" type="out" size="1" desc=""/>
		<port name="memory_mem_we_n" type="out" size="1" desc=""/>
		<port name="memory_mem_reset_n" type="out" size="1" desc=""/>
		<port name="memory_mem_dq" type="inout" size="32" desc=""/>
		<port name="memory_mem_dqs" type="inout" size="4" desc=""/>
		<port name="memory_mem_dqs_n" type="inout" size="4" desc=""/>
		<port name="memory_mem_odt" type="out" size="1" desc=""/>
		<port name="memory_mem_dm" type="out" size="4" desc=""/>
		<port name="memory_oct_rzqin" type="in" size="1" desc=""/>
		
		<port name="hps_0_hps_io_hps_io_emac1_inst_TX_CLK" type="out" size="1" desc=""/>
		<port name="hps_0_hps_io_hps_io_emac1_inst_TXD0" type="out" size="1" desc=""/>
		<port name="hps_0_hps_io_hps_io_emac1_inst_TXD1" type="out" size="1" desc=""/>
		<port name="hps_0_hps_io_hps_io_emac1_inst_TXD2" type="out" size="1" desc=""/>
		<port name="hps_0_hps_io_hps_io_emac1_inst_TXD3" type="out" size="1" desc=""/>
		<port name="hps_0_hps_io_hps_io_emac1_inst_RXD0" type="in" size="1" desc=""/>
		<port name="hps_0_hps_io_hps_io_emac1_inst_RXD1" type="in" size="1" desc=""/>
		<port name="hps_0_hps_io_hps_io_emac1_inst_RXD2" type="in" size="1" desc=""/>
		<port name="hps_0_hps_io_hps_io_emac1_inst_RXD3" type="in" size="1" desc=""/>
		<port name="hps_0_hps_io_hps_io_emac1_inst_RX_CTL" type="in" size="1" desc=""/>
		<port name="hps_0_hps_io_hps_io_emac1_inst_RX_CLK" type="in" size="1" desc=""/>
		<port name="hps_0_hps_io_hps_io_emac1_inst_MDC" type="out" size="1" desc=""/>
		<port name="hps_0_hps_io_hps_io_emac1_inst_TX_CTL" type="out" size="1" desc=""/>
		<port name="hps_0_hps_io_hps_io_emac1_inst_MDIO" type="inout" size="1" desc=""/>
		
		<port name="hps_0_hps_io_hps_io_qspi_inst_IO0" type="inout" size="1" desc=""/>
		<port name="hps_0_hps_io_hps_io_qspi_inst_IO1" type="inout" size="1" desc=""/>
		<port name="hps_0_hps_io_hps_io_qspi_inst_IO2" type="inout" size="1" desc=""/>
		<port name="hps_0_hps_io_hps_io_qspi_inst_IO3" type="inout" size="1" desc=""/>
		<port name="hps_0_hps_io_hps_io_qspi_inst_SS0" type="out" size="1" desc=""/>
		<port name="hps_0_hps_io_hps_io_qspi_inst_CLK" type="out" size="1" desc=""/>
		
		<port name="hps_0_hps_io_hps_io_sdio_inst_CLK" type="out" size="1" desc=""/>
		<port name="hps_0_hps_io_hps_io_sdio_inst_CMD" type="inout" size="1" desc=""/>
		<port name="hps_0_hps_io_hps_io_sdio_inst_D0" type="inout" size="1" desc=""/>
		<port name="hps_0_hps_io_hps_io_sdio_inst_D1" type="inout" size="1" desc=""/>
		<port name="hps_0_hps_io_hps_io_sdio_inst_D2" type="inout" size="1" desc=""/>
		<port name="hps_0_hps_io_hps_io_sdio_inst_D3" type="inout" size="1" desc=""/>
		
		<port name="hps_0_hps_io_hps_io_usb1_inst_D0" type="inout" size="1" desc=""/>
		<port name="hps_0_hps_io_hps_io_usb1_inst_D1" type="inout" size="1" desc=""/>
		<port name="hps_0_hps_io_hps_io_usb1_inst_D2" type="inout" size="1" desc=""/>
		<port name="hps_0_hps_io_hps_io_usb1_inst_D3" type="inout" size="1" desc=""/>
		<port name="hps_0_hps_io_hps_io_usb1_inst_D4" type="inout" size="1" desc=""/>
		<port name="hps_0_hps_io_hps_io_usb1_inst_D5" type="inout" size="1" desc=""/>
		<port name="hps_0_hps_io_hps_io_usb1_inst_D6" type="inout" size="1" desc=""/>
		<port name="hps_0_hps_io_hps_io_usb1_inst_D7" type="inout" size="1" desc=""/>
		<port name="hps_0_hps_io_hps_io_usb1_inst_CLK" type="in" size="1" desc=""/>
		<port name="hps_0_hps_io_hps_io_usb1_inst_DIR" type="in" size="1" desc=""/>
		<port name="hps_0_hps_io_hps_io_usb1_inst_NXT" type="in" size="1" desc=""/>
		<port name="hps_0_hps_io_hps_io_usb1_inst_STP" type="out" size="1" desc=""/>
		
		<port name="hps_0_hps_io_hps_io_spim0_inst_CLK" type="out" size="1" desc=""/>
		<port name="hps_0_hps_io_hps_io_spim0_inst_MOSI" type="out" size="1" desc=""/>
		<port name="hps_0_hps_io_hps_io_spim0_inst_MISO" type="in" size="1" desc=""/>
		<port name="hps_0_hps_io_hps_io_spim0_inst_SS0" type="out" size="1" desc=""/>
		
		<port name="hps_0_hps_io_hps_io_spim1_inst_CLK" type="out" size="1" desc=""/>
		<port name="hps_0_hps_io_hps_io_spim1_inst_MOSI" type="out" size="1" desc=""/>
		<port name="hps_0_hps_io_hps_io_spim1_inst_MISO" type="in" size="1" desc=""/>
		<port name="hps_0_hps_io_hps_io_spim1_inst_SS0" type="out" size="1" desc=""/>
		
		<port name="hps_0_hps_io_hps_io_uart0_inst_RX" type="in" size="1" desc=""/>
		<port name="hps_0_hps_io_hps_io_uart0_inst_TX" type="out" size="1" desc=""/>
		
		<port name="hps_0_hps_io_hps_io_i2c1_inst_SDA" type="inout" size="1" desc=""/>
		<port name="hps_0_hps_io_hps_io_i2c1_inst_SCL" type="inout" size="1" desc=""/>

		<port name="hps_0_hps_io_hps_io_gpio_inst_GPIO00" type="inout" size="1" desc=""/>
		<port name="hps_0_hps_io_hps_io_gpio_inst_GPIO09" type="inout" size="1" desc=""/>
		<port name="hps_0_hps_io_hps_io_gpio_inst_GPIO35" type="inout" size="1" desc=""/>
		<port name="hps_0_hps_io_hps_io_gpio_inst_GPIO48" type="inout" size="1" desc=""/>
		<port name="hps_0_hps_io_hps_io_gpio_inst_GPIO53" type="inout" size="1" desc=""/>
		<port name="hps_0_hps_io_hps_io_gpio_inst_GPIO54" type="inout" size="1" desc=""/>
		<port name="hps_0_hps_io_hps_io_gpio_inst_GPIO55" type="inout" size="1" desc=""/>
		<port name="hps_0_hps_io_hps_io_gpio_inst_GPIO56" type="inout" size="1" desc=""/>
		<port name="hps_0_hps_io_hps_io_gpio_inst_GPIO61" type="inout" size="1" desc=""/>
		<port name="hps_0_hps_io_hps_io_gpio_inst_GPIO62" type="inout" size="1" desc=""/>
		
<!--
		<port name="hps_0_h2f_reset_reset_n" type="out" size="1" desc=""/>
-->
		<port name="hps_0_f2h_cold_reset_req_reset_n" type="in" size="1" desc=""/>
		<port name="hps_0_f2h_debug_reset_req_reset_n" type="in" size="1" desc=""/>
		<port name="hps_0_f2h_warm_reset_req_reset_n" type="in" size="1" desc=""/>
		<port name="hps_0_f2h_stm_hw_events_stm_hwevents" type="in" size="28" desc=""/>
	</ports>
	
	<resets>
		<reset name="hps_0_h2f_reset_reset_n" group="reset_n" direction="out" desc=""/>
		<reset name="reset_reset_n" group="reset_n" direction="in" desc=""/>
	</resets>
	
	<attributes>
		<attribute name="D5_DELAY" value="2 -to arm_memory_mem_ck -tag __hps_sdram_p0" type="instance"/>
		<attribute name="D5_DELAY" value="2 -to arm_memory_mem_ck_n -tag __hps_sdram_p0" type="instance"/>
		<attribute name="PACKAGE_SKEW_COMPENSATION" value="OFF -to arm_memory_mem_dq[0] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="PACKAGE_SKEW_COMPENSATION" value="OFF -to arm_memory_mem_dq[1] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="PACKAGE_SKEW_COMPENSATION" value="OFF -to arm_memory_mem_dq[2] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="PACKAGE_SKEW_COMPENSATION" value="OFF -to arm_memory_mem_dq[3] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="PACKAGE_SKEW_COMPENSATION" value="OFF -to arm_memory_mem_dq[4] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="PACKAGE_SKEW_COMPENSATION" value="OFF -to arm_memory_mem_dq[5] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="PACKAGE_SKEW_COMPENSATION" value="OFF -to arm_memory_mem_dq[6] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="PACKAGE_SKEW_COMPENSATION" value="OFF -to arm_memory_mem_dq[7] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="PACKAGE_SKEW_COMPENSATION" value="OFF -to arm_memory_mem_dq[8] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="PACKAGE_SKEW_COMPENSATION" value="OFF -to arm_memory_mem_dq[9] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="PACKAGE_SKEW_COMPENSATION" value="OFF -to arm_memory_mem_dq[10] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="PACKAGE_SKEW_COMPENSATION" value="OFF -to arm_memory_mem_dq[11] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="PACKAGE_SKEW_COMPENSATION" value="OFF -to arm_memory_mem_dq[12] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="PACKAGE_SKEW_COMPENSATION" value="OFF -to arm_memory_mem_dq[13] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="PACKAGE_SKEW_COMPENSATION" value="OFF -to arm_memory_mem_dq[14] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="PACKAGE_SKEW_COMPENSATION" value="OFF -to arm_memory_mem_dq[15] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="PACKAGE_SKEW_COMPENSATION" value="OFF -to arm_memory_mem_dq[16] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="PACKAGE_SKEW_COMPENSATION" value="OFF -to arm_memory_mem_dq[17] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="PACKAGE_SKEW_COMPENSATION" value="OFF -to arm_memory_mem_dq[18] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="PACKAGE_SKEW_COMPENSATION" value="OFF -to arm_memory_mem_dq[19] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="PACKAGE_SKEW_COMPENSATION" value="OFF -to arm_memory_mem_dq[20] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="PACKAGE_SKEW_COMPENSATION" value="OFF -to arm_memory_mem_dq[21] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="PACKAGE_SKEW_COMPENSATION" value="OFF -to arm_memory_mem_dq[22] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="PACKAGE_SKEW_COMPENSATION" value="OFF -to arm_memory_mem_dq[23] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="PACKAGE_SKEW_COMPENSATION" value="OFF -to arm_memory_mem_dq[24] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="PACKAGE_SKEW_COMPENSATION" value="OFF -to arm_memory_mem_dq[25] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="PACKAGE_SKEW_COMPENSATION" value="OFF -to arm_memory_mem_dq[26] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="PACKAGE_SKEW_COMPENSATION" value="OFF -to arm_memory_mem_dq[27] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="PACKAGE_SKEW_COMPENSATION" value="OFF -to arm_memory_mem_dq[28] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="PACKAGE_SKEW_COMPENSATION" value="OFF -to arm_memory_mem_dq[29] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="PACKAGE_SKEW_COMPENSATION" value="OFF -to arm_memory_mem_dq[30] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="PACKAGE_SKEW_COMPENSATION" value="OFF -to arm_memory_mem_dq[31] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="PACKAGE_SKEW_COMPENSATION" value="OFF -to arm_memory_mem_dm[0] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="PACKAGE_SKEW_COMPENSATION" value="OFF -to arm_memory_mem_dm[1] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="PACKAGE_SKEW_COMPENSATION" value="OFF -to arm_memory_mem_dm[2] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="PACKAGE_SKEW_COMPENSATION" value="OFF -to arm_memory_mem_dm[3] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="PACKAGE_SKEW_COMPENSATION" value="OFF -to arm_memory_mem_dqs[0] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="PACKAGE_SKEW_COMPENSATION" value="OFF -to arm_memory_mem_dqs[1] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="PACKAGE_SKEW_COMPENSATION" value="OFF -to arm_memory_mem_dqs[2] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="PACKAGE_SKEW_COMPENSATION" value="OFF -to arm_memory_mem_dqs[3] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="PACKAGE_SKEW_COMPENSATION" value="OFF -to arm_memory_mem_dqs_n[0] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="PACKAGE_SKEW_COMPENSATION" value="OFF -to arm_memory_mem_dqs_n[1] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="PACKAGE_SKEW_COMPENSATION" value="OFF -to arm_memory_mem_dqs_n[2] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="PACKAGE_SKEW_COMPENSATION" value="OFF -to arm_memory_mem_dqs_n[3] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="PACKAGE_SKEW_COMPENSATION" value="OFF -to arm_memory_mem_a[0] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="PACKAGE_SKEW_COMPENSATION" value="OFF -to arm_memory_mem_a[10] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="PACKAGE_SKEW_COMPENSATION" value="OFF -to arm_memory_mem_a[11] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="PACKAGE_SKEW_COMPENSATION" value="OFF -to arm_memory_mem_a[12] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="PACKAGE_SKEW_COMPENSATION" value="OFF -to arm_memory_mem_a[13] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="PACKAGE_SKEW_COMPENSATION" value="OFF -to arm_memory_mem_a[14] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="PACKAGE_SKEW_COMPENSATION" value="OFF -to arm_memory_mem_a[1] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="PACKAGE_SKEW_COMPENSATION" value="OFF -to arm_memory_mem_a[2] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="PACKAGE_SKEW_COMPENSATION" value="OFF -to arm_memory_mem_a[3] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="PACKAGE_SKEW_COMPENSATION" value="OFF -to arm_memory_mem_a[4] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="PACKAGE_SKEW_COMPENSATION" value="OFF -to arm_memory_mem_a[5] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="PACKAGE_SKEW_COMPENSATION" value="OFF -to arm_memory_mem_a[6] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="PACKAGE_SKEW_COMPENSATION" value="OFF -to arm_memory_mem_a[7] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="PACKAGE_SKEW_COMPENSATION" value="OFF -to arm_memory_mem_a[8] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="PACKAGE_SKEW_COMPENSATION" value="OFF -to arm_memory_mem_a[9] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="PACKAGE_SKEW_COMPENSATION" value="OFF -to arm_memory_mem_ba[0] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="PACKAGE_SKEW_COMPENSATION" value="OFF -to arm_memory_mem_ba[1] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="PACKAGE_SKEW_COMPENSATION" value="OFF -to arm_memory_mem_ba[2] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="PACKAGE_SKEW_COMPENSATION" value="OFF -to arm_memory_mem_cas_n -tag __hps_sdram_p0" type="instance"/>
		<attribute name="PACKAGE_SKEW_COMPENSATION" value="OFF -to arm_memory_mem_cke -tag __hps_sdram_p0" type="instance"/>
		<attribute name="PACKAGE_SKEW_COMPENSATION" value="OFF -to arm_memory_mem_cs_n -tag __hps_sdram_p0" type="instance"/>
		<attribute name="PACKAGE_SKEW_COMPENSATION" value="OFF -to arm_memory_mem_odt -tag __hps_sdram_p0" type="instance"/>
		<attribute name="PACKAGE_SKEW_COMPENSATION" value="OFF -to arm_memory_mem_ras_n -tag __hps_sdram_p0" type="instance"/>
		<attribute name="PACKAGE_SKEW_COMPENSATION" value="OFF -to arm_memory_mem_we_n -tag __hps_sdram_p0" type="instance"/>
		<attribute name="PACKAGE_SKEW_COMPENSATION" value="OFF -to arm_memory_mem_reset_n -tag __hps_sdram_p0" type="instance"/>
		<attribute name="PACKAGE_SKEW_COMPENSATION" value="OFF -to arm_memory_mem_ck -tag __hps_sdram_p0" type="instance"/>
		<attribute name="PACKAGE_SKEW_COMPENSATION" value="OFF -to arm_memory_mem_ck_n -tag __hps_sdram_p0" type="instance"/>
		<attribute name="GLOBAL_SIGNAL" value="OFF -to arm_inst|soc_system_inst|hps_0|hps_io|border|hps_sdram_inst|p0|umemphy|ureset|phy_reset_mem_stable_n -tag __hps_sdram_p0" type="instance"/>
		<attribute name="GLOBAL_SIGNAL" value="OFF -to arm_inst|soc_system_inst|hps_0|hps_io|border|hps_sdram_inst|p0|umemphy|ureset|phy_reset_n -tag __hps_sdram_p0" type="instance"/>
		<attribute name="GLOBAL_SIGNAL" value="OFF -to arm_inst|soc_system_inst|hps_0|hps_io|border|hps_sdram_inst|p0|umemphy|uio_pads|dq_ddio[0].read_capture_clk_buffer -tag __hps_sdram_p0" type="instance"/>
		<attribute name="GLOBAL_SIGNAL" value="OFF -to arm_inst|soc_system_inst|hps_0|hps_io|border|hps_sdram_inst|p0|umemphy|uread_datapath|reset_n_fifo_write_side[0] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="GLOBAL_SIGNAL" value="OFF -to arm_inst|soc_system_inst|hps_0|hps_io|border|hps_sdram_inst|p0|umemphy|uread_datapath|reset_n_fifo_wraddress[0] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="GLOBAL_SIGNAL" value="OFF -to arm_inst|soc_system_inst|hps_0|hps_io|border|hps_sdram_inst|p0|umemphy|uio_pads|dq_ddio[1].read_capture_clk_buffer -tag __hps_sdram_p0" type="instance"/>
		<attribute name="GLOBAL_SIGNAL" value="OFF -to arm_inst|soc_system_inst|hps_0|hps_io|border|hps_sdram_inst|p0|umemphy|uread_datapath|reset_n_fifo_write_side[1] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="GLOBAL_SIGNAL" value="OFF -to arm_inst|soc_system_inst|hps_0|hps_io|border|hps_sdram_inst|p0|umemphy|uread_datapath|reset_n_fifo_wraddress[1] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="GLOBAL_SIGNAL" value="OFF -to arm_inst|soc_system_inst|hps_0|hps_io|border|hps_sdram_inst|p0|umemphy|uio_pads|dq_ddio[2].read_capture_clk_buffer -tag __hps_sdram_p0" type="instance"/>
		<attribute name="GLOBAL_SIGNAL" value="OFF -to arm_inst|soc_system_inst|hps_0|hps_io|border|hps_sdram_inst|p0|umemphy|uread_datapath|reset_n_fifo_write_side[2] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="GLOBAL_SIGNAL" value="OFF -to arm_inst|soc_system_inst|hps_0|hps_io|border|hps_sdram_inst|p0|umemphy|uread_datapath|reset_n_fifo_wraddress[2] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="GLOBAL_SIGNAL" value="OFF -to arm_inst|soc_system_inst|hps_0|hps_io|border|hps_sdram_inst|p0|umemphy|uio_pads|dq_ddio[3].read_capture_clk_buffer -tag __hps_sdram_p0" type="instance"/>
		<attribute name="GLOBAL_SIGNAL" value="OFF -to arm_inst|soc_system_inst|hps_0|hps_io|border|hps_sdram_inst|p0|umemphy|uread_datapath|reset_n_fifo_write_side[3] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="GLOBAL_SIGNAL" value="OFF -to arm_inst|soc_system_inst|hps_0|hps_io|border|hps_sdram_inst|p0|umemphy|uread_datapath|reset_n_fifo_wraddress[3] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="ENABLE_BENEFICIAL_SKEW_OPTIMIZATION_FOR_NON_GLOBAL_CLOCKS" value="ON -to arm_inst|soc_system_inst|hps_0|hps_io|border|hps_sdram_inst -tag __hps_sdram_p0" type="instance"/>
		<attribute name="PLL_COMPENSATION_MODE" value="DIRECT -to arm_inst|soc_system_inst|hps_0|hps_io|border|hps_sdram_inst|pll0|fbout -tag __hps_sdram_p0" type="instance"/>
		
		<attribute name="IO_STANDARD" value="&quot;SSTL-15 CLASS I&quot; -to arm_memory_oct_rzqin -tag __hps_sdram_p0" type="instance"/>
		<attribute name="IO_STANDARD" value="&quot;SSTL-15 CLASS I&quot; -to arm_memory_mem_dq[0] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="INPUT_TERMINATION" value="&quot;PARALLEL 50 OHM WITH CALIBRATION&quot; -to arm_memory_mem_dq[0] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="OUTPUT_TERMINATION" value="&quot;SERIES 50 OHM WITH CALIBRATION&quot; -to arm_memory_mem_dq[0] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="IO_STANDARD" value="&quot;SSTL-15 CLASS I&quot; -to arm_memory_mem_dq[1] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="INPUT_TERMINATION" value="&quot;PARALLEL 50 OHM WITH CALIBRATION&quot; -to arm_memory_mem_dq[1] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="OUTPUT_TERMINATION" value="&quot;SERIES 50 OHM WITH CALIBRATION&quot; -to arm_memory_mem_dq[1] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="IO_STANDARD" value="&quot;SSTL-15 CLASS I&quot; -to arm_memory_mem_dq[2] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="INPUT_TERMINATION" value="&quot;PARALLEL 50 OHM WITH CALIBRATION&quot; -to arm_memory_mem_dq[2] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="OUTPUT_TERMINATION" value="&quot;SERIES 50 OHM WITH CALIBRATION&quot; -to arm_memory_mem_dq[2] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="IO_STANDARD" value="&quot;SSTL-15 CLASS I&quot; -to arm_memory_mem_dq[3] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="INPUT_TERMINATION" value="&quot;PARALLEL 50 OHM WITH CALIBRATION&quot; -to arm_memory_mem_dq[3] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="OUTPUT_TERMINATION" value="&quot;SERIES 50 OHM WITH CALIBRATION&quot; -to arm_memory_mem_dq[3] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="IO_STANDARD" value="&quot;SSTL-15 CLASS I&quot; -to arm_memory_mem_dq[4] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="INPUT_TERMINATION" value="&quot;PARALLEL 50 OHM WITH CALIBRATION&quot; -to arm_memory_mem_dq[4] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="OUTPUT_TERMINATION" value="&quot;SERIES 50 OHM WITH CALIBRATION&quot; -to arm_memory_mem_dq[4] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="IO_STANDARD" value="&quot;SSTL-15 CLASS I&quot; -to arm_memory_mem_dq[5] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="INPUT_TERMINATION" value="&quot;PARALLEL 50 OHM WITH CALIBRATION&quot; -to arm_memory_mem_dq[5] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="OUTPUT_TERMINATION" value="&quot;SERIES 50 OHM WITH CALIBRATION&quot; -to arm_memory_mem_dq[5] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="IO_STANDARD" value="&quot;SSTL-15 CLASS I&quot; -to arm_memory_mem_dq[6] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="INPUT_TERMINATION" value="&quot;PARALLEL 50 OHM WITH CALIBRATION&quot; -to arm_memory_mem_dq[6] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="OUTPUT_TERMINATION" value="&quot;SERIES 50 OHM WITH CALIBRATION&quot; -to arm_memory_mem_dq[6] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="IO_STANDARD" value="&quot;SSTL-15 CLASS I&quot; -to arm_memory_mem_dq[7] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="INPUT_TERMINATION" value="&quot;PARALLEL 50 OHM WITH CALIBRATION&quot; -to arm_memory_mem_dq[7] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="OUTPUT_TERMINATION" value="&quot;SERIES 50 OHM WITH CALIBRATION&quot; -to arm_memory_mem_dq[7] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="IO_STANDARD" value="&quot;SSTL-15 CLASS I&quot; -to arm_memory_mem_dq[8] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="INPUT_TERMINATION" value="&quot;PARALLEL 50 OHM WITH CALIBRATION&quot; -to arm_memory_mem_dq[8] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="OUTPUT_TERMINATION" value="&quot;SERIES 50 OHM WITH CALIBRATION&quot; -to arm_memory_mem_dq[8] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="IO_STANDARD" value="&quot;SSTL-15 CLASS I&quot; -to arm_memory_mem_dq[9] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="INPUT_TERMINATION" value="&quot;PARALLEL 50 OHM WITH CALIBRATION&quot; -to arm_memory_mem_dq[9] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="OUTPUT_TERMINATION" value="&quot;SERIES 50 OHM WITH CALIBRATION&quot; -to arm_memory_mem_dq[9] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="IO_STANDARD" value="&quot;SSTL-15 CLASS I&quot; -to arm_memory_mem_dq[10] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="INPUT_TERMINATION" value="&quot;PARALLEL 50 OHM WITH CALIBRATION&quot; -to arm_memory_mem_dq[10] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="OUTPUT_TERMINATION" value="&quot;SERIES 50 OHM WITH CALIBRATION&quot; -to arm_memory_mem_dq[10] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="IO_STANDARD" value="&quot;SSTL-15 CLASS I&quot; -to arm_memory_mem_dq[11] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="INPUT_TERMINATION" value="&quot;PARALLEL 50 OHM WITH CALIBRATION&quot; -to arm_memory_mem_dq[11] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="OUTPUT_TERMINATION" value="&quot;SERIES 50 OHM WITH CALIBRATION&quot; -to arm_memory_mem_dq[11] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="IO_STANDARD" value="&quot;SSTL-15 CLASS I&quot; -to arm_memory_mem_dq[12] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="INPUT_TERMINATION" value="&quot;PARALLEL 50 OHM WITH CALIBRATION&quot; -to arm_memory_mem_dq[12] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="OUTPUT_TERMINATION" value="&quot;SERIES 50 OHM WITH CALIBRATION&quot; -to arm_memory_mem_dq[12] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="IO_STANDARD" value="&quot;SSTL-15 CLASS I&quot; -to arm_memory_mem_dq[13] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="INPUT_TERMINATION" value="&quot;PARALLEL 50 OHM WITH CALIBRATION&quot; -to arm_memory_mem_dq[13] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="OUTPUT_TERMINATION" value="&quot;SERIES 50 OHM WITH CALIBRATION&quot; -to arm_memory_mem_dq[13] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="IO_STANDARD" value="&quot;SSTL-15 CLASS I&quot; -to arm_memory_mem_dq[14] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="INPUT_TERMINATION" value="&quot;PARALLEL 50 OHM WITH CALIBRATION&quot; -to arm_memory_mem_dq[14] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="OUTPUT_TERMINATION" value="&quot;SERIES 50 OHM WITH CALIBRATION&quot; -to arm_memory_mem_dq[14] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="IO_STANDARD" value="&quot;SSTL-15 CLASS I&quot; -to arm_memory_mem_dq[15] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="INPUT_TERMINATION" value="&quot;PARALLEL 50 OHM WITH CALIBRATION&quot; -to arm_memory_mem_dq[15] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="OUTPUT_TERMINATION" value="&quot;SERIES 50 OHM WITH CALIBRATION&quot; -to arm_memory_mem_dq[15] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="IO_STANDARD" value="&quot;SSTL-15 CLASS I&quot; -to arm_memory_mem_dq[16] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="INPUT_TERMINATION" value="&quot;PARALLEL 50 OHM WITH CALIBRATION&quot; -to arm_memory_mem_dq[16] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="OUTPUT_TERMINATION" value="&quot;SERIES 50 OHM WITH CALIBRATION&quot; -to arm_memory_mem_dq[16] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="IO_STANDARD" value="&quot;SSTL-15 CLASS I&quot; -to arm_memory_mem_dq[17] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="INPUT_TERMINATION" value="&quot;PARALLEL 50 OHM WITH CALIBRATION&quot; -to arm_memory_mem_dq[17] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="OUTPUT_TERMINATION" value="&quot;SERIES 50 OHM WITH CALIBRATION&quot; -to arm_memory_mem_dq[17] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="IO_STANDARD" value="&quot;SSTL-15 CLASS I&quot; -to arm_memory_mem_dq[18] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="INPUT_TERMINATION" value="&quot;PARALLEL 50 OHM WITH CALIBRATION&quot; -to arm_memory_mem_dq[18] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="OUTPUT_TERMINATION" value="&quot;SERIES 50 OHM WITH CALIBRATION&quot; -to arm_memory_mem_dq[18] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="IO_STANDARD" value="&quot;SSTL-15 CLASS I&quot; -to arm_memory_mem_dq[19] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="INPUT_TERMINATION" value="&quot;PARALLEL 50 OHM WITH CALIBRATION&quot; -to arm_memory_mem_dq[19] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="OUTPUT_TERMINATION" value="&quot;SERIES 50 OHM WITH CALIBRATION&quot; -to arm_memory_mem_dq[19] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="IO_STANDARD" value="&quot;SSTL-15 CLASS I&quot; -to arm_memory_mem_dq[20] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="INPUT_TERMINATION" value="&quot;PARALLEL 50 OHM WITH CALIBRATION&quot; -to arm_memory_mem_dq[20] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="OUTPUT_TERMINATION" value="&quot;SERIES 50 OHM WITH CALIBRATION&quot; -to arm_memory_mem_dq[20] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="IO_STANDARD" value="&quot;SSTL-15 CLASS I&quot; -to arm_memory_mem_dq[21] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="INPUT_TERMINATION" value="&quot;PARALLEL 50 OHM WITH CALIBRATION&quot; -to arm_memory_mem_dq[21] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="OUTPUT_TERMINATION" value="&quot;SERIES 50 OHM WITH CALIBRATION&quot; -to arm_memory_mem_dq[21] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="IO_STANDARD" value="&quot;SSTL-15 CLASS I&quot; -to arm_memory_mem_dq[22] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="INPUT_TERMINATION" value="&quot;PARALLEL 50 OHM WITH CALIBRATION&quot; -to arm_memory_mem_dq[22] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="OUTPUT_TERMINATION" value="&quot;SERIES 50 OHM WITH CALIBRATION&quot; -to arm_memory_mem_dq[22] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="IO_STANDARD" value="&quot;SSTL-15 CLASS I&quot; -to arm_memory_mem_dq[23] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="INPUT_TERMINATION" value="&quot;PARALLEL 50 OHM WITH CALIBRATION&quot; -to arm_memory_mem_dq[23] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="OUTPUT_TERMINATION" value="&quot;SERIES 50 OHM WITH CALIBRATION&quot; -to arm_memory_mem_dq[23] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="IO_STANDARD" value="&quot;SSTL-15 CLASS I&quot; -to arm_memory_mem_dq[24] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="INPUT_TERMINATION" value="&quot;PARALLEL 50 OHM WITH CALIBRATION&quot; -to arm_memory_mem_dq[24] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="OUTPUT_TERMINATION" value="&quot;SERIES 50 OHM WITH CALIBRATION&quot; -to arm_memory_mem_dq[24] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="IO_STANDARD" value="&quot;SSTL-15 CLASS I&quot; -to arm_memory_mem_dq[25] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="INPUT_TERMINATION" value="&quot;PARALLEL 50 OHM WITH CALIBRATION&quot; -to arm_memory_mem_dq[25] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="OUTPUT_TERMINATION" value="&quot;SERIES 50 OHM WITH CALIBRATION&quot; -to arm_memory_mem_dq[25] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="IO_STANDARD" value="&quot;SSTL-15 CLASS I&quot; -to arm_memory_mem_dq[26] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="INPUT_TERMINATION" value="&quot;PARALLEL 50 OHM WITH CALIBRATION&quot; -to arm_memory_mem_dq[26] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="OUTPUT_TERMINATION" value="&quot;SERIES 50 OHM WITH CALIBRATION&quot; -to arm_memory_mem_dq[26] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="IO_STANDARD" value="&quot;SSTL-15 CLASS I&quot; -to arm_memory_mem_dq[27] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="INPUT_TERMINATION" value="&quot;PARALLEL 50 OHM WITH CALIBRATION&quot; -to arm_memory_mem_dq[27] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="OUTPUT_TERMINATION" value="&quot;SERIES 50 OHM WITH CALIBRATION&quot; -to arm_memory_mem_dq[27] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="IO_STANDARD" value="&quot;SSTL-15 CLASS I&quot; -to arm_memory_mem_dq[28] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="INPUT_TERMINATION" value="&quot;PARALLEL 50 OHM WITH CALIBRATION&quot; -to arm_memory_mem_dq[28] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="OUTPUT_TERMINATION" value="&quot;SERIES 50 OHM WITH CALIBRATION&quot; -to arm_memory_mem_dq[28] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="IO_STANDARD" value="&quot;SSTL-15 CLASS I&quot; -to arm_memory_mem_dq[29] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="INPUT_TERMINATION" value="&quot;PARALLEL 50 OHM WITH CALIBRATION&quot; -to arm_memory_mem_dq[29] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="OUTPUT_TERMINATION" value="&quot;SERIES 50 OHM WITH CALIBRATION&quot; -to arm_memory_mem_dq[29] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="IO_STANDARD" value="&quot;SSTL-15 CLASS I&quot; -to arm_memory_mem_dq[30] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="INPUT_TERMINATION" value="&quot;PARALLEL 50 OHM WITH CALIBRATION&quot; -to arm_memory_mem_dq[30] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="OUTPUT_TERMINATION" value="&quot;SERIES 50 OHM WITH CALIBRATION&quot; -to arm_memory_mem_dq[30] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="IO_STANDARD" value="&quot;SSTL-15 CLASS I&quot; -to arm_memory_mem_dq[31] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="INPUT_TERMINATION" value="&quot;PARALLEL 50 OHM WITH CALIBRATION&quot; -to arm_memory_mem_dq[31] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="OUTPUT_TERMINATION" value="&quot;SERIES 50 OHM WITH CALIBRATION&quot; -to arm_memory_mem_dq[31] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="IO_STANDARD" value="&quot;DIFFERENTIAL 1.5-V SSTL CLASS I&quot; -to arm_memory_mem_dqs[0] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="INPUT_TERMINATION" value="&quot;PARALLEL 50 OHM WITH CALIBRATION&quot; -to arm_memory_mem_dqs[0] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="OUTPUT_TERMINATION" value="&quot;SERIES 50 OHM WITH CALIBRATION&quot; -to arm_memory_mem_dqs[0] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="IO_STANDARD" value="&quot;DIFFERENTIAL 1.5-V SSTL CLASS I&quot; -to arm_memory_mem_dqs[1] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="INPUT_TERMINATION" value="&quot;PARALLEL 50 OHM WITH CALIBRATION&quot; -to arm_memory_mem_dqs[1] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="OUTPUT_TERMINATION" value="&quot;SERIES 50 OHM WITH CALIBRATION&quot; -to arm_memory_mem_dqs[1] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="IO_STANDARD" value="&quot;DIFFERENTIAL 1.5-V SSTL CLASS I&quot; -to arm_memory_mem_dqs[2] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="INPUT_TERMINATION" value="&quot;PARALLEL 50 OHM WITH CALIBRATION&quot; -to arm_memory_mem_dqs[2] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="OUTPUT_TERMINATION" value="&quot;SERIES 50 OHM WITH CALIBRATION&quot; -to arm_memory_mem_dqs[2] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="IO_STANDARD" value="&quot;DIFFERENTIAL 1.5-V SSTL CLASS I&quot; -to arm_memory_mem_dqs[3] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="INPUT_TERMINATION" value="&quot;PARALLEL 50 OHM WITH CALIBRATION&quot; -to arm_memory_mem_dqs[3] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="OUTPUT_TERMINATION" value="&quot;SERIES 50 OHM WITH CALIBRATION&quot; -to arm_memory_mem_dqs[3] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="IO_STANDARD" value="&quot;DIFFERENTIAL 1.5-V SSTL CLASS I&quot; -to arm_memory_mem_dqs_n[0] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="INPUT_TERMINATION" value="&quot;PARALLEL 50 OHM WITH CALIBRATION&quot; -to arm_memory_mem_dqs_n[0] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="OUTPUT_TERMINATION" value="&quot;SERIES 50 OHM WITH CALIBRATION&quot; -to arm_memory_mem_dqs_n[0] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="IO_STANDARD" value="&quot;DIFFERENTIAL 1.5-V SSTL CLASS I&quot; -to arm_memory_mem_dqs_n[1] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="INPUT_TERMINATION" value="&quot;PARALLEL 50 OHM WITH CALIBRATION&quot; -to arm_memory_mem_dqs_n[1] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="OUTPUT_TERMINATION" value="&quot;SERIES 50 OHM WITH CALIBRATION&quot; -to arm_memory_mem_dqs_n[1] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="IO_STANDARD" value="&quot;DIFFERENTIAL 1.5-V SSTL CLASS I&quot; -to arm_memory_mem_dqs_n[2] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="INPUT_TERMINATION" value="&quot;PARALLEL 50 OHM WITH CALIBRATION&quot; -to arm_memory_mem_dqs_n[2] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="OUTPUT_TERMINATION" value="&quot;SERIES 50 OHM WITH CALIBRATION&quot; -to arm_memory_mem_dqs_n[2] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="IO_STANDARD" value="&quot;DIFFERENTIAL 1.5-V SSTL CLASS I&quot; -to arm_memory_mem_dqs_n[3] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="INPUT_TERMINATION" value="&quot;PARALLEL 50 OHM WITH CALIBRATION&quot; -to arm_memory_mem_dqs_n[3] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="OUTPUT_TERMINATION" value="&quot;SERIES 50 OHM WITH CALIBRATION&quot; -to arm_memory_mem_dqs_n[3] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="IO_STANDARD" value="&quot;DIFFERENTIAL 1.5-V SSTL CLASS I&quot; -to arm_memory_mem_ck -tag __hps_sdram_p0" type="instance"/>
		<attribute name="OUTPUT_TERMINATION" value="&quot;SERIES 50 OHM WITHOUT CALIBRATION&quot; -to arm_memory_mem_ck -tag __hps_sdram_p0" type="instance"/>
		<attribute name="IO_STANDARD" value="&quot;DIFFERENTIAL 1.5-V SSTL CLASS I&quot; -to arm_memory_mem_ck_n -tag __hps_sdram_p0" type="instance"/>
		<attribute name="OUTPUT_TERMINATION" value="&quot;SERIES 50 OHM WITHOUT CALIBRATION&quot; -to arm_memory_mem_ck_n -tag __hps_sdram_p0" type="instance"/>
		<attribute name="IO_STANDARD" value="&quot;SSTL-15 CLASS I&quot; -to arm_memory_mem_a[0] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="CURRENT_STRENGTH_NEW" value="&quot;MAXIMUM CURRENT&quot; -to arm_memory_mem_a[0] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="IO_STANDARD" value="&quot;SSTL-15 CLASS I&quot; -to arm_memory_mem_a[10] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="CURRENT_STRENGTH_NEW" value="&quot;MAXIMUM CURRENT&quot; -to arm_memory_mem_a[10] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="IO_STANDARD" value="&quot;SSTL-15 CLASS I&quot; -to arm_memory_mem_a[11] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="CURRENT_STRENGTH_NEW" value="&quot;MAXIMUM CURRENT&quot; -to arm_memory_mem_a[11] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="IO_STANDARD" value="&quot;SSTL-15 CLASS I&quot; -to arm_memory_mem_a[12] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="CURRENT_STRENGTH_NEW" value="&quot;MAXIMUM CURRENT&quot; -to arm_memory_mem_a[12] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="IO_STANDARD" value="&quot;SSTL-15 CLASS I&quot; -to arm_memory_mem_a[13] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="CURRENT_STRENGTH_NEW" value="&quot;MAXIMUM CURRENT&quot; -to arm_memory_mem_a[13] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="IO_STANDARD" value="&quot;SSTL-15 CLASS I&quot; -to arm_memory_mem_a[14] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="CURRENT_STRENGTH_NEW" value="&quot;MAXIMUM CURRENT&quot; -to arm_memory_mem_a[14] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="IO_STANDARD" value="&quot;SSTL-15 CLASS I&quot; -to arm_memory_mem_a[1] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="CURRENT_STRENGTH_NEW" value="&quot;MAXIMUM CURRENT&quot; -to arm_memory_mem_a[1] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="IO_STANDARD" value="&quot;SSTL-15 CLASS I&quot; -to arm_memory_mem_a[2] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="CURRENT_STRENGTH_NEW" value="&quot;MAXIMUM CURRENT&quot; -to arm_memory_mem_a[2] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="IO_STANDARD" value="&quot;SSTL-15 CLASS I&quot; -to arm_memory_mem_a[3] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="CURRENT_STRENGTH_NEW" value="&quot;MAXIMUM CURRENT&quot; -to arm_memory_mem_a[3] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="IO_STANDARD" value="&quot;SSTL-15 CLASS I&quot; -to arm_memory_mem_a[4] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="CURRENT_STRENGTH_NEW" value="&quot;MAXIMUM CURRENT&quot; -to arm_memory_mem_a[4] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="IO_STANDARD" value="&quot;SSTL-15 CLASS I&quot; -to arm_memory_mem_a[5] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="CURRENT_STRENGTH_NEW" value="&quot;MAXIMUM CURRENT&quot; -to arm_memory_mem_a[5] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="IO_STANDARD" value="&quot;SSTL-15 CLASS I&quot; -to arm_memory_mem_a[6] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="CURRENT_STRENGTH_NEW" value="&quot;MAXIMUM CURRENT&quot; -to arm_memory_mem_a[6] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="IO_STANDARD" value="&quot;SSTL-15 CLASS I&quot; -to arm_memory_mem_a[7] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="CURRENT_STRENGTH_NEW" value="&quot;MAXIMUM CURRENT&quot; -to arm_memory_mem_a[7] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="IO_STANDARD" value="&quot;SSTL-15 CLASS I&quot; -to arm_memory_mem_a[8] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="CURRENT_STRENGTH_NEW" value="&quot;MAXIMUM CURRENT&quot; -to arm_memory_mem_a[8] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="IO_STANDARD" value="&quot;SSTL-15 CLASS I&quot; -to arm_memory_mem_a[9] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="CURRENT_STRENGTH_NEW" value="&quot;MAXIMUM CURRENT&quot; -to arm_memory_mem_a[9] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="IO_STANDARD" value="&quot;SSTL-15 CLASS I&quot; -to arm_memory_mem_ba[0] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="CURRENT_STRENGTH_NEW" value="&quot;MAXIMUM CURRENT&quot; -to arm_memory_mem_ba[0] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="IO_STANDARD" value="&quot;SSTL-15 CLASS I&quot; -to arm_memory_mem_ba[1] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="CURRENT_STRENGTH_NEW" value="&quot;MAXIMUM CURRENT&quot; -to arm_memory_mem_ba[1] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="IO_STANDARD" value="&quot;SSTL-15 CLASS I&quot; -to arm_memory_mem_ba[2] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="CURRENT_STRENGTH_NEW" value="&quot;MAXIMUM CURRENT&quot; -to arm_memory_mem_ba[2] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="IO_STANDARD" value="&quot;SSTL-15 CLASS I&quot; -to arm_memory_mem_cas_n -tag __hps_sdram_p0" type="instance"/>
		<attribute name="CURRENT_STRENGTH_NEW" value="&quot;MAXIMUM CURRENT&quot; -to arm_memory_mem_cas_n -tag __hps_sdram_p0" type="instance"/>
		<attribute name="IO_STANDARD" value="&quot;SSTL-15 CLASS I&quot; -to arm_memory_mem_cke -tag __hps_sdram_p0" type="instance"/>
		<attribute name="CURRENT_STRENGTH_NEW" value="&quot;MAXIMUM CURRENT&quot; -to arm_memory_mem_cke -tag __hps_sdram_p0" type="instance"/>
		<attribute name="IO_STANDARD" value="&quot;SSTL-15 CLASS I&quot; -to arm_memory_mem_cs_n -tag __hps_sdram_p0" type="instance"/>
		<attribute name="CURRENT_STRENGTH_NEW" value="&quot;MAXIMUM CURRENT&quot; -to arm_memory_mem_cs_n -tag __hps_sdram_p0" type="instance"/>
		<attribute name="IO_STANDARD" value="&quot;SSTL-15 CLASS I&quot; -to arm_memory_mem_odt -tag __hps_sdram_p0" type="instance"/>
		<attribute name="CURRENT_STRENGTH_NEW" value="&quot;MAXIMUM CURRENT&quot; -to arm_memory_mem_odt -tag __hps_sdram_p0" type="instance"/>
		<attribute name="IO_STANDARD" value="&quot;SSTL-15 CLASS I&quot; -to arm_memory_mem_ras_n -tag __hps_sdram_p0" type="instance"/>
		<attribute name="CURRENT_STRENGTH_NEW" value="&quot;MAXIMUM CURRENT&quot; -to arm_memory_mem_ras_n -tag __hps_sdram_p0" type="instance"/>
		<attribute name="IO_STANDARD" value="&quot;SSTL-15 CLASS I&quot; -to arm_memory_mem_we_n -tag __hps_sdram_p0" type="instance"/>
		<attribute name="CURRENT_STRENGTH_NEW" value="&quot;MAXIMUM CURRENT&quot; -to arm_memory_mem_we_n -tag __hps_sdram_p0" type="instance"/>
		<attribute name="IO_STANDARD" value="&quot;SSTL-15 CLASS I&quot; -to arm_memory_mem_reset_n -tag __hps_sdram_p0" type="instance"/>
		<attribute name="CURRENT_STRENGTH_NEW" value="&quot;MAXIMUM CURRENT&quot; -to arm_memory_mem_reset_n -tag __hps_sdram_p0" type="instance"/>
		<attribute name="IO_STANDARD" value="&quot;SSTL-15 CLASS I&quot; -to arm_memory_mem_dm[0] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="OUTPUT_TERMINATION" value="&quot;SERIES 50 OHM WITH CALIBRATION&quot; -to arm_memory_mem_dm[0] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="IO_STANDARD" value="&quot;SSTL-15 CLASS I&quot; -to arm_memory_mem_dm[1] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="OUTPUT_TERMINATION" value="&quot;SERIES 50 OHM WITH CALIBRATION&quot; -to arm_memory_mem_dm[1] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="IO_STANDARD" value="&quot;SSTL-15 CLASS I&quot; -to arm_memory_mem_dm[2] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="OUTPUT_TERMINATION" value="&quot;SERIES 50 OHM WITH CALIBRATION&quot; -to arm_memory_mem_dm[2] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="IO_STANDARD" value="&quot;SSTL-15 CLASS I&quot; -to arm_memory_mem_dm[3] -tag __hps_sdram_p0" type="instance"/>
		<attribute name="OUTPUT_TERMINATION" value="&quot;SERIES 50 OHM WITH CALIBRATION&quot; -to arm_memory_mem_dm[3] -tag __hps_sdram_p0" type="instance"/>
	</attributes>
</io>
