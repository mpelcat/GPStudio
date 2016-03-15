library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity gps_receiver is
	port(
			clk	: in std_logic;
			reset : in std_logic;
			enable : in std_logic;
			RXD	: in std_logic;
			data_ready	: out std_logic;
			data_out		: out std_logic_vector(7 downto 0);
			gngga_flag			: out std_logic
		 );
end gps_receiver;


architecture RTL of gps_receiver is

signal count_sample		: unsigned(3 downto 0);
signal number_of_bits	: unsigned(3 downto 0);
signal clk_slow			: std_logic;
signal full_spl_flag		: std_logic;
signal data_out_s			: std_logic_vector(7 downto 0);
signal gngga				: std_logic_vector(55 downto 0);

type type_state is (idle, start, data,stop);
signal state : type_state;

begin

process(clk)
variable count_clk : integer range 0 to 400 := 0;
begin
	if reset='0' then
			count_clk:=0;
			clk_slow <= '0';
	
	elsif clk'event and clk='1' and enable='1' then
		count_clk := count_clk +1;
		if count_clk=163 then	--326/2 pour 9600 bauds
			clk_slow <= not clk_slow;
			count_clk:=0;
		end if;
	end if;
end process;


process(clk_slow)
begin
	if reset='0' then
			state <= idle;
			gngga_flag <= '0';
			data_ready <= '0';
					
	elsif clk_slow'event and clk_slow='1' and enable ='1' then
	
			count_sample <= count_sample+1;
		
		case(state) is 
		
			when(idle) => 
					gngga_flag <= '0';
					data_ready <= '0';
					if RXD = '0' then
						state <= start;
						count_sample <= x"0";
					end if;
		
			when(start) =>
			
					if count_sample=x"7" then
						state <= data;
						count_sample <= x"0";
					else
						state <= start;
					end if;
					
			when(data) =>
					
					if count_sample=x"F" then
						data_out_s <= RXD & data_out_s(7 downto 1); --on reçoit le LSB en premier
						number_of_bits <= number_of_bits +1;
						if number_of_bits = x"7" then
							state <= stop;
							number_of_bits <= x"0";
						end if;						
					end if;
					
			when(stop) =>
					
					if count_sample=x"F" then
						state <= idle;
						data_out <= data_out_s;
						gngga <= gngga(47 downto 0) & data_out_s;
						data_ready <= '1';
						
						if gngga=x"24474E4747412C" then
							gngga_flag<= '1';
						end if;
					end if;
					
			when others =>
						state <= idle;
		end case;
		
	end if;
end process;




end RTL;
