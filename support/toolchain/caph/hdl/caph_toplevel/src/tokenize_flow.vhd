
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use ieee.math_real.all;
use work.caph_flow_pkg.all;

entity tokenize_flow is
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
		
end entity tokenize_flow;


architecture rtl of tokenize_flow is

constant zero : std_logic_vector(TOKEN_SIZE-TOKEN_HEADER_SIZE-DATA_INPUT_SIZE-1 downto 0):=(others=>'0');
constant zzero : std_logic_vector(DATA_INPUT_SIZE-1 downto 0):=(others=>'0');
signal i_wrf:std_logic;

type t_state is (WaitFirstData,WaitSoL,DataValid,DumpEoL,DumpEoF);
signal state : t_state:=WaitFirstData;

signal endframe: std_logic;
signal dv_r  : std_logic;
signal fifo_rdempty_r : std_logic;
signal pixel_r : std_logic_vector(7 downto 0);
signal i_token_o:std_logic_vector(TOKEN_SIZE-1 downto 0);

-- Calcul de la largeur de bus en fonction de la profondeur de la Fifo 
-- 2 CLK de retard par LINE 

 constant FIFO_DEPTH : integer := 4*IMAGE_HEIGHT;
 constant WIDTHU : integer := integer(ceil(log2(real(FIFO_DEPTH))));
 
-------------
-- FIFO 1 SIGNALS
-------------
	signal	fifo_data_s  : std_logic_vector(DATA_INPUT_SIZE-1 downto 0):=(others=>'0');
	signal	fifo_wrclk_s : std_logic:= '0';
	signal	fifo_wrreq_s : std_logic:= '0';
	signal	fifo_wrfull_s :	std_logic:= '0';
	
	signal	fifo_q_s: std_logic_vector(DATA_INPUT_SIZE-1 downto 0):=(others=>'0');
	signal	fifo_rdclk_s: std_logic:= '0';
	signal	fifo_rdreq_s: std_logic:= '0';
	signal	fifo_rdempty_s :	std_logic:= '0';
	signal  fifo_rdusedw_s	: std_logic_vector(integer(ceil(log2(real(FIFO_DEPTH))))-1 DOWNTO 0):=(others=>'0');
	signal  fifo_wrusedw_s	: std_logic_vector(integer(ceil(log2(real(FIFO_DEPTH))))-1 DOWNTO 0):=(others=>'0');
	
	signal fifo_aclr_s : std_logic :='0';
	
	signal data_cpt: integer range 0 to MAX_IMAGE_WIDTH := 0;
	signal line_cpt: integer range 0 to MAX_IMAGE_HEIGHT := 0;

---------------------------------------------------------
--	COMPONENT DECLARATION
---------------------------------------------------------
component fifo_route_matrix
GENERIC
	(
		DEPTH : POSITIVE := 10;
		DATA_SIZE : POSITIVE := 8
	);
	PORT
	(
		aclr		: IN STD_LOGIC  := '0';
		data		: IN STD_LOGIC_VECTOR (DATA_INPUT_SIZE-1 DOWNTO 0);
		rdclk		: IN STD_LOGIC ;
		rdreq		: IN STD_LOGIC ;
		wrclk		: IN STD_LOGIC ;
		wrreq		: IN STD_LOGIC ;
		q			: OUT STD_LOGIC_VECTOR (DATA_INPUT_SIZE-1 DOWNTO 0);
		rdempty		: OUT STD_LOGIC ;
		rdusedw		: OUT STD_LOGIC_VECTOR (WIDTHU-1 DOWNTO 0);
		wrfull		: OUT STD_LOGIC ;
		wrusedw		: OUT STD_LOGIC_VECTOR (WIDTHU-1 DOWNTO 0)
	);
END component;


begin


	FIFO_1 : component fifo_route_matrix
	GENERIC MAP(
		DEPTH => FIFO_DEPTH,
		DATA_SIZE => 8
	)
	PORT map 
	(
		data		=> fifo_data_s,
		rdclk		=> clk_i,
		rdreq		=> fifo_rdreq_s,
		wrclk		=> clk_i,
		wrreq		=> fifo_wrreq_s,
		aclr 		=> fifo_aclr_s,
		q			=> fifo_q_s,
		rdempty => fifo_rdempty_s,
		rdusedw	=> fifo_rdusedw_s,
		wrusedw	=> fifo_wrusedw_s, 
		wrfull	=> fifo_wrfull_s
	);


fifo_data_s <= data_i;
fifo_wrreq_s <= dv_i and enable_i;
fifo_aclr_s <= not(rst_n_i or enable_i);

-- Conditions de commande de la FIFO Altera
fifo_read_label: fifo_rdreq_s <= 
	 not(fifo_rdempty_s) when (state=WaitFirstData) else
	 not(fifo_rdempty_s) when (state=WaitSoL) else
	 not(fifo_rdempty_s) when (state=DataValid) and (data_cpt< to_integer(unsigned(imwidth_i))) else
	'0' when (state=DataValid) and data_cpt=to_integer(unsigned(imwidth_i)) else
	'0' when (state=DumpEoL) else
	'0' when (state=DumpEoF) else 
	'0';
	
process(clk_i,rst_n_i)

begin
	if (rst_n_i = '0') then 
		state <= WaitFirstData;
		i_token_o <=(others=>'0');
		pixel_r <=  (others=>'0');
		data_cpt <= 0;
		line_cpt <=0;
		dv_r <= '0';
	elsif rising_edge(clk_i) then
		dv_r <= dv_i;
		i_token_o <=(others=>'0');
		i_wrf <= '0';
		fifo_rdempty_r <= fifo_rdempty_s;
		case state is
		
			-- wait for First data
			when WaitFirstData =>
				if dv_i='1' then 
					i_token_o <= CaphHeader(SoF) & zzero;
					i_wrf <='1'; -- write to caph fifo
					state <= WaitSoL;
				end if;
					
			-- generated start of line
			when WaitSoL =>
				-- write SoL token
				i_token_o <= CaphHeader(SoL) & zzero;
				i_wrf <='1'; -- write to caph fifo
				
				--fifo_rdreq_s <= '1'; -- rd 1 clk avant data sur bus
				state <= DataValid;	
				
			when DataValid =>
				
				-- fifo_rdempty_r fifo_rdempty_s delayed from 1 clk
				if (fifo_rdempty_r='0') then
					i_token_o <= CaphHeader(Data) & zero & fifo_q_s;
					i_wrf<='1';
					data_cpt <= data_cpt + 1 ;
				end if;
				
				if (data_cpt = to_integer(unsigned(imwidth_i))) then
					data_cpt <= 0;
					line_cpt <= line_cpt + 1 ;
					state <= DumpEoL;
				end if;

			when DumpEoL =>
				i_token_o <= CaphHeader(EoF) & zzero;
				i_wrf<='1';
				
				if (line_cpt = to_integer(unsigned(imheight_i))) then
					state<=DumpEoF;
					line_cpt <= 0;
				else
					state<=WaitSoL;
				end if;
			
			when DumpEoF =>
				i_token_o <= CaphHeader(EoF) & zzero;
				i_wrf<='1';
				state<=WaitFirstData;
		end case;	
	end if;
end process;

token_o <= i_token_o;
wr_fifo_o <= i_wrf;

--with clk_i select
--	wr_fifo_o <= '0' when '0',
--				i_wrf when '1',
--				'0' when others;
--	
	
end architecture;
