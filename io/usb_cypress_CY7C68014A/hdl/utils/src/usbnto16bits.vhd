
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity usbnto16bits is
		generic (
			INPUT_SIZE: integer;
		);
		port ( 
			rst_n_i  		: in  std_logic;
			clk_i  			: in  std_logic;		
			frame_valid_i	: in  std_logic;					
			data_valid_i	: in  std_logic;					
			data_i			: in  std_logic_vector(INPUT_SIZE-1 downto 0);
			frame_valid_o	: out std_logic;
			data_valid_o	: out std_logic;
			data_o			: out std_logic_vector(15 downto 0) 
		);
end usbnto16bits;


architecture rtl of usbnto16bits is

constant CPT_MAX : integer := 16/INPUT_SIZE;

type state_t is (Initial,WaitSd);
signal state : state_t := Initial;

signal tmp : std_logic_vector(15 downto 0):=(others=>'0');

begin

process(clk_i,rst_n_i)
variable cpt : integer range 0 to CPT_MAX := 0;
begin

	if (rst_n_i = '0') then 
		state <= Initial;
		frame_valid_o <= '0';
		data_valid_o <='0';
		data_o <=  (others=>'0');
		tmp <=  (others=>'0');
		cpt = 0;
	elsif rising_edge(clk_i) then
		frame_valid_o <=  frame_valid_i;
		data_valid_o <='0';
		
		case state is
		
			when Initial =>
				-- shift reg
				if data_valid_i ='1' then
					tmp (INPUT_SIZE-1 downto 0) <= data_i;
					tmp sll INPUT_SIZE;
					cpt = cpt + 1;
					if (cpt = CPT_MAX) then
						state <= WaitSd;
						cpt = 0;
					end if;
				end if;
				
			
			when WaitSd =>
				if data_valid_i ='1' then
					data_o <= tmp ;
					data_valid_o <='1';
					state <= Initial;
				end if;
		end case;
	end if;
end process;

end rtl;
