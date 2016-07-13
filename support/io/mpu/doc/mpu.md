# mpu

The mpu block reads the data from 3 sensors : accelerometer, gyroscope and compass and outputs one flow for each sensor. 


![MPU](mpu_schema.pdf)



### Properties

Property | Type  | Description
-----|-------|------------
Enable | boolean | Enable acquisition
Gyroscope sensibility | enum | Changes sensibility from ±250°/s to ±2000°/s
Gyroscope offsets |  int | Apply offset on each axis of the gyroscope
Accelerometer sensibility | enum | Changes sensibility from ±2g to ±16g
Accelerometer offsets |  int | Apply offset on each axis of the accelerometer
Compass sensibility | enum | Changes sensibility from ±0.88Ga to ±8.1Ga
Compass update rate | enum | Changes update rate of the compass

\newpage

## Prototype

```vhdl
entity mpu is
	generic (
		CLK_PROC_FREQ  : integer;
		ACCELERO_SIZE  : integer;
		GYROSCOPE_SIZE : integer;
		COMPASS_SIZE   : integer
	);
	port (
		clk_proc       : in std_logic;
		reset_n        : in std_logic;

		--------------------- external ports --------------------
		ad0            : out std_logic;
		sda            : inout std_logic;
		scl            : inout std_logic;

		---------------------- accelero flow --------------------
		accelero_data  : out std_logic_vector(ACCELERO_SIZE-1 downto 0);
		accelero_fv    : out std_logic;
		accelero_dv    : out std_logic;

		--------------------- gyroscope flow --------------------
		gyroscope_data : out std_logic_vector(GYROSCOPE_SIZE-1 downto 0);
		gyroscope_fv   : out std_logic;
		gyroscope_dv   : out std_logic;

		---------------------- compass flow ---------------------
		compass_data   : out std_logic_vector(COMPASS_SIZE-1 downto 0);
		compass_fv     : out std_logic;
		compass_dv     : out std_logic;

		--======================= Slaves ========================

		------------------------- bus_sl ------------------------
		addr_rel_i     : in std_logic_vector(3 downto 0);
		wr_i           : in std_logic;
		rd_i           : in std_logic;
		datawr_i       : in std_logic_vector(31 downto 0);
		datard_o       : out std_logic_vector(31 downto 0)
	);
end mpu;
```
\newpage

### Inputs outputs ports

Port | Type | Required | Description
-----|------|----------|------------
clk_proc | in | Y | Clock
reset_n | in | Y | Active low reset
AD0 | out | Y | Set last bit of I2C address
sda | inout | Y | I2C data line
scl | inout | Y | I2C clock line
accelero* | flow out | Y | Flow from accelerometer
gyroscope* | flow out | Y | Flow from gyroscope
compass* | flow out | Y | Flow from compass
PI_slave| PI_slave | Y | Signals that modify internal registers

### Parameters

Parameter | Type | Required | Description
-----|------|----------|------------
CLK_PROC_FREQ | int | Y | 50 MHz clock
ACCELERO_SIZE | int | Y | Accelero flow data size (8 bits)
GYROSCOPE_SIZE | int | Y | Gyroscope flow data size (8 bits)
COMPASS_SIZE | int | Y | Compass flow data size (8 bits)

\newpage

## Schematic
![Schematic](mpu_schema_global.pdf)

The accelerometer and the gyroscope are in a MPU-6050 which talks to the FPGA via an I2C bus. The compass is located on a secondary I2C bus connected to the MPU-6050.   

One sample is composed of 18 bytes (2 bytes for each axis from each sensor). The mpu block can modify the configuration of the MPU-6050 such as the sample rate or the sensibility of the sensors.   
The I2C controller handle the data and clock line.  
When it acquires samples, an offsets calculator is used to performs offsets depending on user values for each axis and for each sensor.  
The data corrected are transmitted into a fifo that dispatch the sample into 3 flows.  

### Configuration

There are several things that you can modify in the configuration of the MPU block.

The sample rate act on the refresh rate of the data. The flows will come out at this frequency. 
Note that the compass has its own refresh rate that you can modify. It means that you can have a global sample rate at 50Hz while the compass is only refreshing at 5 Hz. The compass sample rate can be increased to 75Hz.

There is also the possibilty to add hardware offsets. To do so, you have to be at the lowest sensibility (+/- 2g for accelero, +/- 250°/s for gyroscope). The value of the offset is adapted automatically to the sensibility you choose. 
For example, if you choose +100 offset on accelero axis X, it will be +100 at +/-2g, +50 at +/-4g, etc.
The data are coded on 16 signed bits (i.e. +/-16384). 
If you want to add a +0.1g offset, you will set the value as follow : (0.1*16384)/2g = 819.


