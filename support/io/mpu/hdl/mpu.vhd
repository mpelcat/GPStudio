library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
library std;
use work.mpu_pkg.all;

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

architecture rtl of mpu is
component mpu_acqui
	port (
		clk_proc		: in std_logic;
		reset 		: in std_logic;
		sda			: inout std_logic;
		scl			: inout std_logic;
		AD0			: out std_logic;
		parameters	: in param;
		accelero		: out flow;
		gyroscope   : out flow;
		compass		: out flow
	);
end component;

component mpu_slave
	generic (
		CLK_PROC_FREQ : integer
	);
	port (
		clk_proc         : in std_logic;
		reset_n          : in std_logic;

		---------------- dynamic parameters ports ---------------
		enable_reg       : out std_logic_vector(31 downto 0);
		gyro_config_reg  : out std_logic_vector(31 downto 0);
		accel_config_reg : out std_logic_vector(31 downto 0);
		spl_rate_reg     : out std_logic_vector(31 downto 0);
		gain_compass_reg : out std_logic_vector(31 downto 0);
		fz_compass_reg   : out std_logic_vector(31 downto 0);
		accel_off_x_reg  : out std_logic_vector(31 downto 0);
		accel_off_y_reg  : out std_logic_vector(31 downto 0);
		accel_off_z_reg  : out std_logic_vector(31 downto 0);
		gyro_off_x_reg   : out std_logic_vector(31 downto 0);
		gyro_off_y_reg   : out std_logic_vector(31 downto 0);
		gyro_off_z_reg   : out std_logic_vector(31 downto 0);

		--======================= Slaves ========================

		------------------------- bus_sl ------------------------
		addr_rel_i       : in std_logic_vector(3 downto 0);
		wr_i             : in std_logic;
		rd_i             : in std_logic;
		datawr_i         : in std_logic_vector(31 downto 0);
		datard_o         : out std_logic_vector(31 downto 0)
	);
end component;

	signal enable_reg       : std_logic_vector (31 downto 0);
	signal gyro_config_reg  : std_logic_vector (31 downto 0);
	signal accel_config_reg : std_logic_vector (31 downto 0);
	signal spl_rate_reg     : std_logic_vector (31 downto 0);
	signal gain_compass_reg : std_logic_vector (31 downto 0);
	signal fz_compass_reg   : std_logic_vector (31 downto 0);
	signal accel_off_x_reg  : std_logic_vector (31 downto 0);
	signal accel_off_y_reg  : std_logic_vector (31 downto 0);
	signal accel_off_z_reg  : std_logic_vector (31 downto 0);
	signal gyro_off_x_reg   : std_logic_vector (31 downto 0);
	signal gyro_off_y_reg   : std_logic_vector (31 downto 0);
	signal gyro_off_z_reg   : std_logic_vector (31 downto 0);
	
	signal parameters  : param;
	signal accelero, gyroscope, compass : flow;

begin
	mpu_acqui_inst : mpu_acqui
	port map( 
		clk_proc	=> clk_proc,
		reset		=> reset_n,
		sda		=> sda,
		scl		=> scl,
		AD0		=> AD0,
		parameters	=> parameters,
		accelero 	=> accelero,
		gyroscope	=> gyroscope,
		compass     => compass
	);
	
	parameters(0)(31 downto 13)  <=  enable_reg(0) & spl_rate_reg(7 downto 0) & gyro_config_reg(1 downto 0) & accel_config_reg(1 downto 0) 
												& gain_compass_reg(2 downto 0) & fz_compass_reg(2 downto 0);
	parameters(1)	<= gyro_off_x_reg(15 downto 0) & accel_off_x_reg(15 downto 0);
	parameters(2)	<= gyro_off_y_reg(15 downto 0) & accel_off_y_reg(15 downto 0);
	parameters(3)	<= gyro_off_z_reg(15 downto 0) & accel_off_z_reg(15 downto 0);
							
	accelero_data	<= accelero.data;						
	accelero_dv		<= accelero.dv;					
	accelero_fv		<= accelero.fv;
	
	gyroscope_data	<= gyroscope.data;						
	gyroscope_dv	<= gyroscope.dv;					
	gyroscope_fv	<= gyroscope.fv;
	
	compass_data	<= compass.data;						
	compass_dv		<= compass.dv;					
	compass_fv		<= compass.fv;
	
		
	mpu_slave_inst : mpu_slave
    generic map (
		CLK_PROC_FREQ => CLK_PROC_FREQ
	)
    port map (
		clk_proc         => clk_proc,
		reset_n          => reset_n,
		enable_reg       => enable_reg,
		gyro_config_reg  => gyro_config_reg,
		accel_config_reg => accel_config_reg,
		spl_rate_reg     => spl_rate_reg,
		gain_compass_reg => gain_compass_reg,
		fz_compass_reg   => fz_compass_reg,
		accel_off_x_reg  => accel_off_x_reg,
		accel_off_y_reg  => accel_off_y_reg,
		accel_off_z_reg  => accel_off_z_reg,
		gyro_off_x_reg   => gyro_off_x_reg,
		gyro_off_y_reg   => gyro_off_y_reg,
		gyro_off_z_reg   => gyro_off_z_reg,
		addr_rel_i       => addr_rel_i,
		wr_i             => wr_i,
		rd_i             => rd_i,
		datawr_i         => datawr_i,
		datard_o         => datard_o
	);


end rtl;
