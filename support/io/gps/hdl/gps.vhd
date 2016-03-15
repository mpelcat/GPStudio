library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
library std;

entity gps is
	generic (
		CLK_PROC_FREQ : integer;
		GPS_OUT_SIZE  : integer
	);
	port (
		clk_proc     : in std_logic;
		reset_n      : in std_logic;

		--------------------- external ports --------------------
		RXD          : in std_logic;

		---------------------- gps_out flow ---------------------
		gps_out_data : out std_logic_vector(GPS_OUT_SIZE-1 downto 0);
		gps_out_fv   : out std_logic;
		gps_out_dv   : out std_logic;

		--======================= Slaves ========================

		------------------------- bus_sl ------------------------
		addr_rel_i   : in std_logic_vector(1 downto 0);
		wr_i         : in std_logic;
		rd_i         : in std_logic;
		datawr_i     : in std_logic_vector(31 downto 0);
		datard_o     : out std_logic_vector(31 downto 0)
	);
end gps;

architecture rtl of gps is


component gps_slave
	generic (
		CLK_PROC_FREQ : integer
	);
	port (
		clk_proc   : in std_logic;
		reset_n    : in std_logic;

		---------------- dynamic parameters ports ---------------
		enable_reg : out std_logic_vector(31 downto 0);

		--======================= Slaves ========================

		------------------------- bus_sl ------------------------
		addr_rel_i : in std_logic_vector(1 downto 0);
		wr_i       : in std_logic;
		rd_i       : in std_logic;
		datawr_i   : in std_logic_vector(31 downto 0);
		datard_o   : out std_logic_vector(31 downto 0)
	);
end component;


component gps_acqui
	port(
			clk	: in std_logic;
			enable : in std_logic;
			reset : in std_logic;
			RXD	: in std_logic;
			last_wr	: out std_logic;
			data_out	: out std_logic_vector(7 downto 0);
			flow_valid : out std_logic;
			data_valid : out std_logic
		 );
end component;


	signal enable_reg : std_logic_vector (31 downto 0);
	
	
	signal last_wr : std_logic;
	
begin


	gps_slave_inst : gps_slave
    generic map (
		CLK_PROC_FREQ => CLK_PROC_FREQ
	)
    port map (
		clk_proc   => clk_proc,
		reset_n    => reset_n,
		enable_reg => enable_reg,
		addr_rel_i => addr_rel_i,
		wr_i       => wr_i,
		rd_i       => rd_i,
		datawr_i   => datawr_i,
		datard_o   => datard_o
	);

	gps_acqui_inst : gps_acqui
	port map (
		clk	=>clk_proc,
		enable => enable_reg(0),
		reset => reset_n,
		RXD	=> RXD,
		last_wr	=> last_wr,
		data_out   => gps_out_data,
		flow_valid => gps_out_fv ,
		data_valid => gps_out_dv 
		);
	



end rtl;
