library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.ethernet_package.all;

entity eth_slave is 
generic (pi_size_addr 		: integer:=3);
Port(
		CLK 					: in STD_LOGIC;
		RESET_n 				: in STD_LOGIC;
		addr_rel_i			    : in std_logic_vector(pi_size_addr downto 0);
		wr_i					: in std_logic;
		rd_i					: in std_logic;
		datawr_i				: in std_logic_vector(31 downto 0);
		datard_o				: out std_logic_vector(31 downto 0);
		
		--- parameters com
		enable_eth_o  		    : out std_logic;
		enable_in0_o 		    : out std_logic;
		enable_in1_o 		    : out std_logic;
		enable_in2_o 		    : out std_logic;
		enable_in3_o 		    : out std_logic;
        
        --- parameters ethernet
        mac_addr_hal_msb        : out std_logic_vector(23 downto 0);
        mac_addr_hal_lsb        : out std_logic_vector(23 downto 0);
        mac_addr_dest_msb       : out std_logic_vector(23 downto 0);
        mac_addr_dest_lsb       : out std_logic_vector(23 downto 0);
        ip_hal                  : out std_logic_vector(31 downto 0);
        ip_dest                 : out std_logic_vector(31 downto 0);
        port_dest               : out std_logic_vector(15 downto 0) 
		);
end eth_slave;


architecture RTL of eth_slave is

constant MAC_ADDR_HAL_MSB_ADDR  : integer := 0;
constant MAC_ADDR_HAL_LSB_ADDR  : integer := 1;
constant MAC_ADDR_DEST_MSB_ADDR : integer := 2;
constant MAC_ADDR_DEST_LSB_ADDR : integer := 3;
constant IP_HAL_ADDR            : integer := 4;
constant IP_DEST_ADDR           : integer := 5;
constant PORT_DEST_ADDR         : integer := 6;

constant ENABLE_ETH_ADDR        : integer := 7;
constant ENABLE_IN0_ADDR        : integer := 8;
constant ENABLE_IN1_ADDR        : integer := 9;
constant ENABLE_IN2_ADDR        : integer := 10;
constant ENABLE_IN3_ADDR        : integer := 11;

begin

REG:process (clk, RESET_n) 
begin
	if (RESET_n = '0') then	
		enable_eth_o <= '1';
		enable_in0_o <= '1';
		enable_in1_o <= '1';
		enable_in2_o <= '1';
		enable_in3_o <= '1';
        mac_addr_hal_msb    <= x"005043";
        mac_addr_hal_lsb    <= x"430001";
		mac_addr_dest_msb   <= x"7845C4";
        mac_addr_dest_lsb   <= x"192509";
        ip_hal              <= x"AC010203";
        ip_dest             <= x"AC1B016D";
        port_dest           <= x"7FFF";
        
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
                when std_logic_vector(to_unsigned(MAC_ADDR_HAL_MSB_ADDR,pi_size_addr+1)) =>		
					mac_addr_hal_msb <= datawr_i(23 downto 0);
                when std_logic_vector(to_unsigned(MAC_ADDR_HAL_LSB_ADDR,pi_size_addr+1)) =>		
					mac_addr_hal_lsb <= datawr_i(23 downto 0);
                when std_logic_vector(to_unsigned(MAC_ADDR_DEST_MSB_ADDR,pi_size_addr+1)) =>		
					mac_addr_dest_msb <= datawr_i(23 downto 0);
                when std_logic_vector(to_unsigned(MAC_ADDR_DEST_LSB_ADDR,pi_size_addr+1)) =>		
					mac_addr_dest_lsb <= datawr_i(23 downto 0);
                when std_logic_vector(to_unsigned(IP_HAL_ADDR,pi_size_addr+1)) =>		
					ip_hal      <= datawr_i;
                when std_logic_vector(to_unsigned(IP_DEST_ADDR,pi_size_addr+1)) =>		
					ip_dest     <= datawr_i;
                when std_logic_vector(to_unsigned(PORT_DEST_ADDR,pi_size_addr+1)) =>		
					port_dest   <= datawr_i(15 downto 0);
				when others =>
			end case;
		end if;	
	end if;
end process;


end RTL;
