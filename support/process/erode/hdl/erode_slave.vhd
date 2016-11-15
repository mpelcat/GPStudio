library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
library std;

entity erode_slave is
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
		er00_reg_m00          : out std_logic_vector(7 downto 0);
		er01_reg_m01          : out std_logic_vector(7 downto 0);
		er02_reg_m02          : out std_logic_vector(7 downto 0);
		er10_reg_m10          : out std_logic_vector(7 downto 0);
		er11_reg_m11          : out std_logic_vector(7 downto 0);
		er12_reg_m12          : out std_logic_vector(7 downto 0);
		er20_reg_m20          : out std_logic_vector(7 downto 0);
		er21_reg_m21          : out std_logic_vector(7 downto 0);
		er22_reg_m22          : out std_logic_vector(7 downto 0);

		--======================= Slaves ========================

		------------------------- bus_sl ------------------------
		addr_rel_i            : in std_logic_vector(3 downto 0);
		wr_i                  : in std_logic;
		rd_i                  : in std_logic;
		datawr_i              : in std_logic_vector(31 downto 0);
		datard_o              : out std_logic_vector(31 downto 0)
	);
end erode_slave;

architecture rtl of erode_slave is

	-- Registers address   
	constant STATUS_REG_REG_ADDR   : natural := 0;
	constant WIDTHIMG_REG_REG_ADDR : natural := 1;
	constant HEIGTIMG_REG_REG_ADDR : natural := 2;
	constant ER00_REG_REG_ADDR     : natural := 3;
	constant ER01_REG_REG_ADDR     : natural := 4;
	constant ER02_REG_REG_ADDR     : natural := 5;
	constant ER10_REG_REG_ADDR     : natural := 6;
	constant ER11_REG_REG_ADDR     : natural := 7;
	constant ER12_REG_REG_ADDR     : natural := 8;
	constant ER20_REG_REG_ADDR     : natural := 9;
	constant ER21_REG_REG_ADDR     : natural := 10;
	constant ER22_REG_REG_ADDR     : natural := 11;

	-- Internal registers      
	signal status_reg_enable_bit_reg : std_logic;
	signal widthimg_reg_value_reg    : std_logic_vector (15 downto 0);
	signal heigtimg_reg_value_reg    : std_logic_vector (15 downto 0);
	signal er00_reg_m00_reg          : std_logic_vector (7 downto 0);
	signal er01_reg_m01_reg          : std_logic_vector (7 downto 0);
	signal er02_reg_m02_reg          : std_logic_vector (7 downto 0);
	signal er10_reg_m10_reg          : std_logic_vector (7 downto 0);
	signal er11_reg_m11_reg          : std_logic_vector (7 downto 0);
	signal er12_reg_m12_reg          : std_logic_vector (7 downto 0);
	signal er20_reg_m20_reg          : std_logic_vector (7 downto 0);
	signal er21_reg_m21_reg          : std_logic_vector (7 downto 0);
	signal er22_reg_m22_reg          : std_logic_vector (7 downto 0);

begin
	write_reg : process (clk_proc, reset_n)
	begin
		if(reset_n='0') then
			status_reg_enable_bit_reg <= '0';
			widthimg_reg_value_reg <= "0000000000000000";
			heigtimg_reg_value_reg <= "0000000000000000";
			er00_reg_m00_reg <= "00000000";
			er01_reg_m01_reg <= "00000000";
			er02_reg_m02_reg <= "00000000";
			er10_reg_m10_reg <= "00000000";
			er11_reg_m11_reg <= "00000000";
			er12_reg_m12_reg <= "00000000";
			er20_reg_m20_reg <= "00000000";
			er21_reg_m21_reg <= "00000000";
			er22_reg_m22_reg <= "00000000";
		elsif(rising_edge(clk_proc)) then
			if(wr_i='1') then
				case addr_rel_i is
					when std_logic_vector(to_unsigned(STATUS_REG_REG_ADDR, 4))=>
						status_reg_enable_bit_reg <= datawr_i(0);
					when std_logic_vector(to_unsigned(WIDTHIMG_REG_REG_ADDR, 4))=>
						widthimg_reg_value_reg <= datawr_i(15) & datawr_i(14) & datawr_i(13) & datawr_i(12) & datawr_i(11) & datawr_i(10) & datawr_i(9) & datawr_i(8) & datawr_i(7) & datawr_i(6) & datawr_i(5) & datawr_i(4) & datawr_i(3) & datawr_i(2) & datawr_i(1) & datawr_i(0);
					when std_logic_vector(to_unsigned(HEIGTIMG_REG_REG_ADDR, 4))=>
						heigtimg_reg_value_reg <= datawr_i(15) & datawr_i(14) & datawr_i(13) & datawr_i(12) & datawr_i(11) & datawr_i(10) & datawr_i(9) & datawr_i(8) & datawr_i(7) & datawr_i(6) & datawr_i(5) & datawr_i(4) & datawr_i(3) & datawr_i(2) & datawr_i(1) & datawr_i(0);
					when std_logic_vector(to_unsigned(ER00_REG_REG_ADDR, 4))=>
						er00_reg_m00_reg <= datawr_i(7) & datawr_i(6) & datawr_i(5) & datawr_i(4) & datawr_i(3) & datawr_i(2) & datawr_i(1) & datawr_i(0);
					when std_logic_vector(to_unsigned(ER01_REG_REG_ADDR, 4))=>
						er01_reg_m01_reg <= datawr_i(7) & datawr_i(6) & datawr_i(5) & datawr_i(4) & datawr_i(3) & datawr_i(2) & datawr_i(1) & datawr_i(0);
					when std_logic_vector(to_unsigned(ER02_REG_REG_ADDR, 4))=>
						er02_reg_m02_reg <= datawr_i(7) & datawr_i(6) & datawr_i(5) & datawr_i(4) & datawr_i(3) & datawr_i(2) & datawr_i(1) & datawr_i(0);
					when std_logic_vector(to_unsigned(ER10_REG_REG_ADDR, 4))=>
						er10_reg_m10_reg <= datawr_i(7) & datawr_i(6) & datawr_i(5) & datawr_i(4) & datawr_i(3) & datawr_i(2) & datawr_i(1) & datawr_i(0);
					when std_logic_vector(to_unsigned(ER11_REG_REG_ADDR, 4))=>
						er11_reg_m11_reg <= datawr_i(7) & datawr_i(6) & datawr_i(5) & datawr_i(4) & datawr_i(3) & datawr_i(2) & datawr_i(1) & datawr_i(0);
					when std_logic_vector(to_unsigned(ER12_REG_REG_ADDR, 4))=>
						er12_reg_m12_reg <= datawr_i(7) & datawr_i(6) & datawr_i(5) & datawr_i(4) & datawr_i(3) & datawr_i(2) & datawr_i(1) & datawr_i(0);
					when std_logic_vector(to_unsigned(ER20_REG_REG_ADDR, 4))=>
						er20_reg_m20_reg <= datawr_i(7) & datawr_i(6) & datawr_i(5) & datawr_i(4) & datawr_i(3) & datawr_i(2) & datawr_i(1) & datawr_i(0);
					when std_logic_vector(to_unsigned(ER21_REG_REG_ADDR, 4))=>
						er21_reg_m21_reg <= datawr_i(7) & datawr_i(6) & datawr_i(5) & datawr_i(4) & datawr_i(3) & datawr_i(2) & datawr_i(1) & datawr_i(0);
					when std_logic_vector(to_unsigned(ER22_REG_REG_ADDR, 4))=>
						er22_reg_m22_reg <= datawr_i(7) & datawr_i(6) & datawr_i(5) & datawr_i(4) & datawr_i(3) & datawr_i(2) & datawr_i(1) & datawr_i(0);
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
					when std_logic_vector(to_unsigned(HEIGTIMG_REG_REG_ADDR, 4))=>
						datard_o <= "0000000000000000" & heigtimg_reg_value_reg(15) & heigtimg_reg_value_reg(14) & heigtimg_reg_value_reg(13) & heigtimg_reg_value_reg(12) & heigtimg_reg_value_reg(11) & heigtimg_reg_value_reg(10) & heigtimg_reg_value_reg(9) & heigtimg_reg_value_reg(8) & heigtimg_reg_value_reg(7) & heigtimg_reg_value_reg(6) & heigtimg_reg_value_reg(5) & heigtimg_reg_value_reg(4) & heigtimg_reg_value_reg(3) & heigtimg_reg_value_reg(2) & heigtimg_reg_value_reg(1) & heigtimg_reg_value_reg(0);
					when std_logic_vector(to_unsigned(ER00_REG_REG_ADDR, 4))=>
						datard_o <= "000000000000000000000000" & er00_reg_m00_reg(7) & er00_reg_m00_reg(6) & er00_reg_m00_reg(5) & er00_reg_m00_reg(4) & er00_reg_m00_reg(3) & er00_reg_m00_reg(2) & er00_reg_m00_reg(1) & er00_reg_m00_reg(0);
					when std_logic_vector(to_unsigned(ER01_REG_REG_ADDR, 4))=>
						datard_o <= "000000000000000000000000" & er01_reg_m01_reg(7) & er01_reg_m01_reg(6) & er01_reg_m01_reg(5) & er01_reg_m01_reg(4) & er01_reg_m01_reg(3) & er01_reg_m01_reg(2) & er01_reg_m01_reg(1) & er01_reg_m01_reg(0);
					when std_logic_vector(to_unsigned(ER02_REG_REG_ADDR, 4))=>
						datard_o <= "000000000000000000000000" & er02_reg_m02_reg(7) & er02_reg_m02_reg(6) & er02_reg_m02_reg(5) & er02_reg_m02_reg(4) & er02_reg_m02_reg(3) & er02_reg_m02_reg(2) & er02_reg_m02_reg(1) & er02_reg_m02_reg(0);
					when std_logic_vector(to_unsigned(ER10_REG_REG_ADDR, 4))=>
						datard_o <= "000000000000000000000000" & er10_reg_m10_reg(7) & er10_reg_m10_reg(6) & er10_reg_m10_reg(5) & er10_reg_m10_reg(4) & er10_reg_m10_reg(3) & er10_reg_m10_reg(2) & er10_reg_m10_reg(1) & er10_reg_m10_reg(0);
					when std_logic_vector(to_unsigned(ER11_REG_REG_ADDR, 4))=>
						datard_o <= "000000000000000000000000" & er11_reg_m11_reg(7) & er11_reg_m11_reg(6) & er11_reg_m11_reg(5) & er11_reg_m11_reg(4) & er11_reg_m11_reg(3) & er11_reg_m11_reg(2) & er11_reg_m11_reg(1) & er11_reg_m11_reg(0);
					when std_logic_vector(to_unsigned(ER12_REG_REG_ADDR, 4))=>
						datard_o <= "000000000000000000000000" & er12_reg_m12_reg(7) & er12_reg_m12_reg(6) & er12_reg_m12_reg(5) & er12_reg_m12_reg(4) & er12_reg_m12_reg(3) & er12_reg_m12_reg(2) & er12_reg_m12_reg(1) & er12_reg_m12_reg(0);
					when std_logic_vector(to_unsigned(ER20_REG_REG_ADDR, 4))=>
						datard_o <= "000000000000000000000000" & er20_reg_m20_reg(7) & er20_reg_m20_reg(6) & er20_reg_m20_reg(5) & er20_reg_m20_reg(4) & er20_reg_m20_reg(3) & er20_reg_m20_reg(2) & er20_reg_m20_reg(1) & er20_reg_m20_reg(0);
					when std_logic_vector(to_unsigned(ER21_REG_REG_ADDR, 4))=>
						datard_o <= "000000000000000000000000" & er21_reg_m21_reg(7) & er21_reg_m21_reg(6) & er21_reg_m21_reg(5) & er21_reg_m21_reg(4) & er21_reg_m21_reg(3) & er21_reg_m21_reg(2) & er21_reg_m21_reg(1) & er21_reg_m21_reg(0);
					when std_logic_vector(to_unsigned(ER22_REG_REG_ADDR, 4))=>
						datard_o <= "000000000000000000000000" & er22_reg_m22_reg(7) & er22_reg_m22_reg(6) & er22_reg_m22_reg(5) & er22_reg_m22_reg(4) & er22_reg_m22_reg(3) & er22_reg_m22_reg(2) & er22_reg_m22_reg(1) & er22_reg_m22_reg(0);
					when others=>
						datard_o <= (others => '0');
				end case;
			end if;
		end if;
	end process;

	status_reg_enable_bit <= status_reg_enable_bit_reg;
	widthimg_reg_value <= widthimg_reg_value_reg;
	heigtimg_reg_value <= heigtimg_reg_value_reg;
	er00_reg_m00 <= er00_reg_m00_reg;
	er01_reg_m01 <= er01_reg_m01_reg;
	er02_reg_m02 <= er02_reg_m02_reg;
	er10_reg_m10 <= er10_reg_m10_reg;
	er11_reg_m11 <= er11_reg_m11_reg;
	er12_reg_m12 <= er12_reg_m12_reg;
	er20_reg_m20 <= er20_reg_m20_reg;
	er21_reg_m21 <= er21_reg_m21_reg;
	er22_reg_m22 <= er22_reg_m22_reg;

end rtl;
