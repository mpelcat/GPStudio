# com

The com block is doing the transition between GPStudio flows and HAL. It receives several input flows and send them one by one to the HAL. It also receives data from HAL and outputs the corresponding GPStudio flows.

![Com](com_schema.pdf)



### Properties

Property | Type  | Description
-----|-------|------------
enable_eth | boolean | Enable com
enable_inN| boolean | Enable flow in N
enable_outN| boolean | Enable flow out N

\newpage

## Prototype

```vhdl
entity com is
	generic(  FIFO_IN_N 		: integer; 
			  FIFO_IN_ID		: fifo_ID; 
			  FIFO_IN_SIZE		: fifo_size;							
			  ONE_PACKET		: integer;
			  FIFO_OUT_N		: integer;
			  FIFO_OUT_ID		: fifo_ID;
			  FIFO_OUT_SIZE	    : fifo_size;
			  MASTER_PORT		: std_logic_vector(15 downto 0));
	port  (
				clk_hal			: in std_logic;
				clk_proc		: in std_logic;
				reset_n			: in std_logic;
				
				--- From flows in to HAL
				data_o  		: out std_logic_vector(7 downto 0);
                data_size_o     : out std_logic_vector(15 downto 0);
                read_data_i     : in std_logic;
                ready_o         : out std_logic;
                hal_ready       : in std_logic;
                
				--- Flow to master
				flow_master		: out flow_t;
                
                --- From HAL to flows out
				data_i		    : in std_logic_vector(7 downto 0);
				write_i	        : in std_logic;
                
                --- Flows in and out
				flow_in0		: in flow_t;
				flow_in1		: in flow_t;
				flow_in2		: in flow_t;
				flow_in3		: in flow_t;

				flow_out0		: out flow_t;
				flow_out1		: out flow_t;
				
				--- Parameters from slave			
				enable_eth		: in std_logic;
				enable_in0		: in std_logic;
				enable_in1		: in std_logic;
				enable_in2		: in std_logic;
				enable_in3		: in std_logic);
end com;
```
\newpage

### Inputs outputs ports

Port | Type | Required | Description
-----|------|----------|------------
clk_proc | in | Y | Clock 
reset_n | in | Y | Active low reset
clk_hal | in | Y | Clock from HAL
data_o  | out | Y | Data of one packet from a flow
data_size_o  | out | Y | Size of the transmitted packet
read_data_i | in | Y | Read request from HAL
ready_o   | out | Y | One packet from a flow is ready to be sent
hal_ready  | in | Y | HAL is ready to receive one packet
flow_master | out | Y | Flow detected on MASTER_PORT
data_i| in | Y | Data from HAL
write_i| in | Y | Write command from HAL
flow_in* | in | Y | Flow valid, data valid and data from a GPStudio flow input
flow_out* | out | Y | Flow valid, data valid and data from a GPStudio flow output


### Parameters

Parameter | Type | Required | Description
-----|------|----------|------------
FIFO_IN_N       | int | Y       |Number of flows in 
FIFO_IN_ID		|array int | Y  |ID corresponding to each flow in
FIFO_IN_SIZE	|array int | Y  |Fifo size for each flow in
ONE_PACKET      | int | Y       |Hal one packet size
FIFO_OUT_N      | int | Y       |Number of flows out
FIFO_OUT_ID	    |array int | Y  |ID corresponding to each flow out
FIFO_OUT_SIZE	|array int | Y  |Fifo size for each flow out
MASTER_PORT	    | int | Y       |ID of the flow master

\newpage

## Schematic
![Com block integrated with HAL](com_block.pdf)

### From flows to HAL
The com block can receive multiple incoming flows. A sub-block flow_to_com is used for each flow. It is composed of two separate FIFOs. The fifo flags that keep the size of each packet to be sent and the GPStudio flags assigned to it. There are two flags : Start of Flow and End of Flow. 

This is how they are assigned to each packet : 

Start of Flow  | End of Flow  | Description
-----|------|-----------
0 | 0 |  Packet of a flow
0 | 1 |  Last packet of a flow
1 | 0 |  First packet of a flow
1 | 1 |  Data are small enough to fit in only one packet

One the other hand, the fifo data keep the data of incoming flows. The packet_ready signal is asserted high when fifo flags is not empty : it means that there is no data in the fifo data.
 The read_data signal from HAL controls the read request. When it is high, the first data send is the GPStudio header (ID + flags + number of packet). Then the data is read from fifo until the packet is full.

### From HAL to flows
When data are sent to the FPGA via the Marvell and the Ethernet block, it is necessary to send them to GPStudio block in a flow format (flow valid, data valid and data). In order to do that, we use the com_to_flow block. A small schematic of this conversion is presented below.

![Com block integrated with HAL](com_to_flow.pdf)

This block will extract the GPStudio header with the flags and the number of the packet. Depending on the Strat of Frame and End of Frame flags, it will outputs
the flow valid, data valid and data signals corresponding.

This block also has a fifo flags that keeps record of the size of the data for the data valid signal and the flags for the flow valid signal. It works the same way as the flow_to_com block.

