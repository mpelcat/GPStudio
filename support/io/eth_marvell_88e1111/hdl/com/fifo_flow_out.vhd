			
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ethernet_package.all;

	
entity fifo_flow_out is
	generic( ID	  			: std_logic_vector(15 downto 0):=x"8000";
			   depth  		: integer:=2048
			  );
	port  (
				clk				: in std_logic;
				reset_n			: in std_logic;
				ready				: out std_logic;
				port_detected	: in std_logic_vector(15 downto 0);
				flow_in			: in flow_t;
				flow_out_clk	: in std_logic;
				flow_out			: out flow_t
			);
end fifo_flow_out;
	
architecture RTL of fifo_flow_out is

signal rd_fifo			: std_logic;
signal ready_s			: std_logic;
signal rd_fifo_dl		: std_logic;
signal wr_fifo			: std_logic;
signal wr_data			: std_logic_vector(7 downto 0);
signal reset			: std_logic;

begin
reset		<= not reset_n;
ready 		<= ready_s;

fifo_out_inst : ENTITY work.gp_dcfifo
	PORT map
	(
		aclr		=> reset,
		data		=> wr_data,
		rdclk		=> flow_out_clk,
		rdreq		=> rd_fifo,
		wrclk		=> clk,
		wrreq		=> wr_fifo,
		q			=> flow_out.data,
		rdempty	=> ready_s
	);
	
process(flow_out_clk,reset_n)
begin
	if reset_n='0' then
		rd_fifo		<= '0';
	elsif flow_out_clk'event and flow_out_clk='1' then
			rd_fifo_dl		<= rd_fifo;
			if flow_in.fv='0' and ready_s='0' then
				rd_fifo		<= '1';
			elsif ready_s='1' then 
				rd_fifo		<= '0';
			end if;	
	end if;
end process;

process(clk,reset_n)
begin
	if reset_n='0' then
		wr_fifo 		<= '0';
	elsif clk'event and clk='1' then
		if port_detected=ID then
			wr_fifo 		<= flow_in.dv;
			wr_data		<= flow_in.data;
		else
			wr_fifo 		<= '0';
		end if;
	end if;
end process;
	
flow_out.dv		<= rd_fifo and rd_fifo_dl;
flow_out.fv		<= rd_fifo and rd_fifo_dl;
	
END RTL;
