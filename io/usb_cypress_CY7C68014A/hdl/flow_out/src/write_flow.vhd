-- **************************************************************************
--	READ FLOW
-- **************************************************************************
-- Ce composant est connect� � un com_flow_fifo en entr�e et � un processing (FV/LV/Data) en sortie
-- 
-- 16/10/2014 - creation
--------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- entity "uses" the package   
use work.ComFlow_pkg.all;

-- Transform FV/DV/Data en flow 

entity write_flow is
  generic (
  	PACKET_SIZE : integer := 256; 
	FLAGS_CODES : my_array_t := InitFlagCodes
    );
  port(

	data_i : in std_logic_vector(15 downto 0);
	fv_i: in std_logic;
	dv_i : in std_logic;
	enable_i : in std_logic;
	fifo_f_i : in std_logic;

	data_wr_o : out std_logic;
    data_o : out std_logic_vector(15 downto 0);
	pktend_o : out std_logic;
	flag_wr_o :out std_logic;
	flag_o :out  std_logic_vector(7 downto 0);
	
	clk_i :in std_logic;
	rst_n_i :in std_logic
    );
end write_flow;

architecture rtl of write_flow is
---------------------------------------------------------
--	SIGNALS
---------------------------------------------------------
	signal fv_r : std_logic:='0';
	signal dv_r : std_logic:='0';
	signal skip : std_logic := '0'; 
	
begin

FSM:process (clk_i, rst_n_i) 
variable cpt : integer range 0 to PACKET_SIZE:=0;
begin
	if (rst_n_i = '0') then			
		fv_r <='0';
		dv_r <='0';	
		flag_o <= (others=>'0');
		pktend_o <='0';
		skip <= '0';
		cpt:=0;
		
	elsif rising_edge(clk_i) then	
		fv_r <= fv_i;
		dv_r <= dv_i;

		pktend_o <='0';
		flag_wr_o <='0';
		
		if(enable_i='1') then
		
			if( dv_i = '1' and fifo_f_i='0' ) then
				cpt:=cpt + 1;
			end if;
		
			if( fv_r ='1' and fv_i='0' ) then
				flag_wr_o <='1';
				flag_o <= FLAGS_CODES(EoF);
				pktend_o <='1';
				skip <='0';
				cpt := 0;
			elsif (cpt=(PACKET_SIZE-2) and skip='1') then -- peut retarder de un clk le test
				flag_wr_o <='1';
				flag_o <= FLAGS_CODES(EoL);
				cpt := 0;
			elsif (cpt=(PACKET_SIZE-2) and skip='0') then
				skip <='1';
				flag_wr_o <='1';
				flag_o <= FLAGS_CODES(SoF);
				cpt := 0;
			end if;
			
		end if;
	end if;
end process;

	data_wr_o <= dv_i and enable_i and not(fifo_f_i);
	data_o <= data_i;


	
	
end rtl;

