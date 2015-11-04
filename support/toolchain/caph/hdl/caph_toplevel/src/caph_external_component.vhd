------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

use work.caph_flow_pkg.caph_ports_t;

package caph_external_component is

	
	component caph_toplevel is
			generic (
				IN_SIZE	:positive;
				OUT_SIZE	:positive;
				INPUT_FREQ : positive;
				IMAGE_WIDTH : positive;
				IMAGE_HEIGHT: positive;
				USE_PORTS : string :="NO";
				NB_PORTS: positive;
				MEM_ADDR_BUS_SIZE : POSITIVE := 4;
				CLK_PROC_FREQ : positive;
				CLK_CAPH_FREQ : positive
			);	
			port ( 
				clk_proc  			: in  std_logic;
				clk_caph  			: in  std_logic;
				reset  		: in  std_logic;
					
				in_data: in  std_logic_vector(IN_SIZE-1 downto 0);		
				in_fv	: in  std_logic;					
				in_dv	: in  std_logic;					
				
				out_data			: out std_logic_vector(OUT_SIZE-1 downto 0) ;
				out_fv	: out std_logic;
				out_dv	: out std_logic;
				
				
				-- add param interface
	--			param_addr_o: out std_logic_vector(MEM_ADDR_BUS_SIZE-1 DOWNTO 0);			
	--			param_data_i : in std_logic_vector(15 downto 0);
	--			update_port_i : in std_logic
			
				------ bus_sl ------
				addr_rel_i : in std_logic_vector(4 downto 0);
				wr_i : in std_logic;
				rd_i : in std_logic;
				datawr_i : in std_logic_vector(31 downto 0);
				datard_o : out std_logic_vector(31 downto 0)
			
			);
	end component;

	component params_to_ports
	generic (
		NB_PORTS: positive:= 1
    );
	port(
		update_i : in std_logic;
		param_data_i : in std_logic_vector(31 downto 0);
		
		-- array of ports
		ports : out caph_ports_t;
		
		clk_i : in std_logic;
		rst_n_i :in std_logic
    );
	end component;
 
	component caph_pll
	GENERIC
	(
		INPUT_FREQ: positive := 48
	);
	PORT
	(
		inclk0		: IN STD_LOGIC  := '0';
		c0		: OUT STD_LOGIC 
	);
	END component;

	
	component tokenize_flow is
	  generic (
		DATA_INPUT_SIZE: integer := 8;
		TOKEN_HEADER_SIZE: integer := 2;
		TOKEN_SIZE: integer := 10;
		IMAGE_WIDTH : integer := 500;
		IMAGE_HEIGHT : integer := 2
	  );
		port (
			clk_i : in std_logic;
			rst_n_i : in std_logic;
			
			dv_i : in std_logic;
			enable_i : in std_logic;
			data_i: in std_logic_vector(DATA_INPUT_SIZE-1 downto 0);
			imwidth_i : in std_LOGIC_VECTOR(31 downto 0);
			imheight_i : in std_LOGIC_VECTOR(31 downto 0);
			
			clk_caph_i:in std_logic; -- clk fifo = clk_pixelx2
			fifo_full_i:in std_logic; --fifo_full input
			
			token_o : out std_logic_vector(TOKEN_SIZE-1 downto 0);	
			wr_fifo_o:out std_logic -- write fifo 
		);
			
	end component;


		component untokenize_flow is
			generic(
				IMAGE_WIDTH:integer := 320;
				IMAGE_HEIGHT:integer := 240;
				TOKEN_SIZE: integer := 10;
				SIZE:integer:=8
			);
			port (
				clk_caph: in std_logic;
				clk_proc: in std_logic;
				rst_n_i : in std_logic;
				fifo_empty: in std_logic;
				data_i : in std_logic_vector(TOKEN_SIZE-1 downto 0);
				imwidth_i : in std_LOGIC_VECTOR(31 downto 0);
				imheight_i : in std_LOGIC_VECTOR(31 downto 0);
		
				fifo_unpile: out std_logic;
				frame_valid_o  :out std_logic;
				data_valid_o   :out std_logic;
				data_o : out std_logic_vector (SIZE-1 downto 0)
				);
	end component;

	component packet_generator
	port ( 
			rst_n_i  		: in  std_logic;
			clk_i  			: in  std_logic;		
			frame_valid_i	: in  std_logic;					
			data_valid_i	: in  std_logic;					
			data_i			: in  std_logic_vector(7 downto 0);
			frame_valid_o	: out std_logic;
			data_valid_o	: out std_logic;
			data_o			: out std_logic_vector(15 downto 0) 
		);
	end component;

	
	component bus2caph 
	  generic (
		NB_PORTS:positive := 0
	 );
	  port(
		clk_i : in std_logic;
		rst_n_i : in std_logic;
					
		-- quartus declaration
		addr_i : in std_logic_vector(3 DOWNTO 0);
		wr_i : in std_logic;
		datawr_i : in std_logic_vector(31 downto 0);
	
		enable_o : out std_logic;
	
	--	port_o : out std_logic_vector(31 downto 0);
	
		ports: out caph_ports_t;
	
		imwidth_o		: out std_logic_vector(31 downto 0);
		imheight_o		: out std_logic_vector(31 downto 0)
	 );
	 
	end component;

	
-- OLD components	
	component tokenize_mt9 
	  generic (SIZE: integer := 10);
		port (
			clk_i : in std_logic;
			rst_n_i : in std_logic;
			frame_valid_i : in std_logic;
			data_valid_i : in std_logic;
			data_i: in std_logic_vector(7 downto 0);
			
			token_o : out std_logic_vector(SIZE-1 downto 0);
			
			-- CAPH fifo management
			clk_caph_i:in std_logic; -- clk fifo = clk_pixelx2
			fifo_full_i:in std_logic; --fifo_full input
			wr_fifo_o:out std_logic -- write fifo 
			);
			
	end component;

	component untokenize_mt9 
		generic(SIZE:integer:=10);
		port (
			clk_i: in std_logic;
			rst_n_i : in std_logic;
			fifo_empty: in std_logic;
			data_i : in std_logic_vector(SIZE-1 downto 0);
			
			fifo_unpile: out std_logic;
			frame_valid_o  :out std_logic;
			data_valid_o   :out std_logic;
			data_o : out std_logic_vector (7 downto 0)
			);
			
	end component;
	
end caph_external_component;
