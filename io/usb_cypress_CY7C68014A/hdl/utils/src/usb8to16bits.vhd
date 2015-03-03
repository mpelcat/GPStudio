
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity usb8to16bits is
		port ( 
			rst_n_i  		: in  std_logic;
			clk_i  			: in  std_logic;		
			frame_valid_i	: in  std_logic;					
			data_valid_i	: in  std_logic;					
			data_i			: in  std_logic_vector(7 downto 0);
			frame_valid_o	: out std_logic;
			data_valid_o	: out std_logic;
			data_o			: out std_logic_vector(15 downto 0) 
		);
end usb8to16bits;


architecture rtl of usb8to16bits is


type state_t is (Initial,WaitSd);
signal state : state_t := Initial;

signal tmp : std_logic_vector(7 downto 0):=(others=>'0');

begin

process(clk_i,rst_n_i)
begin

	if (rst_n_i = '0') then 
		state <= Initial;
		frame_valid_o <= '0';
		data_valid_o <='0';
		data_o <=  (others=>'0');
		tmp <=  (others=>'0');
	elsif rising_edge(clk_i) then
		frame_valid_o <=  frame_valid_i;
		data_valid_o <='0';
		
		case state is
			when Initial =>
				if data_valid_i ='1' then
					tmp <= data_i;
					state <= WaitSd;
				end if;
			
			when WaitSd =>
				if data_valid_i ='1' then
					data_o <= tmp & data_i;
					data_valid_o <='1';
					state <= Initial;
				end if;
		end case;
	end if;
end process;

end rtl;
