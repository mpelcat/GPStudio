library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
library std;

entity mt9_config_slave is
	port (
		clk_proc		: in std_logic;
		reset_n			: in std_logic;
		
		------------------------- bus_sl ------------------------
		addr_rel_i		: in std_logic_vector(2 downto 0);
		wr_i			: in std_logic;
		rd_i			: in std_logic;
		datawr_i		: in std_logic_vector(31 downto 0);
		datard_o		: out std_logic_vector(31 downto 0);
		
		-- connections to video sampler
		enable_o		: out std_logic;
		flowlength_o	: out std_logic_vector(31 downto 0);
		
		-- connections to mt9_config_i2c
		xstart_o		: out std_logic_vector(31 downto 0);
		ystart_o		: out std_logic_vector(31 downto 0);
		xend_o			: out std_logic_vector(31 downto 0);
		yend_o			: out std_logic_vector(31 downto 0);
		autoexp_o		: out std_logic_vector(31 downto 0);
		integtime_o		: out std_logic_vector(31 downto 0);
		need_to_reconf_o : out std_logic
	);
end mt9_config_slave;

architecture rtl of mt9_config_slave is
	constant ENABLE_REG_ADDR	: natural := 0;
	constant FLOWLENGHT_REG_ADDR : natural := 1;
	constant XSTART_REG_ADDR	: natural := 2;
	constant YSTART_REG_ADDR	: natural := 3;
	constant XEND_REG_ADDR		: natural := 4;
	constant YEND_REG_ADDR		: natural := 5;
	constant AUTOEXP_REG_ADDR	: natural := 6;
	constant INTEGTIME_REG_ADDR	: natural := 7;

	signal enable_reg : std_logic;
	signal flowlength_reg : std_logic_vector(31 downto 0);
	
	signal xstart_reg	: std_logic_vector(31 downto 0);
	signal ystart_reg	: std_logic_vector(31 downto 0);
	signal xend_reg		: std_logic_vector(31 downto 0);
	signal yend_reg		: std_logic_vector(31 downto 0);
	signal autoexp_reg	: std_logic_vector(31 downto 0);
	signal integtime_reg: std_logic_vector(31 downto 0);

begin

	write_reg : process (clk_proc, reset_n)
	begin
		if(reset_n='0') then
			enable_reg <= '0';
			flowlength_reg <= std_logic_vector(to_unsigned(100*100, 32));
			
			xstart_reg <= std_logic_vector(to_unsigned(0, 32));
			ystart_reg <= std_logic_vector(to_unsigned(0, 32));
			xend_reg <= std_logic_vector(to_unsigned(320, 32));
			yend_reg <= std_logic_vector(to_unsigned(240, 32));
			autoexp_reg <= std_logic_vector(to_unsigned(0, 32));
			integtime_reg <= x"000000E6";
			need_to_reconf_o <= '1';
		elsif(rising_edge(clk_proc)) then
			need_to_reconf_o <= '0';
			if(wr_i='1') then
				case addr_rel_i is
					when std_logic_vector(to_unsigned(ENABLE_REG_ADDR, 3))=>
						enable_reg <= datawr_i(0);
					when std_logic_vector(to_unsigned(FLOWLENGHT_REG_ADDR, 3))=>
						flowlength_reg <= datawr_i;
						
					when std_logic_vector(to_unsigned(XSTART_REG_ADDR, 3))=>
						xstart_reg <= datawr_i;
						need_to_reconf_o <= '1';
					when std_logic_vector(to_unsigned(YSTART_REG_ADDR, 3))=>
						ystart_reg <= datawr_i;
						need_to_reconf_o <= '1';
					when std_logic_vector(to_unsigned(XEND_REG_ADDR, 3))=>
						xend_reg <= datawr_i;
						need_to_reconf_o <= '1';
					when std_logic_vector(to_unsigned(YEND_REG_ADDR, 3))=>
						yend_reg <= datawr_i;
						need_to_reconf_o <= '1';
					when std_logic_vector(to_unsigned(AUTOEXP_REG_ADDR, 3))=>
						autoexp_reg <= datawr_i;
						need_to_reconf_o <= '1';
					when std_logic_vector(to_unsigned(INTEGTIME_REG_ADDR, 3))=>
						integtime_reg <= datawr_i;
						need_to_reconf_o <= '1';
					when others=>
				end case;
			end if;
		end if;
	end process;
	
	enable_o <= enable_reg;
	flowlength_o <= flowlength_reg;
	xstart_o <= xstart_reg;
	ystart_o <= ystart_reg;
	xend_o <= xend_reg;
	yend_o <= yend_reg;
	autoexp_o <= autoexp_reg;
	integtime_o <= integtime_reg;
	
end rtl;
