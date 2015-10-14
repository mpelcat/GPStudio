------------------------------------------------------------------------------
-- Title      : Harris ABC To R
-- Project    : Harris ABC To R
------------------------------------------------------------------------------
-- File       : harris_abc_to_r.vhd
-- Author     : N. Roudel
-- Company    : WISIP
-- Created    : 2014-02-21
-- Last update: 2014-02-21
-- Platform   :
-- Standard   :
------------------------------------------------------------------------------
-- Description: Compute Harris value R from A B C variables
--
------------------------------------------------------------------------------
-- Copyright (c) 2013, 2014 Wisip
------------------------------------------------------------------------------
-- Revisions  :
-- Date         Version  Author     Description
-- 2014-02-21   1.0      N. Roudel  File created
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;

library work;
use work.harris_abc_to_r_comp.all;


entity harris_abc_to_r is
	port ( 
		rst_i  			: in  std_logic;
		clk_i  			: in  std_logic;			
		frame_valid_i	: in  std_logic;
		data_valid_i	: in  std_logic;
		
		Aw_i			: in std_logic_vector(29 downto 0);
		Bw_i			: in std_logic_vector(29 downto 0);
		Cw_i			: in std_logic_vector(29 downto 0);
		
		frame_valid_o	: out std_logic;
		data_valid_o	: out std_logic;
		R_o				: out std_logic_vector(61 downto 0)
		);
end harris_abc_to_r;


architecture rtl of harris_abc_to_r is
	
	signal frame_valid_trace_to_trace2_int : std_logic;
	signal data_valid_trace_to_trace2_int : std_logic;
	
	signal frame_valid_trac2_to_ktrace2_int : std_logic;
	signal data_valid_trace2_to_ktrace2_int : std_logic;
	
	signal frame_valid_ktrace2_to_R_int : std_logic;
	signal data_valid_ktrace2_to_R_int : std_logic;

	
	signal det_M_int	:	std_logic_vector(59 downto 0);
	signal det_M_plus1_int	:	std_logic_vector(59 downto 0);
	signal traceM_int	:	std_logic_vector(30 downto 0);
	signal traceM2_int	:	std_logic_vector(61 downto 0);
	signal ktraceM2_int	:	std_logic_vector(61 downto 0);
	
	type fifo_t is array (0 to 4) of std_logic_vector(1 downto 0);
	signal fifo_int : fifo_t;
	
	signal tmp_s:std_logic_vector(59 downto 0);
		
begin


-- la chaîne de calcul de R depuis les résultat Aw,Bw et Cw met 4 cycles d'horloge
-- => on décale data_valid et frame_valid de 4 cycles d'horloge	
p1:process(rst_i,clk_i)
	begin
		if(rst_i = '1' )then
			fifo_int 	<= (others => (others=>'0'));
		elsif( rising_edge(clk_i)  )then
			for i in 1 to 4 loop
				fifo_int(i) <= fifo_int(i-1);
			end loop;
			fifo_int(0)(0) <= data_valid_i;
			fifo_int(0)(1) <= frame_valid_i;
		end if;
	end process;
	
		data_valid_o <= fifo_int(3)(0);
		frame_valid_o <= fifo_int(3)(1);
	
--------------------------------------------------------------------------	
--------------------------------------------------------------------------	
-- Le composant mult add ne gère pas correctement l'addition.
-- A remplacer avec un process semblable a celui de la convolution_3x3
--------------------------------------------------------------------------	
--------------------------------------------------------------------------	
	
p2_Calc_detM: process(clk_i,rst_i)
	begin
		if(rst_i = '1')then
			det_M_int <= (others => '0');
		elsif( rising_edge (clk_i) )then
			det_M_int <= (Aw_i * Bw_i) - (Cw_i * Cw_i);
		end if;
	end process;
	
-- la chaîne de calcul de DetM est réalisée en 1 cycles d'horloge
-- la chaîne de calcul de la k*traceM² est réalisée en 3 cycles d'horloge
-- => On décal de deux cycles d'horloge le detM.
p3_decal_detM: process(clk_i,rst_i)
	begin
		if( rst_i = '1' )then
			tmp_s <=(others => '0');
		elsif( rising_edge(clk_i) )then
			tmp_s <= det_M_int;			
			det_M_plus1_int  <= tmp_s;
		end if;
	end process;
	
p4_Calc_traceM: process(clk_i,rst_i)
	begin
		if(rst_i = '1')then
			traceM_int <= (others => '0');
		elsif( rising_edge (clk_i) )then
			traceM_int <= (Aw_i(29) & Aw_i) + (Bw_i(29) & Bw_i);
			traceM2_int <= traceM_int * traceM_int;
			ktraceM2_int <=  traceM2_int(60) & traceM2_int(60) & traceM2_int(60) & traceM2_int(60) & traceM2_int(60) & traceM2_int(61 downto 5);
		end if;
	end process;

	
p5_Calc_R: process(clk_i,rst_i)
	begin
		if(rst_i = '1')then
			null;
		elsif( rising_edge (clk_i) )then
			R_o <= det_M_plus1_int - ktraceM2_int;
		end if;
	end process;
	
end rtl;
