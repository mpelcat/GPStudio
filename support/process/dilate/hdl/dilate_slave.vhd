library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
library std;

entity dilate_slave is
	generic (
		CLK_PROC_FREQ : integer
	);
	port (
		clk_proc              : in std_logic;
		reset_n               : in std_logic;

		---------------- dynamic parameters ports ---------------
		status_reg_enable_bit : out std_logic;
		widthimg_reg_value    : out std_logic_vector(15 downto 0);
		di00_reg_m00          : out std_logic_vector(7 downto 0);
		di01_reg_m01          : out std_logic_vector(7 downto 0);
		di02_reg_m02          : out std_logic_vector(7 downto 0);
		di10_reg_m10          : out std_logic_vector(7 downto 0);
		di11_reg_m11          : out std_logic_vector(7 downto 0);
		di12_reg_m12          : out std_logic_vector(7 downto 0);
		di20_reg_m20          : out std_logic_vector(7 downto 0);
		di21_reg_m21          : out std_logic_vector(7 downto 0);
		di22_reg_m22          : out std_logic_vector(7 downto 0);

		--======================= Slaves ========================

		------------------------- bus_sl ------------------------
		addr_rel_i            : in std_logic_vector(3 downto 0);
		wr_i                  : in std_logic;
		rd_i                  : in std_logic;
		datawr_i              : in std_logic_vector(31 downto 0);
		datard_o              : out std_logic_vector(31 downto 0)
	);
end dilate_slave;

architecture rtl of dilate_slave is

	-- Registers address   
	constant STATUS_REG_REG_ADDR   : natural := 0;
	constant WIDTHIMG_REG_REG_ADDR : natural := 1;
	constant DI00_REG_REG_ADDR     : natural := 3;
	constant DI01_REG_REG_ADDR     : natural := 4;
	constant DI02_REG_REG_ADDR     : natural := 5;
	constant DI10_REG_REG_ADDR     : natural := 6;
	constant DI11_REG_REG_ADDR     : natural := 7;
	constant DI12_REG_REG_ADDR     : natural := 8;
	constant DI20_REG_REG_ADDR     : natural := 9;
	constant DI21_REG_REG_ADDR     : natural := 10;
	constant DI22_REG_REG_ADDR     : natural := 11;

	-- Internal registers      
	signal status_reg_enable_bit_reg : std_logic;
	signal widthimg_reg_value_reg    : std_logic_vector (15 downto 0);
	signal di00_reg_m00_reg          : std_logic_vector (7 downto 0);
	signal di01_reg_m01_reg          : std_logic_vector (7 downto 0);
	signal di02_reg_m02_reg          : std_logic_vector (7 downto 0);
	signal di10_reg_m10_reg          : std_logic_vector (7 downto 0);
	signal di11_reg_m11_reg          : std_logic_vector (7 downto 0);
	signal di12_reg_m12_reg          : std_logic_vector (7 downto 0);
	signal di20_reg_m20_reg          : std_logic_vector (7 downto 0);
	signal di21_reg_m21_reg          : std_logic_vector (7 downto 0);
	signal di22_reg_m22_reg          : std_logic_vector (7 downto 0);

begin
	write_reg : process (clk_proc, reset_n)
	begin
		if(reset_n='0') then
			status_reg_enable_bit_reg <= '0';
			widthimg_reg_value_reg <= "0000000000000000";
			di00_reg_m00_reg <= "00000000";
			di01_reg_m01_reg <= "00000000";
			di02_reg_m02_reg <= "00000000";
			di10_reg_m10_reg <= "00000000";
			di11_reg_m11_reg <= "00000000";
			di12_reg_m12_reg <= "00000000";
			di20_reg_m20_reg <= "00000000";
			di21_reg_m21_reg <= "00000000";
			di22_reg_m22_reg <= "00000000";
		elsif(rising_edge(clk_proc)) then
			if(wr_i='1') then
				case addr_rel_i is
					when std_logic_vector(to_unsigned(STATUS_REG_REG_ADDR, 4))=>
						status_reg_enable_bit_reg <= datawr_i(0);
					when std_logic_vector(to_unsigned(WIDTHIMG_REG_REG_ADDR, 4))=>
						widthimg_reg_value_reg <= datawr_i(15) & datawr_i(14) & datawr_i(13) & datawr_i(12) & datawr_i(11) & datawr_i(10) & datawr_i(9) & datawr_i(8) & datawr_i(7) & datawr_i(6) & datawr_i(5) & datawr_i(4) & datawr_i(3) & datawr_i(2) & datawr_i(1) & datawr_i(0);
					when std_logic_vector(to_unsigned(DI00_REG_REG_ADDR, 4))=>
						di00_reg_m00_reg <= datawr_i(7) & datawr_i(6) & datawr_i(5) & datawr_i(4) & datawr_i(3) & datawr_i(2) & datawr_i(1) & datawr_i(0);
					when std_logic_vector(to_unsigned(DI01_REG_REG_ADDR, 4))=>
						di01_reg_m01_reg <= datawr_i(7) & datawr_i(6) & datawr_i(5) & datawr_i(4) & datawr_i(3) & datawr_i(2) & datawr_i(1) & datawr_i(0);
					when std_logic_vector(to_unsigned(DI02_REG_REG_ADDR, 4))=>
						di02_reg_m02_reg <= datawr_i(7) & datawr_i(6) & datawr_i(5) & datawr_i(4) & datawr_i(3) & datawr_i(2) & datawr_i(1) & datawr_i(0);
					when std_logic_vector(to_unsigned(DI10_REG_REG_ADDR, 4))=>
						di10_reg_m10_reg <= datawr_i(7) & datawr_i(6) & datawr_i(5) & datawr_i(4) & datawr_i(3) & datawr_i(2) & datawr_i(1) & datawr_i(0);
					when std_logic_vector(to_unsigned(DI11_REG_REG_ADDR, 4))=>
						di11_reg_m11_reg <= datawr_i(7) & datawr_i(6) & datawr_i(5) & datawr_i(4) & datawr_i(3) & datawr_i(2) & datawr_i(1) & datawr_i(0);
					when std_logic_vector(to_unsigned(DI12_REG_REG_ADDR, 4))=>
						di12_reg_m12_reg <= datawr_i(7) & datawr_i(6) & datawr_i(5) & datawr_i(4) & datawr_i(3) & datawr_i(2) & datawr_i(1) & datawr_i(0);
					when std_logic_vector(to_unsigned(DI20_REG_REG_ADDR, 4))=>
						di20_reg_m20_reg <= datawr_i(7) & datawr_i(6) & datawr_i(5) & datawr_i(4) & datawr_i(3) & datawr_i(2) & datawr_i(1) & datawr_i(0);
					when std_logic_vector(to_unsigned(DI21_REG_REG_ADDR, 4))=>
						di21_reg_m21_reg <= datawr_i(7) & datawr_i(6) & datawr_i(5) & datawr_i(4) & datawr_i(3) & datawr_i(2) & datawr_i(1) & datawr_i(0);
					when std_logic_vector(to_unsigned(DI22_REG_REG_ADDR, 4))=>
						di22_reg_m22_reg <= datawr_i(7) & datawr_i(6) & datawr_i(5) & datawr_i(4) & datawr_i(3) & datawr_i(2) & datawr_i(1) & datawr_i(0);
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
					when std_logic_vector(to_unsigned(STATUS_REG_REG_ADDR, 4))=>
						datard_o <= "0000000000000000000000000000000" & status_reg_enable_bit_reg;
					when std_logic_vector(to_unsigned(WIDTHIMG_REG_REG_ADDR, 4))=>
						datard_o <= "0000000000000000" & widthimg_reg_value_reg(15) & widthimg_reg_value_reg(14) & widthimg_reg_value_reg(13) & widthimg_reg_value_reg(12) & widthimg_reg_value_reg(11) & widthimg_reg_value_reg(10) & widthimg_reg_value_reg(9) & widthimg_reg_value_reg(8) & widthimg_reg_value_reg(7) & widthimg_reg_value_reg(6) & widthimg_reg_value_reg(5) & widthimg_reg_value_reg(4) & widthimg_reg_value_reg(3) & widthimg_reg_value_reg(2) & widthimg_reg_value_reg(1) & widthimg_reg_value_reg(0);
					when std_logic_vector(to_unsigned(DI00_REG_REG_ADDR, 4))=>
						datard_o <= "000000000000000000000000" & di00_reg_m00_reg(7) & di00_reg_m00_reg(6) & di00_reg_m00_reg(5) & di00_reg_m00_reg(4) & di00_reg_m00_reg(3) & di00_reg_m00_reg(2) & di00_reg_m00_reg(1) & di00_reg_m00_reg(0);
					when std_logic_vector(to_unsigned(DI01_REG_REG_ADDR, 4))=>
						datard_o <= "000000000000000000000000" & di01_reg_m01_reg(7) & di01_reg_m01_reg(6) & di01_reg_m01_reg(5) & di01_reg_m01_reg(4) & di01_reg_m01_reg(3) & di01_reg_m01_reg(2) & di01_reg_m01_reg(1) & di01_reg_m01_reg(0);
					when std_logic_vector(to_unsigned(DI02_REG_REG_ADDR, 4))=>
						datard_o <= "000000000000000000000000" & di02_reg_m02_reg(7) & di02_reg_m02_reg(6) & di02_reg_m02_reg(5) & di02_reg_m02_reg(4) & di02_reg_m02_reg(3) & di02_reg_m02_reg(2) & di02_reg_m02_reg(1) & di02_reg_m02_reg(0);
					when std_logic_vector(to_unsigned(DI10_REG_REG_ADDR, 4))=>
						datard_o <= "000000000000000000000000" & di10_reg_m10_reg(7) & di10_reg_m10_reg(6) & di10_reg_m10_reg(5) & di10_reg_m10_reg(4) & di10_reg_m10_reg(3) & di10_reg_m10_reg(2) & di10_reg_m10_reg(1) & di10_reg_m10_reg(0);
					when std_logic_vector(to_unsigned(DI11_REG_REG_ADDR, 4))=>
						datard_o <= "000000000000000000000000" & di11_reg_m11_reg(7) & di11_reg_m11_reg(6) & di11_reg_m11_reg(5) & di11_reg_m11_reg(4) & di11_reg_m11_reg(3) & di11_reg_m11_reg(2) & di11_reg_m11_reg(1) & di11_reg_m11_reg(0);
					when std_logic_vector(to_unsigned(DI12_REG_REG_ADDR, 4))=>
						datard_o <= "000000000000000000000000" & di12_reg_m12_reg(7) & di12_reg_m12_reg(6) & di12_reg_m12_reg(5) & di12_reg_m12_reg(4) & di12_reg_m12_reg(3) & di12_reg_m12_reg(2) & di12_reg_m12_reg(1) & di12_reg_m12_reg(0);
					when std_logic_vector(to_unsigned(DI20_REG_REG_ADDR, 4))=>
						datard_o <= "000000000000000000000000" & di20_reg_m20_reg(7) & di20_reg_m20_reg(6) & di20_reg_m20_reg(5) & di20_reg_m20_reg(4) & di20_reg_m20_reg(3) & di20_reg_m20_reg(2) & di20_reg_m20_reg(1) & di20_reg_m20_reg(0);
					when std_logic_vector(to_unsigned(DI21_REG_REG_ADDR, 4))=>
						datard_o <= "000000000000000000000000" & di21_reg_m21_reg(7) & di21_reg_m21_reg(6) & di21_reg_m21_reg(5) & di21_reg_m21_reg(4) & di21_reg_m21_reg(3) & di21_reg_m21_reg(2) & di21_reg_m21_reg(1) & di21_reg_m21_reg(0);
					when std_logic_vector(to_unsigned(DI22_REG_REG_ADDR, 4))=>
						datard_o <= "000000000000000000000000" & di22_reg_m22_reg(7) & di22_reg_m22_reg(6) & di22_reg_m22_reg(5) & di22_reg_m22_reg(4) & di22_reg_m22_reg(3) & di22_reg_m22_reg(2) & di22_reg_m22_reg(1) & di22_reg_m22_reg(0);
					when others=>
						datard_o <= (others => '0');
				end case;
			end if;
		end if;
	end process;

	status_reg_enable_bit <= status_reg_enable_bit_reg;
	widthimg_reg_value <= widthimg_reg_value_reg;
	di00_reg_m00 <= di00_reg_m00_reg;
	di01_reg_m01 <= di01_reg_m01_reg;
	di02_reg_m02 <= di02_reg_m02_reg;
	di10_reg_m10 <= di10_reg_m10_reg;
	di11_reg_m11 <= di11_reg_m11_reg;
	di12_reg_m12 <= di12_reg_m12_reg;
	di20_reg_m20 <= di20_reg_m20_reg;
	di21_reg_m21 <= di21_reg_m21_reg;
	di22_reg_m22 <= di22_reg_m22_reg;

end rtl;
