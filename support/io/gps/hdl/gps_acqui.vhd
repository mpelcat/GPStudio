-------------------------------------------------------------
-- Bloc that contain UART blocs (receiver and transmitter) 
-- and the baud rate generator.
-- It also controls these blocks by detecting the end of a
-- data sequence from receiver, allowing the data to be sent
-- to the usb block.
-- The configuration settings are chosen by the user and
-- written in registers that are read here. It allows to
-- start a configuration depending on those settings. 
-------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.gps_pkg.all;

entity top_GPS is
	port(
			clk			: in std_logic;
			reset 		: in std_logic;
			RXD			: in std_logic;
			TXD			: out std_logic;
			parameters 	: in std_logic_vector(31 downto 0);			
			data_out		: out std_logic_vector(7 downto 0);
			flow_valid 	: out std_logic;
			data_valid 	: out std_logic
		 );
end top_GPS;


architecture RTL of top_GPS is

signal data							: std_logic_vector(7 downto 0);
signal gngga_flag					: std_logic;
signal data_ready					: std_logic;
signal data_ready_dl 			: std_logic;
signal data_ready_dl2 			: std_logic;
signal wr_en,rd_en				: std_logic;
signal fifo_empty   				: std_logic;
signal gngga_flag_dl				: std_logic;
signal rd_en_dl,rd_en_dl2	 	: std_logic;
signal start_flag					: std_logic;
signal done							: std_logic;
signal data_in						: std_logic_vector(7 downto 0);
signal done_dl						: std_logic;
signal data_to_send 				: std_logic_vector(175 downto 0);
signal done_send,done_send_dl : std_logic;
signal checksum					: std_logic_vector(7 downto 0);
signal PL_length					: std_logic_vector(15 downto 0);
signal ID							: std_logic_vector(15 downto 0);
signal PL       					: std_logic_vector(23 downto 0);
signal enable, enable_dl	 	: std_logic;
signal sat_conf,sat_conf_dl 	: std_logic;
signal update_rate 				: std_logic_vector(7 downto 0);
signal update_rate_dl 			: std_logic_vector(7 downto 0);
signal trig_conf,trig_conf_dl : std_logic;
signal count_max 					: unsigned(15 downto 0);
signal bytes						: unsigned(7 downto 0);
signal count_config				: unsigned(3 downto 0);
signal count_bd   				: unsigned(15 downto 0);
signal rst_count_bd_s1 			: std_logic;
signal rst_count_bd_s2			: std_logic;
signal rst_count_bd 				: std_logic;
signal update_rate_s  			: std_logic_vector(7 downto 0);
signal restart_done				: std_logic;
signal fifo_count					: std_logic_vector(7 downto 0);
signal data_fifo_o				: std_logic_vector(7 downto 0);
signal rd_coord					: std_logic;

type state_type is (idle, data_state);
signal state : state_type;

type state_type_t is (idle, send);
signal state_transmitter : state_type_t;

begin

------------------------Instantiating bloks-----------------------

GPS_receiver_inst : entity work.GPS_receiver(RTL)
	port map (
		clk				=> clk,
		reset				=> reset,
		enable 			=> enable,
		RXD				=> RXD,
		data_ready 		=> data_ready,
		data_out			=> data,
		count_bd			=> count_bd,
		count_max		=> count_max,
		rst_count_bd	=> rst_count_bd_s1,
		gngga_flag 		=> gngga_flag
		);
				
gps_transmitter_inst : entity work.gps_transmitter(RTL)
	port map (
		clk				=> clk,
		reset				=> reset,
		enable 			=> enable,
		start_flag 		=> start_flag,
		done				=> done,
		done_send 		=> done_send,		
		count_bd			=> count_bd,
		count_max		=> count_max,
		rst_count_bd	=> rst_count_bd_s2,
		TXD				=> TXD,
		bytes 			=> bytes,
		data_in 			=> data_in
		);		
				
fifo_gps_inst : entity work.fifo_gps(SYN)
	port map (
		clock 			=> clk,
		wrreq 			=> wr_en, 
		rdreq				=> rd_en,
		data 				=> data,
		full 				=> open,
		empty 			=> fifo_empty,
		q 					=> data_fifo_o,--data_out, 
		usedw				=> fifo_count	
		);

clk_gen_inst : entity work.clk_gen(RTL)
	port map (
		clk_50M 			=> clk,
		reset 			=> reset,
		enable 			=> enable,
		count_max 		=> count_max,
		count_bd  		=> count_bd,
		rst_count_bd 	=> rst_count_bd
		);
---------------------------------------------------------------



---------------------Receiver controller-----------------------	
process(clk,enable,reset)
begin
	if reset='0' then
			wr_en 			<= '0';
			rd_en 			<= '0';
			data_ready_dl	<= '0';
			rd_en_dl	<= '0';
			gngga_flag_dl 	<= '0';
			data_ready_dl2 <= '0';
			rd_coord			<= '0';
			
	elsif clk'event and clk='1'then
		if enable='1' then
	  
			data_ready_dl 	<= data_ready;
			data_ready_dl2 <= data_ready_dl;
			gngga_flag_dl 	<= gngga_flag;
			rd_en_dl 		<= rd_en;
			rd_en_dl2		<= rd_en_dl; 
			
			
			flow_valid 		<= rd_coord;--rd_en or rd_en_dl2;--
			data_valid 		<= rd_coord;--rd_en_dl;--
			data_out			<= data_fifo_o;			
			
			case(state) is 
				----- NMEA $GNGGA sequence detected, starting acquisition
				when idle =>
				
					wr_en <= '0';
					
					if fifo_count=x"01" and rd_en='1' then 
						rd_en 	<= '0';
					elsif fifo_count=x"36" and rd_en='1' then
						rd_coord <= '1';
					elsif fifo_count=x"1E" and rd_en ='1' then
						rd_coord	<= '0';
					end if;
																	  
					if gngga_flag='1' and gngga_flag_dl='0' then
						state 	<= data_state;
					else
						state <= idle;
					end if;
					
				----- Write data into FIFO when the full byte have been read from receiver
				when data_state =>
				
					if data_ready_dl='1' and data_ready_dl2='0'then
						
						if data = x"0D" then		----- Detecting end of sequence, read data from FIFO and send them to usb block
							rd_en 	<= '1';
							state 	<= idle;
						else
							wr_en 	<= '1';
						end if;
						
					else
						wr_en 		<= '0';
						state			<=data_state;
					end if;
					
				when others =>
					wr_en 			<= '0';
					rd_en_dl	<= '0';
					state 			<= idle;
			end case;
			
		end if;		
	end if;
end process;


---------------------Set configuration settings-----------------------	
process(clk,reset,enable)
begin
	if reset='0' then
		checksum 		<= x"00";
		PL_length 		<= (others => '0');
		ID 		 		<= (others => '0');
		PL 		 		<= (others => '0');
			
	elsif clk'event and clk='1' and enable='1' then
		if enable='1' then
		  	----- Set Mode (GPS or GPS/Glonass)
			if count_config=x"0" then	
				PL_length 			<= ZERO & LEN_5;
				ID 		 			<= ID_MODE;
				
				if sat_conf='0' then
					checksum 		<= ID_MODE(15 DOWNTO 8) xor ID_MODE(7 DOWNTO 0) xor MODE_GPS_GL;			
					PL 		 		<= ZERO & MODE_GPS_GL & ZERO;
				else
					PL 		 		<= ZERO & MODE_GPS & ZERO;
					checksum 		<= ID_MODE(15 DOWNTO 8) xor ID_MODE(7 DOWNTO 0) xor MODE_GPS;
				end if;
			
			----- Set baud rate (9600 default, set to 921600)
			elsif count_config=x"1" then	
				PL_length 			<= ZERO & LEN_4;
				ID 					<= ID_BAUD_RATE;
				checksum 			<= ID_BAUD_RATE(15 DOWNTO 8) xor BAUD_RATE_MAX;
				PL(15 downto 0)	<= BAUD_RATE_MAX & ZERO;
		
			----- Set update rate (from 1Hz to 40Hz)
			elsif count_config=x"2" then
				PL_length 			<= ZERO & LEN_3;
				ID(7 downto 0) 	<= ID_UPDATE_RATE;
				
				if sat_conf='0' and update_rate_s>UPDATE_RATE_MAX_GL then	--Mode GPS/Glonass limited to 20Hz	
					checksum 		<= ID_UPDATE_RATE xor UPDATE_RATE_MAX_GL;
					PL(15 downto 0)<= UPDATE_RATE_MAX_GL & ZERO;
				else
					checksum <= ID_UPDATE_RATE xor update_rate_s;
					PL(15 downto 0)<= update_rate_s & ZERO;
				end if;		
				
			else
				checksum 			<= ZERO;
				PL_length 			<= (others => '0');
				ID 		 			<= (others => '0');
				PL 		 			<= (others => '0');
			end if;
			
			-----To solve defaults values issues
			if update_rate/=x"01" and update_rate/=x"02" and update_rate/=x"04" and update_rate/=x"05"
				and update_rate/=x"08" and update_rate/=x"0A" and update_rate/=x"14" and update_rate/=x"19" and update_rate/=x"28" then
				
				update_rate_s		<= x"01";
			else
				update_rate_s		<= update_rate;
			end if;
		
		end if;	
	end if;
end process;

---------------------Set configuration settings-----------------------
process(clk,enable,reset)
begin
		if reset='0' then
			count_max 			<= COUNT_BD_RATE_DEFAULT;
			bytes					<= x"00";
			count_config 		<= x"0";
			restart_done 		<= '0';
			
		elsif clk'event and clk='1'then
		  if enable='1' then
		  
			enable_dl			<= enable;
			sat_conf_dl  		<= sat_conf;
			update_rate_dl		<= update_rate;	
			trig_conf_dl 		<= trig_conf;
			done_dl 				<= done;
			done_send_dl	   <= done_send;
			data_in 				<= data_to_send(175 downto 168);
			
			case(state_transmitter) is
				
			when idle =>
				----- Modification of the configuration detected
				if trig_conf_dl='1' or count_config/=x"0" then
					state_transmitter	<= send;
					start_flag 			<= '1';
					
					----- Writing the new Mode
					if count_config=x"0" then
						data_to_send(175 downto 80) <= START_BYTES & PL_length & ID & PL & checksum & END_BYTES;
						bytes				<= LEN_CONF_MODE;
						count_config 	<= count_config+1;
						
					----- Writing the new baud rate
					elsif count_config=x"1" then
						data_to_send(175 downto 88) <= START_BYTES & PL_length & ID & PL(15 downto 0) & checksum & END_BYTES;
						bytes				<= LEN_CONF_BD_RATE;
						count_config 	<= count_config+1;	
					
					----- Writing the new update rate
					elsif count_config=x"2" then
						data_to_send(175 downto 96) <= START_BYTES & PL_length & ID(7 downto 0) & PL(15 downto 0) & checksum & END_BYTES; 
						bytes				<= LEN_CONF_UPDATE;
						if restart_done='1' then
							count_config 	<= x"0";
						else	
							count_config 	<= count_config+1;
						end if;
						
					----- Restart only once after changing baud rate
					elsif count_config=x"3" then
						data_to_send <= START_BYTES & RESTART & END_BYTES;
						bytes 			<= LEN_CONF_RESTART;
						count_config 	<= x"0";
						restart_done 	<= '1';
					else
						count_config 	<= x"0";
					end if;			
					
				else
					start_flag 				<= '0';
					state_transmitter		<= idle;
				end if;
				
			when send =>
				----- Shift to send the next byte of data
				if done = '1' and done_dl='0' then
					data_to_send	<= data_to_send(167 downto 0) & data_to_send(175 downto 168);
				end if;
				
				----- Detect end of configuration, set new baud rate counter
				if done_send='1' and done_send_dl='0' then
					state_transmitter 	<= idle;
					if bytes=LEN_CONF_BD_RATE then
						count_max 	<= COUNT_BD_RATE_MAX;
					end if;
				end if;
				
			when others =>
				state 	<= idle;
				
			end case;
		
		end if;
	end if;
end process;

----- Read user settings
enable 			<= parameters(31);
sat_conf  		<= parameters(30);
update_rate  	<= parameters(29 downto 22);

rst_count_bd <= rst_count_bd_s1 or rst_count_bd_s2;
	
----- Detect a modification on the actual configuration
trig_conf 		<= '1' when ((update_rate_dl/=update_rate or sat_conf_dl/=sat_conf) and enable='1') or (enable='1' and enable_dl='0') 
							 else '0';
					  

end RTL;
