-- Top level of the com block, contains the flow to com and com to flow mux.
-- Also instantiates the flow to com and com to flow block.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.com_package.all;

	
entity com is
	generic(  FIFO_IN_N 		: integer	:= 4; 
			  FIFO_IN_ID		: fifo_ID	:= ("000001","000010","000011",x"000100",others=>"000000"); 
			  FIFO_IN_SIZE		: fifo_size	:= (2048,1024,2048,512,others=>0);							
			  ONE_PACKET		: integer	:= 1450;
			  FIFO_OUT_N		: integer	:= 3;
			  FIFO_OUT_ID		: fifo_ID	:= ("110000","100001","100010",others=>x"100000");--- the first one is the master ID
			  FIFO_OUT_SIZE	    : fifo_size	:= (512,1024,others=>0)
			  );
	port  (
				clk_hal			: in std_logic;
				clk_proc		: in std_logic;
				reset_n			: in std_logic;
				
				--- From flows in to HAL
				data_o  		: out std_logic_vector(7 downto 0);
                data_size_o     : out std_logic_vector(15 downto 0);
                read_data_i     : in std_logic;
                ready_o         : out std_logic;
                hal_ready       : in std_logic;
                
				--- Flow to master
				flow_master		: out flow_t;
                
                --- From HAL to flows out
				data_i		    : in std_logic_vector(7 downto 0);
				write_i	        : in std_logic;
                
                --- Flows in and out
				flow_in0		: in flow_t;
				flow_in1		: in flow_t;
				flow_in2		: in flow_t;
				flow_in3		: in flow_t;

				flow_out0		: out flow_t;
				flow_out1		: out flow_t;
				
				--- Parameters from slave			
				enable_eth		: in std_logic;
				enable_in0		: in std_logic;
				enable_in1		: in std_logic;
				enable_in2		: in std_logic;
				enable_in3		: in std_logic
			);
end com;
	
architecture RTL of com is

----- Signals for fifos receiving flows (flow_to_com)
signal ready				: array_std_logic;
signal enable_i     		: array_std_logic;
signal read_data     		: array_std_logic;
signal fifo_in_flow_i		: array_flow_t;
signal data          		: array_bus8;
signal data_size            : array_bus16;
signal count_in,count_in_dl : integer range 0 to fifo_in_N-1;
signal HAL_busy_dl		    : std_logic;
signal wait_for_hal         : std_logic;
signal ready_dl,ready_s     : std_logic;
signal hal_ready_dl         : std_logic;

----- Signals for fifos sending flows (com_to_flow)
signal enable_o     		: std_logic;
signal fifo_out_flow_o		: array_flow_t;

begin	
---------------------------------------------------------------------------------------------------------
--------------------------                  FLOW_TO_COM_MUX 
---------------------------------------------------------------------------------------------------------

----- Checking ready signals from fifos receiving flows
process(clk_hal,reset_n)
begin
	if reset_n ='0' then
		count_in        <= 0;
        wait_for_hal    <= '0';
	elsif clk_hal'event and clk_hal='1' then
        ready_dl 		<= ready(count_in);
        if ready(count_in)='0' and ready_dl='1' then
            wait_for_hal    <= '1';
        elsif wait_for_hal='1' and hal_ready='1' then --- Increment count between each packet sent
            wait_for_hal    <= '0';
            count_in        <= count_in+1;
        elsif wait_for_hal='0' and hal_ready='1' and ready(count_in)='0' and read_data_i='0' then --- Increment when flow not ready
            count_in        <= count_in+1;
        end if;

	end if;
end process;

ready_s             <= '0' when wait_for_hal='1' else ready(count_in);
ready_o             <= ready_s;
data_o              <= data(count_in);
data_size_o         <= data_size(count_in);
read_data(count_in) <= read_data_i;

----- Instantiating fifo receiving flows
flow_to_com_gen : for i in 0 to fifo_in_N-1 generate
    flow_to_com_inst : entity work.flow_to_com 
    generic map(    ID_FIFO	  	=> fifo_in_ID(i),
                    FIFO_DEPTH	=> fifo_in_size(i),
                    ONE_PACKET 	=> (ONE_PACKET))
    port map (
                    clk_hal			=> clk_hal,
                    clk_proc		=> clk_proc,
                    reset_n			=> reset_n,		
                    enable			=> enable_i(i),
                    flow_in			=> fifo_in_flow_i(i),	
                    data_size       => data_size(i),
                    read_data       => read_data(i),
                    ready			=> ready(i),
                    data_out		=> data(i)
					);
		end generate flow_to_com_gen; 
        
------------à generer
fifo_in_flow_i(0)		<=	flow_in0;
fifo_in_flow_i(1)		<=	flow_in1;
fifo_in_flow_i(2)		<=	flow_in2;
fifo_in_flow_i(3)		<=	flow_in3;		


---------------------------------------------------------------------------------------------------------
--------------------------                  COM_TO_FLOW_MUX 
---------------------------------------------------------------------------------------------------------
----- Instantiating com_to_flows blocks
com_to_flow_gen : for i in 0 to fifo_out_N-1 generate
    com_to_flow_inst : entity work.com_to_flow 
    generic map(    ID_FIFO	  	=> fifo_out_ID(i),
                    FIFO_DEPTH	=> fifo_out_size(i))
    port map (
                    clk_hal			=> clk_hal,
                    clk_proc		=> clk_proc,
                    reset_n			=> reset_n,		
                    enable			=> enable_o,
                    flow_out		=> fifo_out_flow_o(i),
                    write_data      => write_i,
                    data_in 		=> data_i
					);
		end generate com_to_flow_gen;
 
flow_master             <=  fifo_out_flow_o(0);
flow_out0				<=	fifo_out_flow_o(1);
flow_out1				<=	fifo_out_flow_o(2);			

----- Enable flows in and out		
enable_i(0) 			<= enable_eth and enable_in0;
enable_i(1) 			<= enable_eth and enable_in1;
enable_i(2) 			<= enable_eth and enable_in2;
enable_i(3) 			<= enable_eth and enable_in3;		
			          
enable_o    <= '1';

end RTL;
