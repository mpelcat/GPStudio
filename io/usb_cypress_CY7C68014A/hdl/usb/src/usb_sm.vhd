
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
-- library std;
library work;
use work.ComFlow_pkg.all;

entity usb_sm is
 generic (
	FLOW_STATUS_ID : integer;
	NB_FLOW : integer := 2 ; 
	IDFLOW : IDFLOW_t -- array (0 to 255) of integer range 0 to 255;
	-- CDC : integer := 1; -- activate CDC
	-- CDC_SYNC_FF_CHAIN_DEPTH: integer := 2 -- CDC Flip flop Chain depth
    );
  port(
    usb_ifclk    : in    std_logic;
    usb_flaga    : in    std_logic;
    usb_flagb    : in    std_logic;
    usb_flagc    : in    std_logic;
    usb_flagd    : in    std_logic;
    usb_fd_io    : inout std_logic_vector(15 downto 0);
    usb_sloe     : out   std_logic;
    usb_slrd     : out   std_logic;
    usb_slwr     : out   std_logic;
    usb_pktend   : out   std_logic;
    usb_addr     : out   std_logic_vector(1 downto 0);
    
	usb_rst		  : in 	std_logic;
	 
	flow_in_data_o  : out   std_logic_vector(15 downto 0);
	flow_in_wr_o	: out   std_logic;
	flow_in_full_i: in   std_logic;
	flow_in_end_o : out std_logic;
	 
	flow_out_data_i  : in   std_logic_vector(15 downto 0);
	flow_out_rd_o	: out   std_logic;
	flow_out_empty_i: in   std_logic;
	flow_out_rdy_i : in std_logic
    );
end usb_sm;

architecture rtl of usb_sm is

  type sm is (idle, rd, wr, wr_end,ReturnStatus,WaitOneCycleBeforeWr);
  signal state : sm := idle;

  type return_status_t is (flowid, packet_number, status );
  signal return_state : return_status_t := flowid;
  
  type status_t is (Idle, DecodeID,WaitEndWr);
  signal status_state : status_t := Idle;
  signal status_rdy_s : std_logic:='0';
  
  signal write_enable : std_logic;
  signal fifo_tx_flow_rdy_r : std_logic:='0';
  signal end_status_wr_s : std_logic:='0';
  signal usb_flaga_r :std_logic :='0';
  signal status_rdy_r : std_logic:='0';
  
  
  
  -- usb_start_rd synchronizer
  -- usb_start_rd launch and latch clocks are not the same
  
  -- signal fifo_tx_flow_rdy_sync_r  : std_logic_vector(CDC_SYNC_FF_CHAIN_DEPTH-1 downto 0);
  -- signal usb_start_rd_s                  : std_logic;

  
  ------------------------------
  -- ARRAY for FLOW STATUS
  -- ---------------------------
  type my_array_status is array(0 to NB_FLOW-1) of std_logic_vector(7 downto 0);
  signal array_status : my_array_status := (others=>(others=>'0'));
  
  signal flow_out_empty_i_r : std_logic :='0';
  signal fifo_tx_flow_rdy_s : std_logic:='0';
  
  
begin


-----------------------------------------------------------
-- Clock Domain Crossing Managment
-----------------------------------------------------------
--
-- CDC_GENERATE: 
	-- if (CDC = 1 ) generate

---	Clock Domain Crossing process
	-- CDC_SYNC : process (usb_ifclk)
	-- begin
		-- if usb_ifclk'event and usb_ifclk = '1' then
		  -- fifo_tx_flow_rdy_sync_r(0) <= flow_out_rdy_i;
		  -- for reg in 0 to CDC_SYNC_FF_CHAIN_DEPTH-2 loop
			-- fifo_tx_flow_rdy_sync_r(reg+1) <= fifo_tx_flow_rdy_sync_r(reg);
		  -- end loop;
		-- end if;
	  -- end process;
  
	-- fifo_tx_flow_rdy_s <= fifo_tx_flow_rdy_sync_r(CDC_SYNC_FF_CHAIN_DEPTH-1);
  
 -- end generate CDC_GENERATE;
  
-- NO_CDC_GENERATE:
--- directly connecte internal signals to input signals
	-- if (CDC = 0 ) generate 
	-- fifo_tx_flow_rdy_s <= flow_out_rdy_i;
  -- end generate NO_CDC_GENERATE;
  
fifo_tx_flow_rdy_s <= flow_out_rdy_i;
-----------------------------------------------------------


  
	-- connect status flow to array of status
	
	-- ARRAY_STATUS_GEN: for i in 0 to NB_FLOW-1 generate
	-- array_status(i) <= X"0" & "000" & flow_in_full_i;  connexion non generated
	-- end generate ARRAY_STATUS_GEN;
	
	array_status(0) <= X"0" & "000" & flow_in_full_i;
	array_status(1) <= std_logic_vector(to_unsigned(TX_PACKET_SIZE-1,8));
	------------------------------------------------
	
	
  process(usb_ifclk,usb_rst)
  
  variable status_nb : unsigned(15 downto 0):= (others=>'0');
  variable i :integer range 0 to NB_FLOW := 0;
  
  begin
	 if (usb_rst = '0') then
		state <= idle;
				 
		flow_in_wr_o <= '0';
		flow_out_rd_o <= '0';
		flow_in_end_o <= '0';

		usb_addr        <= "00";  -- Connected to End Point 2 - OUT - (EP2 = "00")
		usb_sloe        <= '1';
		usb_slrd        <= '1';
		usb_slwr        <= '1';
		usb_pktend      <= '1';
		
		write_enable    <= '0';
		usb_fd_io       <= (others => 'Z');
		fifo_tx_flow_rdy_r	<= '0';
		end_status_wr_s <='0';
		status_nb := (others=>'0');
		
		flow_out_empty_i_r <= '0';
		 
    elsif(rising_edge(usb_ifclk))then
	
	fifo_tx_flow_rdy_r <= fifo_tx_flow_rdy_s;
--	status_rdy_r <= status_rdy_s;
	flow_out_empty_i_r <= flow_out_empty_i;
	
      case state is
        when idle =>
          -- EZ-USB Interface : Do Nothing
          usb_addr   <= "00";  -- Connected to End Point 2 - OUT - (EP2 = "00")
         
		  usb_sloe   <= '1';
          usb_slrd   <= '1';
          usb_slwr   <= '1';
          usb_pktend <= '1';
		  flow_in_end_o <= '0';
         
          usb_fd_io  <= (others => 'Z');
			 
		 flow_in_wr_o <= '0';
		 flow_out_rd_o <= '0';
		 end_status_wr_s <='0';
		 
          if(usb_flaga = '1')then -- flaga : EP2 pas vide
            state <= rd;
			usb_sloe <= '0';
            usb_slrd <= '0';
		  elsif(status_rdy_s = '1' and usb_flagd='1')then
			state <= ReturnStatus;
          elsif(fifo_tx_flow_rdy_s = '1' and usb_flagd='1')then
		  --elsif(usb_start_rd_s = '1' and usb_flagd='1')then
              state <= WaitOneCycleBeforeWr;
			  usb_sloe   <= '1'; -- for test
			  flow_out_rd_o <= '1';
          else
            state <= idle;
          end if;

		
        when rd =>
          -- EZ-USB Interface : Read Request to EP2
          usb_addr   <= "00";  -- Connected to End Point 2 (EP2 = "00")
          usb_slwr   <= '1';
          usb_pktend <= '1';
		  flow_in_end_o <='0';
		  
          if(usb_flaga = '1')then
            usb_sloe <= '0';
            usb_slrd <= '0';
			-- ecrire usb_fd_io dans fifo EP2
			if flow_in_full_i = '0' then 
				--TODO: inversion octets pour USB
				flow_in_data_o(15 downto 8) <= usb_fd_io(7 downto 0);
				flow_in_data_o(7 downto 0) <= usb_fd_io(15 downto 8);
				usb_fd_io <= (others => 'Z');
				flow_in_wr_o <= '1';
			else
				flow_in_wr_o <= '0';
				
			end if;	
            state <= rd;
          
		  else
			flow_in_wr_o <= '0';
			usb_pktend <='0';
			flow_in_end_o <='1';
            state <= idle;
          end if;

		when WaitOneCycleBeforeWr =>
			state <= wr;
			usb_addr   <= "10"; 
 
        when wr =>
          usb_addr   <= "10";  -- Connected to End Point 6 - IN - (EP6 = "10")
          usb_sloe   <= '1';
          usb_slrd   <= '1';
          usb_pktend <= '1';
			 
          if(usb_flagd = '1') then -- flagd : EP6 pas plein
            usb_slwr  <= '0';
			
			if (fifo_tx_flow_rdy_s = '1') then		
					flow_out_rd_o <= '1';
					-- TODO:inversion pour USB
					usb_fd_io(7 downto 0) <= flow_out_data_i(15 downto 8) ; 
					usb_fd_io(15 downto 8) <= flow_out_data_i(7 downto 0) ; 		
					state           <= wr;
					
            elsif(fifo_tx_flow_rdy_r='1'and fifo_tx_flow_rdy_s = '0') then
					-- flow_out_rd_o <='0';
					-- state <= wr_end;
					-- usb_pktend <= '1';
					-- usb_slwr        <= '1';
					usb_fd_io(7 downto 0) <= flow_out_data_i(15 downto 8) ; 
					usb_fd_io(15 downto 8) <= flow_out_data_i(7 downto 0) ; 
					
					usb_pktend <= '0'; 
					flow_out_rd_o <='0';
					state <= wr_end;		
			else
					state <= wr_end;
            end if;
			
			-- if (flow_out_empty_i_r='0' and flow_out_empty_i = '1')  then
				-- usb_pktend <= '0'; 
				-- flow_out_rd_o <='0';
				-- state <= wr_end;
			-- end if;

          else
            usb_slwr <= '1';
            state <= idle;
          end if;

			
		-- Waiting for usb_start_read falling to zero
        when wr_end =>
			usb_pktend <= '1';
			usb_slwr        <= '1';
			state   <= idle;
			
			
		  -- Return FIFOs Full status 
		when ReturnStatus =>
			
		  usb_addr   <= "10";  -- Connected to End Point 6 - IN - (EP6 = "10")
          usb_sloe   <= '1';
          usb_slrd   <= '1';
          usb_pktend <= '1';
				  
		   if(usb_flagd = '1') then -- flagd : EP6 pas plein
				usb_slwr  <= '0';
			
				case return_state is
					when flowid => 
						usb_fd_io <= std_logic_vector(to_unsigned(FLOW_STATUS_ID,16));
						return_state <= packet_number;
						i := 0 ;
					
					when packet_number =>
						status_nb := status_nb + X"0001";
						-- on renvoie le fifo de chaque fifo de reception
						usb_fd_io(15 downto 8) <= std_logic_vector(status_nb(7 downto 0));
						usb_fd_io(7 downto 0)  <= std_logic_vector(status_nb(15 downto 8));
						
						return_state <= status;
						
						
					when status =>

							usb_fd_io(15 downto 8) <= array_status(i);
							usb_fd_io(7 downto 0) <= std_logic_vector(to_unsigned(IDFLOW(i),8));
							
							i := i + 1 ;
							if (i = NBFLOW) then
								return_state <= flowid;	
								usb_pktend <= '0';
								end_status_wr_s <='1';
								state <= wr_end;
							end if;

				end case;
          else
            usb_slwr <= '1';
            state <= idle;
          end if;

		end case;
    end if;
  end process;
  
  
STATUS_PROC:process (usb_ifclk, usb_rst) 
begin
	if (usb_rst = '0') then	
		status_rdy_s <='0';
		status_state <= Idle;
	elsif rising_edge(usb_ifclk) then
		usb_flaga_r <= usb_flaga;
		
			case status_state is
			
				when Idle =>
					if(usb_flaga_r='0' and usb_flaga = '1')then
						status_state <= DecodeID;
					end if;
					
				when DecodeID =>
					-- Si le FLOW ID correspond a celui du status usb
					if (usb_fd_io(15 downto 8) = std_logic_vector(to_unsigned(FLOW_STATUS_ID,8)) ) then
						status_rdy_s<='1';
						status_state <= WaitEndWr;
					else
						status_rdy_s<='0';
						status_state <= Idle;
					end if;
					
				when WaitEndWr =>
					if (end_status_wr_s ='1') then
						status_rdy_s<='0';
						status_state <= Idle;
					end if;
					
					-- en case d'erreur 
					-- if(return_state=flowid) then
						-- status_rdy_s<='0';
						-- status_state <= Idle;
					-- end if;
					
			end case;
	end if;
end process;


end rtl;
