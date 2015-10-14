------------------------------------------------------------------------------
-- Title      : Harris ABC To R module component library
-- Project    : Harris ABC To R
------------------------------------------------------------------------------
-- File       : harris_abc_to_r_comp.vhd
-- Author     : N. Roudel
-- Company    : Wisip
-- Created    : 2014-02-21
-- Last update: 2014-02-21
-- Platform   :
-- Standard   :
------------------------------------------------------------------------------
-- Description:
------------------------------------------------------------------------------
-- Copyright (c) 2013, 2014 - Wisp
------------------------------------------------------------------------------
-- Revisions  :
-- Date         Version  Author     Description
-- 2014-02-21   1.0      N. Roudel  File created
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;

package harris_abc_to_r_comp is


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
end harris_abc_to_r_comp;