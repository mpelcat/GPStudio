library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use ieee.math_real.all;
library std;
library altera_mf;
use altera_mf.altera_mf_components.all;
use work.harris_package.all;

entity sup_block is
	generic (
		COMP_WIDTH : integer;
	);
	port (
		oper_a      : in std_logic_vector((COMP_WIDTH -1) downto 0);;
		oper_b      : in std_logic_vector((COMP_WIDTH -1) downto 0);;
		result      : out std_logic_vector((COMP_WIDTH -1) downto 0);

	);

end sup_block;



architecture rtl of  sup_block is


begin

end architecture

