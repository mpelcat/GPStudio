
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

-- use caph_proc_comp package which list all component declaratio of caph processing
library work;
use work.caph_external_component.all;
use work.caph_processing_component.all;
use work.caph_flow_pkg.all;

entity caph_toplevel is
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
			addr_rel_i : in std_logic_vector(MEM_ADDR_BUS_SIZE-1 downto 0);
			wr_i : in std_logic;
			rd_i : in std_logic;
			datawr_i : in std_logic_vector(31 downto 0);
			datard_o : out std_logic_vector(31 downto 0)
		
		);
end caph_toplevel;


architecture rtl of caph_toplevel is

	constant TOKEN_SIZE : positive := 10;
	
	--~ signal clk_caph : std_logic;
	
	--TODO:change name of w3/w6
	signal w3_f: std_logic;
	signal w3_wr: std_logic;
	signal token : std_logic_vector(TOKEN_SIZE-1 downto 0);
	
	signal w6_rd: std_logic;
	signal w6_e: std_logic;
	signal w6: std_logic_vector(TOKEN_SIZE-1 downto 0);

	signal frame_valid_s : std_logic := '0';
	signal data_valid_s  : std_logic := '0';
	signal data_s : std_logic_vector(7 downto 0);
	
	signal caph_ports_s : caph_ports_t;
	
	signal param_wraddr_s : std_logic_vector(3 downto 0):=(others=>'0');
	signal param_rdaddr_s : std_logic_vector(3 downto 0):=(others=>'0');
	signal param_data_s : std_logic_vector(31 downto 0):=(others=>'0');

	signal enable_s : std_logic := '0';
	signal enable_s_sync : std_logic := '0';
	
--	signal port_s : std_logic_vector(31 downto 0):=(others=>'0');
	signal imwidth_s :std_logic_vector(31 downto 0):=(others=>'0');
	signal imheight_s :std_logic_vector(31 downto 0):=(others=>'0');
	
	signal param_wr_s : std_logic:='0';
	
	--component stroed in USB io in GPSTUDIO
	component fv_synchro_signal is
		port(
			fv_i: in std_logic;
			signal_i : in std_logic;
			signal_o: out std_logic;
			clk_i :in std_logic;
			rst_n_i :in std_logic
		);
	end component;

begin

-- add pll pix_clk x 2 for caph fifo
--~ caph_pll_inst :caph_pll
--~ generic map( INPUT_FREQ => INPUT_FREQ)
--~ port map (
	--~ inclk0 => clk_proc,
	--~ c0 => clk_caph);

--~ TODO Synch ENABLE FV
-- 

ENABLE_IN0_INST: component fv_synchro_signal
  port map(
	fv_i => in_fv,
	signal_i => enable_s,
	signal_o => enable_s_sync,
	clk_i => clk_proc,
	rst_n_i => reset
);

tokenize_inst: component tokenize_flow
	  generic map(
		DATA_INPUT_SIZE => IN_SIZE,
		TOKEN_HEADER_SIZE => 2,
		TOKEN_SIZE => TOKEN_SIZE,
		IMAGE_WIDTH => 320, -- todo: remove generic 
		IMAGE_HEIGHT => 240
	  )
	port map(
			clk_i 		=> clk_proc,
			rst_n_i 	=> reset,
			dv_i 		=> in_dv,
			enable_i 	=> enable_s_sync,
			imwidth_i 	=> imwidth_s,
			imheight_i 	=> imheight_s,
			data_i		=> in_data,
			clk_caph_i	=> clk_caph,
			fifo_full_i => w3_f,
			token_o 	=> token,
			wr_fifo_o	=> w3_wr
		);
	
-- component params_to_ports
-- prend une connection wishbone et genere une liste de port en sortie
-- use array of record
-- TODO: use clk_caph with dual clock ram block

BI2CAPH_INST: component bus2caph	
  generic map(NB_PORTS=>NB_PORTS)
	port map (
		clk_i => clk_proc,
		rst_n_i => reset,			
		addr_i => addr_rel_i,		
		wr_i => wr_i,			
		datawr_i => datawr_i, 	
		enable_o => enable_s,		
		ports => caph_ports_s,
		imwidth_o => imwidth_s,
		imheight_o => imheight_s
	);		


--~ caph_proc : component dx_net
  --~ port map(
    	--~ w3_f=> w3_f,
    	--~ w3 => token,
    	--~ w3_wr => w3_wr,
 --~ 
    	--~ w6_e=> w6_e,
    	--~ w6 => w6,
    	--~ w6_rd=> w6_rd,
    	--~ clock=> clk_caph,
    	--~ reset => reset 
    --~ );
 
 caph_proc : component conv33_port_net
   port map
	(
		i_f=> w3_f,
		i => token,
		i_wr => w3_wr,

		k0_f=> caph_ports_s(0).full,
		k0 => caph_ports_s(0).data(15 downto 0),
		k0_wr => caph_ports_s(0).wr,

		k1_f=> caph_ports_s(1).full,
		k1 => caph_ports_s(1).data(15 downto 0),
		k1_wr => caph_ports_s(1).wr,

		k2_f=> caph_ports_s(2).full,
		k2 => caph_ports_s(2).data(15 downto 0),
		k2_wr => caph_ports_s(2).wr,

		k3_f=> caph_ports_s(3).full,
		k3 => caph_ports_s(3).data(15 downto 0),
		k3_wr => caph_ports_s(3).wr,

		k4_f=> caph_ports_s(4).full,
		k4 => caph_ports_s(4).data(15 downto 0),
		k4_wr => caph_ports_s(4).wr,

		k5_f=> caph_ports_s(5).full,
		k5 => caph_ports_s(5).data(15 downto 0),
		k5_wr => caph_ports_s(5).wr,

		k6_f=> caph_ports_s(6).full,
		k6 => caph_ports_s(6).data(15 downto 0),
		k6_wr => caph_ports_s(6).wr,

		k7_f=> caph_ports_s(7).full,
		k7 => caph_ports_s(7).data(15 downto 0),
		k7_wr => caph_ports_s(7).wr,

		k8_f=> caph_ports_s(8).full,
		k8 => caph_ports_s(8).data(15 downto 0),
		k8_wr => caph_ports_s(8).wr,

		n_f=> caph_ports_s(9).full,
		n => caph_ports_s(9).data(7 downto 0),
		n_wr => caph_ports_s(9).wr,

		o_e=> w6_e,
		o => w6,
		o_rd=> w6_rd,

		 clock=> clk_caph,
		 reset => reset 
     );
     
--~ caph_proc : component dy_net
  --~ port map(
		--~ i_f=> w3_f,
		--~ i => token,
		--~ i_wr => w3_wr,
--~ 
		--~ o_e=> w6_e,
		--~ o => w6,
		--~ o_rd=> w6_rd,
		--~ clock=> clk_caph,
		--~ reset => reset 
    --~ );
    

--  caph_proc : component port_test_net
--    port map(
-- 		w4_f=> w3_f,
-- 		w4 => token,
-- 		w4_wr => w3_wr,
-- 
-- 		w6_f=> caph_ports_s(0).full,
-- 		w6 => caph_ports_s(0).data(7 downto 0),
-- 		w6_wr => caph_ports_s(0).wr,
-- 
-- 		 w9_e=> w6_e,
-- 		 w9 => w6,
-- 		 w9_rd=> w6_rd,
-- 		 clock=> clk_caph,
-- 		 reset => reset 
--      );
-- 
--~ caph_proc : component inv_net
  --~ port map(
		--~ w3_f=> w3_f,
		--~ w3 => token,
		--~ w3_wr => w3_wr,
--~ 
		--~ w6_e=> w6_e,
		--~ w6 => w6,
		--~ w6_rd=> w6_rd,
		--~ clock=> clk_caph,
		--~ reset => reset 
    --~ );
	
untokenize_inst: component untokenize_flow
	GENERIC map(
		IMAGE_WIDTH => 320,
		IMAGE_HEIGHT => 240,
		TOKEN_SIZE => TOKEN_SIZE,
		SIZE => OUT_SIZE
	)
	PORT MAP(
		clk_caph=> clk_caph,
		clk_proc=> clk_proc,
		rst_n_i => reset,
		fifo_empty=> w6_e,
		data_i => w6,
		imwidth_i => imwidth_s,
		imheight_i => imheight_s,
		fifo_unpile=> w6_rd,
		frame_valid_o  => out_fv,
		data_valid_o   => out_dv, 
		data_o => out_data
	);

-- Change 8bits to 16 for USB
--USB_packet_generator_inst:component packet_generator 
--		port map( 
--			rst_n_i  		=> rst_n_i,
--			clk_i  			=> clk_i,		
--			frame_valid_i	=> frame_valid_s,
--			data_valid_i	=> data_valid_s,				
--			data_i			=> data_s,
--			frame_valid_o	=> frame_valid_o,
--			data_valid_o	=> data_valid_o,
--			data_o			=> data_o
--		);
--	

end rtl;
