
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.COM_package.all;

	
entity COM is
	generic(fifo_in_N 		: integer	:= 4;			--up to 10 fifos
			  fifo_in_ID		: fifo_ID	:= (x"7000",x"7080",x"4000",x"4040",others=>x"0000"); 
			  fifo_in_size		: fifo_size	:= (2048,1024,2048,512,others=>0);							
			  one_packet		: integer	:= 1450;
			  fifo_out_N		: integer	:=2;
			  fifo_out_ID		: fifo_ID	:= (x"3000",x"3001",others=>x"0000");
			  fifo_out_size	: fifo_size	:= (512,1024,others=>0)
			  
			  );
	port  (
				clk				: in std_logic;
				clk_proc			: in std_logic;
				reset_n			: in std_logic;
				
				--- From flows in to HAL
				HAL_busy			: in std_logic;
				ID_in				: out std_logic_vector(15 downto 0);
				size				: out std_logic_vector(15 downto 0);
				flow_out			: out flow_t;
				
------------à generer
				flow_in0			: in flow_t;
				flow_in1			: in flow_t;
				flow_in2			: in flow_t;
				flow_in3			: in flow_t;	
				----
				
				
				--- From HAL to flows out
				ID_out			: in std_logic_vector(15 downto 0);
				flow_rx_in		: in flow_t;
				
------------à generer
				flow_out0		: out flow_t;
				flow_out1		: out flow_t;
				
				--- Parameters from slave
------------à generer				
				enable_eth		: in std_logic;
				enable_in0		: in std_logic;
				enable_in1		: in std_logic;
				enable_in2		: in std_logic;
				enable_in3		: in std_logic
			);
end COM;
	
architecture RTL of COM is

----- Signals for fifos receiving flows (fifo_in)
type fifo_in_signal	is array (0 to fifo_in_N-1) of std_logic;
type fifo_in_flow_t	is array (0 to fifo_in_N-1) of flow_t;
type fifo_in_bus	is array (0 to fifo_in_N-1) of std_logic_vector(15 downto 0);
signal ready					: fifo_in_signal;
signal start_rd_fifo			: fifo_in_signal;
signal data_len				: fifo_in_bus;
signal ID_port					: fifo_in_bus;
signal fifo_in_flow_i		: fifo_in_flow_t;
signal fifo_in_flow_o		: fifo_in_flow_t;
signal count_in			: integer range 0 to fifo_in_N-1;

----- Signals for fifos transmitting flows (fifo_out)
type fifo_out_flow_t	is array (0 to fifo_out_N-1) of flow_t;
type fifo_out_signal	is array (0 to fifo_out_N-1) of std_logic;
type fifo_out_bus	is array (0 to fifo_out_N-1) of std_logic_vector(15 downto 0);
signal fifo_out_flow_i		: fifo_out_flow_t;
signal fifo_out_flow_o		: fifo_out_flow_t;
signal ready_out				: fifo_out_signal;
signal count_out				: integer range 0 to fifo_out_N-1;

type fsm_COM is (idle, transmitting,wait_state);
signal state_COM			: fsm_COM;
signal data_len_hex		: std_logic_vector(15 downto 0);
signal HAL_busy_dl		: std_logic;

signal enable_s			: fifo_in_signal;

begin

data_len_hex	<= std_logic_vector(to_unsigned(one_packet,16));

----- Instantiating fifo receiving flows
fifo_in_gen : for i in 0 to fifo_in_N-1 generate
		fifo_in_inst : entity work.fifo_flow_in 
		generic map(ID	  			=> fifo_in_ID(i),
						depth  		=> fifo_in_size(i),
						one_packet 	=> (one_packet-1))
		port map (
						clk				=> clk,
						flow_in_clk		=> clk_proc,
						reset_n			=> reset_n,
						enable			=> enable_s(i),
						ready				=> ready(i),
						start_rd_fifo	=> start_rd_fifo(i),
						data_len			=> data_len(i),
						ID_port			=> ID_port(i),
						
						flow_in			=> fifo_in_flow_i(i),
						flow_out			=> fifo_in_flow_o(i)
					);
		end generate fifo_in_gen;

----- Checking ready signals from fifos receiving flows and setting the read fifo signal
process(clk,reset_n)
begin
	if reset_n ='0' then
		size				<= (others => '0');
		flow_out.data	<= (others => '0');
		flow_out.dv		<= '0';
		flow_out.fv		<= '0';
		state_COM		<= idle;
		
	elsif clk'event and clk='1' then
		
		case(state_COM) is		
			when idle =>
					if ready(count_in)='1' then
						state_COM					<= transmitting;
						start_rd_fifo(count_in)		<= '1';
						if data_len(count_in)>= data_len_hex then
							size							<= data_len_hex;
						else
							size							<= data_len(count_in);
						end if;
					else
						count_in 		<= count_in+1;
					end if;		
				
			when transmitting =>
				flow_out						<= fifo_in_flow_o(count_in);
				ID_in							<= ID_port(count_in);
				start_rd_fifo(count_in)	<= '0';
				if ready(count_in)='0' then
					state_COM	<= wait_state;
				end if;

			when wait_state =>
				HAL_busy_dl		<= HAL_busy;
				if HAL_busy = '0' and HAL_busy_dl='1' then
					state_COM <= idle;
				end if;
				
			when others =>
					state_COM	<= idle;
		end case;
	end if;
end process;
			
----- Instantiating fifo receiving flows
fifo_out_gen : for i in 0 to fifo_out_N-1 generate
		fifo_out_gen : entity work.fifo_flow_out
	generic map( 
				ID	  			=> fifo_out_ID(i),
			   depth  		=> fifo_out_size(i)
			  )
	port map (
				clk				=> clk,
				reset_n			=> reset_n,
				ready				=> ready_out(i),
				port_detected	=> ID_out,
				flow_in			=> flow_rx_in,
				flow_out_clk	=> clk_proc,
				flow_out			=> fifo_out_flow_i(i)
			);
		end generate fifo_out_gen;

		
------------à generer
fifo_in_flow_i(0)		<=	flow_in0;
fifo_in_flow_i(1)		<=	flow_in1;
fifo_in_flow_i(2)		<=	flow_in2;
fifo_in_flow_i(3)		<=	flow_in3;		
		
flow_out0				<=	fifo_out_flow_i(0);
flow_out1				<=	fifo_out_flow_i(1);			
			
enable_s(0) 			<= enable_eth or enable_in0;
enable_s(1) 			<= enable_eth or enable_in1;
enable_s(2) 			<= enable_eth or enable_in2;
enable_s(3) 			<= enable_eth or enable_in3;		
			
			
			
end RTL;