--------------------------------------------------------------------
-- Package containing several constant data
--------------------------------------------------------------------


library ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package gps_pkg is

	constant LEN_3 						: STD_LOGIC_VECTOR(7 DOWNTO 0)   := x"03";
	constant LEN_4 						: STD_LOGIC_VECTOR(7 DOWNTO 0)   := x"04";
	constant LEN_5							: STD_LOGIC_VECTOR(7 DOWNTO 0)   := x"05";
	constant ZERO							: STD_LOGIC_VECTOR(7 DOWNTO 0)   := x"00";
	constant ID_MODE						: STD_LOGIC_VECTOR(15 DOWNTO 0)  := x"6419";
	constant MODE_GPS						: STD_LOGIC_VECTOR(7 DOWNTO 0)   := x"01";
	constant MODE_GPS_GL					: STD_LOGIC_VECTOR(7 DOWNTO 0)   := x"03";
	constant ID_BAUD_RATE				: STD_LOGIC_VECTOR(15 DOWNTO 0)  := x"0500";
	constant BAUD_RATE_MAX				: STD_LOGIC_VECTOR(7 DOWNTO 0)   := x"08";
	constant ID_UPDATE_RATE				: STD_LOGIC_VECTOR(7 DOWNTO 0)   := x"0E";
	constant UPDATE_RATE_MAX_GL		: STD_LOGIC_VECTOR(7 DOWNTO 0)   := x"20";
	constant START_BYTES					: STD_LOGIC_VECTOR(15 DOWNTO 0)  := x"A0A1";
	constant END_BYTES					: STD_LOGIC_VECTOR(15 DOWNTO 0)   := x"0D0A";
	constant RESTART						: STD_LOGIC_VECTOR(143 DOWNTO 0) := x"00_0F_01_01_07_D8_0B_0E_08_2E_03_09_C4_30_70_00_64_16";
	constant LEN_CONF_MODE				: UNSIGNED(7 DOWNTO 0)   := x"0C";
	constant LEN_CONF_BD_RATE			: UNSIGNED(7 DOWNTO 0)   := x"0B";
	constant LEN_CONF_UPDATE			: UNSIGNED(7 DOWNTO 0)   := x"0A";
	constant LEN_CONF_RESTART			: UNSIGNED(7 DOWNTO 0)   := x"16";
	constant COUNT_BD_RATE_DEFAULT	: UNSIGNED(15 DOWNTO 0)  := x"1458";
	constant COUNT_BD_RATE_MAX			: UNSIGNED(15 DOWNTO 0)  := x"0035";
end gps_pkg;
