# ethernet

The ethernet block controls the marvell 88E1111 PHY. It works at 1Gigabit/s speed. The implemented protocol is UDP.
  
It receives data from com block and encapsulates them before sending the whole packet to the marvell. 
On the other side it receives data from the marvell and filter MAC/IP addresses before extracting data and sending them to the com block.


![Ethernet block](ethernet_chain.pdf)



### Properties

Property | Type  | Description
-----|-------|------------
MAC address |  enum | Set MAC address of the device
IP ethernet | enum | Set IP of the device
MAC destination | enum | Set MAC of the destination device
IP destination | enum | Set IP of the destination device
Port destination | enum | Set port of destination device

\newpage

## Prototype

```vhdl
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
		flow_out_data		: out std_logic_vector(7 downto 0);
		flow_out_dv			: out std_logic;
		ID_port_out			: out std_logic_vector(15 downto 0)
	);

end gemac_udp;
```
\newpage

### Inputs outputs ports

Port | Type | Required | Description
-----|------|----------|------------
CLK125 | in | Y | 125MHZ clock from board
reset_n | in | Y | Active low reset
PHY_RESET_L |out |Y|Hardware reset of the marvell
PHY_MDC |out |Y|Clock line of the Management Data Input/Output
PHY_MDIO|inout|Y|Data line of the Management Data Input/Output
TX|out|Y|RGMII : 4 data bits and 1 data valid bit send to marvell
RX|in|Y|RGMII : 4 data bits and 1 data valid bit received from marvell
clk250_marvell|in|Y|Clock from Clock Interconnect (GE_RXCLK x2)
clk250_fpga|in|Y|Clock from Clock Interconnect (CLK125 x2)
mac_addr_hal_msb|in|Y| 3 top bytes of the mac address device 
mac_addr_hal_lsb|in|Y| 3 bottom bytes of the mac address device
mac_addr_hal_msb|in|Y| 3 top bytes of the mac address destination device 
mac_addr_hal_lsb|in|Y| 3 bottom bytes of the mac address destination device
ip_hal|in|Y| IP address of the device
ip_dest|in|Y| IP address of the destination device
port_dest|in|Y| UDP port of the destination device
hal_ready|out|Y| Marvell is ready to receive data from com when high
data_i|in|Y|Packet data from com
data_size_i|in|Y|Size of the data packet 
ready_i|in|Y|Com has one packet ready to be sent
read_data_o|out|Y|Read data request


\newpage

## Schematic
![Ethernet](ethernet_schema.pdf)

###Transmission
The data are received from the communication block with the size of the packet. When a packet is ready to be sent in the communication block, then com_ready is asserted high and the flow_to_hal_mux_controller starts reading the data. The data go through a small fifo in the eth_tx_header to delay data enough time to set the header. This header is composed of the ethernet header (MAC addresses, type), the ip header (ip source and destination, length, etc...) and the udp header (port source and destination, length, udp checksum). 

Once the full header is set, the packet is padded with 0 if necessary, i.e. it is too short, then the ethernet CRC is added at the end of the packet. The packet is now ready to be transmitted. 
Since the Marvell PHY interface is set to RGMII (4bits clocked on rising and falling edge of GE_TXCLK) and we are working on GMII (8bits clocked on rising edge of CLK125), we need to make the conversion. The interface management handle the conversion and send the full packet to the Marvell.


###Reception
The data are received from the Marvell pins in RGMII mode (4 bits of data clocked on both rising and falling edge of GE_RXCLK). We make the conversion to work on GMII mode and we also synchronize data on the clock from the board (CLK125). These two steps are done in the interface management with the rgmii2gmii fifo making the mode conversion. 

The packet is now filtered to detect the MAC address and the IP and compared them to the ones received from slave. If they are verified, then the Ethernet/IP/UDP headers and the padding/footer are removed. The data are then transmitted to the com block.

###Configuration
The configuration and the hardware reset of the marvell is handled by the eth_mdio sub block.  This block performs a 25 ms hardware reset when power-up. 

The default configuration is unchanged. It works with the RGMII mode and no delay on TX and RX lines. In this configuration, the marvell datasheet recommends specific inputs and outputs delays which are set in the constraint file ethernet.sdc.

 
