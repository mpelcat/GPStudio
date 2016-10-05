library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
library std;

entity threshold is
	generic (
		CLK_PROC_FREQ : integer;
		IN_SIZE       : integer;
		OUT_SIZE      : integer
	);
	port (
		clk_proc   : in std_logic;
		reset_n    : in std_logic;

		------------------------- in flow -----------------------
		in_data    : in std_logic_vector(IN_SIZE-1 downto 0);
		in_fv      : in std_logic;
		in_dv      : in std_logic;

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
end threshold;

architecture rtl of threshold is
component threshold_process
	generic (
		CLK_PROC_FREQ : integer;
		IN_SIZE       : integer;
		OUT_SIZE      : integer
	);
	port (
		clk_proc      : in std_logic;
		reset_n       : in std_logic;

		---------------- dynamic parameters ports ---------------
		threshold_reg : in std_logic_vector(31 downto 0);

		------------------------- in flow -----------------------
		in_data       : in std_logic_vector(IN_SIZE-1 downto 0);
		in_fv         : in std_logic;
		in_dv         : in std_logic;

		------------------------ out flow -----------------------
		out_data      : out std_logic_vector(OUT_SIZE-1 downto 0);
		out_fv        : out std_logic;
		out_dv        : out std_logic
	);
end component;

component threshold_slave
	generic (
		CLK_PROC_FREQ : integer
	);
	port (
		clk_proc      : in std_logic;
		reset_n       : in std_logic;

		---------------- dynamic parameters ports ---------------
		threshold_reg : out std_logic_vector(31 downto 0);

		--======================= Slaves ========================

		------------------------- bus_sl ------------------------
		addr_rel_i    : in std_logic_vector(1 downto 0);
		wr_i          : in std_logic;
		rd_i          : in std_logic;
		datawr_i      : in std_logic_vector(31 downto 0);
		datard_o      : out std_logic_vector(31 downto 0)
	);
end component;

	signal threshold_reg : std_logic_vector (31 downto 0);

begin
	threshold_process_inst : threshold_process
    generic map (
		CLK_PROC_FREQ => CLK_PROC_FREQ,
		IN_SIZE       => IN_SIZE,
		OUT_SIZE      => OUT_SIZE
	)
    port map (
		clk_proc      => clk_proc,
		reset_n       => reset_n,
		threshold_reg => threshold_reg,
		in_data       => in_data,
		in_fv         => in_fv,
		in_dv         => in_dv,
		out_data      => out_data,
		out_fv        => out_fv,
		out_dv        => out_dv
	);

	threshold_slave_inst : threshold_slave
    generic map (
		CLK_PROC_FREQ => CLK_PROC_FREQ
	)
    port map (
		clk_proc      => clk_proc,
		reset_n       => reset_n,
		threshold_reg => threshold_reg,
		addr_rel_i    => addr_rel_i,
		wr_i          => wr_i,
		rd_i          => rd_i,
		datawr_i      => datawr_i,
		datard_o      => datard_o
	);


end rtl;
