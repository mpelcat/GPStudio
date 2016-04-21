--------------------------------------------------------------------
-- Package containing several constant data
--------------------------------------------------------------------

library ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package mpu_pkg is

	constant ADDR_I2C_MPU 			: STD_LOGIC_VECTOR(6 DOWNTO 0) := "1101000";
	constant ADDR_I2C_COMPASS 		: STD_LOGIC_VECTOR(6 DOWNTO 0) := "0011110";
	constant PWR_MGMT_1				: STD_LOGIC_VECTOR(7 DOWNTO 0) := x"6B";
	constant USER_CTRL				: STD_LOGIC_VECTOR(7 DOWNTO 0) := x"6A";
	constant ACCEL_CONFIG_REG		: STD_LOGIC_VECTOR(7 DOWNTO 0) := x"1C";
	constant SMPLRT_DIV				: STD_LOGIC_VECTOR(7 DOWNTO 0) := x"19";
	constant FIFO_EN					: STD_LOGIC_VECTOR(7 DOWNTO 0) := x"23";
	constant GYRO_CONFIG_REG		: STD_LOGIC_VECTOR(7 DOWNTO 0) := x"1B";
	constant BYPASS_MPU				: STD_LOGIC_VECTOR(7 DOWNTO 0) := x"37";
	constant COMPASS_CONF_A			: STD_LOGIC_VECTOR(7 DOWNTO 0) := x"00";
	constant COMPASS_CONF_B			: STD_LOGIC_VECTOR(7 DOWNTO 0) := x"01";
	constant COMPASS_MODE			: STD_LOGIC_VECTOR(7 DOWNTO 0) := x"02";
	constant I2C_MST_CTRL			: STD_LOGIC_VECTOR(7 DOWNTO 0) := x"24";
	constant I2C_SLV0_ADDR			: STD_LOGIC_VECTOR(7 DOWNTO 0) := x"25";
	constant I2C_SLV0_REG			: STD_LOGIC_VECTOR(7 DOWNTO 0) := x"26";
	constant I2C_SLV0_CTRL			: STD_LOGIC_VECTOR(7 DOWNTO 0) := x"27";
	constant FIFO_READ				: STD_LOGIC_VECTOR(7 DOWNTO 0) := x"74";
	constant COUNT_FIFO_BYTES_T	: INTEGER RANGE 0 to 8100		 := 8_000;
	constant TRIGGER_OR_RST_FIFO_T: INTEGER RANGE 0 to 20100		 := 20_000;
	constant AD0_value				: std_logic := '0';
	constant clk_50M				   : unsigned(27 downto 0) := x"2FAF080";
	
	type param is array (integer range 0 to 3) of std_logic_vector(31 downto 0);
	
	type flow is record
			data : std_logic_vector(7 downto 0);
			fv	  : std_logic;
			dv   : std_logic;
	end record;
	
end mpu_pkg;
