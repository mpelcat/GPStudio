-----------------------------------------------------------------------
-- UART transmitter block. It sends the data to the GPS at the baud rate 
-- defined. The data are sent following the Skytraq binary protocol.
-----------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.gps_pkg.all;

entity gps_transmitter is
	port(
			clk				: in std_logic;
			reset 			: in std_logic;
			enable 			: in std_logic;
			start_flag 		: in std_logic;
			done				: out std_logic;
			done_send 		: out std_logic;			
			count_bd			: in unsigned(15 downto 0);
			count_max		: in unsigned(15 downto 0);
			rst_count_bd	: out std_logic;
			TXD				: out std_logic;
			bytes 			: in unsigned(7 downto 0);
			data_in			: in std_logic_vector(7 downto 0)
		 );
end GPS_transmitter;


architecture RTL of gps_transmitter is

signal number_of_bits	: unsigned(3 downto 0);
signal data_out_s			: std_logic_vector(7 downto 0);
signal gngga				: std_logic_vector(55 downto 0);
signal g_flag				: std_logic;
signal data_to_send		: std_logic_vector(7 downto 0);
signal count_bytes		: unsigned(7 downto 0);
signal count_wait			: unsigned(15 downto 0);
signal TXD_r				: std_logic;

type type_state is (idle, start, data, wait_st, stop);
signal state : type_state;

begin

process(clk,reset,enable)
begin
	if reset='0' then
		rst_count_bd <='0';
		number_of_bits <= x"0";
		TXD_r <= '1';
		state <= idle;
		
	elsif clk'event and clk='1'then
		if enable='1' then
			
			case(state) is 
				----- Starting a communication
				when(idle) => 
				
					done			<= '0';
					done_send 	<= '0';
					TXD_r 		<= '1';
					
					if start_flag='1' then
						state 		 	<= start;
						data_to_send 	<= data_in;
						rst_count_bd 	<= '1';							
					end if;
				
				----- Writing start bit
				when(start) =>
			
					rst_count_bd 	<= '0';
					data_to_send 	<= data_in;
					done				<= '0';
					TXD_r 			<= '0';
					
					if count_bd=count_max then
						state 			<= data;
						number_of_bits <= x"0";
					end if;
						
				----- Writing the 8 bits of data (LSB first)
				when(data) =>	
			
					TXD_r <= data_to_send(0);
					
					if count_bd=count_max then
						data_to_send <= '0' & data_to_send(7 downto 1);	
						if number_of_bits= x"7" then
							state 	<= stop;
						else
							number_of_bits <= number_of_bits +1;
						end if;
					end if;
						
				----- Write stop bit
				when(stop) =>		
						
					TXD_r <= '1';
					
					if count_bd=count_max then
						done				<= '1';
						number_of_bits <= x"0";
						count_bytes 	<= count_bytes +1;
						if count_bytes=bytes-1 then
							if count_max=COUNT_BD_RATE_MAX then
								count_wait 	<= x"0000";
							else
								count_wait 	<= x"7000";
							end if;
							state 		<= wait_st;
						else	
							state 	<= start;			
						end if;
					end if;
					
				----- Full sequence sended, waiting before sending a new one
				when wait_st =>
				
					TXD_r <= '1';
					
					if count_bd=count_max then
						count_wait <= count_wait +1;
					elsif count_wait=x"FFFF" then 
						state 		<= idle;
						count_bytes <= x"00";
						done_send 	<= '1';
					end if;
						
				when others =>						
						TXD_r 		<= '1';
						state 		<= idle;
			end case;
		
		else
			rst_count_bd <='0';
			number_of_bits <= x"0";
			TXD_r <= '1';
			state <= idle;
		end if;
	end if;
end process;

TXD <= TXD_r;

end RTL;
