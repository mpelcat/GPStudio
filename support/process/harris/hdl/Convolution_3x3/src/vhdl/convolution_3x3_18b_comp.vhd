------------------------------------------------------------------------------
-- Title      : Convolution 3x3 18 bits module component library
-- Project    : Convolution 3x3
------------------------------------------------------------------------------
-- File       : convolution_3x3_18b_comp.vhd
-- Author     : N. Roudel
-- Company    : Wisip
-- Created    : 2014-02-07
-- Last update: 2014-02-07
-- Platform   :
-- Standard   :
------------------------------------------------------------------------------
-- Description:
------------------------------------------------------------------------------
-- Copyright (c) 2013, 2014 - Wisp
------------------------------------------------------------------------------
-- Revisions  :
-- Date         Version  Author     Description
-- 2014-02-07   1.0      N. Roudel  File created
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;

library matrix_type_lib;
use matrix_type_lib.matrix_type_comp.all;

package convolution_3x3_18b_comp is

	component convolution_3x3_18b is
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
	end component;
	

	component altera_add9_26b
		PORT
		(
			clock		: IN STD_LOGIC  := '0';
			data0x		: IN STD_LOGIC_VECTOR (25 DOWNTO 0);
			data1x		: IN STD_LOGIC_VECTOR (25 DOWNTO 0);
			data2x		: IN STD_LOGIC_VECTOR (25 DOWNTO 0);
			data3x		: IN STD_LOGIC_VECTOR (25 DOWNTO 0);
			data4x		: IN STD_LOGIC_VECTOR (25 DOWNTO 0);
			data5x		: IN STD_LOGIC_VECTOR (25 DOWNTO 0);
			data6x		: IN STD_LOGIC_VECTOR (25 DOWNTO 0);
			data7x		: IN STD_LOGIC_VECTOR (25 DOWNTO 0);
			data8x		: IN STD_LOGIC_VECTOR (25 DOWNTO 0);
			result		: OUT STD_LOGIC_VECTOR (29 DOWNTO 0)
		);
	end component;
	
end convolution_3x3_18b_comp;