library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
library std;

entity lbp is
	generic (
		LINE_WIDTH_MAX : integer;
		PIX_WIDTH : integer
	);
	port (
		clk_proc : in std_logic;
		reset_n : in std_logic;

		------------------------- in flow -----------------------
		in_data : in std_logic_vector((PIX_WIDTH-1) downto 0);
		in_fv : in std_logic;
		in_dv : in std_logic;

		------------------------ out flow -----------------------
		out_data : out std_logic_vector((PIX_WIDTH-1) downto 0);
		out_fv : out std_logic;
		out_dv : out std_logic;

		--======================= Slaves ========================

		------------------------- bus_sl ------------------------
		addr_rel_i : in std_logic_vector(1 downto 0);
		wr_i : in std_logic;
		rd_i : in std_logic;
		datawr_i : in std_logic_vector(31 downto 0);
		datard_o : out std_logic_vector(31 downto 0)
	);
end lbp;

architecture rtl of lbp is

component lbp_slave
	port (
		clk_proc		: in std_logic;
		reset_n			: in std_logic;
		
		------------------------- bus_sl ------------------------
		addr_rel_i		: in std_logic_vector(1 downto 0);
		wr_i			: in std_logic;
		rd_i			: in std_logic;
		datawr_i		: in std_logic_vector(31 downto 0);
		datard_o		: out std_logic_vector(31 downto 0);
		
		-- connections to lbp module
		enable_o		: out std_logic;
		widthimg_o		: out std_logic_vector(15 downto 0);
		theshold_o		: out std_logic_vector(7 downto 0)
	);
end component;

component lbp_process
	generic (
		LINE_WIDTH_MAX : integer;
		PIX_WIDTH : integer
	);
	port (
		clk_proc	: in std_logic;
		reset_n		: in std_logic;

		------------------------- in flow -----------------------
		in_data		: in std_logic_vector((PIX_WIDTH-1) downto 0);
		in_fv		: in std_logic;
		in_dv		: in std_logic;

		------------------------ out flow -----------------------
		out_data	: out std_logic_vector((PIX_WIDTH-1) downto 0);
		out_fv		: out std_logic;
		out_dv		: out std_logic;

		------------------------- params ------------------------
		enable_i	: in std_logic;
		widthimg_i	: in std_logic_vector(15 downto 0);
		theshold_i	: in std_logic_vector(7 downto 0)
	);
end component;

-- signals part
	signal enable_s : std_logic;
	signal widthimg_s : std_logic_vector(15 downto 0);
	signal theshold_s : std_logic_vector(7 downto 0);

begin

	lbp_slave_inst : lbp_slave
    port map (
		clk_proc	=>	clk_proc,
		reset_n		=>	reset_n,

		-- bus_sl
		addr_rel_i	=>	addr_rel_i,
		wr_i		=>	wr_i,
		rd_i		=>	rd_i,
		datawr_i	=>	datawr_i,
		datard_o	=>	datard_o,

		-- connections to lbp_process
		enable_o			=>	enable_s,
		widthimg_o			=>	widthimg_s,
		theshold_o			=>	theshold_s
	);

	lbp_process_inst : lbp_process
    generic map (
    	LINE_WIDTH_MAX	=>	LINE_WIDTH_MAX,
    	PIX_WIDTH	=>	PIX_WIDTH
	)
    port map (
		clk_proc	=>	clk_proc,
		reset_n		=>	reset_n,

		-- in flow
		in_data		=>	in_data,
		in_fv		=>	in_fv,
		in_dv		=>	in_dv,

		-- out flow
		out_data	=>	out_data,
		out_fv		=>	out_fv,
		out_dv		=>	out_dv,

		-- connections to lbp_slave
		enable_i			=>	enable_s,
		widthimg_i			=>	widthimg_s,
		theshold_i			=>	theshold_s
	);

end rtl;
