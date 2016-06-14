
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ethernet_package.all;

	
entity fifo_flow_in is
	generic( ID	  			: std_logic_vector(15 downto 0):=x"8000";
			   depth  		: integer:=2048;
				one_packet	: integer:=1450
			  );
	port  (
				clk				: in std_logic;
				flow_in_clk		: in std_logic;
				reset_n			: in std_logic;
				enable			: in std_logic;
				ready				: out std_logic;
				start_rd_fifo	: in std_logic;
				data_len			: out std_logic_vector(15 downto 0);
				ID_port			: out std_logic_vector(15 downto 0);
					
				flow_in			: in flow_t;
				flow_out			: out flow_t
			);
end fifo_flow_in;
	
architecture RTL of fifo_flow_in is

signal empty					: std_logic;
signal usedw					: std_logic_vector(get_length(depth)-1 downto 0);
signal data_len_zero			: std_logic_vector(15 downto 0);
signal data_len_s				: std_logic_vector(15 downto 0);
signal rd_fifo_dl,rd_fifo	: std_logic;
signal start_count			: std_logic;
signal count					: unsigned(15 downto 0);

signal start_rd_fifo_dl		: std_logic;
signal ready_s					: std_logic;
signal last_data				: std_logic;
signal not_empty				: std_logic;
signal ready_dl1,ready_dl2	: std_logic;
signal ready_dl3,ready_dl4	: std_logic;
signal ready_dl5,ready_dl6	: std_logic;
signal wrreq					: std_logic;
signal reset					: std_logic;
begin
reset	<= not reset_n;
ID_port	<= ID;

data_len_zero<=x"0000";
data_len_s	<= data_len_zero or usedw;
data_len  	<= data_len_s;


fifo_in_inst : ENTITY work.gp_dcfifo 
	generic map (depth => depth)
	PORT map(
		aclr		=> reset,
		data		=> flow_in.data,
		rdclk		=> clk,
		rdreq		=> rd_fifo,
		wrclk		=> flow_in_clk,
		wrreq		=> wrreq,
		q			=> flow_out.data,
		rdempty	=> empty,
		wrfull	=> open,
		rdusedw	=> usedw
	);

----- Read fifo after receiving a pulse from the smart mux;
----- Stop reading when a fifo is empty OR when enough data has been read to complete a packet 
process(clk,reset_n)
begin
	if reset_n='0' then
		rd_fifo				<= '0';
		last_data			<= '0';
		start_count			<= '0';
		count					<=x"0000";
		
	elsif clk'event and clk='1' then
		start_rd_fifo_dl	<= start_rd_fifo;
		rd_fifo_dl			<= rd_fifo;
		
		if data_len_s=x"0001" then
			last_data		<= '0';
		else
			last_data		<= '1';
		end if;
			

		
		if start_rd_fifo='1' and start_rd_fifo_dl='0' then
			rd_fifo		<= '1';
			start_count	<= '1';
			count			<= to_unsigned(one_packet,16);
		elsif start_count	<= '1' then 
			if count=x"0000" or empty='1' then
				rd_fifo		<= '0';
				start_count	<= '0';
			else	
				count			<= count-1;
			end if;
		end if;
	end if;
end process;


----- Set the ready signal, when it is at '1' data are ready to be transmitted to the smart mux
process(clk,reset_n)
begin
	if reset_n='0' then
		ready_s		<= '0';
		not_empty	<= '0';
		
	elsif clk'event and clk='1' then
		----- Delay ready signal to have correct size of data in fifo
		ready_dl1	<= ready_s;
		ready_dl2	<= ready_dl1;
		ready_dl3	<= ready_dl2;
		ready_dl4	<= ready_dl3;
		ready_dl5	<= ready_dl4;
		ready			<= ready_dl5;
		
		----- Set ready when an incoming flow ends or when the fifo is empty
		if flow_in.fv='0' and data_len_s>x"0000" and ready_s <= '0' then 
			ready_s <= '1';
		elsif rd_fifo='0' and rd_fifo_dl='1' then
			ready_s <= '0';
			if data_len_s>=x"0002" then
				not_empty	<= '1';
			end if;
		elsif not_empty='1' then
			not_empty		<= '0';
			ready_s			<= '1';
		end if;
	end if;
end process;

--- Write fifo only when enable
wrreq			<= flow_in.dv when enable='1' else '0';

flow_out.dv	<= rd_fifo_dl and last_data;
flow_out.fv	<= rd_fifo_dl and last_data;

end RTL;
