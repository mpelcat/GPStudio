------------------------------------------------------------------------------
-- Title      : Matrix 3x3 Builder 8 bits
-- Project    : Matrix 3x3 Builder
------------------------------------------------------------------------------
-- File       : matrix_3x3_builder_8b.vhd
-- Author     : N. Roudel
-- Company    : WISIP
-- Created    : 2014-02-06
-- Last update: 2014-02-60
-- Platform   :
-- Standard   :
------------------------------------------------------------------------------
-- Description: Data flow as input, matrix 5x5 of 8 bits datas as output
--
------------------------------------------------------------------------------
-- Copyright (c) 2013, 2014 Wisip
------------------------------------------------------------------------------
-- Revisions  :
-- Date         Version  Author     Description
-- 2014-02-06   1.0      N. Roudel  File created
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use ieee.std_logic_unsigned.all;

library matrix_type_lib;
use matrix_type_lib.matrix_type_comp.all;

library work;
use work.matrix_3x3_builder_8b_comp.all;

entity matrix_3x3_builder_8b is
	generic (
			IM_WIDTH	: 	positive
		);	
		port ( 
			rst_i  			: 	in  std_logic;
			clk_i  			: 	in  std_logic;			
			frame_valid_i	:	in	std_logic;
			data_valid_i	:	in	std_logic;
			data_i 			: 	in  std_logic_vector(7 downto 0);
			
			frame_valid_o	:	out	std_logic;
			data_valid_o	:	out	std_logic;
			
			data_o			:	out matrix_3x3_8b_t
    );
end matrix_3x3_builder_8b;


architecture rtl of matrix_3x3_builder_8b is
type fifo_t is array (0 to 2*IM_WIDTH + 2) of std_logic_vector(7 downto 0);
signal fifo_int : fifo_t;

type fifo2_t is array (0 to 1) of std_logic_vector(1 downto 0);
signal fifo2_int : fifo2_t;
begin


	p0_build_5x5: process(rst_i,clk_i)
	begin
		if( rst_i = '1' )then
			fifo_int <= (others => (others => '0'));
		elsif( rising_edge(clk_i) )then
			 if(data_valid_i = '1')then
				for i in 1 to 2*IM_WIDTH + 2 loop
					fifo_int(i) <= fifo_int(i-1);
				end loop;			
				fifo_int(0) <= data_i;	
			end if;
		end if;
	end process p0_build_5x5;
	
	p1_decal_dval: process(rst_i,clk_i)
		begin
		if( rst_i = '1' )then
			fifo2_int <= (others => (others => '0'));
		elsif( rising_edge(clk_i) )then			
			data_valid_o 	<= data_valid_i;
			frame_valid_o 	<= frame_valid_i;
				
		end if;
	end process;
	
	
	data_o(1) <= fifo_int(0*IM_WIDTH + 0);
	data_o(2) <= fifo_int(0*IM_WIDTH + 1);
	data_o(3) <= fifo_int(0*IM_WIDTH + 2);
	data_o(4) <= fifo_int(1*IM_WIDTH + 0);
	data_o(5) <= fifo_int(1*IM_WIDTH + 1);
	data_o(6) <= fifo_int(1*IM_WIDTH + 2);
	data_o(7) <= fifo_int(2*IM_WIDTH + 0);
	data_o(8) <= fifo_int(2*IM_WIDTH + 1);
	data_o(9) <= fifo_int(2*IM_WIDTH + 2);
	
	
end rtl;
