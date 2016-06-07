# gps

The gps block receives data from the GPS receiver and outputs one flow containing the coordinates. 


![MPU](schema_gps.pdf)

## Properties

Property | Type  | Description
-----|-------|------------
Enable | boolean | Enable acquisition
Mode | enum | GPS : uses only GPS satellites, less accurate (up to 40Hz).
|    |      | GPS/Glonass : uses GPS and Glonass satellites, more accurate (up to 20Hz).
Update rate | enum | Modify update rate from 1Hz to 40Hz

\newpage

## Prototype

```vhdl
entity gps is
	generic (
		CLK_PROC_FREQ : integer;
		OUT_SIZE      : integer
	);
	port (
		clk_proc   : in std_logic;
		reset_n    : in std_logic;

		--------------------- external ports --------------------
		RXD        : in std_logic;
		TXD        : out std_logic;

		------------------------ out flow -----------------------
		out_data   : out std_logic_vector(OUT_SIZE-1 downto 0);
		out_fv     : out std_logic;
		out_dv     : out std_logic;

		--======================= Slaves ========================

		------------------------- bus_sl ------------------------
		addr_rel_i : in std_logic_vector(1 downto 0);
		wr_i       : in std_logic;
		rd_i       : in std_logic;
		datawr_i   : in std_logic_vector(31 downto 0);
		datard_o   : out std_logic_vector(31 downto 0)
	);
end gps;
```
\newpage

## Inputs outputs ports

Port | Type | Required | Description
-----|------|----------|------------
clk_proc | in | Y | Clock
reset_n | in | Y | Active low reset
RXD | in | Y | UART receive line
TXD | out | Y | UART transmit line
out* | flow out | Y | Flow from gps
PI_slave | PI_slave | Y | Signals used to modify internal registers

## Parameters

Parameter | Type | Required | Description
-----|------|----------|------------
CLK_PROC_FREQ | int | Y | 48 MHz clock
OUT_SIZE | int | Y | Flow data size (8 bits for the gps)

\newpage

## Schematic
![Schematic](gps_schema_global.pdf)

The GPS receiver is a Skytraq S1216F8-GL. It can work with both GPS and Glonass satellites for more accuracy.   

One sample is composed of the values of latitude and longitude and their orientation. The gps block is able to modify the configuration of the Skytraq such as the sample rate or which satellites to use : using only GPS satellites makes the acquisition to run up to 40Hz while using both GPS and Glonass satellites limits the acquisition at 20Hz.   
The gps receiver handles the RXD line.  
The gps transmitter receives the configuration data to send to the GPS and handles the TXD line.  
The baud rate generator modifies the baud rate of the receiver and the transmitter depending on the configuration that have been chosen.  
The gps controller detects the sequence containing the coordinates and writes them into the fifo.  
The fifo outputs the gps flow when a sample is complete.  

