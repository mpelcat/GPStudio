
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.ethernet_package.all;

entity eth_marvell_88e1111 is
	generic (
		MASTER_ADDR_WIDTH	: integer				:= 2;
		MASTER_PORT			: std_logic_vector(15 downto 0)	:= x"8000";
		FIFO_IN_N			: integer				:= 4;--up to 16 fifos
		FIFO_IN_ID			: fifo_ID				:= (x"7000",x"7001",x"4001",x"4002",others=>x"0000");
		FIFO_IN_SIZE		: fifo_size				:= (2048,1024,2048,512,others=>0);
		ONE_PACKET_SIZE	: integer				:= 1450;
		FIFO_OUT_N			: integer				:= 2;--up to 16 fifos
		FIFO_OUT_ID			: fifo_ID				:= (x"3000",x"3001",others=>x"0000");
		FIFO_OUT_SIZE		: fifo_size				:= (512,512,others=>0)
	);
	port(	
		CLK125				: in STD_LOGIC;
		clk_proc				: in std_logic;
		reset_n				: in std_logic;
		
		--- ETHERNET
		PHY_RESET_L 		: out STD_LOGIC;
		PHY_MDC 				: out STD_LOGIC;
		PHY_MDIO 			: inout STD_LOGIC;
		GE_RXCLK 			: in STD_LOGIC;  
		GE_TXCLK 			: out STD_LOGIC;
		TX_data				: out std_logic_vector(3 downto 0);
		TX_dv					: out std_logic;
		RX_data				: in std_logic_vector(3 downto 0);
		RX_dv					: in std_logic;
		
------------à generer
		flow_in0_data			: in std_logic_vector(7 downto 0);
		flow_in0_dv				: in std_logic;
		flow_in0_fv				: in std_logic;
		
		flow_in1_data			: in std_logic_vector(7 downto 0);
		flow_in1_dv				: in std_logic;
		flow_in1_fv				: in std_logic;
		
		flow_in2_data			: in std_logic_vector(7 downto 0);
		flow_in2_dv				: in std_logic;
		flow_in2_fv				: in std_logic;
		
		flow_in3_data			: in std_logic_vector(7 downto 0);
		flow_in3_dv				: in std_logic;
		flow_in3_fv				: in std_logic;
		
		flow_out0_data			: out std_logic_vector(7 downto 0);
		flow_out0_dv			: out std_logic;
		flow_out0_fv			: out std_logic;
		
		flow_out1_data			: out std_logic_vector(7 downto 0);
		flow_out1_dv			: out std_logic;
		flow_out1_fv			: out std_logic;
		
		--- PI_master
		master_addr_o		: out std_logic_vector(MASTER_ADDR_WIDTH downto 0);
		master_wr_o			: out std_logic;
		master_rd_o			: out std_logic;
		master_datawr_o	: out std_logic_vector(31 downto 0);
		master_datard_i	: in std_logic_vector(31 downto 0);
		
		--- PI_slave
		addr_rel_i			: in std_logic_vector(3 downto 0);
		wr_i					: in std_logic;
		rd_i					: in std_logic;
		datawr_i				: in std_logic_vector(31 downto 0);
		datard_o				: out std_logic_vector(31 downto 0)
	);
end eth_marvell_88e1111;

architecture RTL of eth_marvell_88e1111 is

signal TX_s				: rgmii_t;
signal param   		: param_t;
signal flow_tx_out	: flow_t;
signal flow_rx_in		: flow_t;
signal flow_master	: flow_t;
signal ID_port_in		: std_logic_vector(15 downto 0);
signal ID_port_out	: std_logic_vector(15 downto 0);
signal size_flow		: std_logic_vector(15 downto 0);
signal TX				: rgmii_t;
signal RX				: rgmii_t;

------------à generer
signal enable_eth		: std_logic;
signal enable_in0		: std_logic;
signal enable_in1		: std_logic;
signal enable_in2		: std_logic;
signal enable_in3		: std_logic;

begin
TX_data	<= TX.data;
TX_dv		<= TX.dv;
RX.data	<= RX_data;
RX.dv		<= RX_dv;

com_inst : entity work.com
	generic map(
				master_port			=> MASTER_PORT,
				fifo_in_N 			=> FIFO_IN_N,			
				fifo_in_ID			=> FIFO_IN_ID, 
				fifo_in_size		=> FIFO_IN_SIZE,							
				one_packet			=> ONE_PACKET_SIZE,
				fifo_out_N			=> FIFO_OUT_N,
				fifo_out_ID			=> FIFO_OUT_ID, 
				fifo_out_size		=> FIFO_OUT_SIZE
			  )
	port map (
				clk				=> clk125,
				clk_proc			=> clk_proc,
				reset_n			=> reset_n,
				
				--- From flows in to HAL
				HAL_busy			=> TX_s.dv,
				flow_out			=> flow_tx_out,
				ID_in				=> ID_port_in,
				size				=> size_flow,			
				--- From HAL to flows out
				flow_rx_in		=> flow_rx_in,
				ID_out			=> ID_port_out,
				--- flow to master
				flow_master		=> flow_master,

------------à generer				
				flow_in0.data			=> flow_in0_data,
				flow_in0.dv				=> flow_in0_dv,
				flow_in0.fv				=> flow_in0_fv,
				
				flow_in1.data			=> flow_in1_data,
				flow_in1.dv				=> flow_in1_dv,
				flow_in1.fv				=> flow_in1_fv,
				
				flow_in2.data			=> flow_in2_data,
				flow_in2.dv				=> flow_in2_dv,
				flow_in2.fv				=> flow_in2_fv,
				
				flow_in3.data			=> flow_in3_data,
				flow_in3.dv				=> flow_in3_dv,
				flow_in3.fv				=> flow_in3_fv,
				
				flow_out0.data			=> flow_out0_data,
				flow_out0.dv			=> flow_out0_dv,
				flow_out0.fv			=> flow_out0_fv,
				
				flow_out1.data			=> flow_out1_data,
				flow_out1.dv			=> flow_out1_dv,
				flow_out1.fv			=> flow_out1_fv,
				
				--- parameters from slave
------------à generer
				enable_eth 		=> enable_eth,
				enable_in0 		=> enable_in0,
				enable_in1 		=> enable_in1,
				enable_in2 		=> enable_in2,
				enable_in3 		=> enable_in3				
			);

ethernet_inst : entity work.gemac_udp
	port map (
		--- External ports
	   CLK125				=> clk125,
		reset_n				=> reset_n,
		PHY_RESET_L 		=> PHY_RESET_L,
		PHY_MDC 				=> PHY_MDC,
		PHY_MDIO 			=> PHY_MDIO,
		GE_RXCLK 			=> GE_RXCLK,  
		GE_TXCLK 			=> GE_TXCLK,
		TX						=> TX_s,
		RX						=> RX,
		
		--- Receiving flows to send on link
		flow_in_size		=> size_flow,
		flow_in_data		=> flow_tx_out.data,
		flow_in_dv			=> flow_tx_out.dv,
		flow_in_fv			=> flow_tx_out.fv,
		ID_port_in			=> ID_port_in,
		
		--- Transmitting flows received by link
		flow_out_data		=> flow_rx_in.data,
		flow_out_dv			=> flow_rx_in.dv,
		flow_out_fv			=> flow_rx_in.fv,
		ID_port_out			=> ID_port_out
	);
		
	TX				<= TX_s;
		
master : entity work.master_eth 
generic map (pi_size_addr 		=> MASTER_ADDR_WIDTH)
Port map(
		CLK 					=> clk_proc,
		RESET_n 				=> reset_n,
		flow_in				=> flow_master,
		master_addr_o		=> master_addr_o,
		master_wr_o			=> master_wr_o,
		master_rd_o			=> master_rd_o,
		master_datawr_o	=> master_datawr_o,
		master_datard_i	=> master_datard_i
		);

slave : entity work.slave_eth 
generic map (pi_size_addr 		=> 3)
Port map(
		CLK 					=> clk_proc,
		RESET_n 				=> reset_n,
		addr_rel_i			=> addr_rel_i,
		wr_i					=> wr_i,
		rd_i					=> rd_i,
		datawr_i				=> datawr_i,
		datard_o				=> datard_o,
		enable_eth_o  		=> enable_eth,
		enable_in0_o 		=> enable_in0,
		enable_in1_o 		=> enable_in1,
		enable_in2_o 		=> enable_in2,
		enable_in3_o 		=> enable_in3
		);
end RTL;
