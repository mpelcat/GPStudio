library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
library std;

entity mpu_slave is
	generic (
		CLK_PROC_FREQ : integer
	);
	port (
		clk_proc         : in std_logic;
		reset_n          : in std_logic;

		---------------- dynamic parameters ports ---------------
		enable_reg       : out std_logic_vector(31 downto 0);
		gyro_config_reg  : out std_logic_vector(31 downto 0);
		accel_config_reg : out std_logic_vector(31 downto 0);
		spl_rate_reg     : out std_logic_vector(31 downto 0);
		gain_compass_reg : out std_logic_vector(31 downto 0);
		fz_compass_reg   : out std_logic_vector(31 downto 0);
		accel_off_x_reg  : out std_logic_vector(31 downto 0);
		accel_off_y_reg  : out std_logic_vector(31 downto 0);
		accel_off_z_reg  : out std_logic_vector(31 downto 0);
		gyro_off_x_reg   : out std_logic_vector(31 downto 0);
		gyro_off_y_reg   : out std_logic_vector(31 downto 0);
		gyro_off_z_reg   : out std_logic_vector(31 downto 0);

		--======================= Slaves ========================

		------------------------- bus_sl ------------------------
		addr_rel_i       : in std_logic_vector(3 downto 0);
		wr_i             : in std_logic;
		rd_i             : in std_logic;
		datawr_i         : in std_logic_vector(31 downto 0);
		datard_o         : out std_logic_vector(31 downto 0)
	);
end mpu_slave;

architecture rtl of mpu_slave is

	-- Registers address       
	constant ENABLE_REG_REG_ADDR       : natural := 0;
	constant GYRO_CONFIG_REG_REG_ADDR  : natural := 1;
	constant ACCEL_CONFIG_REG_REG_ADDR : natural := 2;
	constant SPL_RATE_REG_REG_ADDR     : natural := 3;
	constant GAIN_COMPASS_REG_REG_ADDR : natural := 4;
	constant FZ_COMPASS_REG_REG_ADDR   : natural := 5;
	constant ACCEL_OFF_X_REG_REG_ADDR  : natural := 6;
	constant ACCEL_OFF_Y_REG_REG_ADDR  : natural := 7;
	constant ACCEL_OFF_Z_REG_REG_ADDR  : natural := 8;
	constant GYRO_OFF_X_REG_REG_ADDR   : natural := 9;
	constant GYRO_OFF_Y_REG_REG_ADDR   : natural := 10;
	constant GYRO_OFF_Z_REG_REG_ADDR   : natural := 11;

	-- Internal registers 
	signal enable_reg_reg       : std_logic_vector (31 downto 0);
	signal gyro_config_reg_reg  : std_logic_vector (31 downto 0);
	signal accel_config_reg_reg : std_logic_vector (31 downto 0);
	signal spl_rate_reg_reg     : std_logic_vector (31 downto 0);
	signal gain_compass_reg_reg : std_logic_vector (31 downto 0);
	signal fz_compass_reg_reg   : std_logic_vector (31 downto 0);
	signal accel_off_x_reg_reg  : std_logic_vector (31 downto 0);
	signal accel_off_y_reg_reg  : std_logic_vector (31 downto 0);
	signal accel_off_z_reg_reg  : std_logic_vector (31 downto 0);
	signal gyro_off_x_reg_reg   : std_logic_vector (31 downto 0);
	signal gyro_off_y_reg_reg   : std_logic_vector (31 downto 0);
	signal gyro_off_z_reg_reg   : std_logic_vector (31 downto 0);

begin
	write_reg : process (clk_proc, reset_n)
	begin
		if(reset_n='0') then
			enable_reg_reg <= x"00000000";
			gyro_config_reg_reg <= x"00000000";
			accel_config_reg_reg <= x"00000000";
			spl_rate_reg_reg <= x"00000000";
			gain_compass_reg_reg <= x"00000000";
			fz_compass_reg_reg <= x"00000000";
			accel_off_x_reg_reg <= x"00000000";
			accel_off_y_reg_reg <= x"00000000";
			accel_off_z_reg_reg <= x"00000000";
			gyro_off_x_reg_reg <= x"00000000";
			gyro_off_y_reg_reg <= x"00000000";
			gyro_off_z_reg_reg <= x"00000000";
		elsif(rising_edge(clk_proc)) then
			if(wr_i='1') then
				case addr_rel_i is
					when std_logic_vector(to_unsigned(ENABLE_REG_REG_ADDR, 4))=>
						enable_reg_reg <= datawr_i;
					when std_logic_vector(to_unsigned(GYRO_CONFIG_REG_REG_ADDR, 4))=>
						gyro_config_reg_reg <= datawr_i;
					when std_logic_vector(to_unsigned(ACCEL_CONFIG_REG_REG_ADDR, 4))=>
						accel_config_reg_reg <= datawr_i;
					when std_logic_vector(to_unsigned(SPL_RATE_REG_REG_ADDR, 4))=>
						spl_rate_reg_reg <= datawr_i;
					when std_logic_vector(to_unsigned(GAIN_COMPASS_REG_REG_ADDR, 4))=>
						gain_compass_reg_reg <= datawr_i;
					when std_logic_vector(to_unsigned(FZ_COMPASS_REG_REG_ADDR, 4))=>
						fz_compass_reg_reg <= datawr_i;
					when std_logic_vector(to_unsigned(ACCEL_OFF_X_REG_REG_ADDR, 4))=>
						accel_off_x_reg_reg <= datawr_i;
					when std_logic_vector(to_unsigned(ACCEL_OFF_Y_REG_REG_ADDR, 4))=>
						accel_off_y_reg_reg <= datawr_i;
					when std_logic_vector(to_unsigned(ACCEL_OFF_Z_REG_REG_ADDR, 4))=>
						accel_off_z_reg_reg <= datawr_i;
					when std_logic_vector(to_unsigned(GYRO_OFF_X_REG_REG_ADDR, 4))=>
						gyro_off_x_reg_reg <= datawr_i;
					when std_logic_vector(to_unsigned(GYRO_OFF_Y_REG_REG_ADDR, 4))=>
						gyro_off_y_reg_reg <= datawr_i;
					when std_logic_vector(to_unsigned(GYRO_OFF_Z_REG_REG_ADDR, 4))=>
						gyro_off_z_reg_reg <= datawr_i;
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
					when std_logic_vector(to_unsigned(ENABLE_REG_REG_ADDR, 4))=>
						datard_o <= enable_reg_reg;
					when std_logic_vector(to_unsigned(GYRO_CONFIG_REG_REG_ADDR, 4))=>
						datard_o <= gyro_config_reg_reg;
					when std_logic_vector(to_unsigned(ACCEL_CONFIG_REG_REG_ADDR, 4))=>
						datard_o <= accel_config_reg_reg;
					when std_logic_vector(to_unsigned(SPL_RATE_REG_REG_ADDR, 4))=>
						datard_o <= spl_rate_reg_reg;
					when std_logic_vector(to_unsigned(GAIN_COMPASS_REG_REG_ADDR, 4))=>
						datard_o <= gain_compass_reg_reg;
					when std_logic_vector(to_unsigned(FZ_COMPASS_REG_REG_ADDR, 4))=>
						datard_o <= fz_compass_reg_reg;
					when std_logic_vector(to_unsigned(ACCEL_OFF_X_REG_REG_ADDR, 4))=>
						datard_o <= accel_off_x_reg_reg;
					when std_logic_vector(to_unsigned(ACCEL_OFF_Y_REG_REG_ADDR, 4))=>
						datard_o <= accel_off_y_reg_reg;
					when std_logic_vector(to_unsigned(ACCEL_OFF_Z_REG_REG_ADDR, 4))=>
						datard_o <= accel_off_z_reg_reg;
					when std_logic_vector(to_unsigned(GYRO_OFF_X_REG_REG_ADDR, 4))=>
						datard_o <= gyro_off_x_reg_reg;
					when std_logic_vector(to_unsigned(GYRO_OFF_Y_REG_REG_ADDR, 4))=>
						datard_o <= gyro_off_y_reg_reg;
					when std_logic_vector(to_unsigned(GYRO_OFF_Z_REG_REG_ADDR, 4))=>
						datard_o <= gyro_off_z_reg_reg;
					when others=>
						datard_o <= (others => '0');
				end case;
			end if;
		end if;
	end process;

	enable_reg <= enable_reg_reg;
	gyro_config_reg <= gyro_config_reg_reg;
	accel_config_reg <= accel_config_reg_reg;
	spl_rate_reg <= spl_rate_reg_reg;
	gain_compass_reg <= gain_compass_reg_reg;
	fz_compass_reg <= fz_compass_reg_reg;
	accel_off_x_reg <= accel_off_x_reg_reg;
	accel_off_y_reg <= accel_off_y_reg_reg;
	accel_off_z_reg <= accel_off_z_reg_reg;
	gyro_off_x_reg <= gyro_off_x_reg_reg;
	gyro_off_y_reg <= gyro_off_y_reg_reg;
	gyro_off_z_reg <= gyro_off_z_reg_reg;

end rtl;
