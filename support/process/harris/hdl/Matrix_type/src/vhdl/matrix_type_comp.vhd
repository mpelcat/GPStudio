------------------------------------------------------------------------------
-- Title      : Matrix Type 5x5 module component library
-- Project    : Matrix Type 5x5
------------------------------------------------------------------------------
-- File       : matrix_type_5x5_comp.vhd
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

package matrix_type_comp is

type matrix_3x3_8b_t is array (1 to 3*3) of std_logic_vector(7 downto 0);
type matrix_3x3_18b_t is array (1 to 3*3) of std_logic_vector(17 downto 0);
	
end matrix_type_comp;