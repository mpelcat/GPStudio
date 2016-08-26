library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
library std;

entity conv is
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
		addr_rel_i : in std_logic_vector(3 downto 0);
		wr_i       : in std_logic;
		rd_i       : in std_logic;
		datawr_i   : in std_logic_vector(31 downto 0);
		datard_o   : out std_logic_vector(31 downto 0)
	);
end conv;

architecture rtl of conv is
component conv_process
	generic (
		CLK_PROC_FREQ : integer;
		IN_SIZE       : integer;
		OUT_SIZE      : integer
	);
	port (
		clk_proc              : in std_logic;
		reset_n               : in std_logic;

		---------------- dynamic parameters ports ---------------
		status_reg_enable_bit : in std_logic;
		widthimg_reg          : in std_logic_vector(31 downto 0);
		w00_reg_m00           : in std_logic_vector(7 downto 0);
		w01_reg_m01           : in std_logic_vector(7 downto 0);
		w02_reg_m02           : in std_logic_vector(7 downto 0);
		w10_reg_m10           : in std_logic_vector(7 downto 0);
		w11_reg_m11           : in std_logic_vector(7 downto 0);
		w12_reg_m12           : in std_logic_vector(7 downto 0);
		w20_reg_m20           : in std_logic_vector(7 downto 0);
		w21_reg_m21           : in std_logic_vector(7 downto 0);
		w22_reg_m22           : in std_logic_vector(7 downto 0);
		norm_reg              : in std_logic_vector(31 downto 0);

		------------------------- in flow -----------------------
		in_data               : in std_logic_vector(IN_SIZE-1 downto 0);
		in_fv                 : in std_logic;
		in_dv                 : in std_logic;

		------------------------ out flow -----------------------
		out_data              : out std_logic_vector(OUT_SIZE-1 downto 0);
		out_fv                : out std_logic;
		out_dv                : out std_logic
	);
end component;

component conv_slave
	generic (
		CLK_PROC_FREQ : integer
	);
	port (
		clk_proc              : in std_logic;
		reset_n               : in std_logic;

		---------------- dynamic parameters ports ---------------
		status_reg_enable_bit : out std_logic;
		widthimg_reg          : out std_logic_vector(31 downto 0);
		w00_reg_m00           : out std_logic_vector(7 downto 0);
		w01_reg_m01           : out std_logic_vector(7 downto 0);
		w02_reg_m02           : out std_logic_vector(7 downto 0);
		w10_reg_m10           : out std_logic_vector(7 downto 0);
		w11_reg_m11           : out std_logic_vector(7 downto 0);
		w12_reg_m12           : out std_logic_vector(7 downto 0);
		w20_reg_m20           : out std_logic_vector(7 downto 0);
		w21_reg_m21           : out std_logic_vector(7 downto 0);
		w22_reg_m22           : out std_logic_vector(7 downto 0);
		norm_reg              : out std_logic_vector(31 downto 0);

		--======================= Slaves ========================

		------------------------- bus_sl ------------------------
		addr_rel_i            : in std_logic_vector(3 downto 0);
		wr_i                  : in std_logic;
		rd_i                  : in std_logic;
		datawr_i              : in std_logic_vector(31 downto 0);
		datard_o              : out std_logic_vector(31 downto 0)
	);
end component;

	signal status_reg_enable_bit : std_logic;
	signal widthimg_reg          : std_logic_vector (31 downto 0);
	signal w00_reg_m00           : std_logic_vector (7 downto 0);
	signal w01_reg_m01           : std_logic_vector (7 downto 0);
	signal w02_reg_m02           : std_logic_vector (7 downto 0);
	signal w10_reg_m10           : std_logic_vector (7 downto 0);
	signal w11_reg_m11           : std_logic_vector (7 downto 0);
	signal w12_reg_m12           : std_logic_vector (7 downto 0);
	signal w20_reg_m20           : std_logic_vector (7 downto 0);
	signal w21_reg_m21           : std_logic_vector (7 downto 0);
	signal w22_reg_m22           : std_logic_vector (7 downto 0);
	signal norm_reg              : std_logic_vector (31 downto 0);

begin
	conv_process_inst : conv_process
    generic map (
		CLK_PROC_FREQ => CLK_PROC_FREQ,
		IN_SIZE       => IN_SIZE,
		OUT_SIZE      => OUT_SIZE
	)
    port map (
		clk_proc              => clk_proc,
		reset_n               => reset_n,
		status_reg_enable_bit => status_reg_enable_bit,
		widthimg_reg          => widthimg_reg,
		w00_reg_m00           => w00_reg_m00,
		w01_reg_m01           => w01_reg_m01,
		w02_reg_m02           => w02_reg_m02,
		w10_reg_m10           => w10_reg_m10,
		w11_reg_m11           => w11_reg_m11,
		w12_reg_m12           => w12_reg_m12,
		w20_reg_m20           => w20_reg_m20,
		w21_reg_m21           => w21_reg_m21,
		w22_reg_m22           => w22_reg_m22,
		norm_reg              => norm_reg,
		in_data               => in_data,
		in_fv                 => in_fv,
		in_dv                 => in_dv,
		out_data              => out_data,
		out_fv                => out_fv,
		out_dv                => out_dv
	);

	conv_slave_inst : conv_slave
    generic map (
		CLK_PROC_FREQ => CLK_PROC_FREQ
	)
    port map (
		clk_proc              => clk_proc,
		reset_n               => reset_n,
		status_reg_enable_bit => status_reg_enable_bit,
		widthimg_reg          => widthimg_reg,
		w00_reg_m00           => w00_reg_m00,
		w01_reg_m01           => w01_reg_m01,
		w02_reg_m02           => w02_reg_m02,
		w10_reg_m10           => w10_reg_m10,
		w11_reg_m11           => w11_reg_m11,
		w12_reg_m12           => w12_reg_m12,
		w20_reg_m20           => w20_reg_m20,
		w21_reg_m21           => w21_reg_m21,
		w22_reg_m22           => w22_reg_m22,
		norm_reg              => norm_reg,
		addr_rel_i            => addr_rel_i,
		wr_i                  => wr_i,
		rd_i                  => rd_i,
		datawr_i              => datawr_i,
		datard_o              => datard_o
	);


end rtl;
