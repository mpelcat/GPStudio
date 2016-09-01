<?xml version="1.0" encoding="UTF-8"?>
<io driver="arm" categ="hps" pi_size_addr_rel="0" desc="">
  <parts>
    <part name="main">
      <svg width="160" height="110">
        <rect width="160" height="110" x="0" y="0" fill="lightgray"/>
        <text x="50" y="50">ARM</text>
      </svg>
    </part>
  </parts>
  <files>
    <file name="arm.v" type="verilog" group="hdl" path="hdl/arm.v"/>
    <file name="soc_system.v" type="verilog" group="hdl" path="hdl/synthesis/soc_system.v"/>
    <file name="soc_system.qip" type="qip" group="hdl" path="hdl/synthesis/soc_system.qip"/>
    <file name="submodules" type="directory" group="hdl" path="hdl/synthesis/submodules/"/>
    <file name="arm.io" type="io" group="blockdef" path="arm.io"/>
  </files>
  <resets>
    <reset name="hps_0_h2f_reset_reset_n" group="reset_n" direction="out"/>
    <reset name="reset_reset_n" group="reset_n" direction="in"/>
  </resets>
  <flows>
    <flow name="in0" size="16" type="in"/>
    <flow name="in1" size="16" type="in"/>
    <flow name="out0" size="16" type="out"/>
    <flow name="out1" size="16" type="out"/>
  </flows>
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
    <port name="hps_0_f2h_cold_reset_req_reset_n" type="in" size="1" desc=""/>
    <port name="hps_0_f2h_debug_reset_req_reset_n" type="in" size="1" desc=""/>
    <port name="hps_0_f2h_warm_reset_req_reset_n" type="in" size="1" desc=""/>
    <port name="hps_0_f2h_stm_hw_events_stm_hwevents" type="in" size="28" desc=""/>
  </ports>
  <pins/>
</io>
