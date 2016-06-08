
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ethernet_package.all;

entity synchro_receive is
	port (	   
				CLK125			: in std_logic;
				RESET_n			: in std_logic;
				RX_unsync		: in gmii_t;
				RX_unsync_dl	: in gmii_t;
				RX_sync			: out gmii_t
		);
end synchro_receive;

architecture RTL of synchro_receive is

signal RX_unsync_reg				: gmii_t;
signal RX_unsync_dl_inv			: gmii_t;
signal inv_clk						: std_logic;
signal sync, not_sync 			: std_logic;
shared variable detect_edge1	: std_logic;
shared variable detect_edge2	: std_logic;
signal fifo_sync_empty			: std_logic;
signal rd_en_sync					: std_logic;
signal rd_en_sync_dl				: std_logic;
signal data_valid_sync			: std_logic;
signal data_sync					: std_logic_vector(7 downto 0);

begin

---- Invert clock
inv_clk <= not CLK125;


---- Fifo synchronizing data from invert clock to normal clock 
sync_rx_inst : ENTITY work.sync_rx
	PORT map(
		data			=> RX_unsync_dl.data,
		rdclk			=> clk125,
		rdreq			=> rd_en_sync,
		wrclk			=> inv_clk,
		wrreq			=> RX_unsync_dl.dv,
		q				=> data_sync,
		rdempty		=> fifo_sync_empty,
		wrfull		=> open
	);

	
---- Flag detecting data on the rising edge of clk125 
process(CLK125,reset_n)
begin
	if reset_n='0' then
		not_sync				<= '0';
	elsif (CLK125'event and CLK125='1') then
		
		not_sync 			<= detect_edge1;		
		RX_unsync_reg 		<= RX_unsync;
		if RX_unsync.dv='1' and RX_unsync_reg.dv='0' and detect_edge2='0' then
			detect_edge1 	:='1';
		elsif rd_en_sync='0' and rd_en_sync_dl='1' then
			detect_edge1 	:='0';
		end if;	
		
	end if;
end process;


---- Flag detecting data on the falling edge of clk125 
process(inv_clk,reset_n)
begin
	if reset_n='0' then
		sync					<= '0';
		
	elsif (inv_clk'event and inv_clk='1') then
		sync 					<= detect_edge2;
		RX_unsync_dl_inv	<= RX_unsync;
		if RX_unsync.dv='1' and RX_unsync_dl_inv.dv='0' and detect_edge1='0' then
			detect_edge2 	:='1';
		elsif rd_en_sync='0' and rd_en_sync_dl='1' then
			detect_edge2 	:='0';
		end if;		
		
	end if;
end process;


---- Set Fifo signals
process(CLK125,reset_n)
begin
	if reset_n='0' then
		rd_en_sync		<= '0';
		
	elsif (CLK125'event and CLK125='1') then
		rd_en_sync 			<= not fifo_sync_empty;
		rd_en_sync_dl 		<= rd_en_sync;
		data_valid_sync	<= rd_en_sync and not fifo_sync_empty;
	end if;
end process;	



process(clk125,reset_n)
begin
	if reset_n='0' then
		RX_sync.dv				<= '0';
		RX_sync.data			<= (others=>'0');
		
	elsif (CLK125'event and CLK125='1') then
		if not_sync='1' then
			RX_sync.data		<=	data_sync;		 	--- If the synchro is not ok, get the data from the fifo
			RX_sync.dv			<= data_valid_sync;
		else
			RX_sync.data			<=	RX_unsync_dl.data	;	--- Else keep the data
			RX_sync.dv				<= RX_unsync_dl.dv;
		end if;
	end if;
end process;	

end RTL;