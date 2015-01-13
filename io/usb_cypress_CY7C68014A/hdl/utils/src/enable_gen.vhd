-- **************************************************************************
--	Enable_gen 
-- **************************************************************************
-- 03/12/2014
--------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

-- entity "uses" the package   
-- use work.ComFlow_pkg.all;

entity enable_gen is
  generic (
	DATA_WIDTH : integer := 32;
	N_WORDS : integer := 1024
    );
  port(
	clk_i : in std_logic;
	rst_n_i : in std_logic;
				
	addr_i : in std_logic_vector(integer(ceil(log2(real(N_WORDS))))-1 DOWNTO 0);		--(addr_rel_0_o),
	--addr_i : in std_logic_vector(3 DOWNTO 0);		--(addr_rel_0_o),
	wr_i : in std_logic;			--(wr_0_o),
	datawr_i : in std_logic_vector(DATA_WIDTH-1 downto 0);

	en_o : out std_logic;
	flow_out_sel_o: out std_logic;
	source_sel_o : out std_logic
    );
end enable_gen;

architecture rtl of enable_gen is

signal enable_reg : std_logic_vector(DATA_WIDTH-1 downto 0) := (others=>'0');
 

begin

REG:process (clk_i, rst_n_i) 
begin
	if (rst_n_i = '0') then	
		enable_reg <= (others=>'0');
		
	elsif rising_edge(clk_i) then
		if(wr_i = '1') then
			case addr_i is
				when (others=>'0') =>		
					enable_reg <= datawr_i;
				when others =>
					enable_reg <= enable_reg;
			end case;
		else
			enable_reg <= enable_reg;
		end if;	
	end if;
end process;
	
en_o <= enable_reg(0);	
flow_out_sel_o <= enable_reg(1);
source_sel_o <= enable_reg(2);

end rtl;

