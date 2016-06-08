library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.COM_package.all;

entity filter is
	port (	   
				RXCLK				: in std_logic;
				reset_n			: in std_logic;
				RX_i 				: in gmii_t;
				RX_o 				: out gmii_t;
				port_detected	: out std_logic_vector(15 downto 0)
		);
end filter;

architecture RTL of filter is

type filter_fsm is (idle,mac,ip,port_st,data);
signal state	: filter_fsm;

signal dreamcam_mac	: std_logic_vector(47 downto 0);
signal dreamcam_ip	: std_logic_vector(31 downto 0);
signal dreamcam_port	: std_logic_vector(15 downto 0);

signal rcv_mac			: std_logic_vector(47 downto 0);
signal rcv_ip			: std_logic_vector(31 downto 0);
signal rcv_port		: std_logic_vector(15 downto 0);
signal count			: unsigned(7 downto 0);
signal dv_dl			: std_logic;
signal mac_f			: flag;
signal ip_f				: flag;
begin

dreamcam_mac	<= x"005043430001";
dreamcam_ip		<= x"01020304";
dreamcam_port	<= x"8000";



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
					
			when mac =>				
					if count = x"05" then
						state <= ip;
						count	<= x"00";
						if rcv_mac=dreamcam_mac then
							mac_f.good	<='1';
						else
							mac_f.bad	<='1';
						end if;
					else
						rcv_mac <= rcv_mac(39 downto 0) & RX_i.data;
						count <= count +1;
					end if;				
					
			when ip =>
					count <= count +1;
					if count > x"16" then	
						if count = x"1B" then
							state <= port_st;
							count	<= x"00";
							if rcv_ip=dreamcam_ip then
								ip_f.good	<='1';
							else
								ip_f.bad		<='1';
							end if;
						else
							rcv_ip <=rcv_ip(23 downto 0) & RX_i.data;
						end if;
					end if;
					
					
			when port_st =>
					count <= count +1;
					if count > x"00" then
						if count = x"03" then
							state <= data;
							count	<= x"00";
							port_detected	<= rcv_port;
						else
							rcv_port <=rcv_port(7 downto 0) & RX_i.data;
						end if;
					end if;
					
			when data =>
					count <= count +1;
					if count > x"02" then
						if mac_f.good='1' and ip_f.good='1' then
							RX_o	<= RX_i;
							if RX_i.dv='0' then
								state <= idle;
							end if;
						else
							state 		<= idle;
							RX_o.dv 		<= '0';
							RX_o.data	<= x"00";
						end if;
					end if;
					
			when others =>
				state <= idle;			
		
		end case;
	end if;
	
end process;	


end RTL;