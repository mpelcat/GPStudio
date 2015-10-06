library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
library std;

entity lbp_slave is
	port (
		clk_proc		: in std_logic;
		reset_n			: in std_logic;
		
		------------------------- bus_sl ------------------------
		addr_rel_i		: in std_logic_vector(1 downto 0);
		wr_i			: in std_logic;
		rd_i			: in std_logic;
		datawr_i		: in std_logic_vector(31 downto 0);
		datard_o		: out std_logic_vector(31 downto 0);
		
		-- connections to lbp module
		enable_o		: out std_logic;
		widthimg_o		: out std_logic_vector(15 downto 0);
		theshold_o		: out std_logic_vector(7 downto 0)
	);
end lbp_slave;

architecture rtl of lbp_slave is
	constant ENABLE_REG_ADDR		: natural := 0;
	constant WIDTHIMG_REG_ADDR	: natural := 1;
	constant THRESHOLD_REG_ADDR	: natural := 2;

	signal enable_reg :		std_logic;
	signal widthimg_reg :	std_logic_vector(15 downto 0);
	signal theshold_reg :	std_logic_vector(7 downto 0);

begin

	write_reg : process (clk_proc, reset_n)
	begin
		if(reset_n='0') then
			enable_reg <= '0';
			widthimg_reg <= std_logic_vector(to_unsigned(320, 16));
			theshold_reg <= std_logic_vector(to_unsigned(0, 8));
			
		elsif(rising_edge(clk_proc)) then
			if(wr_i='1') then
				case addr_rel_i is
					when std_logic_vector(to_unsigned(ENABLE_REG_ADDR, 2))=>
						enable_reg <= datawr_i(0);
					when std_logic_vector(to_unsigned(WIDTHIMG_REG_ADDR, 2))=>
						widthimg_reg <= datawr_i(15 downto 0);
					when std_logic_vector(to_unsigned(THRESHOLD_REG_ADDR, 2))=>
						theshold_reg <= datawr_i(7 downto 0);
					when others=>
				end case;
			end if;
		end if;
	end process;
	
	enable_o <= enable_reg;
	widthimg_o <= widthimg_reg;
	theshold_o <= theshold_reg;
	
end rtl;
