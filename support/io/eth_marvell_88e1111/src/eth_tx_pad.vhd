library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity eth_tx_pad is Port(
	CLK : in STD_LOGIC;
	RESET : in STD_LOGIC;
	IN_ETH_STREAM : in STD_LOGIC_VECTOR(9 downto 0);
	OUT_ETH_STREAM : out STD_LOGIC_VECTOR(9 downto 0));
end eth_tx_pad;

architecture Behavioral of eth_tx_pad is
	signal state : unsigned(6 downto 0) := "0000000";
	signal next_state : unsigned(6 downto 0) := "0000000";
	constant min_packet : unsigned(6 downto 0) := "1001000"; 
begin
	process(CLK,RESET)
	begin
		if RESET = '0' then
			state <= "0000000";
			OUT_ETH_STREAM <= "00" & x"00";
		elsif CLK'event and CLK = '1' then

			if IN_ETH_STREAM(9) = '1' then
				state <= next_state;
				OUT_ETH_STREAM(9) <= '1';
				if next_state = "0000000" then
					OUT_ETH_STREAM(8) <= '0';
				else
					OUT_ETH_STREAM(8) <= '1';--extend frame signal, if need be
				end if;
				if IN_ETH_STREAM(8) = '1' then--route data out normally
					OUT_ETH_STREAM(7 downto 0) <= IN_ETH_STREAM(7 downto 0);
				else--replace data with 0 when padding packet
					OUT_ETH_STREAM(7 downto 0) <= x"00";
				end if;
			else
				state <= state;
				OUT_ETH_STREAM(9) <= '0';
			end if;
		end if;
	end process;
	
	process(state, IN_ETH_STREAM(8))
	begin
		case state is
		when "0000000" =>
			if IN_ETH_STREAM(8) = '1' then--when frame signal turns high,
				next_state <= "0000001";--begin looking at the new packet
			else
				next_state <= "0000000";
			end if;
		when min_packet =>--60 bytes have been seen
			if IN_ETH_STREAM(8) = '0' then--wait until packet finished
				next_state <= min_packet + "0000001";--to append extra 4 bytes
			else
				next_state <= min_packet;
			end if;
		when "1001100" =>                                        
			next_state <= "0000000";
		when others =>
			next_state <= state + "0000001";
		end case;
	end process;
end Behavioral;

