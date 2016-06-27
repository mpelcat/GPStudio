library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.com_package.all;

entity com_master is 
generic (pi_size_addr 		: integer:=2);
Port(
		CLK 				: in STD_LOGIC;
		RESET_n 			: in STD_LOGIC;
		flow_in				: in flow_t;
		master_addr_o		: out std_logic_vector(pi_size_addr downto 0);
		master_wr_o			: out std_logic;
		master_rd_o			: out std_logic;
		master_datawr_o	    : out std_logic_vector(31 downto 0);
		master_datard_i	    : in std_logic_vector(31 downto 0)
		);
end com_master;


architecture RTL of com_master is

type master_fsm is (idle,get_data,write_param);
signal state			: master_fsm;

signal count				: unsigned(3 downto 0);
signal rx_dv_dl				: std_logic;
signal master_datawr_o_s	: std_logic_vector(31 downto 0);

begin

master_rd_o			<= '0';
master_datawr_o	    <= master_datawr_o_s;

process(clk,RESET_n)
begin
	if RESET_n='0' then
		master_wr_o				<= '0';
		state 					<= idle;
		master_datawr_o_s		<= (others => '0');
		master_addr_o			<= (others => '0');
		
	elsif clk'event and clk='1' then 
		rx_dv_dl		<=	flow_in.dv;
		
		case (state) is
				when idle =>
				
					master_wr_o		<= '0';
					if flow_in.dv='1' and rx_dv_dl='0' then
						state 								<= get_data;
						master_datawr_o_s(7 downto 0)	    <= flow_in.data;
						count								<= x"0";
					end if;
						
				when get_data =>
					
					count 		<= count + 1;
					if count < x"3" then
						master_datawr_o_s	<= master_datawr_o_s(23 downto 0) & flow_in.data;
					elsif count = x"3" then 
						master_addr_o		<= flow_in.data(pi_size_addr downto 0);
					else
						state 	<= write_param;
					end if;
					
				when write_param =>
						
						master_wr_o		<= '1';
						state 			<= idle;
						
				when others =>
					state <= idle;
					
		end case;	
	end if;
end process;



end RTL;
