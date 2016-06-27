
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.ALL;
use work.ethernet_package.all;


entity eth_tx_header is 
	Port(
			CLK125 			    : in STD_LOGIC;
			reset_n 		    : in STD_LOGIC;
            data_i  		    : in std_logic_vector(7 downto 0);
            data_size_i         : in std_logic_vector(15 downto 0);
			TX_i 				: in gmii_t;
			TX_o 				: out gmii_t;
            --- parameters from slave
            mac_addr_hal_msb    : in std_logic_vector(23 downto 0);
            mac_addr_hal_lsb    : in std_logic_vector(23 downto 0);
            mac_addr_dest_msb   : in std_logic_vector(23 downto 0);
            mac_addr_dest_lsb   : in std_logic_vector(23 downto 0);
            ip_hal              : in std_logic_vector(31 downto 0);
            ip_dest             : in std_logic_vector(31 downto 0);
            port_dest           : in std_logic_vector(15 downto 0)
	);
end eth_tx_header;


architecture RTL of eth_tx_header is

signal fifo_udp_out	        : std_logic_vector(7 downto 0);
signal empty_fifo_udp       : std_logic;
signal CS_sum			    : std_logic_vector(31 downto 0);
signal rd_fifo_udp	        : std_logic;

type encapsulation_fsm is (ethernet,ip,udp,data,idle);
signal state_encap : encapsulation_fsm;

signal eth_hdr				: std_logic_vector(111 downto 0);
signal ip_hdr				: std_logic_vector(159 downto 0);
signal udp_hdr				: std_logic_vector(63 downto 0);
signal mac_addr_hal         : std_logic_vector(47 downto 0);
signal mac_addr_dest        : std_logic_vector(47 downto 0);
signal len_udp,len_ip		: std_logic_vector(15 downto 0);
signal port_src         	: std_logic_vector(15 downto 0);
signal CS_udp,CS_ip			: std_logic_vector(15 downto 0);
signal count_udp			: std_logic_vector(7 downto 0);
signal id       			: std_logic_vector(5 downto 0);
signal start_encap			: std_logic;
signal dv_uncap_dl			: std_logic;
signal dv_uncap_dl2			: std_logic;
signal queue_dv_dl			: std_logic;
signal set_length			: std_logic;
signal start_encap_dl       : std_logic;
signal TX					: gmii_t;
signal reset                : std_logic;

begin

reset   <= not reset_n;

	fifo_udp_inst : entity work.gp_fifo
    generic map(
        DATA_WIDTH      => 8,
        FIFO_DEPTH      => 64
    )
	port map(
		clk		    => CLK125,
        reset_n     => reset,
		data_in		=> TX_i.data,
		data_rd		=> rd_fifo_udp,
		data_wr		=> TX_i.dv,
		empty		=> empty_fifo_udp,
		data_out    => fifo_udp_out
	);
		
	checksum_udp : process(clk125,reset_n)
		begin
			if reset_n ='0' then
				dv_uncap_dl	    <= '0';
				start_encap		<= '0';
				queue_dv_dl	    <= '0';
			elsif CLK125'event and CLK125='1' then
				dv_uncap_dl 	<= TX_i.dv;
				dv_uncap_dl2	<= dv_uncap_dl;
				queue_dv_dl		<= TX.dv;
                start_encap_dl  <= start_encap;
                
				--start the encapsulation when a flow is received
				if TX_i.dv='1' and dv_uncap_dl='0' then
					start_encap		<= '1';
                elsif start_encap='0' and start_encap_dl='1' then
                    len_udp			<= data_size_i + x"8"; -- Data + udp header 
					len_ip			<= data_size_i + x"1C";-- Data + udp header + ip header
                    id              <= fifo_udp_out(5 downto 0);
				else
					start_encap		<= '0';
				end if;
					
				if TX_i.dv='1' then 
					CS_sum <= CS_sum + TX_i.data;
				elsif dv_uncap_dl='1' and TX_i.dv='0' then 
					CS_sum	<= CS_sum + port_dest + port_src + len_udp;
					--CS_ip		<= ;
				elsif dv_uncap_dl='0' and dv_uncap_dl2='1' then
					CS_udp 	<= not (CS_sum(15 downto 0) + CS_sum(31 downto 16));
					CS_ip 	<= x"AAAA";
				elsif TX.dv='0' and queue_dv_dl='1' then
					CS_sum	<= x"00000000";
					CS_ip		<= x"0000";
				end if;
			end if;
		end process;
		
		
		encapsule_ip_udp : process(clk125,reset_n)
		begin
			if reset_n='0' then
				state_encap 	<= idle;
				TX.dv			<= '0';
				TX.data 		<= (others =>'0');
				rd_fifo_udp		<= '0'; 
				count_udp		<=x"00";
				
			elsif CLK125'event and CLK125='1' then
					case(state_encap) is
					
						when idle => 
                                if TX_i.dv='1' and dv_uncap_dl='0' then
                                    rd_fifo_udp <= '1';
								elsif start_encap='0' and start_encap_dl='1' then
									set_length	<= '1';
									count_udp	<=x"00"; 
								elsif set_length='1' then
									set_length	<= '0';
									state_encap <= ethernet;
									eth_hdr		<= mac_addr_dest & mac_addr_hal & x"0800";
									ip_hdr		<= x"4500" & len_ip & x"00004000" & x"8011" & CS_ip & ip_hal & ip_dest;
									udp_hdr		<= port_src & port_dest & len_udp & CS_udp;
								else
									TX.dv	    <= '0';
                                    rd_fifo_udp <= '0';
								end if;
						
						when ethernet =>
								TX.dv	    <= '1';
								eth_hdr		<= eth_hdr(103 downto 0) & eth_hdr(111 downto 104);
								TX.data     <= eth_hdr(111 downto 104);
								if count_udp=x"0D" then
									state_encap	<= ip;
									count_udp	<=x"00";
								else
									count_udp <= count_udp +1;
								end if;
								
						when ip =>
								ip_hdr			<= ip_hdr(151 downto 0) & ip_hdr(159 downto 152);		
								TX.data 	    <= ip_hdr(159 downto 152);
								if count_udp=x"13" then
									state_encap	<= udp;	
									count_udp	<=x"00";
								else
									count_udp <= count_udp +1;
								end if;
						
                        when udp => --- Header for GPStudio
                                udp_hdr		<= udp_hdr(55 downto 0) & udp_hdr(63 downto 56);	
								TX.data     <= udp_hdr(63 downto 56);
                                count_udp <= count_udp +1;
                                if count_udp=x"07" then
									state_encap	<= data;	
									count_udp	<=x"00";
                                    rd_fifo_udp	<= '1';
								end if;
                        
						when data =>
								TX.data <= fifo_udp_out;
								if empty_fifo_udp='1' and rd_fifo_udp='1' then 
									rd_fifo_udp	<= '0';
								elsif rd_fifo_udp	= '0' then
									TX.dv	<= '0';
									state_encap	<= idle;		
								end if;
						
						when others =>
								state_encap <= idle;
								
					end case;
			end if;		
		end process;
		
		TX_o			<= TX;
		port_src		<= "00"& id & x"00";
        mac_addr_hal    <= mac_addr_hal_msb & mac_addr_hal_lsb;
        mac_addr_dest   <= mac_addr_dest_msb & mac_addr_dest_lsb;
		
		
end RTL;