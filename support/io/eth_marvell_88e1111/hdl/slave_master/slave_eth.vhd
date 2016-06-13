library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.ethernet_package.all;

entity slave_eth is 
generic (pi_size_addr 		: integer:=3);
Port(
		CLK 					: in STD_LOGIC;
		RESET_n 				: in STD_LOGIC;
		addr_rel_i			: in std_logic_vector(pi_size_addr downto 0);
		wr_i					: in std_logic;
		rd_i					: in std_logic;
		datawr_i				: in std_logic_vector(31 downto 0);
		datard_o				: out std_logic_vector(31 downto 0);
		
		--- parameters
		enable_eth_o  		: out std_logic;
		enable_in0_o 		: out std_logic;
		enable_in1_o 		: out std_logic;
		enable_in2_o 		: out std_logic;
		enable_in3_o 		: out std_logic
		);
end slave_eth;


architecture RTL of slave_eth is

constant ENABLE_ETH_ADDR : integer := 0;
constant ENABLE_IN0_ADDR : integer := 1;
constant ENABLE_IN1_ADDR : integer := 2;
constant ENABLE_IN2_ADDR : integer := 3;
constant ENABLE_IN3_ADDR : integer := 4;

begin

REG:process (clk, RESET_n) 
begin
	if (RESET_n = '0') then	
		enable_eth_o <= '1';
		enable_in0_o <= '1';
		enable_in1_o <= '1';
		enable_in2_o <= '1';
		enable_in3_o <= '1';
		
	elsif rising_edge(clk) then
		if(wr_i = '1') then
			case addr_rel_i is
				when std_logic_vector(to_unsigned(ENABLE_ETH_ADDR,pi_size_addr+1)) =>		
					enable_eth_o <= datawr_i(0);
				when std_logic_vector(to_unsigned(ENABLE_IN0_ADDR,pi_size_addr+1)) =>		
					enable_in0_o <= datawr_i(0);
				when std_logic_vector(to_unsigned(ENABLE_IN1_ADDR,pi_size_addr+1)) =>		
					enable_in1_o <= datawr_i(0);
				when std_logic_vector(to_unsigned(ENABLE_IN2_ADDR,pi_size_addr+1)) =>		
					enable_in2_o <= datawr_i(0);
				when std_logic_vector(to_unsigned(ENABLE_IN3_ADDR,pi_size_addr+1)) =>		
					enable_in3_o <= datawr_i(0);
				when others =>
			end case;
		end if;	
	end if;
end process;


end RTL;