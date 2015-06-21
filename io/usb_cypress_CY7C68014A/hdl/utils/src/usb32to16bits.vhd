
library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;

LIBRARY altera_mf;
USE altera_mf.altera_mf_components.all;


-- USB 32 TO 16 BITS FROM SVM DATA
-- V1: sans compteur, dur de gérer tous les cas de figures 
-- TODO: Mettre en place deux compteurs/un pour le nombre de données écrite et un pour le nombre de donnée dépilée:
-- Pb de FV si plus court que le temps de dépilage => Fifo de données ?

entity usb32to16bits is
		generic (
			INPUT_SIZE: integer;
			FIFO_DEPTH : integer
		);
		port ( 
			rst_n_i  		: in  std_logic;
			clk_i  			: in  std_logic;		
			frame_valid_i	: in  std_logic;					
			data_valid_i	: in  std_logic;					
			data_i			: in  std_logic_vector(31 downto 0);
			frame_valid_o	: out std_logic;
			data_valid_o	: out std_logic;
			data_o			: out std_logic_vector(15 downto 0) 
		);
end usb32to16bits;


architecture rtl of usb32to16bits is

type state_t is (Initial,SendLSB,DumpLastMSB,DumpLastLSB,SyncSignal);
signal state : state_t := Initial;

signal tmp : std_logic_vector(15 downto 0):=(others=>'0');
signal fifo_empty_s: std_logic:='0';
signal databuf : std_logic_vector(31 downto 0):=(others=>'0');

signal aclr_s : std_logic:='0';
signal rdreq_s : std_logic:='0';

signal usedw_s: std_logic_vector(integer(ceil(log2(real(FIFO_DEPTH))))-1 downto 0):=(others=>'0');

signal fifo_empty_r: std_logic :='0';
begin

aclr_s <= not(rst_n_i);

with state select
rdreq_s <=  not(fifo_empty_s) when Initial,
			'0' when SendLSB ,
			'0' when others;
			
FIFO : component scfifo
	GENERIC MAP(
		intended_device_family => "Cyclone III",
		lpm_numwords => FIFO_DEPTH,
		lpm_showahead => "OFF",
		lpm_type => "scfifo",
		lpm_width => 32,
		lpm_widthu => integer(ceil(log2(real(FIFO_DEPTH)))),
		overflow_checking => "ON",
		underflow_checking => "ON",
		use_eab => "ON"
)
	PORT map 
	(
		data		=> data_i,
		rdreq		=> rdreq_s,
		clock		=> clk_i,
		wrreq		=> data_valid_i,
		aclr 		=> aclr_s ,
		q			=> databuf,
		empty => fifo_empty_s,
		usedw => usedw_s,
		full	=> open
	);
	
process(clk_i,rst_n_i)

begin

	if (rst_n_i = '0') then 
		state <= Initial;
		frame_valid_o <= '0';
		data_valid_o <='0';
		data_o <=  (others=>'0');
		tmp <=  (others=>'0');
		fifo_empty_r <= '1';
--		rdreq_s <= '0';
		
	elsif rising_edge(clk_i) then
	--	frame_valid_o <=  frame_valid_i;
		data_valid_o <='0';
		fifo_empty_r <= fifo_empty_s;
		
		case state is
		
			when Initial =>
			
				if (frame_valid_i = '1') then
					frame_valid_o <='1';
				end if;
				
				
				if( fifo_empty_r = '0' ) then
				
					data_o <= databuf(31 downto 16);
					data_valid_o <='1';

					tmp <= databuf(15 downto 0);
					state <= SendLSB;
				end if;
			
			when SendLSB =>
					data_o <= tmp ;
					data_valid_o <='1';
					state <= Initial;
					
					-- Dernière donnée : cas particulier
					if(fifo_empty_s = '1') then
						state <= DumpLastMSB;
					end if;
				
			when DumpLastMSB =>
				data_valid_o <='1';
				data_o <= databuf(31 downto 16);
				state <= DumpLastLSB;
				
			when DumpLastLSB =>
				data_valid_o <='1';
				data_o <= databuf(15 downto 0);
				state <= SyncSignal;
				
			when SyncSignal =>
				if (frame_valid_i = '0') then
					frame_valid_o <='0';
					data_valid_o <='0';
				end if;
				
				state <= Initial;
		end case;
	end if;
end process;

end rtl;
