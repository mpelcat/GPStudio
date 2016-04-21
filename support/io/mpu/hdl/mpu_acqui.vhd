--------------------------------------------------------------------------------------
-- The configuration settings choose by the user are read here. If a modification is
-- detected, a configuration is started with the new values.
-- This bloc generates the triggers to acquire data at the sample rate define by user. 
--------------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;
--USE ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.mpu_pkg.all;

entity mpu_acqui is
port (
		clk_proc			: in std_logic;
		reset				: in std_logic;
		sda				: inout std_logic;
		scl				: inout std_logic;
		AD0				: out std_logic;
		parameters 		: in param;
		accelero			: out flow;
		gyroscope		: out flow;
		compass			: out flow
);
end mpu_acqui;


architecture RTL of mpu_acqui is 

signal en					: std_logic;
signal spl_rate 			: std_logic_vector(7 downto 0);
signal gyro_config 		: std_logic_vector(1 downto 0);
signal accel_config		: std_logic_vector(1 downto 0);
signal gain_compass 		: std_logic_vector(2 downto 0);
signal freq_compass 		: std_logic_vector(2 downto 0);
signal trigger				: std_logic;
signal config_button		: std_logic;
signal wr_en				: std_logic;
signal rd_en				: std_logic;
signal rd_en_dl			: std_logic;
signal data_fifo_in		: std_logic_vector(7 downto 0);
signal count_fifo			: std_logic_vector(5 downto 0);
signal wr_en_dl			: std_logic;
signal wr_en_flag			: std_logic;
signal reset_fifo_buffer: std_logic;
signal trigger_auto 		: std_logic;
signal config_change		: std_logic;
signal en_dl				: std_logic;
signal spl_rate_dl		: std_logic_vector(7 downto 0);
signal gyro_config_dl	: std_logic_vector(1 downto 0);
signal accel_config_dl	: std_logic_vector(1 downto 0);
signal gain_compass_dl	: std_logic_vector(2 downto 0);
signal freq_compass_dl	: std_logic_vector(2 downto 0);
signal run_conf			: std_logic;
signal not_reset			: std_logic;
signal data_fifo_out		: std_logic_vector(7 downto 0);
signal rd_accel,rd_gyro	: std_logic;
signal rd_comp				: std_logic;
signal count_rst_fifo   : unsigned(3 downto 0);
signal count_param		: integer range 0 TO 30_000_000;
signal spl_ratex2			: unsigned(8 downto 0);
signal COUNT_ONE_ACQUI	: INTEGER RANGE 0 TO 30_000_000;
signal spl_rate_mpu		: std_logic_vector(7 downto 0);
signal rd_fifo_count		: std_logic;
signal rd_comp_dl			: std_logic;
signal ready 				: std_logic;
signal rd_ready_f			: std_logic;
signal fifo_mpu_count	: std_logic_vector(15 downto 0);
signal fifo_mpu_res		: unsigned(15 downto 0);
signal data_read 			: std_logic_vector(7 downto 0);
signal wr_en_fifo			: std_logic;


begin


mpu_i2c_inst : entity work.mpu_i2c(behavioral) port map (
	clk   				=> clk_proc,
	en						=> en,
	reset_n				=> reset,
	config_button  	=> config_button,
	trigger 				=> trigger,
	data_read 			=> data_read,
	fifo_wr_en			=> wr_en,
	spl_rate				=> spl_rate_mpu,
	gyro_config			=> gyro_config,
	accel_config		=> accel_config,
	gain_compass		=> gain_compass,
	freq_compass		=> freq_compass,
	reset_fifo_buffer => reset_fifo_buffer,
	run_conf				=> run_conf,
	rd_fifo_count 		=> rd_fifo_count,
	sda 					=> sda,
	scl 					=> scl
	);
	
mpu_fifo_inst_1 : entity work.mpu_fifo(syn) port map (
		aclr			=> not_reset,
		data			=> data_fifo_in,
		rdclk			=> clk_proc,
		rdreq			=> rd_en,
		wrclk			=> clk_proc,
		wrreq			=> wr_en_fifo,
		q				=> data_fifo_out,
		rdempty		=> open,
		rdusedw		=> count_fifo,
		wrfull		=> open
	);

mpu_off_inst : entity work.offset_correction(RTL) port map (
		clk				=> clk_proc,
		reset				=> reset,
		enable			=> en,
		rd_fifo_count  => rd_fifo_count,
		parameters		=> parameters,
		wr_en_flag		=> wr_en_flag,
		wr_fifo			=> wr_en_fifo,
		data_i			=> data_read,
		data_o			=> data_fifo_in
	);

	
------ Generates triggers in order to read data from mpu. Check the mpu internal FIFO count bytes between each trigger
process(clk_proc,reset)
begin
	if reset='0' then
		trigger_auto 		<= '0';
		reset_fifo_buffer <= '0';
		count_param			<= 0;
		count_rst_fifo		<= x"0";
		rd_fifo_count 		<= '0';
		
	elsif clk_proc'event and clk_proc='1' then		----- Generates triggers for reading data from mpu
		if en='1' then 
			
			if spl_rate <= x"0F" then
				spl_rate_mpu	<= x"84"; --60.15hz
			elsif spl_rate <= x"1E" then
				spl_rate_mpu	<= x"57"; --90.9hz  
			elsif spl_rate <= x"3C" then
				spl_rate_mpu	<= x"34"; --150.9hz
			else
				spl_rate_mpu	<= x"19";
			end if;
			
			if run_conf='0' then
				count_param 	<= count_param + 1;

				if count_param < COUNT_ONE_ACQUI-TRIGGER_OR_RST_FIFO_T then 
					rd_fifo_count			<= '0';
					if count_rst_fifo = x"1" then
						trigger_auto 		<= '1';
						reset_fifo_buffer <= '0';
					else
						trigger_auto 		<= '0';
						reset_fifo_buffer <= '1';
					end if;
					
				elsif count_param <= COUNT_ONE_ACQUI-COUNT_FIFO_BYTES_T then  	
						reset_fifo_buffer <= '0';
						trigger_auto 		<= '0';
						if count_rst_fifo=x"0" then
							rd_fifo_count	<= '1';
						end if;
						
				elsif count_param <= COUNT_ONE_ACQUI then  
					
					if count_param = COUNT_ONE_ACQUI then  
						count_rst_fifo 	<= count_rst_fifo+1;
						count_param			<= 0;
						
						if count_rst_fifo = x"1" then				
							count_rst_fifo	<= x"0";	
						end if;
					end if;
				end if;
			else
				count_rst_fifo		<= x"0";
				count_param			<= 0;
				trigger_auto 		<= '0';
				reset_fifo_buffer <= '0';
				rd_fifo_count		<= '0';
			end if;	
		else
			count_rst_fifo		<= x"0";
			count_param			<= 0;
			trigger_auto 		<= '0';
			reset_fifo_buffer <= '0';
			rd_fifo_count		<= '0';	
		end if;
	end if;
end process;

------ Get the parameters set by user.
process(clk_proc,reset)
begin
		if reset='0' then
			spl_rate_dl			<= x"00";
			accel_config_dl	<= "00";
			gyro_config_dl		<= "00";
			gain_compass_dl	<= "000";
			freq_compass_dl	<= "000";
			en_dl					<= '0';
			
		elsif clk_proc'event and clk_proc='1' then
			----- Assignation of the parameters
			en 					<= parameters(0)(31);
			spl_rate 			<= parameters(0)(30 downto 23);
			gyro_config 		<= parameters(0)(22 downto 21);
			accel_config 		<= parameters(0)(20 downto 19);
			gain_compass		<= parameters(0)(18 downto 16);
			freq_compass		<= parameters(0)(15 downto 13);
			config_button		<= config_change;
			
			----- Keep data to detect a change on the configuration
			spl_rate_dl 		<= spl_rate;
			accel_config_dl 	<= accel_config;
			gyro_config_dl 	<= gyro_config;
			gain_compass_dl 	<= gain_compass;
			freq_compass_dl 	<= freq_compass;
			en_dl					<= en;
		end if;
end process;


------ Set Read and Write flags for the FIFO and set data_valid/flow_valid for each flow.
process(clk_proc,reset)
begin
		if reset='0' then
			rd_en_dl 	<= '0';
			rd_en 	 	<= '0';
			rd_accel		<= '0';
			rd_gyro		<= '0';
			rd_comp		<= '0';
			wr_en_dl 	<= '0';
			wr_en_flag  <= '0';	
		
		elsif clk_proc'event and clk_proc='1' then
		
			wr_en_dl 	<= wr_en;
			wr_en_flag  <= wr_en and not wr_en_dl;	
			rd_en_dl 	<= rd_en;
			rd_comp_dl	<= rd_comp;
			
			----- Reading FIFO and set data_valid and flow_valid for each flow
			if rd_fifo_count='1' then
				if count_fifo = "000010" then
					rd_en			<= '1';
				elsif count_fifo = "000001" then	
					rd_en			<= '0';
				end if;
			else
				if rd_en='1' then
					if count_fifo = "010100" then
						rd_accel		<= '1';
					elsif count_fifo = "001111" then
						rd_accel		<= '0';
					elsif count_fifo = "001101" then
						rd_gyro		<= '1';
					elsif count_fifo = "000111" then
						rd_comp 		<= '1';
						rd_gyro		<= '0';
					elsif count_fifo = "000010" then  
						rd_en			<= '0';
						rd_gyro		<= '0';
					end if;
				else
					if count_fifo = "010100" then
						rd_en			<= '1';
					elsif count_fifo = "000000" then
						rd_comp 		<= '0';
					end if;	
				end if;						
			end if;
		end if;
end process;


------ After reading how many bytes are in the FIFO of the mpu, we look if there are only full samples.
------ If one sample is not full, then the data is not read (flag 'ready'=0).
process(clk_proc,reset)
begin
	if reset = '0' then
		ready				<= '0';
		fifo_mpu_res	<= x"0000";
		fifo_mpu_count <= x"0000";
		
	elsif clk_proc'event and clk_proc = '1' then		----- Generate write enable flag for the FIFO
		
		if rd_ready_f='1' then
			fifo_mpu_count <= fifo_mpu_count(7 downto 0) & data_fifo_out;
		else
			fifo_mpu_res 	<= unsigned(fifo_mpu_count) rem 20;
		end if;
		
		if fifo_mpu_res=x"0000" then
			ready <= '1';
		else
			ready <= '0';
		end if;
	
	end if;
end process;


AD0 					<= AD0_value; -- For mpu i2c address
not_reset   		<= not reset; -- Fifo asynchronous reset
trigger 				<= trigger_auto when en='1' else '0'; 		-- Set trigger when enable
rd_ready_f 			<= rd_en_dl and rd_fifo_count and rd_en; 	-- Reading Fifo count bytes from mpu

----- Determine the time between each trigger
spl_ratex2			<= unsigned(spl_rate)&'0';						
COUNT_ONE_ACQUI  	<= to_integer(clk_50M/spl_ratex2);

----- Detecting a modification of the configuration
config_change <= '1' when (spl_rate/=spl_rate_dl or gyro_config/=gyro_config_dl or accel_config/=accel_config_dl 
									or gain_compass/=gain_compass_dl or freq_compass/=freq_compass_dl) or en/=en_dl
					  else '0';		
					
----- Set output flows
accelero.dv 		<= rd_accel and ready;
accelero.fv 		<= rd_accel and ready;
accelero.data  	<= data_fifo_out;

gyroscope.dv 		<= rd_gyro and ready;
gyroscope.fv 		<= rd_gyro and ready;
gyroscope.data  	<= data_fifo_out;

compass.dv 			<= rd_comp and rd_en_dl and ready;
compass.fv 			<= rd_comp and rd_en_dl and ready;
compass.data  		<= data_fifo_out;		

end RTL;
