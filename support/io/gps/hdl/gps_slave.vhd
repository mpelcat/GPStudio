library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
library std;

entity gps_slave is
	generic (
		CLK_PROC_FREQ : integer
	);
	port (
		clk_proc   : in std_logic;
		reset_n    : in std_logic;

		---------------- dynamic parameters ports ---------------
		enable_reg : out std_logic_vector(31 downto 0);
		acqui_reg  : out std_logic_vector(31 downto 0);
		sat_reg    : out std_logic_vector(31 downto 0);
		update_reg : out std_logic_vector(31 downto 0);

		--======================= Slaves ========================

		------------------------- bus_sl ------------------------
		addr_rel_i : in std_logic_vector(7 downto 0);
		wr_i       : in std_logic;
		rd_i       : in std_logic;
		datawr_i   : in std_logic_vector(31 downto 0);
		datard_o   : out std_logic_vector(31 downto 0)
	);
end gps_slave;

architecture rtl of gps_slave is

	-- Registers address 
	constant ENABLE_REG_REG_ADDR : natural := 0;
	constant ACQUI_REG_REG_ADDR  : natural := 1;
	constant SAT_REG_REG_ADDR    : natural := 2;
	constant UPDATE_REG_REG_ADDR : natural := 3;

	-- Internal registers
	signal enable_reg_reg : std_logic_vector (31 downto 0);
	signal acqui_reg_reg  : std_logic_vector (31 downto 0);
	signal sat_reg_reg    : std_logic_vector (31 downto 0);
	signal update_reg_reg : std_logic_vector (31 downto 0);

begin
	write_reg : process (clk_proc, reset_n)
	begin
		if(reset_n='0') then
			enable_reg_reg <= x"00000000";
			acqui_reg_reg <= x"00000000";
			sat_reg_reg <= x"00000000";
			update_reg_reg <= x"00000000";
		elsif(rising_edge(clk_proc)) then
			if(wr_i='1') then
				case addr_rel_i is
					when std_logic_vector(to_unsigned(ENABLE_REG_REG_ADDR, 8))=>
						enable_reg_reg <= datawr_i;
					when std_logic_vector(to_unsigned(ACQUI_REG_REG_ADDR, 8))=>
						acqui_reg_reg <= datawr_i;
					when std_logic_vector(to_unsigned(SAT_REG_REG_ADDR, 8))=>
						sat_reg_reg <= datawr_i;
					when std_logic_vector(to_unsigned(UPDATE_REG_REG_ADDR, 8))=>
						update_reg_reg <= datawr_i;
					when others=>
				end case;
			end if;
		end if;
	end process;

	read_reg : process (clk_proc, reset_n)
	begin
		if(reset_n='0') then
			datard_o <= (others => '0');
		elsif(rising_edge(clk_proc)) then
			if(rd_i='1') then
				case addr_rel_i is
					when std_logic_vector(to_unsigned(ENABLE_REG_REG_ADDR, 8))=>
						datard_o <= enable_reg_reg;
					when std_logic_vector(to_unsigned(ACQUI_REG_REG_ADDR, 8))=>
						datard_o <= acqui_reg_reg;
					when std_logic_vector(to_unsigned(SAT_REG_REG_ADDR, 8))=>
						datard_o <= sat_reg_reg;
					when std_logic_vector(to_unsigned(UPDATE_REG_REG_ADDR, 8))=>
						datard_o <= update_reg_reg;
					when others=>
						datard_o <= (others => '0');
				end case;
			end if;
		end if;
	end process;

	enable_reg <= enable_reg_reg;
	acqui_reg <= acqui_reg_reg;
	sat_reg <= sat_reg_reg;
	update_reg <= update_reg_reg;

end rtl;
