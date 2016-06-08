
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ethernet_package.all;

entity interface_management is
	port (	   
				CLK125			: in std_logic;
				reset_n			: in std_logic;
				RX_i 				: in rgmii_t;
				RX_o 				: out gmii_t;
				RX_o_dl			: out gmii_t;
				TX_i 				: in gmii_t;
				TX_o 				: out rgmii_t
		);
end interface_management;

architecture RTL of interface_management is

type fsm_rcv is (idle,preamble,data);
signal state_rcv 			: fsm_rcv;

signal CLK250 					: std_logic;
signal count_preamble 		: unsigned(3 downto 0);
signal preamble_done 		: std_logic;
signal TX_i_dl					: rgmii_t;
signal RX						: rgmii_t;
signal half						: std_logic;
signal half2					: std_logic;
signal rx_dv_flag				: std_logic;
signal RX_o_dl1,RX_o_dl2	: gmii_t;
signal RX_o_dl3,RX_o_dl4	: gmii_t;
signal reset					: std_logic;

begin
reset			<= not reset_n;

-------- Generate a 250MHz clock for the double data rate
pll_inst : entity work.pll250
	port map (
		areset		=> RESET,
		inclk0		=> CLK125,
		c0				=> CLK250,
		locked		=> open			
	);


-------- Detect and remove Ethernet preamble
process(clk250,reset_n)
begin
	if reset_n='0' then
		state_rcv 			<= idle;
		preamble_done 		<= '0';
		count_preamble 	<= x"0";
		RX.dv 				<= '0';
		RX.data  			<= x"0";
		
	elsif (clk250'event and clk250='1') then
		
		case (state_rcv) is		
			when idle =>
			
					if RX_i.dv='1' then
						state_rcv 		<= preamble;
						if RX_i.data=x"5" then
							count_preamble <= count_preamble +1;
						end if;
					else
						count_preamble <= x"0";
						state_rcv 		<= idle;
					end if;
			
			when preamble =>
			
					if RX_i.dv='1' and RX_i.data=x"5" then
						if count_preamble=x"E" then
							preamble_done 		<= '1';
						else
							count_preamble 	<= count_preamble +1;
						end if;
					elsif RX_i.data=x"D" and count_preamble=x"E" then  
						preamble_done 	<= '0';
						state_rcv 		<= data;
						count_preamble <= x"0";
					elsif RX_i.dv='0' then 
						state_rcv 		<= idle;
					end if;
			
			when data =>
			
					if RX_i.dv='1' then
						RX.dv	 		<= '1';
						RX.data  	<= RX_i.data;
						state_rcv 	<= data;
					else
						RX.dv 		<= '0';
						RX.data  	<= x"0";
						state_rcv 	<= idle;
					end if;
					
			when others =>
				state_rcv 			<= idle;
				preamble_done 		<= '0';
		end case;		
	end if;
end process;




process(clk250,reset_n)
begin
		if reset_n='0' then
			RX_o.dv		<= '0';
			
		elsif (clk250'event and clk250='1') then
	  
			------ Transmission GMII to RGMII
			TX_o.dv 									<=	TX_i_dl.dv;
			TX_o.data 								<= TX_i_dl.data;
			TX_i_dl.dv								<= TX_i.dv;
			
			if TX_i.dv='1' and TX_i_dl.dv='0' then
				TX_i_dl.data(3 downto 0) 		<= TX_i.data(7 downto 4);
				half 									<= '1';
				
			elsif TX_i_dl.dv='1' then
				half 									<= not half;
				if half='1' then
					TX_i_dl.data(3 downto 0) 	<= TX_i.data(7 downto 4);
				else
					TX_i_dl.data(3 downto 0) 	<= TX_i.data(3 downto 0);
				end if;
			end if;	
			
		
			------ Reception RGMII to GMII
			RX_o.dv									<= rx_dv_flag;
			rx_dv_flag								<= RX.dv;
			if RX.dv='1' and rx_dv_flag='0' then 
				half2 								<= '1';
				RX_o.data(3 downto 0) 			<= RX.data;
				RX_o_dl1.data(3 downto 0) 		<= RX.data;
				
			elsif rx_dv_flag='1' then
				half2 								<= not half2;
				if half2='1' then
					RX_o.data(7 downto 4) 		<= RX.data;
					RX_o_dl1.data(7 downto 4) 	<= RX.data;
				else
					RX_o.data(3 downto 0) 		<= RX.data;
					RX_o_dl1.data(3 downto 0) 	<= RX.data;
				end if;
			end if;
			
			----- Delay data to have enough time to detect if data is synchro on the rising edge of clk125 or not
			RX_o_dl1.dv		<= rx_dv_flag;
			RX_o_dl2			<= RX_o_dl1;
			RX_o_dl3			<= RX_o_dl2;
			RX_o_dl			<= RX_o_dl3;
			
     end if;   
end process;

end RTL;