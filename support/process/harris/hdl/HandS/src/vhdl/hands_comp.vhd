------------------------------------------------------------------------------
-- Title      : Harris ABC module component library
-- Project    : Harris ABC
------------------------------------------------------------------------------
-- File       : harris_abc_comp.vhd
-- Author     : N. Roudel
-- Company    : Wisip
-- Created    : 2014-02-10
-- Last update: 2014-02-10
-- Platform   :
-- Standard   :
------------------------------------------------------------------------------
-- Description:
------------------------------------------------------------------------------
-- Copyright (c) 2013, 2014 - Wisp
------------------------------------------------------------------------------
-- Revisions  :
-- Date         Version  Author     Description
-- 2014-02-10   1.0      N. Roudel  File created
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;

library matrix_type_lib;
use matrix_type_lib.matrix_type_comp.all;

library hands_lib;
use hands_lib.matrix_3x3_builder_8b_comp.all;
use hands_lib.matrix_3x3_builder_18b_comp.all;
use hands_lib.gradient_3x3_comp.all;
use hands_lib.convolution_3x3_18b_comp.all;
use hands_lib.harris_abc_to_r_comp.all;


package hands_comp is


	component hands is
		generic (
			IM_WIDTH		:   positive:=64;
			IM_HEIGHT		:	positive:=64;
			HARRIS_TRSHLD	:	positive := 3000
			
		);	
		port ( 
			rst_i  			: in  std_logic;
			clk_i  			: in  std_logic;			
			frame_valid_i	: in  std_logic;
			data_valid_i	: in  std_logic;
			data_i			: in  std_logic_vector(7 downto 0);
			
			frame_valid_o	: out std_logic;
			data_valid_o	: out std_logic;

			R_o				: out std_logic_vector(61 downto 0);
			R_detect_o		: out std_logic;
			X_o				: out std_logic_vector(15 downto 0);
			Y_o				: out std_logic_vector(15 downto 0)
			
		);
	end component;
	
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
		
	
	component matrix_3x3_builder_18b is
		generic (
			IM_WIDTH	: 	positive
		);	
		port ( 
			rst_i  			: 	in  std_logic;
			clk_i  			: 	in  std_logic;			
			frame_valid_i	:	in	std_logic;			
			data_valid_i	:	in	std_logic;			
			data_i 			: 	in  std_logic_vector(17 downto 0);
			
			frame_valid_o	:	out	std_logic;
			data_valid_o	:	out	std_logic;
			data_o			:	out matrix_3x3_18b_t		
		);
	end component;
	

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
			data_o			: out std_logic_vector(29 downto 0) := (others => '0')
		);
	end component;
	
	component harris_abc_to_r is
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
	end component;
	
end hands_comp;