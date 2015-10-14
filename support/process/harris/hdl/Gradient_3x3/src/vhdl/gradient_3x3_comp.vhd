------------------------------------------------------------------------------
-- Title      : Gradient 3x3 8 bits module component library
-- Project    : Gradient 3x3 8 bits
------------------------------------------------------------------------------
-- File       : gradient_3x3_comp.vhd
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

package gradient_3x3_comp is

	component gradient_3x3 is
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
	end component;
	
end gradient_3x3_comp;