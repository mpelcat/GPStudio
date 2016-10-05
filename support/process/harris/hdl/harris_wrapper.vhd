library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use ieee.math_real.all;
library std;
library altera_mf;
use altera_mf.altera_mf_components.all;
use work.harris_package_components.all;

entity harris_wrapper is

		generic (
			LINE_WIDTH_MAX 	: integer;
			PIX_WIDTH 	: integer
		);
		
		port(
			clk_proc 		: in std_logic;
			reset_n 		: in std_logic;
	
			in_data 		: in std_logic_vector((PIX_WIDTH-1) downto 0);
			in_fv 			: in std_logic;
			in_dv 			: in std_logic;
		
			out_data		: out	std_logic_vector (PIX_WIDTH-1 downto 0);
			out_fv			: out	std_logic;
			out_dv			: out	std_logic;

			enable_i 		: in std_logic;
			widthimg_i 		: in std_logic_vector(15 downto 0)
			);
end harris_wrapper;


architecture arch of harris_wrapper is


begin



end arch;
