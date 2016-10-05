library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
library std;

entity threshold_slave is
	generic (
		CLK_PROC_FREQ : integer
	);
	port (
		clk_proc      : in std_logic;
		reset_n       : in std_logic;

		---------------- dynamic parameters ports ---------------
		threshold_reg : out std_logic_vector(31 downto 0);

		--======================= Slaves ========================

		------------------------- bus_sl ------------------------
		addr_rel_i    : in std_logic_vector(1 downto 0);
		wr_i          : in std_logic;
		rd_i          : in std_logic;
		datawr_i      : in std_logic_vector(31 downto 0);
		datard_o      : out std_logic_vector(31 downto 0)
	);
end threshold_slave;

architecture rtl of threshold_slave is

	-- Registers address    
	constant THRESHOLD_REG_REG_ADDR : natural := 0;

	-- Internal registers
	signal threshold_reg_reg : std_logic_vector (31 downto 0);

begin
	write_reg : process (clk_proc, reset_n)
	begin
		if(reset_n='0') then
			threshold_reg_reg <= x"00000000";
		elsif(rising_edge(clk_proc)) then
			if(wr_i='1') then
				case addr_rel_i is
					when std_logic_vector(to_unsigned(THRESHOLD_REG_REG_ADDR, 2))=>
						threshold_reg_reg <= datawr_i;
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
					when std_logic_vector(to_unsigned(THRESHOLD_REG_REG_ADDR, 2))=>
						datard_o <= threshold_reg_reg;
					when others=>
						datard_o <= (others => '0');
				end case;
			end if;
		end if;
	end process;

	threshold_reg <= threshold_reg_reg;

end rtl;
