library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
library std;

entity mpu is
	generic (
		CLK_PROC_FREQ : integer;
		DATA_OUT_SIZE : integer
	);
	port (
		clk_proc      : in std_logic;
		reset_n       : in std_logic;

		--------------------- external ports --------------------
		ad0           : out std_logic;
		sda           : inout std_logic;
		scl           : inout std_logic;

		---------------------- data_out flow --------------------
		data_out_data : out std_logic_vector(DATA_OUT_SIZE-1 downto 0);
		data_out_fv   : out std_logic;
		data_out_dv   : out std_logic;

		--======================= Slaves ========================

		------------------------- bus_sl ------------------------
		addr_rel_i    : in std_logic_vector(9 downto 0);
		wr_i          : in std_logic;
		rd_i          : in std_logic;
		datawr_i      : in std_logic_vector(31 downto 0);
		datard_o      : out std_logic_vector(31 downto 0)
	);
end mpu;

architecture rtl of mpu is
component mpu_acqui
	port (
		clk_proc		: in std_logic;
		reset 			: in std_logic;
		sda			: inout std_logic;
		scl			: inout std_logic;
		AD0			: out std_logic;
		parameters		: in std_logic_vector(31 downto 0);
		data_out		: out std_logic_vector(9 downto 0)

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
		trigger_reg      : out std_logic_vector(31 downto 0);
		auto_reg         : out std_logic_vector(31 downto 0);
		gyro_config_reg  : out std_logic_vector(31 downto 0);
		accel_config_reg : out std_logic_vector(31 downto 0);
		spl_rate_reg     : out std_logic_vector(31 downto 0);
		gain_compass_reg : out std_logic_vector(31 downto 0);
		fz_compass_reg   : out std_logic_vector(31 downto 0);

		--======================= Slaves ========================

		------------------------- bus_sl ------------------------
		addr_rel_i       : in std_logic_vector(9 downto 0);
		wr_i             : in std_logic;
		rd_i             : in std_logic;
		datawr_i         : in std_logic_vector(31 downto 0);
		datard_o         : out std_logic_vector(31 downto 0)
	);
end component;

	signal enable_reg       : std_logic_vector (31 downto 0);
	signal trigger_reg      : std_logic_vector (31 downto 0);
	signal auto_reg         : std_logic_vector (31 downto 0);
	signal gyro_config_reg  : std_logic_vector (31 downto 0);
	signal accel_config_reg : std_logic_vector (31 downto 0);
	signal spl_rate_reg     : std_logic_vector (31 downto 0);
	signal gain_compass_reg : std_logic_vector (31 downto 0);
	signal fz_compass_reg   : std_logic_vector (31 downto 0);
	
	signal data_s	   : std_logic_vector (9 downto 0);
	signal parameters  : std_logic_vector (31 downto 0);

begin

	mpu_acqui_inst : mpu_acqui
	port map( 
		clk_proc	=> clk_proc,
		reset		=> reset_n,
		sda		=> sda,
		scl		=> scl,
		AD0		=> AD0,
		parameters	=> parameters,
		data_out	=> data_s
		
	);


	parameters    <=  enable_reg(0) & spl_rate_reg(7 downto 0) & gyro_config_reg(1 downto 0) & accel_config_reg(1 downto 0) 
							& trigger_reg(0) &"01" & auto_reg(0) & gain_compass_reg(2 downto 0) & fz_compass_reg(2 downto 0) & "000000000";

	
	data_out_data <= data_s(7 downto 0);
	data_out_fv   <= data_s(9);
	data_out_dv   <= data_s(8);

	mpu_slave_inst : mpu_slave
    generic map (
		CLK_PROC_FREQ => CLK_PROC_FREQ
	)
    port map (
		clk_proc         => clk_proc,
		reset_n          => reset_n,
		enable_reg       => enable_reg,
		trigger_reg      => trigger_reg,
		auto_reg         => auto_reg,
		gyro_config_reg  => gyro_config_reg,
		accel_config_reg => accel_config_reg,
		spl_rate_reg     => spl_rate_reg,
		gain_compass_reg => gain_compass_reg,
		fz_compass_reg   => fz_compass_reg,
		addr_rel_i       => addr_rel_i,
		wr_i             => wr_i,
		rd_i             => rd_i,
		datawr_i         => datawr_i,
		datard_o         => datard_o
	);


end rtl;
