--------------------------------------------------------------------------------------
-- This bloc handles the control of the i2c communication block (mpu_i2c_master.vhd)
-- It receive the data and place them into a FIFO. When a full sample is detected,
-- data are sent to usb block.
--------------------------------------------------------------------------------------


LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.mpu_pkg.all;

ENTITY mpu_i2c IS
  PORT(
    clk						: in std_logic;
    en						: in std_logic;								--Enable
    reset_n   				: IN STD_LOGIC;                   		--active low reset
    config_button    	: in std_logic;								--active la config des registres de l'IMU
    trigger		    		: in std_logic;								--lance une lecture du registre (possibilité de burst read)
    data_read 				: out std_logic_vector(7 downto 0);		--données lues 
    fifo_wr_en				: out std_logic;								--écriture des données dans la fifo
    spl_rate				: in std_logic_vector(7 downto 0);   	--Parametres
    gyro_config			: in std_logic_vector(1 downto 0);		--
    accel_config			: in std_logic_vector(1 downto 0);		--
	 gain_compass			: in std_logic_vector(2 downto 0);
	 freq_compass			: in std_logic_vector(2 downto 0);
    reset_fifo_buffer	: in std_logic;   							--Reset le buffer de la FIFO
	 run_conf				: out std_logic;
    sda       				: INOUT STD_LOGIC;                     --serial data output of i2c bus
    scl       				: INOUT STD_LOGIC                      --serial clock output of i2c bus
	 );
	
END mpu_i2c;


ARCHITECTURE behavioral OF mpu_i2c IS

type state_fsm is (idle,init,read_state, write_state);
signal state : state_fsm;

type state_config is (waiting, config);
signal state_conf : state_config;

component mpu_i2c_master IS
  PORT(
    clk       			: IN     STD_LOGIC;                    
    reset_n   			: IN     STD_LOGIC;                    
    end_rw				: out std_logic;
    master_ack_flag  : out std_logic;
    op_counter			: out std_logic;
    fifo_wr_en			: out std_logic;
    ena       			: IN     STD_LOGIC;                    
    addr      			: IN     STD_LOGIC_VECTOR(6 DOWNTO 0); 
    rw        			: IN     STD_LOGIC;                    
    data_wr   			: IN     STD_LOGIC_VECTOR(7 DOWNTO 0); 
    busy      			: OUT    STD_LOGIC;                    
    data_rd   			: OUT    STD_LOGIC_VECTOR(7 DOWNTO 0); 
    ack_error 			: BUFFER STD_LOGIC;                    
    sda       			: INOUT  STD_LOGIC;                    
    scl       			: INOUT  STD_LOGIC);
END component;

signal clk_s 		   : std_logic;
signal reset_n_s 	   : std_logic;
signal ena_s 		   : std_logic;
signal rw_s 		   : std_logic;
signal data_wr_s 	   : std_logic_vector(7 downto 0);
signal addr_s 		   : std_logic_vector(6 downto 0);
signal busy_s 	  	   : std_logic;
signal data_rd_s 	   : std_logic_vector(7 downto 0);
signal end_rw_s 	   : std_logic;

signal master_ack_flag 	: std_logic;
signal register_number 	: std_logic_vector(7 downto 0);
signal data_to_w 	   	: std_logic_vector(7 downto 0);
signal prev_end_rw 	   : std_logic;
signal count_ack 	   	: std_logic_vector(7 downto 0);
signal detect_config   	: std_logic;
signal trig_read_dl	   : std_logic;
signal trig		   	   : std_logic;
signal op_counter_f    	: std_logic;
signal op_counter_f_dl 	: std_logic;
signal op_counter	   	: std_logic_vector(7 downto 0);

signal reset_fifo_flag 	: std_logic;
signal reset_fifo_dl   	: std_logic;
signal run_conf_s			: std_logic;

begin

mpu_i2c_master_inst : entity work.mpu_i2c_master(logic)
generic map (input_clk => 50_000_000 ,bus_clk => 400_000)
port map(
    clk       			=> clk,
    reset_n  			=> reset_n,
    end_rw  			=> end_rw_s,
    master_ack_flag 	=> master_ack_flag,
    op_counter			=> op_counter_f,
    fifo_wr_en 		=> fifo_wr_en,
    ena       			=> ena_s,
    addr      			=> addr_s,
    rw        			=> rw_s,
    data_wr   			=> data_wr_s,
    busy      			=> busy_s,
    data_rd   			=> data_rd_s,
    ack_error 			=> open,
    sda       			=> sda, 
    scl       			=> scl

);


process(clk,reset_n)
begin
	
	if reset_n='0' then
		state <= idle;
		rw_s <= '1';
		ena_s <= '0';

	elsif clk'event and clk='1' then
		
	
			trig_read_dl 		<= trigger;
			trig 					<= trigger and not trig_read_dl;
			prev_end_rw 		<= end_rw_s;
			reset_fifo_dl 		<= reset_fifo_buffer;
			reset_fifo_flag 	<= reset_fifo_buffer and not reset_fifo_dl;
			
		case (state) is
		
			when idle =>
			   
			   if en='1' then
															
					if ((busy_s='0' and (trig='1' or run_conf_s='1')) or reset_fifo_flag='1') then		----- Start of communication detected	
						state <= init;
					else
						state <= idle;
					end if;
			   end if;
			
			when init =>
			
				rw_s 			<= '0';
				ena_s 		<= '1';
				data_wr_s 	<= register_number;
				
				if state_conf=config or reset_fifo_buffer='1' then		----- Write mode : configuration
							state <= write_state;
				else
						if end_rw_s = '1' then		----- Read mode : data acquisition
							state <= read_state;
						end if;
						
				end if;

			when read_state =>
			
					rw_s <= '1';
					
					if master_ack_flag = '1' then			
						data_read <= data_rd_s;
						
						if end_rw_s='1' and prev_end_rw='0' then
							count_ack <= count_ack +1;
							state 	 <= read_state;
						end if;
									
						if count_ack=x"14" then		----- Full sample detected in the FIFO
							state 		<= idle;
							ena_s 		<= '0';
							count_ack 	<= x"00";
						end if;
						
					end if;
					
			when write_state =>
			
					rw_s <= '0';	
					
					if end_rw_s='1' and prev_end_rw='0' then		----- Counting acknowledges
						count_ack 	<= count_ack +1;
						state 		<= write_state;
					end if;
					
					if count_ack =x"01" then							
						data_wr_s 	<= data_to_w;		----- Sending data to write in the MPU internal register							
						
					elsif count_ack=x"02" then 
						state 		<= idle;
						ena_s 		<= '0';
						count_ack 	<= x"00";
					
					else 
						data_wr_s 	<= register_number;		----- Sending the internal register ID
					end if;
					
				
			when others => 
					state <= idle;
		end case;	
	end if;
	
end process;


process(clk, reset_n)
begin
	if reset_n ='0' then
		register_number 	<= x"00";
		data_to_w			<= x"00";
		op_counter			<= x"00";
		addr_s 				<= ADDR_I2C_MPU;
		run_conf_s				<= '0';
		
	elsif clk'event and clk='1' then	
	
		----- Counting configuration operations 
		op_counter_f_dl <= op_counter_f;		
		if op_counter_f='1' and op_counter_f_dl='0' then
			if (op_counter < x"11") then
				op_counter <= op_counter +1;
			else
				op_counter <= x"00";
			end if;
			
		end if;
		
		
		case(state_conf) is 
		
			when waiting => 
			
						op_counter 			<= x"00";
						
					----- Reset fifo buffer to avoid latence issues
					if reset_fifo_buffer='1' then		
						addr_s 				<= ADDR_I2C_MPU;
						register_number 	<= USER_CTRL;
						data_to_w 			<= x"64";
					
					----- Reading data from the internal FIFO of the MPU-6050
					else
						addr_s 				<= ADDR_I2C_MPU;
						register_number 	<= FIFO_READ;
						data_to_w 			<= x"00";
					end if;
					
					----- Modification of the configuration settings detected, starting a configuration sequence
					if config_button = '1' then
						state_conf			<= config;
					else	
						state_conf			<= waiting;
						run_conf_s				<= '0';
					end if;
			
			when config =>
					
									
						----- Sortie du mode "Pause"
						if op_counter=x"00" then
							addr_s 				<= ADDR_I2C_MPU;
							register_number 	<= PWR_MGMT_1;
							data_to_w     		<= x"01";
							run_conf_s				<= '1';
							
						----- FIFO enable
						elsif op_counter=x"01" then			
							register_number 	<= USER_CTRL;
							data_to_w			<= x"40";
							
						----- Accelerometer configuration	
						elsif op_counter=x"02" then			
							register_number	<= ACCEL_CONFIG_REG;
							data_to_w			<= "000" & accel_config & "000";
						
						------ Sample rate	
						elsif op_counter=x"03" then
							register_number 	<= SMPLRT_DIV;	
							data_to_w			<= spl_rate;
							
						----- Data to place in internal FIFO	
						elsif op_counter = x"04" then
							register_number 	<= FIFO_EN;
							data_to_w 			<= x"F9";---x"F8" sans compass
							
						----- Gyroscope configuration
						elsif op_counter=x"05" then
							register_number	<= GYRO_CONFIG_REG;
							data_to_w			<= "000" & gyro_config & "000";	
							
						----- Bypassing MPU : I2C bus directly connected to compass	
						elsif op_counter=x"06" then			
							register_number 	<= BYPASS_MPU;
							data_to_w			<= x"02";
							
						----- Compass sample rate
						elsif op_counter=x"07" then			
							addr_s 				<= ADDR_I2C_COMPASS;
							register_number 	<= COMPASS_CONF_A;
							data_to_w			<= "011" & freq_compass & "00";
							
						----- Compass automatic mode activation
						elsif op_counter=x"08" then			
							register_number 	<= COMPASS_MODE;
							data_to_w			<= x"00";
							
						----- Compass gain value
						elsif op_counter=x"09" then
							register_number 	<= COMPASS_CONF_B;
							data_to_w 			<= gain_compass & "00000";
							
						----- Disable bypass
						elsif op_counter=x"0A" then	
							addr_s 				<= ADDR_I2C_MPU;		
							register_number 	<= BYPASS_MPU;
							data_to_w			<= x"00";
							
						----- MPU set to master on his auxiliary I2C bus 	
						elsif op_counter=x"0B" then			
							register_number 	<= USER_CTRL;
							data_to_w			<= x"60";
							
						----- Auxiliary I2C bus frequency set to 400kHz	
						elsif op_counter=x"0C" then			
							register_number 	<= I2C_MST_CTRL;
							data_to_w			<= x"0D";
							
						----- I2C address of compass + mode read
						elsif op_counter=x"0D" then			
							register_number 	<= I2C_SLV0_ADDR;
							data_to_w			<= x"9E";
							
						----- Internal register from compass from which the data will be read	
						elsif op_counter=x"0E" then			
							register_number 	<= I2C_SLV0_REG;
							data_to_w			<= x"03";
							
						----- Enable the acquisition of the 6 bytes of data from compass
						elsif op_counter=x"0F" then			
							register_number 	<= I2C_SLV0_CTRL;
							data_to_w			<= x"86";

						elsif op_counter=x"10" then
							register_number 	<= USER_CTRL;
							data_to_w			<= x"64";
							state_conf			<= waiting;
							run_conf_s				<= '0';
						else
							register_number 	<= x"00";
						end if;
						
						
				when others =>
						state_conf <= waiting;
				
		end case;
	end if;
end process;

run_conf <= run_conf_s;

end behavioral;
