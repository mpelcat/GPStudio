library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
library std;

entity conv_slave is
	generic (
		CLK_PROC_FREQ : integer
	);
	port (
		clk_proc              : in std_logic;
		reset_n               : in std_logic;

		---------------- dynamic parameters ports ---------------
		status_reg_enable_bit : out std_logic;
		widthimg_reg_width    : out std_logic_vector(15 downto 0);
		w00_reg_m00           : out std_logic_vector(7 downto 0);
		w01_reg_m01           : out std_logic_vector(7 downto 0);
		w02_reg_m02           : out std_logic_vector(7 downto 0);
		w10_reg_m10           : out std_logic_vector(7 downto 0);
		w11_reg_m11           : out std_logic_vector(7 downto 0);
		w12_reg_m12           : out std_logic_vector(7 downto 0);
		w20_reg_m20           : out std_logic_vector(7 downto 0);
		w21_reg_m21           : out std_logic_vector(7 downto 0);
		w22_reg_m22           : out std_logic_vector(7 downto 0);
		norm_reg_norm         : out std_logic_vector(3 downto 0);

		--======================= Slaves ========================

		------------------------- bus_sl ------------------------
		addr_rel_i            : in std_logic_vector(3 downto 0);
		wr_i                  : in std_logic;
		rd_i                  : in std_logic;
		datawr_i              : in std_logic_vector(31 downto 0);
		datard_o              : out std_logic_vector(31 downto 0)
	);
end conv_slave;

architecture rtl of conv_slave is

	-- Registers address   
	constant STATUS_REG_REG_ADDR   : natural := 0;
	constant WIDTHIMG_REG_REG_ADDR : natural := 1;
	constant W00_REG_REG_ADDR      : natural := 2;
	constant W01_REG_REG_ADDR      : natural := 3;
	constant W02_REG_REG_ADDR      : natural := 4;
	constant W10_REG_REG_ADDR      : natural := 5;
	constant W11_REG_REG_ADDR      : natural := 6;
	constant W12_REG_REG_ADDR      : natural := 7;
	constant W20_REG_REG_ADDR      : natural := 8;
	constant W21_REG_REG_ADDR      : natural := 9;
	constant W22_REG_REG_ADDR      : natural := 10;
	constant NORM_REG_REG_ADDR     : natural := 11;

	-- Internal registers      
	signal status_reg_enable_bit_reg : std_logic;
	signal widthimg_reg_width_reg    : std_logic_vector (15 downto 0);
	signal w00_reg_m00_reg           : std_logic_vector (7 downto 0);
	signal w01_reg_m01_reg           : std_logic_vector (7 downto 0);
	signal w02_reg_m02_reg           : std_logic_vector (7 downto 0);
	signal w10_reg_m10_reg           : std_logic_vector (7 downto 0);
	signal w11_reg_m11_reg           : std_logic_vector (7 downto 0);
	signal w12_reg_m12_reg           : std_logic_vector (7 downto 0);
	signal w20_reg_m20_reg           : std_logic_vector (7 downto 0);
	signal w21_reg_m21_reg           : std_logic_vector (7 downto 0);
	signal w22_reg_m22_reg           : std_logic_vector (7 downto 0);
	signal norm_reg_norm_reg         : std_logic_vector (3 downto 0);

begin
	write_reg : process (clk_proc, reset_n)
	begin
		if(reset_n='0') then
			status_reg_enable_bit_reg <= '0';
			widthimg_reg_width_reg <= "0000000000000000";
			w00_reg_m00_reg <= "00000000";
			w01_reg_m01_reg <= "00000000";
			w02_reg_m02_reg <= "00000000";
			w10_reg_m10_reg <= "00000000";
			w11_reg_m11_reg <= "00000000";
			w12_reg_m12_reg <= "00000000";
			w20_reg_m20_reg <= "00000000";
			w21_reg_m21_reg <= "00000000";
			w22_reg_m22_reg <= "00000000";
			norm_reg_norm_reg <= "0000";
		elsif(rising_edge(clk_proc)) then
			if(wr_i='1') then
				case addr_rel_i is
					when std_logic_vector(to_unsigned(STATUS_REG_REG_ADDR, 4))=>
						status_reg_enable_bit_reg <= datawr_i(0);
					when std_logic_vector(to_unsigned(WIDTHIMG_REG_REG_ADDR, 4))=>
						widthimg_reg_width_reg <= datawr_i(15) & datawr_i(14) & datawr_i(13) & datawr_i(12) & datawr_i(11) & datawr_i(10) & datawr_i(9) & datawr_i(8) & datawr_i(7) & datawr_i(6) & datawr_i(5) & datawr_i(4) & datawr_i(3) & datawr_i(2) & datawr_i(1) & datawr_i(0);
					when std_logic_vector(to_unsigned(W00_REG_REG_ADDR, 4))=>
						w00_reg_m00_reg <= datawr_i(7) & datawr_i(6) & datawr_i(5) & datawr_i(4) & datawr_i(3) & datawr_i(2) & datawr_i(1) & datawr_i(0);
					when std_logic_vector(to_unsigned(W01_REG_REG_ADDR, 4))=>
						w01_reg_m01_reg <= datawr_i(7) & datawr_i(6) & datawr_i(5) & datawr_i(4) & datawr_i(3) & datawr_i(2) & datawr_i(1) & datawr_i(0);
					when std_logic_vector(to_unsigned(W02_REG_REG_ADDR, 4))=>
						w02_reg_m02_reg <= datawr_i(7) & datawr_i(6) & datawr_i(5) & datawr_i(4) & datawr_i(3) & datawr_i(2) & datawr_i(1) & datawr_i(0);
					when std_logic_vector(to_unsigned(W10_REG_REG_ADDR, 4))=>
						w10_reg_m10_reg <= datawr_i(7) & datawr_i(6) & datawr_i(5) & datawr_i(4) & datawr_i(3) & datawr_i(2) & datawr_i(1) & datawr_i(0);
					when std_logic_vector(to_unsigned(W11_REG_REG_ADDR, 4))=>
						w11_reg_m11_reg <= datawr_i(7) & datawr_i(6) & datawr_i(5) & datawr_i(4) & datawr_i(3) & datawr_i(2) & datawr_i(1) & datawr_i(0);
					when std_logic_vector(to_unsigned(W12_REG_REG_ADDR, 4))=>
						w12_reg_m12_reg <= datawr_i(7) & datawr_i(6) & datawr_i(5) & datawr_i(4) & datawr_i(3) & datawr_i(2) & datawr_i(1) & datawr_i(0);
					when std_logic_vector(to_unsigned(W20_REG_REG_ADDR, 4))=>
						w20_reg_m20_reg <= datawr_i(7) & datawr_i(6) & datawr_i(5) & datawr_i(4) & datawr_i(3) & datawr_i(2) & datawr_i(1) & datawr_i(0);
					when std_logic_vector(to_unsigned(W21_REG_REG_ADDR, 4))=>
						w21_reg_m21_reg <= datawr_i(7) & datawr_i(6) & datawr_i(5) & datawr_i(4) & datawr_i(3) & datawr_i(2) & datawr_i(1) & datawr_i(0);
					when std_logic_vector(to_unsigned(W22_REG_REG_ADDR, 4))=>
						w22_reg_m22_reg <= datawr_i(7) & datawr_i(6) & datawr_i(5) & datawr_i(4) & datawr_i(3) & datawr_i(2) & datawr_i(1) & datawr_i(0);
					when std_logic_vector(to_unsigned(NORM_REG_REG_ADDR, 4))=>
						norm_reg_norm_reg <= datawr_i(3) & datawr_i(2) & datawr_i(1) & datawr_i(0);
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
						datard_o <= "0000000000000000" & widthimg_reg_width_reg(15) & widthimg_reg_width_reg(14) & widthimg_reg_width_reg(13) & widthimg_reg_width_reg(12) & widthimg_reg_width_reg(11) & widthimg_reg_width_reg(10) & widthimg_reg_width_reg(9) & widthimg_reg_width_reg(8) & widthimg_reg_width_reg(7) & widthimg_reg_width_reg(6) & widthimg_reg_width_reg(5) & widthimg_reg_width_reg(4) & widthimg_reg_width_reg(3) & widthimg_reg_width_reg(2) & widthimg_reg_width_reg(1) & widthimg_reg_width_reg(0);
					when std_logic_vector(to_unsigned(W00_REG_REG_ADDR, 4))=>
						datard_o <= "000000000000000000000000" & w00_reg_m00_reg(7) & w00_reg_m00_reg(6) & w00_reg_m00_reg(5) & w00_reg_m00_reg(4) & w00_reg_m00_reg(3) & w00_reg_m00_reg(2) & w00_reg_m00_reg(1) & w00_reg_m00_reg(0);
					when std_logic_vector(to_unsigned(W01_REG_REG_ADDR, 4))=>
						datard_o <= "000000000000000000000000" & w01_reg_m01_reg(7) & w01_reg_m01_reg(6) & w01_reg_m01_reg(5) & w01_reg_m01_reg(4) & w01_reg_m01_reg(3) & w01_reg_m01_reg(2) & w01_reg_m01_reg(1) & w01_reg_m01_reg(0);
					when std_logic_vector(to_unsigned(W02_REG_REG_ADDR, 4))=>
						datard_o <= "000000000000000000000000" & w02_reg_m02_reg(7) & w02_reg_m02_reg(6) & w02_reg_m02_reg(5) & w02_reg_m02_reg(4) & w02_reg_m02_reg(3) & w02_reg_m02_reg(2) & w02_reg_m02_reg(1) & w02_reg_m02_reg(0);
					when std_logic_vector(to_unsigned(W10_REG_REG_ADDR, 4))=>
						datard_o <= "000000000000000000000000" & w10_reg_m10_reg(7) & w10_reg_m10_reg(6) & w10_reg_m10_reg(5) & w10_reg_m10_reg(4) & w10_reg_m10_reg(3) & w10_reg_m10_reg(2) & w10_reg_m10_reg(1) & w10_reg_m10_reg(0);
					when std_logic_vector(to_unsigned(W11_REG_REG_ADDR, 4))=>
						datard_o <= "000000000000000000000000" & w11_reg_m11_reg(7) & w11_reg_m11_reg(6) & w11_reg_m11_reg(5) & w11_reg_m11_reg(4) & w11_reg_m11_reg(3) & w11_reg_m11_reg(2) & w11_reg_m11_reg(1) & w11_reg_m11_reg(0);
					when std_logic_vector(to_unsigned(W12_REG_REG_ADDR, 4))=>
						datard_o <= "000000000000000000000000" & w12_reg_m12_reg(7) & w12_reg_m12_reg(6) & w12_reg_m12_reg(5) & w12_reg_m12_reg(4) & w12_reg_m12_reg(3) & w12_reg_m12_reg(2) & w12_reg_m12_reg(1) & w12_reg_m12_reg(0);
					when std_logic_vector(to_unsigned(W20_REG_REG_ADDR, 4))=>
						datard_o <= "000000000000000000000000" & w20_reg_m20_reg(7) & w20_reg_m20_reg(6) & w20_reg_m20_reg(5) & w20_reg_m20_reg(4) & w20_reg_m20_reg(3) & w20_reg_m20_reg(2) & w20_reg_m20_reg(1) & w20_reg_m20_reg(0);
					when std_logic_vector(to_unsigned(W21_REG_REG_ADDR, 4))=>
						datard_o <= "000000000000000000000000" & w21_reg_m21_reg(7) & w21_reg_m21_reg(6) & w21_reg_m21_reg(5) & w21_reg_m21_reg(4) & w21_reg_m21_reg(3) & w21_reg_m21_reg(2) & w21_reg_m21_reg(1) & w21_reg_m21_reg(0);
					when std_logic_vector(to_unsigned(W22_REG_REG_ADDR, 4))=>
						datard_o <= "000000000000000000000000" & w22_reg_m22_reg(7) & w22_reg_m22_reg(6) & w22_reg_m22_reg(5) & w22_reg_m22_reg(4) & w22_reg_m22_reg(3) & w22_reg_m22_reg(2) & w22_reg_m22_reg(1) & w22_reg_m22_reg(0);
					when std_logic_vector(to_unsigned(NORM_REG_REG_ADDR, 4))=>
						datard_o <= "0000000000000000000000000000" & norm_reg_norm_reg(3) & norm_reg_norm_reg(2) & norm_reg_norm_reg(1) & norm_reg_norm_reg(0);
					when others=>
						datard_o <= (others => '0');
				end case;
			end if;
		end if;
	end process;

	status_reg_enable_bit <= status_reg_enable_bit_reg;
	widthimg_reg_width <= widthimg_reg_width_reg;
	w00_reg_m00 <= w00_reg_m00_reg;
	w01_reg_m01 <= w01_reg_m01_reg;
	w02_reg_m02 <= w02_reg_m02_reg;
	w10_reg_m10 <= w10_reg_m10_reg;
	w11_reg_m11 <= w11_reg_m11_reg;
	w12_reg_m12 <= w12_reg_m12_reg;
	w20_reg_m20 <= w20_reg_m20_reg;
	w21_reg_m21 <= w21_reg_m21_reg;
	w22_reg_m22 <= w22_reg_m22_reg;
	norm_reg_norm <= norm_reg_norm_reg;

end rtl;
