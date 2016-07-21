-- This entity is used to adapt the interface between the marvell (4 bits double data rate clocked on GE_RXCLK)
-- and the fpga (8 bits clocked on rising edge of CLK125)

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ethernet_package.all;

entity interface_management is
	port (	   
				clk125			: in std_logic;
                clk250_marvell  : in std_logic;
                clk250_fpga     : in std_logic;
				reset_n			: in std_logic;
				RX_i 			: in rgmii_t;
				RX_o 			: out gmii_t;
				TX_i 			: in gmii_t;
				TX_o 			: out rgmii_t
		);
end interface_management;

architecture RTL of interface_management is

type fsm_rcv is (idle,preamble,data);
signal state_rcv 			: fsm_rcv;

signal count_preamble 		: unsigned(3 downto 0);
signal TX_i_dl				: rgmii_t;
signal half					: std_logic;
signal reset				: std_logic;
signal empty_rgmii2gmii     : std_logic;
signal data_valid_sync      : std_logic;
signal rd_en_sync           : std_logic;
signal data_sync            : std_logic_vector(7 downto 0);
signal RX_sync				: gmii_t;
signal empty_gmii2rgmii     : std_logic;
signal rd_en_tx,rd_en_tx_dl : std_logic;
signal data_valid_tx        : std_logic;
signal data_tx              : std_logic_vector(3 downto 0);

begin
reset			<= not reset_n;

--- Data in : 4bits at 250MHz (GE_RXCLK x2) --- Data out : 8bits 125MHz
rgmii2gmii_fifo_inst : entity work.rgmii2gmii_fifo
        port map (
            wrclk       => clk250_marvell,
            wrreq       => RX_i.dv,
            data        => RX_i.data,
            rdclk       => clk125,
            rdreq       => rd_en_sync,
            q           => data_sync,
            rdempty     => empty_rgmii2gmii          
            );
            
--- Process controling signals of rgmii2gmii fifo
process(clk125)
begin
    if clk125'event and clk125='1' then
        rd_en_sync 			<= not empty_rgmii2gmii;
        data_valid_sync	    <= rd_en_sync and not empty_rgmii2gmii;
        
        RX_sync.data		<= data_sync;		
        RX_sync.dv			<= data_valid_sync;
    end if;
end process;


-------- Detect and remove Ethernet preamble
process(clk125,reset_n)
begin
	if reset_n='0' then
		state_rcv 			<= idle;
		count_preamble 	    <= x"0";
		RX_o.dv 			<= '0';
		RX_o.data  			<= x"00";
		
	elsif (clk125'event and clk125='1') then
		
		case (state_rcv) is		
			when idle =>
			
					if RX_sync.dv='1' then
						state_rcv 		<= preamble;
						if RX_sync.data=x"55" then
							count_preamble <= count_preamble +1;
						end if;
					else
						count_preamble <= x"0";
						state_rcv 		<= idle;
					end if;
			
			when preamble =>
			
					if RX_sync.dv='1' and RX_sync.data=x"55" then
						count_preamble 	<= count_preamble +1;
					elsif RX_sync.data=x"D5" and count_preamble>=x"5" then  
						state_rcv 		<= data;
						count_preamble  <= x"0";
					elsif RX_sync.dv='0' then 
						state_rcv 		<= idle;
					end if;
			
			when data =>
			
					if RX_sync.dv='1' then
						RX_o.dv	 	<= '1';
						RX_o.data  	<= RX_sync.data;
						state_rcv 	<= data;
					else
						RX_o.dv 		<= '0';
						RX_o.data  	    <= x"00";
						state_rcv 	<= idle;
					end if;
					
			when others =>
				state_rcv 			<= idle;
		end case;		
	end if;
end process;

------ Transmission GMII to RGMII
process(clk250_fpga,reset_n)
begin
		if reset_n='0' then
			TX_o.dv		<= '0';
			TX_o.data 	<= x"0";
            
		elsif (clk250_fpga'event and clk250_fpga='1') then
			TX_o.dv 								<=	TX_i_dl.dv;
			TX_o.data 								<= TX_i_dl.data;
			TX_i_dl.dv								<= TX_i.dv;
			
			if TX_i.dv='1' and TX_i_dl.dv='0' then
				TX_i_dl.data(3 downto 0) 		<= TX_i.data(7 downto 4);
				half 							<= '1';
				
			elsif TX_i_dl.dv='1' then
				half 				<= not half;
				if half='1' then
					TX_i_dl.data(3 downto 0) 	<= TX_i.data(7 downto 4);
				else
					TX_i_dl.data(3 downto 0) 	<= TX_i.data(3 downto 0);
				end if;
			end if;			
     end if;   
end process;

end RTL;
