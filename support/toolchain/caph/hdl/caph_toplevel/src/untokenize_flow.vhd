

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.caph_flow_pkg.all;

entity untokenize_flow is
	generic(
	IMAGE_WIDTH:integer := 320;
	IMAGE_HEIGHT:integer := 240;
	TOKEN_SIZE: integer := 10;
	SIZE:integer:=8
	);
	port (
		clk_caph: in std_logic;
		clk_proc: in std_logic;
		rst_n_i : in std_logic;
		fifo_empty: in std_logic;
		data_i : in std_logic_vector(TOKEN_SIZE-1 downto 0);
		imwidth_i : in std_LOGIC_VECTOR(31 downto 0);
		imheight_i : in std_LOGIC_VECTOR(31 downto 0);
		
		
		fifo_unpile: out std_logic;
		frame_valid_o  :out std_logic;
		data_valid_o   :out std_logic;
		data_o : out std_logic_vector (SIZE-1 downto 0)
		);
end entity untokenize_flow;



architecture rtl of untokenize_flow is

	signal frame_valid_s  : std_logic;
	signal data_valid_s   : std_logic;
	signal data_s :  std_logic_vector (SIZE-1 downto 0);
		
	signal frame_valid_sr  : std_logic;
	signal data_valid_sr   : std_logic;
	signal data_sr :  std_logic_vector (SIZE-1 downto 0);
	
	signal linecpt : integer range 0 to MAX_IMAGE_HEIGHT := 0;

begin

process(clk_caph,rst_n_i)

variable datacpt : integer range 0 to MAX_IMAGE_WIDTH := 0;

begin
	if (rst_n_i = '0') then 
		frame_valid_s<='0';
		data_valid_s<='0';
		data_s <= (others=>'0');
		datacpt := 0;
		linecpt <= 0;
	elsif rising_edge(clk_caph) then
		data_valid_s <= '0';
		
		if (data_i(TOKEN_SIZE-1 downto TOKEN_SIZE-2) = CaphHeader(Data))   then
			data_s <= data_i(7 downto 0);
			data_valid_s <= '1';
			frame_valid_s <= '1';
			
			datacpt := datacpt + 1;
			
			if(datacpt = to_integer(unsigned(imwidth_i))) then
				datacpt  := 0;
				linecpt <= linecpt+1;
			end if;
		end if;
		
		if(linecpt= to_integer(unsigned(imheight_i))) then
			frame_valid_s <= '0';
			data_valid_s <= '0';
			datacpt := 0;
			linecpt <= 0;
		end if;
		
	end if;
end process;
	
fifo_unpile <= not(fifo_empty);
data_valid_o <= data_valid_s;
frame_valid_o <= frame_valid_s;
data_o <= data_s;
	
--SyncCLKPROC: process(clk_caph,rst_n_i)
--begin
--	if (rst_n_i = '0') then 
--			data_sr <= (others=>'0');
--			data_valid_sr <= '0';
--			frame_valid_sr <= '0';
--			data_o <= (others=>'0');
--			data_valid_o <= '0';
--			frame_valid_o <= '0';
--	elsif rising_edge(clk_caph) then
--			
--			data_sr <= data_s;
--			data_o <= data_sr;
--			
--			data_valid_sr <= data_valid_s;
--			data_valid_o <= data_valid_sr;
--			
--			frame_valid_sr <= frame_valid_s;
--			frame_valid_o <= frame_valid_sr;
--			
--	end if;
--end process;
	
	
end architecture;