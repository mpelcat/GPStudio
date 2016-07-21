-- This code filters the incoming packet (MAC + IP) and extract some other infos such as size or the port.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ethernet_package.all;

entity eth_udp_filter is
	port (	   
				RXCLK				: in std_logic;
				reset_n			    : in std_logic;
				RX_i 				: in gmii_t;
				RX_o 				: out gmii_t;
                mac_addr_hal_msb    : in std_logic_vector(23 downto 0);
                mac_addr_hal_lsb    : in std_logic_vector(23 downto 0);
                ip_hal              : in std_logic_vector(31 downto 0);
				port_detected	    : out std_logic_vector(15 downto 0)
		);
end eth_udp_filter;

architecture RTL of eth_udp_filter is

type filter_fsm is (idle,mac,size_st,ip,port_st,data);
signal state	: filter_fsm;

signal rcv_mac			: std_logic_vector(47 downto 0);
signal rcv_ip			: std_logic_vector(31 downto 0);
signal rcv_port		    : std_logic_vector(15 downto 0);
signal count			: unsigned(7 downto 0);
signal rcv_size		    : std_logic_vector(15 downto 0);
signal count_data       : unsigned(15 downto 0);
signal size_detected	: unsigned(15 downto 0);
signal dv_dl			: std_logic;
signal mac_f			: flag;
signal ip_f				: flag;
begin

process(RXCLK,reset_n)
begin
	if reset_n='0' then
		state 		<= idle;			
		count 		<= x"00";
		mac_f.good	<='0';
		mac_f.bad	<='0';							
		RX_o.dv 		<= '0';
		RX_o.data	<= x"00";
		
	elsif RXCLK'event and RXCLK='1' then
		dv_dl		<= RX_i.dv;
		case(state) is
		
			when idle =>
					if RX_i.dv = '1' and  dv_dl='0' then
						state <= mac;
						count <= x"00";
						rcv_mac(7 downto 0) <= RX_i.data;
					elsif RX_i.dv = '0' then
						mac_f.good 		<= '0';
						mac_f.bad 		<= '0';
						ip_f.bad 		<= '0';
						ip_f.good 		<= '0';
					end if;
			
            -- Check if MAC address fit the value in eth_slave		
			when mac =>				
					if count = x"05" then
						state   <= size_st;
						count	<= x"00";
						if rcv_mac = mac_addr_hal_msb & mac_addr_hal_lsb then
							mac_f.good	<='1';
						else
							mac_f.bad	<='1';
						end if;
					else
						rcv_mac <= rcv_mac(39 downto 0) & RX_i.data;
						count <= count +1;
					end if;				
			
            -- Get size of the packet
            when size_st =>
                    count <= count +1;
					if count > x"08" then	
						if count = x"0A" then
							state           <= ip;
							count	        <= x"00";
						end if;
						rcv_size        <= rcv_size(7 downto 0) & RX_i.data;
					end if;
          
            -- Check if IP address fit the value in eth_slave
			when ip =>
                    size_detected	<= unsigned(rcv_size) - x"1C"; -- 28 bytes of ip header + udp header 
					count           <= count +1;
					if count > x"0B" then	
						if count = x"10" then
							state <= port_st;
							count	<= x"00";
							if rcv_ip = ip_hal then
								ip_f.good	<='1';
							else
								ip_f.bad		<='1';
							end if;
						else
							rcv_ip <=rcv_ip(23 downto 0) & RX_i.data;
						end if;
					end if;
					
			-- Get port		
			when port_st =>
					count <= count +1;
					if count > x"00" then
						if count = x"03" then
							state           <= data;
                            count_data      <= x"0000";
							count	        <= x"00";
							port_detected	<= rcv_port;
						else
							rcv_port <=rcv_port(7 downto 0) & RX_i.data;
						end if;
					end if;
			
            -- If MAC and IP are verified then the data is transmitted to the next block		
			when data =>
					count <= count +1;
					if count > x"02" then
						if mac_f.good='1' and ip_f.good='1' then
                            count_data  <= count_data+1;
							if RX_i.dv='0' or count_data=size_detected then
								state       <= idle;
                                RX_o.dv 	<= '0';
                            else
                                RX_o	    <= RX_i;
							end if;
						else
							state 		<= idle;
							RX_o.dv 	<= '0';
							RX_o.data	<= x"00";
						end if;
					end if;
					
			when others =>
				state <= idle;			
		
		end case;
	end if;
	
end process;	


end RTL;
