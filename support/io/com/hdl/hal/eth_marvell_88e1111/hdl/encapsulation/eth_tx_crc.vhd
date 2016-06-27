----------------------------------------------------------------------------------
-- Company: Laboratoire Leprince Ringuet
-- Engineer: 
-- 
-- Create Date:    14:03:42 10/14/2011 
-- Design Name: 
-- Module Name:    eth_tx_crc - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity  eth_tx_crc is Port(
	CLK : in STD_LOGIC;
	RESET : in STD_LOGIC;
	IN_ETH_STREAM : in STD_LOGIC_VECTOR(9 downto 0);
	OUT_ETH_STREAM : out STD_LOGIC_VECTOR(9 downto 0));
end eth_tx_crc;

architecture Behavioral of eth_tx_crc is
	type multiple is array (3 downto 0) of std_logic_vector(7 downto 0);
	signal dat_dly : multiple;
	signal frm_dly : STD_LOGIC_VECTOR(3 downto 0);
	signal checksum : STD_LOGIC_VECTOR(7 downto 0);
	signal my_sig : std_logic;
	component crc32_8 Port(
		CRC_REG : out STD_LOGIC_VECTOR(31 downto 0);
		CRC : out STD_LOGIC_VECTOR(7 downto 0);
		D : in STD_LOGIC_VECTOR(7 downto 0);
		CALC : in STD_LOGIC;
		INIT : in STD_LOGIC;
		D_VALID : in STD_LOGIC;
		CLK : in STD_LOGIC;
		RESET : in STD_LOGIC);
	end component;
begin
	my_sig <= not frm_dly(3);
	crc_checksum : crc32_8 port map(
		CLK => CLK, 
		D => dat_dly(3),--data input
		INIT => my_sig,--not frm_dly(3),--reset CRC
		CALC => IN_ETH_STREAM(8),--use D in calculation
		D_VALID => IN_ETH_STREAM(9),--strobe bit
		CRC_REG => open, 
		CRC => checksum, 
		RESET => RESET);--global reset used as redundant signal

	process(CLK,RESET)
	begin
		if RESET = '0' then
			dat_dly(0) <= x"00";
			dat_dly(1) <= x"00";
			dat_dly(2) <= x"00";
			dat_dly(3) <= x"00";
			frm_dly <= x"0";
			OUT_ETH_STREAM <= "00" & x"00";
		elsif CLK'event and CLK = '1' then
			if IN_ETH_STREAM(9) = '1' then
				--delay the data by four bytes to detect the end of the frame
				dat_dly <= dat_dly(2 downto 0) & IN_ETH_STREAM(7 downto 0);
				frm_dly <= frm_dly(2 downto 0) & IN_ETH_STREAM(8);
				--register output
				OUT_ETH_STREAM(9 downto 8) <= '1' & frm_dly(3);
				if IN_ETH_STREAM(8) = '1' then
					OUT_ETH_STREAM(7 downto 0) <= dat_dly(3);
				else
					OUT_ETH_STREAM(7 downto 0) <= checksum;
				end if;
			else
				OUT_ETH_STREAM(9) <= '0';
			end if;
		end if;
	end process;
end Behavioral;


