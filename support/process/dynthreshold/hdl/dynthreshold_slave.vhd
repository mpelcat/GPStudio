library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
library std;

entity dynthreshold_slave is
	generic (
		CLK_PROC_FREQ : integer
	);
	port (
		clk_proc                 : in std_logic;
		reset_n                  : in std_logic;

		---------------- dynamic parameters ports ---------------
		status_reg_enable_bit    : out std_logic;
		desired_ratio_reg        : out std_logic_vector(31 downto 0);
		border_research_type_reg : out std_logic_vector(31 downto 0);

		--======================= Slaves ========================

		------------------------- bus_sl ------------------------
		addr_rel_i               : in std_logic_vector(1 downto 0);
		wr_i                     : in std_logic;
		rd_i                     : in std_logic;
		datawr_i                 : in std_logic_vector(31 downto 0);
		datard_o                 : out std_logic_vector(31 downto 0)
	);
end dynthreshold_slave;

architecture rtl of dynthreshold_slave is

	-- Registers address               
	constant STATUS_REG_REG_ADDR               : natural := 0;
	constant DESIRED_RATIO_REG_REG_ADDR        : natural := 1;
	constant BORDER_RESEARCH_TYPE_REG_REG_ADDR : natural := 2;

	-- Internal registers         
	signal status_reg_enable_bit_reg    : std_logic;
	signal desired_ratio_reg_reg        : std_logic_vector (31 downto 0);
	signal border_research_type_reg_reg : std_logic_vector (31 downto 0);

begin
	write_reg : process (clk_proc, reset_n)
	begin
		if(reset_n='0') then
			status_reg_enable_bit_reg <= '0';
			desired_ratio_reg_reg <= x"00000000";
			border_research_type_reg_reg <= x"00000000";
		elsif(rising_edge(clk_proc)) then
			if(wr_i='1') then
				case addr_rel_i is
					when std_logic_vector(to_unsigned(STATUS_REG_REG_ADDR, 2))=>
						status_reg_enable_bit_reg <= datawr_i(0);
					when std_logic_vector(to_unsigned(DESIRED_RATIO_REG_REG_ADDR, 2))=>
						desired_ratio_reg_reg <= datawr_i;
					when std_logic_vector(to_unsigned(BORDER_RESEARCH_TYPE_REG_REG_ADDR, 2))=>
						border_research_type_reg_reg <= datawr_i;
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
					when std_logic_vector(to_unsigned(STATUS_REG_REG_ADDR, 2))=>
						datard_o <= "0000000000000000000000000000000" & status_reg_enable_bit_reg;
					when std_logic_vector(to_unsigned(DESIRED_RATIO_REG_REG_ADDR, 2))=>
						datard_o <= desired_ratio_reg_reg;
					when std_logic_vector(to_unsigned(BORDER_RESEARCH_TYPE_REG_REG_ADDR, 2))=>
						datard_o <= border_research_type_reg_reg;
					when others=>
						datard_o <= (others => '0');
				end case;
			end if;
		end if;
	end process;

	status_reg_enable_bit <= status_reg_enable_bit_reg;
	desired_ratio_reg <= desired_ratio_reg_reg;
	border_research_type_reg <= border_research_type_reg_reg;

end rtl;
