library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
library std;

entity dynthreshold_slave is
	generic (
		CLK_PROC_FREQ : integer
	);
	port (
		clk_proc              : in std_logic;
		reset_n               : in std_logic;

		---------------- dynamic parameters ports ---------------
		status_reg_enable_bit : out std_logic;
		widthimg_reg_value    : out std_logic_vector(15 downto 0);
		heigtimg_reg_value    : out std_logic_vector(15 downto 0);
		desired_ratio_reg     : out std_logic_vector(31 downto 0);

		--======================= Slaves ========================

		------------------------- bus_sl ------------------------
		addr_rel_i            : in std_logic_vector(2 downto 0);
		wr_i                  : in std_logic;
		rd_i                  : in std_logic;
		datawr_i              : in std_logic_vector(31 downto 0);
		datard_o              : out std_logic_vector(31 downto 0)
	);
end dynthreshold_slave;

architecture rtl of dynthreshold_slave is

	-- Registers address        
	constant STATUS_REG_REG_ADDR        : natural := 0;
	constant WIDTHIMG_REG_REG_ADDR      : natural := 1;
	constant HEIGTIMG_REG_REG_ADDR      : natural := 2;
	constant DESIRED_RATIO_REG_REG_ADDR : natural := 3;

	-- Internal registers      
	signal status_reg_enable_bit_reg : std_logic;
	signal widthimg_reg_value_reg    : std_logic_vector (15 downto 0);
	signal heigtimg_reg_value_reg    : std_logic_vector (15 downto 0);
	signal desired_ratio_reg_reg     : std_logic_vector (31 downto 0);

begin
	write_reg : process (clk_proc, reset_n)
	begin
		if(reset_n='0') then
			status_reg_enable_bit_reg <= '0';
			widthimg_reg_value_reg <= "0000000000000000";
			heigtimg_reg_value_reg <= "0000000000000000";
			desired_ratio_reg_reg <= x"00000000";
		elsif(rising_edge(clk_proc)) then
			if(wr_i='1') then
				case addr_rel_i is
					when std_logic_vector(to_unsigned(STATUS_REG_REG_ADDR, 3))=>
						status_reg_enable_bit_reg <= datawr_i(0);
					when std_logic_vector(to_unsigned(WIDTHIMG_REG_REG_ADDR, 3))=>
						widthimg_reg_value_reg <= datawr_i(15) & datawr_i(14) & datawr_i(13) & datawr_i(12) & datawr_i(11) & datawr_i(10) & datawr_i(9) & datawr_i(8) & datawr_i(7) & datawr_i(6) & datawr_i(5) & datawr_i(4) & datawr_i(3) & datawr_i(2) & datawr_i(1) & datawr_i(0);
					when std_logic_vector(to_unsigned(HEIGTIMG_REG_REG_ADDR, 3))=>
						heigtimg_reg_value_reg <= datawr_i(15) & datawr_i(14) & datawr_i(13) & datawr_i(12) & datawr_i(11) & datawr_i(10) & datawr_i(9) & datawr_i(8) & datawr_i(7) & datawr_i(6) & datawr_i(5) & datawr_i(4) & datawr_i(3) & datawr_i(2) & datawr_i(1) & datawr_i(0);
					when std_logic_vector(to_unsigned(DESIRED_RATIO_REG_REG_ADDR, 3))=>
						desired_ratio_reg_reg <= datawr_i;
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
					when std_logic_vector(to_unsigned(STATUS_REG_REG_ADDR, 3))=>
						datard_o <= "0000000000000000000000000000000" & status_reg_enable_bit_reg;
					when std_logic_vector(to_unsigned(WIDTHIMG_REG_REG_ADDR, 3))=>
						datard_o <= "0000000000000000" & widthimg_reg_value_reg(15) & widthimg_reg_value_reg(14) & widthimg_reg_value_reg(13) & widthimg_reg_value_reg(12) & widthimg_reg_value_reg(11) & widthimg_reg_value_reg(10) & widthimg_reg_value_reg(9) & widthimg_reg_value_reg(8) & widthimg_reg_value_reg(7) & widthimg_reg_value_reg(6) & widthimg_reg_value_reg(5) & widthimg_reg_value_reg(4) & widthimg_reg_value_reg(3) & widthimg_reg_value_reg(2) & widthimg_reg_value_reg(1) & widthimg_reg_value_reg(0);
					when std_logic_vector(to_unsigned(HEIGTIMG_REG_REG_ADDR, 3))=>
						datard_o <= "0000000000000000" & heigtimg_reg_value_reg(15) & heigtimg_reg_value_reg(14) & heigtimg_reg_value_reg(13) & heigtimg_reg_value_reg(12) & heigtimg_reg_value_reg(11) & heigtimg_reg_value_reg(10) & heigtimg_reg_value_reg(9) & heigtimg_reg_value_reg(8) & heigtimg_reg_value_reg(7) & heigtimg_reg_value_reg(6) & heigtimg_reg_value_reg(5) & heigtimg_reg_value_reg(4) & heigtimg_reg_value_reg(3) & heigtimg_reg_value_reg(2) & heigtimg_reg_value_reg(1) & heigtimg_reg_value_reg(0);
					when std_logic_vector(to_unsigned(DESIRED_RATIO_REG_REG_ADDR, 3))=>
						datard_o <= desired_ratio_reg_reg;
					when others=>
						datard_o <= (others => '0');
				end case;
			end if;
		end if;
	end process;

	status_reg_enable_bit <= status_reg_enable_bit_reg;
	widthimg_reg_value <= widthimg_reg_value_reg;
	heigtimg_reg_value <= heigtimg_reg_value_reg;
	desired_ratio_reg <= desired_ratio_reg_reg;

end rtl;
