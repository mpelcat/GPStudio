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

					if ((busy_s='0' and (trig='1' or op_counter/=x"00")) or reset_fifo_flag='1') then	
						state <= init;
					else
						state <= idle;
					end if;
			   end if;
			
			when init =>
			
				rw_s 			<= '0';
				ena_s 		<= '1';
				data_wr_s 	<= register_number;
				
				if state_conf=config or reset_fifo_buffer='1' then
							state <= write_state;
				else
						if end_rw_s = '1' then
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
									
						if count_ack=x"14" then  		--nombre de read a effectuer en hexa
							state 		<= idle;
							ena_s 		<= '0';
							count_ack 	<= x"00";
						end if;
						
					end if;
					
			when write_state =>
			
					rw_s <= '0';	
					
					if end_rw_s='1' and prev_end_rw='0' then		---Compteur d'acknowledge
						count_ack 	<= count_ack +1;
						state 		<= write_state;
					end if;
					
					if count_ack =x"01" then							---Envoi des donn�es � �crire dans le registre APRES
						data_wr_s 	<= data_to_w;							---l'envoi de l'adresse du registre
						
					elsif count_ack=x"02" then 
						state 		<= idle;
						ena_s 		<= '0';
						count_ack 	<= x"00";
					
					else 
						data_wr_s 	<= register_number;
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
		
	elsif clk'event and clk='1' then	
	
	------Compteur d'operations pour la config
		op_counter_f_dl <= op_counter_f;
		if op_counter_f='1' and op_counter_f_dl='0' then
			if (op_counter < x"10") then
				op_counter <= op_counter +1;
			else
				op_counter <= x"00";
			end if;
			
		end if;
		
		
		case(state_conf) is 
		
			when waiting => 
			
						op_counter 			<= x"00";
				
					if reset_fifo_buffer='1' then
						addr_s 				<= ADDR_I2C_MPU;
						register_number 	<= USER_CTRL;
						data_to_w 			<= x"64";
					
					else
						addr_s 				<= ADDR_I2C_MPU;
						register_number 	<= FIFO_READ;
						data_to_w 			<= x"00";
					end if;
					
					if config_button = '1' then
						state_conf			<= config;
					else	
						state_conf			<= waiting;
					end if;
			
			when config =>
					
									-----Configuration des registres de l'IMU
						----Sortie du mode "Pause"
						if op_counter=x"00" then
							addr_s 				<= ADDR_I2C_MPU;
							register_number 	<= PWR_MGMT_1;
							data_to_w     		<= x"01";
						
						----FIFO enable
						elsif op_counter=x"01" then			
							register_number 	<= USER_CTRL;
							data_to_w			<= x"40";
							
						----Configuration de l'accelerometre	
						elsif op_counter=x"02" then			
							register_number	<= ACCEL_CONFIG_REG;
							data_to_w			<= "000" & accel_config & "000";
						
						------Sample rate	
						elsif op_counter=x"03" then
							register_number 	<= SMPLRT_DIV;	
							data_to_w			<= spl_rate;
							
						-----Choix des données de l'IMU à placer dans la FIFO	
						elsif op_counter = x"04" then
							register_number 	<= FIFO_EN;
							data_to_w 			<= x"F9";---x"F8" sans compass
							
						-----Configuration du gyromètre
						elsif op_counter=x"05" then
							register_number	<= GYRO_CONFIG_REG;
							data_to_w			<= "000" & gyro_config & "000";	
							
						-----Bypass du MPU : on communique directement avec le compass	
						elsif op_counter=x"06" then			
							register_number 	<= BYPASS_MPU;
							data_to_w			<= x"02";
							
						-----Frequence d'acquisition des données du compass
						elsif op_counter=x"07" then			
							addr_s 				<= ADDR_I2C_COMPASS;
							register_number 	<= COMPASS_CONF_A;
							data_to_w			<= "011" & freq_compass & "00";
							
						-----Activation du mode automatique du compass
						elsif op_counter=x"08" then			
							register_number 	<= COMPASS_MODE;
							data_to_w			<= x"00";
							
						-----Valeur du gain fixée à +/- 1.3 Gauss
						elsif op_counter=x"09" then
							register_number 	<= COMPASS_CONF_B;
							data_to_w 			<= gain_compass & "00000";
							
						-----Désactivation du bypass (plus de communication FPGA/compass possible)
						elsif op_counter=x"0A" then	
							addr_s 				<= ADDR_I2C_MPU;		
							register_number 	<= BYPASS_MPU;
							data_to_w			<= x"00";
							
						-----Le MPU est passé en maitre sur son bus auxiliaire 	
						elsif op_counter=x"0B" then			
							register_number 	<= USER_CTRL;
							data_to_w			<= x"60";
							
						-----Fréquence du bus I2C auxiliaire mise à 400kHz	
						elsif op_counter=x"0C" then			
							register_number 	<= I2C_MST_CTRL;
							data_to_w			<= x"0D";
							
						-----Adresse I2C du compass + bit de lecture
						elsif op_counter=x"0D" then			
							register_number 	<= I2C_SLV0_ADDR;
							data_to_w			<= x"9E";
							
						-----Registre interne du compass à partir duquel commencera la lecture des données	
						elsif op_counter=x"0E" then			
							register_number 	<= I2C_SLV0_REG;
							data_to_w			<= x"03";
							
						-----Activation de l'acquisition des données du compass + indique qu'il faut lire 6 octets
						elsif op_counter=x"0F" then			
							register_number 	<= I2C_SLV0_CTRL;
							data_to_w			<= x"86";

						--elsif op_counter=x"10" then
						--	register_number 	<= USER_CTRL;
						--	data_to_w			<= x"64";
							state_conf			<= waiting;
							
						else
							register_number 	<= x"00";
						end if;
						
						
				when others =>
						state_conf <= waiting;
				
		end case;
	end if;


end process;


end behavioral;
