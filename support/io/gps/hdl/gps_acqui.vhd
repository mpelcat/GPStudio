library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity gps_acqui is
	port(
			clk	: in std_logic;
			enable : in std_logic;
			reset : in std_logic;
			RXD	: in std_logic;
			last_wr : out std_logic;
			data_out	: out std_logic_vector(7 downto 0);
			flow_valid : out std_logic;
			data_valid : out std_logic
		 );
end gps_acqui;


architecture RTL of gps_acqui is

signal data	: std_logic_vector(7 downto 0);
signal gngga_flag	: std_logic;
signal data_ready	: std_logic;
signal data_ready_dl : std_logic;
signal data_ready_dl2 : std_logic;
signal wr_en,rd_en,fifo_empty,rd_fifo	: std_logic;
signal gngga_flag_dl	: std_logic;
signal rd_data_valid : std_logic;
signal count_data : integer range 0 to 100;

type state_type is (idle, data_state);
signal state : state_type;

component gps_fifo
	port (
			clock : in std_logic;
			wrreq, rdreq	: in std_logic;
			data : in std_logic_vector(7 downto 0);
			full,empty : out std_logic;
			q :  out std_logic_vector(7 downto 0);
			usedw	: out std_logic_vector(7 downto 0)	
	);
end component;

begin

gps_receiver_inst : entity work.gps_receiver(RTL)
	port map (
				clk	=> clk,
				reset	=> reset,
				enable => enable,
				RXD	=> RXD,
				data_ready => data_ready,
				data_out=> data,
				gngga_flag => gngga_flag
				);
gps_fifo_inst : gps_fifo
	port map (
			clock => clk,
			wrreq => wr_en, 
			rdreq	=> rd_fifo,
			data => data,
			full => open,
			empty => fifo_empty,
			q => data_out,
			usedw	=> open
	
	);
	

process(clk)
begin
		if reset='0' then
				wr_en <= '0';
				state <= idle;
				rd_en <= '0';
				count_data<=0;
				last_wr <= '0';
				
		elsif clk'event and clk='1' and enable='1' then
				data_ready_dl <= data_ready;
				data_ready_dl2 <= data_ready_dl;
				gngga_flag_dl <= gngga_flag;
				rd_data_valid <= rd_fifo;
				
				case(state) is 
				
					when idle =>
					
						count_data<=0;
						if fifo_empty ='1' then
							rd_en <= '0';
						end if;
											
						if gngga_flag='1' then
							state <= data_state;
						else
							state <= idle;
						end if;
						
					when data_state =>
					
						if data_ready_dl='1' and data_ready_dl2='0' then
							
							count_data <= count_data+1;
							last_wr <= '0';
							if count_data=67 then
								
								count_data<=0;
								rd_en <= '1';
								state <= idle;
								wr_en <= '0';
							else	
									wr_en <= '1';
							end if;
							
						else
								
							wr_en <= '0';
							state<=data_state;
						end if;
						
					when others =>
						wr_en <= '0';
						state <= idle;
				end case;
		end if;
end process;

rd_fifo <= rd_en and not fifo_empty;
flow_valid <= rd_en;
data_valid <=  rd_data_valid and rd_fifo;

end RTL;
