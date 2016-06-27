----------------------------------------------------------------------------------
-- Company: Laboratoire Leprince-Ringuet
-- Engineer: 
-- 
-- Create Date:    11:58:40 10/14/2011 
-- Design Name: 
-- Module Name:    eth_tx_stream - Behavioral 
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

use IEEE.NUMERIC_STD.ALL;


entity eth_tx_stream is Port(
	CLK125 : in STD_LOGIC;
	RESET : in STD_LOGIC;
	TXD : out STD_LOGIC_VECTOR(7 downto 0);
	TXCTRL : out STD_LOGIC;--phy data valid
	--TXC : out STD_LOGIC;--gigabit phy tx clock
	ETH_TX_STREAM : in STD_LOGIC_VECTOR(9 downto 0));
end eth_tx_stream;

architecture Behavioral of eth_tx_stream is
	type multiple is ARRAY(7 downto 0) of STD_LOGIC_VECTOR(7 downto 0);
	signal data_dly : multiple;
	signal frm_dly : STD_LOGIC_VECTOR(7 downto 0) := x"00";
	signal txdat_reg : STD_LOGIC_VECTOR(7 downto 0) := x"00";
	signal txen_reg : STD_LOGIC;
	signal txdat : STD_LOGIC_VECTOR(7 downto 0) := x"00";
	signal txcontrol : STD_LOGIC := '0';
	signal outcnt : unsigned(2 downto 0) := "000";
	signal invert_clk : std_logic;

begin
	
	TXD <= txdat;
	TXCTRL <= txcontrol;

	process(CLK125,RESET)
	begin
		if RESET = '0' then
			for i in 0 to 7 loop
				data_dly(i) <= x"00";
			end loop;
			frm_dly <= x"00";
			txdat_reg <= x"00";
			txen_reg <= '0';
			txdat <= x"00";
			txcontrol <= '0';
		elsif CLK125'event and CLK125 = '1' then
			if ETH_TX_STREAM(9) = '1' then
				--delay the data by eight bytes to insert the preamble
				data_dly(0) <= ETH_TX_STREAM(7 downto 0);
				data_dly(7 downto 1) <= data_dly(6 downto 0);  
				frm_dly <= frm_dly(6 downto 0) & ETH_TX_STREAM(8); 
				--register the data byte to send
				if frm_dly(7) = '1' then 
					txdat_reg <= data_dly(7);
				elsif frm_dly(6) = '1' then 
					txdat_reg <= x"D5";
				else
					txdat_reg <= x"55";
				end if;
				txen_reg <= ETH_TX_STREAM(8) or frm_dly(7); 
				--handle the 100Mbps/1000Mbps modes
				outcnt <= "000";
				txdat <= txdat_reg;
				txcontrol <= txen_reg;
			else
				if outcnt < "111" then
					outcnt <= outcnt + "001";
				else
					outcnt <= outcnt;
				end if;
				if outcnt = "100" then
					txdat <= x"0" & txdat(7 downto 4);
				--else
					--txdat <= txdat;
				end if;
				txcontrol <= txcontrol;
			end if;
		end if;
	end process;
	

end Behavioral;