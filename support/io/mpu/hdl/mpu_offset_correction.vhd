LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.mpu_pkg.all;

entity offset_correction is
port (
		clk				: in std_logic;
		reset				: in std_logic;
		enable			: in std_logic;
		rd_fifo_count  : in std_logic;
		parameters		: in param;
		wr_en_flag		: in std_logic;
		wr_fifo			: out std_logic;
		data_i			: in std_logic_vector(7 downto 0);
		data_o			: out std_logic_vector(7 downto 0)
);
end offset_correction;


architecture RTL of offset_correction is 

signal count 						: unsigned(1 downto 0);
signal raw_data					: std_logic_vector(15 downto 0);
signal data_cor					: std_logic_vector(15 downto 0);
signal count_value 				: unsigned(3 downto 0);
signal offset, offset_default	: std_logic_vector(15 downto 0);
signal sign 						: std_logic;

type state_off is (idle,correction);
signal state 	: state_off; 


begin

--------This process correct data values by subtracting the corresponding offset to the raw value. 
process(clk,reset)
begin
	if reset='0' then
		count <= "00";
		wr_fifo <= '0';
		count_value <= x"0";
		
	elsif clk'event and clk='1' then
		if enable ='1' then
			
			case(state) is 
			
				when idle =>
				
					if wr_en_flag='1' then
						count <= count +1;
						raw_data <= raw_data(7 downto 0) & data_i;
						
					elsif count="10" then
						count <= "00";
						state <= correction;

						if rd_fifo_count='0' then
						
							if count_value=x"9" then
								count_value <= x"0";
							else
								count_value <= count_value+1;
							end if;
							
							if count_value<x"7" then 
								data_cor <= raw_data-offset;
							else
								data_cor <= raw_data;
							end if;
						else
							data_cor <= raw_data;
						end if;
					end if;
				
				when correction =>	
				
					if count="10" then
						count <= "00";
						state <= idle;
						wr_fifo <= '0';
					else
						count <= count+1;
						wr_fifo <= '1';
						data_o	<= data_cor(15 downto 8);
						data_cor <= data_cor(7 downto 0) & data_cor(15 downto 8);
					end if;					
				
			end case;
		else
			count 		<= "00";
			wr_fifo 		<= '0';
			count_value <= x"0";
			state			<= idle;
		end if;
	end if;
end process;	

--------This process determine each offset to subtract depending on the actual configuration and its value (whether it is negative or positive)
process(clk,reset)
begin
	if reset='0' then
		offset <= x"0000";
		
	elsif clk'event and clk='1' then
		if enable = '1' then
				
			if count_value<3 then
				if parameters(0)(20 downto 19)="01" then
					offset <= sign & offset_default(15 downto 1);
				elsif parameters(0)(20 downto 19)="10" then
					offset <= sign&sign& offset_default(15 downto 2);
				elsif parameters(0)(20 downto 19)="11" then
					offset <= sign&sign&sign& offset_default(15 downto 3);
				else
					offset <= offset_default;
				end if;

			else	
				if parameters(0)(22 downto 21)="01" then
					offset <= sign & offset_default(15 downto 1);
				elsif parameters(0)(22 downto 21)="10" then
					offset <= sign&sign& offset_default(15 downto 2);
				elsif parameters(0)(22 downto 21)="11" then
					offset <= sign&sign&sign& offset_default(15 downto 3);
				else
					offset <= offset_default;
				end if;
				
			end if;
		end if;
	end if;
	
end process;

sign	<= offset_default(15);	

offset_default <= 	parameters(1)(15 downto 0) when count_value = x"0" else		--offset accel X
							parameters(2)(15 downto 0) when count_value = x"1" else		--offset accel Y
							parameters(3)(15 downto 0) when count_value = x"2" else		--offset accel Z
							parameters(1)(31 downto 16) when count_value = x"4" else		--offset gyro X
							parameters(2)(31 downto 16) when count_value = x"5" else		--offset gyro Y
							parameters(3)(31 downto 16) when count_value = x"6" else		--offset gyro Z
							x"0000";	

end RTL;
