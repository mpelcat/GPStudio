------------------------------------------------------------------------------
-- Title      : Gradient 3x3 8 bits
-- Project    : Gradient 3x3 8 bits
------------------------------------------------------------------------------
-- File       : gradient_3x3.vhd
-- Author     : N. Roudel
-- Company    : WISIP
-- Created    : 2014-02-06
-- Last update: 2014-02-60
-- Platform   :
-- Standard   :
------------------------------------------------------------------------------
-- Description: matrix 3x3 of 8 bits datas as input, scalar as output
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
use ieee.std_logic_signed.all;

library matrix_type_lib;
use matrix_type_lib.matrix_type_comp.all;

library work;
use work.gradient_3x3_comp.all;

entity gradient_3x3 is
		port ( 
			rst_i  			: 	in  std_logic;
			clk_i  			: 	in  std_logic;			
			frame_valid_i	:	in	std_logic;				
			data_valid_i	:	in	std_logic;				
			data_i 			: 	in  matrix_3x3_8b_t;
			
			frame_valid_o	:	out	std_logic;
			data_valid_o	:	out	std_logic;
			Ixx_o			:	out std_logic_vector(17 downto 0);		
			Ixy_o			:	out std_logic_vector(17 downto 0);		
			Iyy_o			:	out std_logic_vector(17 downto 0)		
		);
end gradient_3x3;


architecture rtl of gradient_3x3 is

type fifo_t is array (0 to 1) of std_logic_vector(1 downto 0);
signal fifo_int : fifo_t;

signal Ix : std_logic_vector(8 downto 0);
signal Iy : std_logic_vector(8 downto 0);

begin

	p0_decal_valid: process(rst_i,clk_i)
		begin
		if( rst_i = '1' )then
			fifo_int 	<= (others => (others => '0'));
		elsif( rising_edge(clk_i) )then
			fifo_int(1)		<= fifo_int(0);
			fifo_int(0)(0) 	<= data_valid_i;			
			fifo_int(0)(1) 	<= frame_valid_i;			
		end if;
	end process;
	
	data_valid_o 	<= fifo_int(1)(0);
	frame_valid_o 	<= fifo_int(1)(1);
	
	p1_process_grad: process(rst_i,clk_i)
		begin
			if(rst_i = '1' )then
				Ix 		<= (others => '0');
				Iy 		<= (others => '0');
				Ixx_o 	<= (others => '0');
				Ixy_o 	<= (others => '0');
				Iyy_o 	<= (others => '0');
			elsif( rising_edge(clk_i) )then
				if( data_valid_i = '1' )then
					Ix 		<= ( '0'&data_i(6) ) - ( '0'&data_i(4) );
					Iy 		<= ( '0'&data_i(8) ) - ( '0'&data_i(2) );
				end if;
				
				if( fifo_int(0)(0) = '1' )then
					Ixx_o	<= Ix * Ix;
					Ixy_o	<= Ix * Iy;
					Iyy_o	<= Iy * Iy;	
				end if;
			end if;
	end process;
		
	
end rtl;
