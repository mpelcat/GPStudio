-- This is the top level of the ethernet block.
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.ethernet_package.all;


entity ethernet_udp is
	port (
		--- External ports
        CLK125				: in STD_LOGIC;
		reset_n				: in std_logic;
		PHY_RESET_L 		: out STD_LOGIC;
		PHY_MDC 			: out STD_LOGIC;
		PHY_MDIO 			: inout STD_LOGIC;
		TX					: out rgmii_t;
		RX					: in rgmii_t;
        GE_TXCLK            : out std_logic;
		
        --- Clock from PLL to synchronize received data
        clk250_marvell      : in STD_LOGIC;
        clk250_fpga         : in STD_LOGIC;
        
        --- parameters from slave
        mac_addr_hal_msb    : in std_logic_vector(23 downto 0);
        mac_addr_hal_lsb    : in std_logic_vector(23 downto 0);
        mac_addr_dest_msb   : in std_logic_vector(23 downto 0);
        mac_addr_dest_lsb   : in std_logic_vector(23 downto 0);
        ip_hal              : in std_logic_vector(31 downto 0);
        ip_dest             : in std_logic_vector(31 downto 0);
        port_dest           : in std_logic_vector(15 downto 0);
        
		--- Receiving flows to send on link
        hal_ready           : out std_logic;
		data_i  		    : in std_logic_vector(7 downto 0);
        data_size_i         : in std_logic_vector(15 downto 0);
        ready_i             : in std_logic;
        read_data_o         : out std_logic;
		
		--- Transmitting flows received by link
		data_o      		: out std_logic_vector(7 downto 0);
		write_o 			: out std_logic
	);
	
end ethernet_udp;

architecture RTL of ethernet_udp is

signal eth_tx_stream			: std_logic_vector(8 downto 0);
signal TX_s         			: rgmii_t;
signal TX_udp         			: gmii_t;
signal RX_gmii		 			: gmii_t;
signal RX_sync					: gmii_t;
signal RX_gmii_dl				: gmii_t;
signal RX_filtered			    : gmii_t;
signal port_detected			: std_logic_vector(15 downto 0);
signal TX_encapsulated		    : gmii_t;
signal TEST_rx_sync			    : std_logic;
signal data_valid_i             : std_logic;
signal count                    : std_logic_vector(15 downto 0);
signal read_data_s,hal_ready_s  : std_logic;
signal data_valid_dl1,data_valid_dl2 : std_logic;
signal read_data_dl             : std_logic;
signal TX_s_dl                  : std_logic;

begin

data_o	        <= RX_filtered.data;
write_o		    <= RX_filtered.dv;
eth_tx_stream   <= TX_encapsulated.dv & TX_encapsulated.data;
TX              <= TX_s;
read_data_o     <= read_data_s;
hal_ready       <= hal_ready_s;
GE_TXCLK        <= CLK125;

----- Read data from com, read data when the flow_to_com is ready
process(CLK125,reset_n)		
begin
	if reset_n='0' then
		read_data_s     <= '0';
        hal_ready_s     <= '1';
	elsif CLK125'event and CLK125='1' then
        data_valid_dl1      <= read_data_s;
        data_valid_dl2      <= data_valid_dl1;  
        TX_s_dl             <= TX_s.dv;
        
        --- Read data from com, read data when the flow_to_com is ready
		if ready_i='1' and read_data_s='0' and hal_ready_s='1' then
			read_data_s     <= '1';
        elsif ready_i='0' then     
            read_data_s     <= '0';
        end if;
        
        --- Set hal_ready : high when it starts reading data and low when the packet has been fully sent
        if read_data_s='1' and data_valid_dl1='0' then
            hal_ready_s     <= '0';
        elsif TX_s.dv='0' and TX_s_dl='1' then
            hal_ready_s     <= '1';
        end if;
	end if;
end process;
data_valid_i        <= read_data_s and data_valid_dl2;
    
--- RGMII to GMII and GMII to RGMII
interface_managemet_inst : entity work.interface_management
	port map (	   
				clk125			=> clk125,
                clk250_marvell  => clk250_marvell,
                clk250_fpga     => clk250_fpga,
				reset_n			=> reset_n,
				RX_i 			=> RX,
				RX_o 			=> RX_gmii,
				TX_i 			=> TX_udp,
				TX_o 			=> TX_s
	);
    
----- Filter mac/ip address and detect destination port
filter_mac_ip_port :  entity work.eth_udp_filter 
	port map (	   
				RXCLK			    => clk125,
				reset_n			    => reset_n,
				RX_i 			    => RX_gmii,
				RX_o 			    => RX_filtered,
                mac_addr_hal_msb    => mac_addr_hal_msb,
                mac_addr_hal_lsb    => mac_addr_hal_lsb,
                ip_hal              => ip_hal,
				port_detected	    => port_detected
		);

----- Adding ip/udp header and gps header to data to send	
	eth_tx_hdr_inst : entity work.eth_tx_header 
	Port map(
			CLK125 			    => CLK125,
			reset_n 		    => reset_n,
            data_i  		    => data_i,
            data_size_i         => data_size_i,
			TX_i.dv 		    => data_valid_i,
			TX_i.data 		    => data_i,
			TX_o 			    => TX_encapsulated,
            --- Parameters from slave
            mac_addr_hal_msb    => mac_addr_hal_msb,
            mac_addr_hal_lsb    => mac_addr_hal_lsb,
            mac_addr_dest_msb   => mac_addr_dest_msb,
            mac_addr_dest_lsb   => mac_addr_dest_lsb,
            ip_hal              => ip_hal,
            ip_dest             => ip_dest,
            port_dest           => port_dest
	);	
	
----- Data to send : padding if needed, adding CRC and preamble
GMStream_inst : entity work.eth_tx_encap(Behavioral)
    port map(           
			  GE_TXEN             => TX_udp.dv,    
			  GE_TXD              => TX_udp.data,                              
			  CLK125              => CLK125,                     
			  reset_n             => reset_n,                       
			  ETH_TX_STREAM       => eth_tx_stream           
    );

----- Control the configuration of the marvell and the hardware reset	
eth_ctrl : entity work.eth_mdio 
	port map(
		CLK         => CLK125,
		RESET       => reset_n,
		E_RST_L     => PHY_RESET_L,
		E_MDC       => PHY_MDC,
		E_MDIO      => PHY_MDIO
        );
        
end RTL;

