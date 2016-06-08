
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use work.ethernet_package.all;


entity gemac_udp is
	port (
		--- External ports
	   CLK125				: in STD_LOGIC;
		reset_n				: in std_logic;
		PHY_RESET_L 		: out STD_LOGIC;
		PHY_MDC 				: out STD_LOGIC;
		PHY_MDIO 			: inout STD_LOGIC;
		GE_RXCLK 			: in STD_LOGIC;  
		GE_TXCLK 			: out STD_LOGIC;
		TX						: out rgmii_t;
		RX						: in rgmii_t;
		
		--- Receiving flows to send on link
		flow_in_data		: in std_logic_vector(7 downto 0);
		flow_in_dv			: in std_logic;
		flow_in_fv			: in std_logic;
		ID_port_in			: in std_logic_vector(15 downto 0);
		
		--- Transmitting flows received by link
		flow_out_data		: out std_logic_vector(7 downto 0);
		flow_out_dv			: out std_logic;
		flow_out_fv			: out std_logic;
		ID_port_out			: out std_logic_vector(15 downto 0)
	);
	
end gemac_udp;

architecture RTL of gemac_udp is

signal RESET_BTN				:  STD_LOGIC;
signal eth_tx_stream			: std_logic_vector(8 downto 0);
signal RESET					: std_logic;
signal TX_udp 					: gmii_t;
signal RX_gmii		 			: gmii_t;
signal RX_sync					: gmii_t;
signal RX_gmii_dl				: gmii_t;
signal RX_filtered			: gmii_t;
signal port_detected			: std_logic_vector(15 downto 0);
signal TX_encapsulated		: gmii_t;
signal TEST_rx_sync			: std_logic;

begin

RESET_BTN 		<= '1';
RESET				<= not(RESET_BTN);

flow_out_data	<= RX_filtered.data;
flow_out_dv		<= RX_filtered.dv;
flow_out_fv		<= RX_filtered.dv;
ID_port_out		<= port_detected;

eth_tx_stream  <=  TX_encapsulated.dv & TX_encapsulated.data;


----- RGMII to GMII and GMII to RGMII
interface_managemet_inst : entity work.interface_management
	port map (	   
				CLK125			=> CLK125,
				reset_n			=> reset_n,
				RX_i 				=> RX,
				RX_o 				=> RX_gmii,
				RX_o_dl			=> RX_gmii_dl,
				TX_i 				=> TX_udp,
				TX_o 				=> TX
	);

----- Synchro received data on clk125
synchro_receive_inst : entity work.synchro_receive
	port map (	   
				CLK125			=> clk125,
				reset_n			=> reset_n,
				RX_unsync		=> RX_gmii,
				RX_unsync_dl	=> RX_gmii_dl,
				RX_sync			=>	RX_sync
		);

----- Filter mac/ip address and detect destination port
filter_mac_ip_port :  entity work.filter 
	port map (	   
				RXCLK				=> clk125,
				reset_n			=> reset_n,
				RX_i 				=>	RX_sync,
				RX_o 				=> RX_filtered,
				port_detected	=> port_detected
		);

----- Adding ip/udp header to data to send	
	eth_tx_hdr_inst : entity work.eth_tx_header 
	Port map(
			CLK125 			=> CLK125,
			reset_n 			=> reset_n,
			ID_port_in		=> ID_port_in,
			TX_i.dv 			=> flow_in_dv,
			TX_i.data 		=> flow_in_data,
			TX_o 				=> TX_encapsulated
	);	
	
----- Data to send : padding, adding CRC and preamble
GMStream_inst : entity work.ge_mac_stream(Behavioral)
    port map(
			  PHY_RESET_L         => PHY_RESET_L,              
			  PHY_MDC             => PHY_MDC,          
			  PHY_MDIO            => PHY_MDIO,            
			  GE_TXEN             => TX_udp.dv,    
			  GE_TXD              => TX_udp.data,                              
			  CLK125              => CLK125,                     
			  reset_n             => reset_n,                       
			  ETH_TX_STREAM       => eth_tx_stream           
    );
		
---- Shifting clock to PHY
txclk_i : entity work.shiftclk
port map (	   
		inclk0			=> CLK125,
		c0 				=> GE_TXCLK
	);


end RTL;

