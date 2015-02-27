library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.ComFlow_pkg.all;

entity usb_cypress_CY7C68014A is
	generic(
		MASTER_ADDR_WIDTH : integer
	);
	port(
		clk_proc : in std_logic;
		reset : out std_logic;

		------ external ports ------
		rst : in std_logic;
		ifclk : in std_logic;
		flaga : in std_logic;
		flagb : in std_logic;
		flagc : in std_logic;
		flagd : in std_logic;
		fd_io : inout std_logic_vector(15 downto 0);
		sloe : out std_logic;
		slrd : out std_logic;
		slwr : out std_logic;
		pktend : out std_logic;
		addr : out std_logic_vector(1 downto 0);

		------ in0 flow ------
		in0_data : in std_logic_vector(15 downto 0);
		in0_fv : in std_logic;
		in0_dv : in std_logic;
		------ in1 flow ------
		in1_data : in std_logic_vector(15 downto 0);
		in1_fv : in std_logic;
		in1_dv : in std_logic;


		------ out0 flow ------
		out0_data : out std_logic_vector(15 downto 0);
		out0_fv : out std_logic;
		out0_dv : out std_logic;

		------ out1 flow ------
		out1_data : out std_logic_vector(15 downto 0);
		out1_fv : out std_logic;
		out1_dv : out std_logic;

		---- ===== Masters =====

		------ bus_master ------
		master_addr_o : out std_logic_vector(MASTER_ADDR_WIDTH-1 downto 0);
		master_wr_o : out std_logic;
		master_rd_o : out std_logic;
		master_datawr_o : out std_logic_vector(31 downto 0);
		master_datard_i : in std_logic_vector(31 downto 0);

		---- ===== Slaves =====

		------ bus_sl ------
		addr_rel_i : in std_logic_vector(3 downto 0);
		wr_i : in std_logic;
		rd_i : in std_logic;
		datawr_i : in std_logic_vector(31 downto 0);
		datard_o : out std_logic_vector(31 downto 0)
	);
end entity;


architecture rtl of usb_cypress_CY7C68014A is

-- SIGNAUX INTERNES NON CONNECTE
signal flow_out_sel_s : std_logic:='0';
signal source_sel_s:std_logic:='0';

-- SLAVE BUS 
	signal enable_s : std_logic :='0';

-- SYNC BUS
	signal enable_s_fvsync : std_logic:='0';
	
-- USBFLOW_IN
	signal flow_in1_data_s  : std_logic_vector(15 downto 0):=(others=>'0');
	signal flow_in1_wr_s : std_logic:='0';
	signal flow_in1_full_s :	std_logic:='0';
	signal flow_in1_pktend_s : std_logic:='0';
	
-- USBFLOW OUT
	signal flow_out_data_s : std_logic_vector(15 downto 0):=(others=>'0');
	signal flow_out_empty_s : std_logic:='0';
	signal flow_out_rd_s : std_logic:='0';
	signal flow_out_rdy_s : std_logic:='0';
	
	signal flow_out_data_0_s : std_logic_vector(15 downto 0):=(others=>'0');
	signal flow_out_empty_0_s : std_logic:='0';
	signal flow_out_rd_0_s : std_logic:='0';
	signal flow_out_rdy_0_s : std_logic:='0';
	
	signal flow_out_data_1_s : std_logic_vector(15 downto 0):=(others=>'0');
	signal flow_out_empty_1_s : std_logic:='0';
	signal flow_out_rd_1_s : std_logic:='0';
	signal flow_out_rdy_1_s : std_logic:='0';
	

-- FLOW_PARAMS
	signal update_port_s : std_logic:='0';

-- USB_SM_INST

	
begin

reset <= rst;
		
USB_SM_INST : usb_sm
    -- generic map (
	  -- FLOW_STATUS_ID => 253,
	  -- NB_FLOW => 2, -- NBFLOW is declared in ComFlow_pkg package
	  -- IDFLOW =>  (1, 128)
	  -- )
    port map (
		usb_ifclk    => ifclk,
		usb_flaga    => flaga,
		usb_flagb    => flagb,
		usb_flagc    => flagc,
		usb_flagd    => flagd,
		usb_fd_io    => fd_io,
		usb_sloe     => sloe,
		usb_slrd     => slrd,
		usb_slwr     => slwr,
		usb_pktend   => pktend,
		usb_rst		 => rst,
		usb_addr     => addr,

		flow_in_data_o  => flow_in1_data_s,
		flow_in_wr_o => flow_in1_wr_s,
		flow_in_full_i => flow_in1_full_s,
		flow_in_end_o =>  flow_in1_pktend_s,

		flow_out_data_i  => flow_out_data_s,
		flow_out_rd_o => flow_out_rd_s,
		flow_out_empty_i => flow_out_empty_s,
		flow_out_rdy_i => flow_out_rdy_s
		);
		
SLAVE_BUS_INST: component enable_gen	
		generic map(
			DATA_WIDTH => 32,
			N_WORDS => 16
		)
		port map (
			clk_i => clk_proc,
			rst_n_i => rst,	
			addr_i => addr_rel_i,		--(addr_rel_0_o),
			wr_i => wr_i,				--(wr_0_o),
			datawr_i => datawr_i, 		--(data_wr_0_o)	
			en_o => enable_s,
			flow_out_sel_o => flow_out_sel_s,
			source_sel_o => source_sel_s
			);
		
ENABLE_SYNC_FV: component fv_synchro_signal
  port map(
	fv_i => in0_fv,
	signal_i => enable_s,
	signal_o => enable_s_fvsync,
	clk_i => clk_proc,
	rst_n_i => rst
);

--FLOW_IN 1
USBFLOW_IN0: component flow_in
  generic map(
	FIFO_DEPTH => 1024,
	FLOW_ID => 1,
	FLAGS_CODES => InitFlagCodes
    )
  port map(
	data_wr_i =>flow_in1_wr_s,
	data_i => flow_in1_data_s,
	pktend_i => flow_in1_pktend_s,
	enable_i => enable_s_fvsync,

	data_o => out0_data,
	fv_o => out0_fv,
	dv_o => out0_dv,
	flow_full_o => open,
		
	clk_in_i =>ifclk,
	clk_out_i => clk_proc,
	rst_n_i =>rst
    );

--FLOW_IN 2
USBFLOW_IN1: component flow_in
  generic map(
	FIFO_DEPTH => 1024,
	FLOW_ID => 2,
	FLAGS_CODES => InitFlagCodes
    )
  port map(
	data_wr_i =>flow_in1_wr_s,
	data_i => flow_in1_data_s,
	pktend_i => flow_in1_pktend_s,
	enable_i => enable_s_fvsync,

	data_o => out1_data,
	fv_o => out1_fv,
	dv_o => out1_dv,
	flow_full_o => open,
		
	clk_in_i =>ifclk,
	clk_out_i =>clk_proc,
	rst_n_i =>rst
    );

--FLOW OUT 0
USBFLOW_OUT0: component flow_out 
  generic map (
	FIFO_DEPTH => 512*64,
	FLOW_ID => 128,
	PACKET_SIZE => 256, -- header inclus
	FLAGS_CODES => InitFlagCodes
    )
  port map(
	data_i => in0_data,
	fv_i => in0_fv,
	dv_i => in0_dv,
	rdreq_i => flow_out_rd_0_s,-- to arb
	enable_i => enable_s_fvsync,
	data_o => flow_out_data_0_s,-- to arb
	flow_rdy_o=> flow_out_rdy_0_s,-- to arb
	f_empty_o => flow_out_empty_0_s,-- to arb
	
	clk_in_i => clk_proc, 
	clk_out_i => ifclk,
	rst_n_i=> rst
);

--FLOW OUT 1
USBFLOW_OUT1: component flow_out 
  generic map (
	FIFO_DEPTH => 512*64,
	FLOW_ID => 129,
	PACKET_SIZE => 256, -- header inclus
	FLAGS_CODES => InitFlagCodes
    )
  port map(
	data_i => in1_data,
	fv_i => in1_fv,
	dv_i => in1_dv,

	rdreq_i => flow_out_rd_1_s, -- to arb
	enable_i => enable_s_fvsync,
	data_o => flow_out_data_1_s, -- to arb
	flow_rdy_o=> flow_out_rdy_1_s, -- to arb
	f_empty_o => flow_out_empty_1_s, -- to arb
	
	clk_in_i => clk_proc, 
	clk_out_i => ifclk,
	rst_n_i=> rst
);


-- component flow_out_arbiter 
	
USBFLOW_ARB : component flow_out_arb
 port map(
		-- fv 0 signals
		rdreq_0_o => flow_out_rd_0_s,
		data_0_i => flow_out_data_0_s,
		flow_rdy_0_i => flow_out_rdy_0_s,
		f_empty_0_i  => flow_out_empty_0_s,
	
		-- fv 0 signals
		rdreq_1_o => flow_out_rd_1_s,
		data_1_i => flow_out_data_1_s,
		flow_rdy_1_i=> flow_out_rdy_1_s,
		f_empty_1_i => flow_out_empty_1_s,

		-- fv usb signals
		rdreq_usb_i => flow_out_rd_s,
		data_usb_o => flow_out_data_s,
		flow_rdy_usb_o =>flow_out_rdy_s,
		f_empty_usb_o =>flow_out_empty_s,
		
		clk_i => ifclk,
		rst_n_i => rst);



--  FLOW_PARAMS module --> Bus Interconnect Master
FLOW_PARAMS: component flow_wishbone 
		generic map(
		FIFO_DEPTH => 64, 
		FLOW_ID_SET => 15,
		MASTER_ADDR_WIDTH=>MASTER_ADDR_WIDTH
		)
		port map(
			data_wr_i => flow_in1_wr_s,
			data_i => flow_in1_data_s,
			pktend_i => flow_in1_pktend_s,
			fifo_full_o => flow_in1_full_s,
			
			param_addr_o => master_addr_o,
			param_data_o => master_datawr_o,
			param_wr_o => master_wr_o,
			
			-- rajouter fin d'ecriture dans la memoire...
			tmp_update_port_o => update_port_s,
			clk_in_i => ifclk,
			clk_out_i => clk_proc, 
			rst_n_i => rst
		);
end rtl;
