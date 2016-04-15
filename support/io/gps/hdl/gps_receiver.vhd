--------------------------------------------------------
-- UART receiver block. It detects the falling edge of
-- the signal from RXD pin and start acquiring data. 
-- If the NMEA $GNGGA sequence is detected, the data are
-- written in the FIFO.
--------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity GPS_receiver is
	port(
			clk				: in std_logic;
			reset 			: in std_logic;
			enable 			: in std_logic;
			RXD				: in std_logic;
			data_ready		: out std_logic;
			data_out			: out std_logic_vector(7 downto 0);
			count_bd			: in unsigned(15 downto 0);
			count_max		: in unsigned(15 downto 0);
			rst_count_bd	: out std_logic;	
			gngga_flag		: out std_logic
		 );
end GPS_receiver;


architecture RTL of GPS_receiver is

signal number_of_bits	: unsigned(3 downto 0);
signal data_out_s			: std_logic_vector(7 downto 0);
signal gngga				: std_logic_vector(55 downto 0);
signal RXD_s				: std_logic;

type type_state is (idle, start, data, stop);
signal state_rec : type_state;


begin

process(clk,reset)
begin
	if reset='0' then
	
			state_rec 		<= idle;
			gngga_flag 		<= '0';
			data_ready 		<= '0';
			rst_count_bd 	<= '0';

	elsif clk'event and clk='1' then
		if enable='1' then
	  
			RXD_s <= RXD;
			
			case(state_rec) is 
				----- Detecting the beginning of a communication
				when(idle) => 
				
						gngga_flag 	<= '0';
						data_ready 	<= '0';
						
						if RXD = '0' or RXD_s='0' then
							state_rec 		<= start;
							rst_count_bd 	<= '1';
						end if;
				
				----- Start bit is read
				when(start) =>
				
						rst_count_bd <='0';
						
						if count_bd>=count_max/2 then
							state_rec 		<= data;	
							rst_count_bd 	<= '1';
						end if;
				
				----- 8 bits of data are read (LSB first)		
				when(data) =>		
						
						rst_count_bd <='0';
						
						if count_bd=count_max then
							data_out_s 		<= RXD & data_out_s(7 downto 1); 
							number_of_bits <= number_of_bits +1;
							
							if number_of_bits = x"7" then
								state_rec 		<= stop;
								number_of_bits <= x"0";
							end if;	
						end if;
						
				----- Stop bit, the detection of the NMEA $GNGGA sequence is check
				when(stop) =>		
				
					data_out <= data_out_s;
					
					if count_bd+1>=count_max then		
						state_rec <= idle;
						
						if gngga=x"24474E4747412C" or gngga(15 downto 0)=x"A0A1" then --or gngga=x"24474E4753412C"then
							gngga_flag		<= '1';
							data_ready 		<= '0';
						else
							data_ready 		<= '1';
						end if;
						
					elsif count_bd=count_max-5 then 
							gngga <= gngga(47 downto 0) & data_out_s;
					end if;
						
			end case;

		end if;	
	end if;
end process;

end RTL;
