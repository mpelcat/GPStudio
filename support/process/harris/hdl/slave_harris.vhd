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

entity  slave_harris is 
  generic (
	DATA_WIDTH : integer := 32
    );
  port(
	clk_i : in std_logic;
	rst_n_i : in std_logic;
				
	addr_i : in std_logic_vector(3 DOWNTO 0);		
	wr_i : in std_logic;
	datawr_i : in std_logic_vector(DATA_WIDTH-1 downto 0);

	harris_threshold_o : out std_logic_vector(31 downto 0)
		
    );
end slave_harris;

architecture rtl of  slave_harris is

constant HARRIS_THRESHOLD_ADDR : integer := 0;

begin

REG:process (clk_i, rst_n_i) 
begin
	if (rst_n_i = '0') then	
		harris_threshold_o <= (others=>'0');
	elsif rising_edge(clk_i) then
		if(wr_i = '1') then
			case addr_i is
				when std_logic_vector(to_unsigned(HARRIS_THRESHOLD_ADDR,4)) =>		
					harris_threshold_o <= datawr_i;
				when others =>
			end case;
		end if;	
	end if;
end process;

end rtl;

