library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
library std;

entity erode is
	generic (
		LINE_WIDTH_MAX : integer;
		CLK_PROC_FREQ  : integer;
		IN_SIZE        : integer;
		OUT_SIZE       : integer
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
end erode;

architecture rtl of erode is
component erode_process
	generic (
		LINE_WIDTH_MAX : integer;
		CLK_PROC_FREQ  : integer;
		IN_SIZE        : integer;
		OUT_SIZE       : integer
	);
	port (
		clk_proc              : in std_logic;
		reset_n               : in std_logic;

		---------------- dynamic parameters ports ---------------
		status_reg_enable_bit : in std_logic;
		widthimg_reg_value    : in std_logic_vector(15 downto 0);
		heigtimg_reg_value    : in std_logic_vector(15 downto 0);
		er00_reg_m00          : in std_logic_vector(7 downto 0);
		er01_reg_m01          : in std_logic_vector(7 downto 0);
		er02_reg_m02          : in std_logic_vector(7 downto 0);
		er10_reg_m10          : in std_logic_vector(7 downto 0);
		er11_reg_m11          : in std_logic_vector(7 downto 0);
		er12_reg_m12          : in std_logic_vector(7 downto 0);
		er20_reg_m20          : in std_logic_vector(7 downto 0);
		er21_reg_m21          : in std_logic_vector(7 downto 0);
		er22_reg_m22          : in std_logic_vector(7 downto 0);

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

component erode_slave
	generic (
		CLK_PROC_FREQ : integer
	);
	port (
		clk_proc              : in std_logic;
		reset_n               : in std_logic;

		---------------- dynamic parameters ports ---------------
		status_reg_enable_bit : out std_logic;
		widthimg_reg_value    : out std_logic_vector(15 downto 0);
		heigtimg_reg_value    : out std_logic_vector(15 downto 0);
		er00_reg_m00          : out std_logic_vector(7 downto 0);
		er01_reg_m01          : out std_logic_vector(7 downto 0);
		er02_reg_m02          : out std_logic_vector(7 downto 0);
		er10_reg_m10          : out std_logic_vector(7 downto 0);
		er11_reg_m11          : out std_logic_vector(7 downto 0);
		er12_reg_m12          : out std_logic_vector(7 downto 0);
		er20_reg_m20          : out std_logic_vector(7 downto 0);
		er21_reg_m21          : out std_logic_vector(7 downto 0);
		er22_reg_m22          : out std_logic_vector(7 downto 0);

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
	signal widthimg_reg_value    : std_logic_vector (15 downto 0);
	signal heigtimg_reg_value    : std_logic_vector (15 downto 0);
	signal er00_reg_m00          : std_logic_vector (7 downto 0);
	signal er01_reg_m01          : std_logic_vector (7 downto 0);
	signal er02_reg_m02          : std_logic_vector (7 downto 0);
	signal er10_reg_m10          : std_logic_vector (7 downto 0);
	signal er11_reg_m11          : std_logic_vector (7 downto 0);
	signal er12_reg_m12          : std_logic_vector (7 downto 0);
	signal er20_reg_m20          : std_logic_vector (7 downto 0);
	signal er21_reg_m21          : std_logic_vector (7 downto 0);
	signal er22_reg_m22          : std_logic_vector (7 downto 0);

begin
	erode_process_inst : erode_process
    generic map (
		CLK_PROC_FREQ  => CLK_PROC_FREQ,
		LINE_WIDTH_MAX => LINE_WIDTH_MAX,
		IN_SIZE        => IN_SIZE,
		OUT_SIZE       => OUT_SIZE
	)
    port map (
		clk_proc              => clk_proc,
		reset_n               => reset_n,
		status_reg_enable_bit => status_reg_enable_bit,
		widthimg_reg_value    => widthimg_reg_value,
		heigtimg_reg_value    => heigtimg_reg_value,
		er00_reg_m00          => er00_reg_m00,
		er01_reg_m01          => er01_reg_m01,
		er02_reg_m02          => er02_reg_m02,
		er10_reg_m10          => er10_reg_m10,
		er11_reg_m11          => er11_reg_m11,
		er12_reg_m12          => er12_reg_m12,
		er20_reg_m20          => er20_reg_m20,
		er21_reg_m21          => er21_reg_m21,
		er22_reg_m22          => er22_reg_m22,
		in_data               => in_data,
		in_fv                 => in_fv,
		in_dv                 => in_dv,
		out_data              => out_data,
		out_fv                => out_fv,
		out_dv                => out_dv
	);

	erode_slave_inst : erode_slave
    generic map (
		CLK_PROC_FREQ => CLK_PROC_FREQ
	)
    port map (
		clk_proc              => clk_proc,
		reset_n               => reset_n,
		status_reg_enable_bit => status_reg_enable_bit,
		widthimg_reg_value    => widthimg_reg_value,
		heigtimg_reg_value    => heigtimg_reg_value,
		er00_reg_m00          => er00_reg_m00,
		er01_reg_m01          => er01_reg_m01,
		er02_reg_m02          => er02_reg_m02,
		er10_reg_m10          => er10_reg_m10,
		er11_reg_m11          => er11_reg_m11,
		er12_reg_m12          => er12_reg_m12,
		er20_reg_m20          => er20_reg_m20,
		er21_reg_m21          => er21_reg_m21,
		er22_reg_m22          => er22_reg_m22,
		addr_rel_i            => addr_rel_i,
		wr_i                  => wr_i,
		rd_i                  => rd_i,
		datawr_i              => datawr_i,
		datard_o              => datard_o
	);


end rtl;
