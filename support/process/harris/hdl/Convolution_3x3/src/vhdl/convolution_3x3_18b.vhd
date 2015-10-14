------------------------------------------------------------------------------
-- Title      : Convolution 3x3 18bits
-- Project    : Convolution 3x3
------------------------------------------------------------------------------
-- File       : convolution_3x3_18b.vhd
-- Author     : N. Roudel
-- Company    : WISIP
-- Created    : 2014-02-07
-- Last update: 2014-02-07
-- Platform   :
-- Standard   :
------------------------------------------------------------------------------
-- Description: matrix 5x5 8bits and mask 5x5 8bits as input, scalar as output
--
------------------------------------------------------------------------------
-- Copyright (c) 2013, 2014 Wisip
------------------------------------------------------------------------------
-- Revisions  :
-- Date         Version  Author     Description
-- 2014-02-07   1.0      N. Roudel  File created
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;


library matrix_type_lib;
use matrix_type_lib.matrix_type_comp.all;

library work;
use work.convolution_3x3_18b_comp.all;

entity convolution_3x3_18b is
		port ( 
			rst_i  			: in  std_logic;
			clk_i  			: in  std_logic;			
			frame_valid_i	: in  std_logic;					
			data_valid_i	: in  std_logic;					
			
			data_i			: in  matrix_3x3_18b_t;
			mask_i			: in  matrix_3x3_8b_t;
			
			frame_valid_o	: out std_logic;
			data_valid_o	: out std_logic;
			data_o			: out std_logic_vector(29 downto 0) 
		);
end convolution_3x3_18b;


architecture rtl of convolution_3x3_18b is
signal res1_int : std_logic_vector(25 downto 0);
signal res2_int : std_logic_vector(25 downto 0);
signal res3_int : std_logic_vector(25 downto 0);
signal res4_int : std_logic_vector(25 downto 0);
signal res5_int : std_logic_vector(25 downto 0);
signal res6_int : std_logic_vector(25 downto 0);
signal res7_int : std_logic_vector(25 downto 0);
signal res8_int : std_logic_vector(25 downto 0);
signal res9_int : std_logic_vector(25 downto 0);

signal res_in	: std_logic_vector(29 downto 0);

type fifo_t is array (0 to 2) of std_logic_vector(1 downto 0);
signal fifo_int : fifo_t;

begin

p0_decal_dval:process(rst_i,clk_i)
	begin
		if(rst_i = '1' )then
			fifo_int 	<= (others => ( others => '0'));
		elsif( rising_edge(clk_i)  )then
			for i in 1 to 2 loop
				fifo_int(i) <= fifo_int(i-1);
			end loop;
			fifo_int(0)(0) <= data_valid_i;
			fifo_int(0)(1) <= frame_valid_i;
		end if;
	end process p0_decal_dval;
	
	data_valid_o <= fifo_int(2)(0);
	frame_valid_o <= fifo_int(2)(1);
	
p1_mult:process(rst_i,clk_i)
	begin
		if( rst_i = '1' )then
		
		elsif( rising_edge(clk_i) )then
			res1_int <= data_i(1) * mask_i(1);
			res2_int <= data_i(2) * mask_i(2);
			res3_int <= data_i(3) * mask_i(3);
			   
			res4_int <= data_i(4) * mask_i(4);
			res5_int <= data_i(5) * mask_i(5);
			res6_int <= data_i(6) * mask_i(6);
			   
			res7_int <= data_i(7) * mask_i(7);
			res8_int <= data_i(8) * mask_i(8);
			res9_int <= data_i(9) * mask_i(9);
					
		end if;
	end process p1_mult;
	

	
add0: component altera_add9_26b
	PORT map(		
		clock	=> clk_i,
		data0x	=> res1_int,	
		data1x	=> res2_int,	
		data2x	=> res3_int,	
		data3x	=> res4_int,	
		data4x	=> res5_int,	
		data5x	=> res6_int,	
		data6x	=> res7_int,	
		data7x	=> res8_int,	
		data8x	=> res9_int,	
		result	=> res_in	
	);
	
div0: process(rst_i,clk_i)
	begin
		if( rst_i = '1' )then
			data_o <= (others => '0');
		elsif( rising_edge(clk_i) )then
			data_o <= res_in(29) & res_in(29) & res_in(29) & res_in(29) & res_in(29 downto 4);
		end if;
	end process;
	
end rtl;
