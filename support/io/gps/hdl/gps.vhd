library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
library std;

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

architecture rtl of gps is
component top_GPS
	port (
		clk	   : in std_logic;
		reset      : in std_logic;
		RXD	   : in std_logic;
		TXD	   : out std_logic;			
		parameters : in std_logic_vector(31 downto 0);
		data_out   : out std_logic_vector(7 downto 0);
		flow_valid : out std_logic;
		data_valid : out std_logic
	);
end component;

component gps_slave
	generic (
		CLK_PROC_FREQ : integer
	);
	port (
		clk_proc   : in std_logic;
		reset_n    : in std_logic;

		---------------- dynamic parameters ports ---------------
		enable_reg : out std_logic_vector(31 downto 0);
		sat_reg    : out std_logic_vector(31 downto 0);
		update_reg : out std_logic_vector(31 downto 0);

		--======================= Slaves ========================

		------------------------- bus_sl ------------------------
		addr_rel_i : in std_logic_vector(1 downto 0);
		wr_i       : in std_logic;
		rd_i       : in std_logic;
		datawr_i   : in std_logic_vector(31 downto 0);
		datard_o   : out std_logic_vector(31 downto 0)
	);
end component;

	signal enable_reg : std_logic_vector (31 downto 0);
	signal sat_reg    : std_logic_vector (31 downto 0);
	signal update_reg : std_logic_vector (31 downto 0);
	signal parameters : std_logic_vector(31 downto 0);
begin
	gps_slave_inst : gps_slave
    generic map (
		CLK_PROC_FREQ => CLK_PROC_FREQ
	)
    port map (
		clk_proc   => clk_proc,
		reset_n    => reset_n,
		enable_reg => enable_reg,
		sat_reg    => sat_reg,
		update_reg => update_reg,
		addr_rel_i => addr_rel_i,
		wr_i       => wr_i,
		rd_i       => rd_i,
		datawr_i   => datawr_i,
		datard_o   => datard_o
	);

	top_GPS_inst : top_GPS
	port map(
			clk	=> clk_proc,
			reset   => reset_n,
			RXD	=> RXD,
			TXD	=> TXD,			
			parameters => parameters,
			data_out   => out_data ,
			flow_valid => out_fv ,
			data_valid => out_dv 
		 );

parameters(31 downto 22) <= enable_reg(0) & sat_reg(0) & update_reg(7 downto 0);

end rtl;
