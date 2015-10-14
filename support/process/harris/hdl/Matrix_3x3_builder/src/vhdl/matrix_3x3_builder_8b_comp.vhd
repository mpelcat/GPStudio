------------------------------------------------------------------------------
-- Title      : Matrix 3x3 Builder 8 bits module component library
-- Project    : Matrix 3x3 Builder
------------------------------------------------------------------------------
-- File       : matrix_3x3_builder_8b_comp.vhd
-- Author     : N. Roudel
-- Company    : Wisip
-- Created    : 2014-02-06
-- Last update: 2014-02-06
-- Platform   :
-- Standard   :
------------------------------------------------------------------------------
-- Description:
------------------------------------------------------------------------------
-- Copyright (c) 2013, 2014 - Wisp
------------------------------------------------------------------------------
-- Revisions  :
-- Date         Version  Author     Description
-- 2014-02-06   1.0      N. Roudel  File created
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;

library matrix_type_lib;
use matrix_type_lib.matrix_type_comp.all;

package matrix_3x3_builder_8b_comp is

	component matrix_3x3_builder_8b is
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
	end component;
	
end matrix_3x3_builder_8b_comp;