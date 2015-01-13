library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
LIBRARY std;
 

entity mt9 is
	generic(
		gen_num_reg		:	integer := 3
	);
	port(
		mt9_extclk 		: 	in	std_logic;
		mt9_sclk 		: 	in	std_logic;
		mt9_sclkdouble : 	in	std_logic;
		
		mt9_extclk_o	:	out std_logic;
		mt9_reset_n_o	:	out std_logic;
		mt9_standby_o	:	out std_logic;
		mt9_oe_n_o		:	out std_logic;
		mt9_trigger_o	:	out std_logic;
		mt9_saddr_o		:	out std_logic;
		mt9_sdata_io	:	inout std_logic;
		mt9_sclk_o		:	out std_logic;
		
		mt9_regconf_done  :	out std_logic
		
		);
end mt9;

architecture rtl of mt9 is
-- type reset_register_stream_bit is (trigger_mode, )
-- type reset_register_t is record
  
  -- stream : std_logic;
-- end record;
constant IMAGE_WIDTH  : natural := 320;
--constant IMAGE_WIDTH  : natural := 1280;
constant X_ADDR_START : natural := 0;
constant X_ADDR_END   : natural := X_ADDR_START+IMAGE_WIDTH-1;

constant IMAGE_HEIGHT : natural := 240;
--constant IMAGE_HEIGHT : natural := 960;
constant Y_ADDR_START : natural := 0;
constant Y_ADDR_END   : natural := Y_ADDR_START+ IMAGE_HEIGHT-1;

signal p0_cnt1 : integer range 1 to 200000 := 1;
signal p1_start: std_logic := '0';

type p1_sm is (w_init,w_start,w_slave_addr_wr,w_ack1,w_reg_addr_msb,w_ack2,w_reg_addr_lsb,w_ack3,w_write_data_msb,w_ack4,w_write_data_lsb,w_ack5,w_stop,w_fin);
signal p1_state : p1_sm := w_init;

signal p1_tempo 			: integer range 1 to 20000000*4 := 1;
signal p1_cnt1 			: integer range 0 to 8 := 0;

signal int_slave_addr_wr: std_logic_vector(7 downto 0) := x"20";

type reg_tab is array (0 to 10) of std_logic_vector(15 downto 0);
signal int_reg_start_addr: reg_tab := (others=>(others=>'0'));
signal int_reg_start_data: reg_tab := (others=>(others=>'0'));

signal int_cnt_reg_write	:	integer range 0 to 10 := 0;

signal mt9_conf_done : 	std_logic;
signal int_reset_n	:	std_logic;

begin

		
	mt9_extclk_o	<= mt9_extclk;
	mt9_oe_n_o		<= '0';	
	mt9_standby_o	<= '0';
	mt9_trigger_o	<= '1';
	mt9_saddr_o		<= '0';	
	mt9_reset_n_o  <= int_reset_n;
	mt9_sclk_o		<= mt9_sclk;
	
	mt9_regconf_done	<= mt9_conf_done;
	
	int_slave_addr_wr <= x"20";
	
	-- Reset register & i/o configuration
	int_reg_start_addr(0) <= x"301A";
	int_reg_start_data(0) <= x"01D8";

	-- Y address start
	-- int_reg_start_addr(1) <= x"3002";
	-- int_reg_start_data(1) <= x"0000";

	-- Y address start
	int_reg_start_addr(1) <= x"3002";
	int_reg_start_data(1) <= 
		std_logic_vector(to_unsigned(
      Y_ADDR_START,int_reg_start_data(3)'length
    ));	-- x"0002";
	-- Y address end (reg_3006-reg_3002+1)
	int_reg_start_addr(2) <= x"3006";
	int_reg_start_data(2) <= 
    std_logic_vector(to_unsigned(
      Y_ADDR_END,int_reg_start_data(4)'length
    )); --x"01F3";
  
  -- X address start
  int_reg_start_addr(3) <= x"3004";
	int_reg_start_data(3) <= 
    std_logic_vector(to_unsigned(
      X_ADDR_START,int_reg_start_data(3)'length
    )); --x"0002";
  -- X address end (reg_3008-reg_3004+1)
  int_reg_start_addr(4) <= x"3008";
	int_reg_start_data(4) <=
    std_logic_vector(to_unsigned(
      X_ADDR_END,int_reg_start_data(4)'length
    )); --x"0401";
	
	-- Autoexposure control: 	x"0000" disables AE,
	--									x"0001" enables AE,
	--									x"0003" enables AE + auto analog gain
	--									x"0013" enables AE + auto_gain (digital & analog)
	--int_reg_start_addr(2) <= x"3100";	
	--int_reg_start_data(2) <= x"0001";
	
	-- Coarse Integration Time = R0x3012 * RawTime. (RawTime = 50 µs)
	int_reg_start_addr(5) <= x"3012";	
	int_reg_start_data(5) <= x"00E6"; --x"00C6";
	
  -- int_reg_start_addr(4) <= x"3070";	-- Test patterns
	-- int_reg_start_data(4) <= x"0002"; -- 3: 100% color bar test pattern
	-- int_reg_start_data(4) <= x"0003"; -- 3: Fade-to-grey color bar test pattern
  
  int_reg_start_addr(6) <= x"3100";	-- Auto Exposure
	int_reg_start_data(6) <= x"0000"; -- 0: disabled
	-- int_reg_start_data(6) <= x"0013";

  int_reg_start_addr(7) <= x"3064";	-- Embedded data
	int_reg_start_data(7) <= x"1802"; -- 0: disabled
	
--	int_reg_start_addr(8) <= x"30B0";	-- Embedded data
--	int_reg_start_data(8) <= x"0000"; 	-- 0: CFA color 

   int_reg_start_addr(8) <= x"3030";	
   int_reg_start_data(8) <= x"0010"; 
		
	
	p0_boot_sequence: process(mt9_extclk)
		begin
			if( rising_edge(mt9_extclk) )then
				if( p0_cnt1 < 20000 )then
					int_reset_n 	<= '1';
					p1_start			<= '0';
					p0_cnt1 			<= p0_cnt1 + 1;
				elsif( p0_cnt1 < 190000 )then
					p0_cnt1 			<= p0_cnt1 + 1;					
					int_reset_n 	<= '0';
				else
					p1_start 		<= '1';
					int_reset_n		<= '1';
				end if;			
			end if;
		end process p0_boot_sequence;
		
	p1_write_reg:process(mt9_sclkdouble,p1_start)
		begin
			if( p1_start = '0' )then
				p1_state <= w_init;	
				mt9_conf_done <= '0';
				int_cnt_reg_write <= 0;
			elsif( rising_edge(mt9_sclkdouble) )then	
				case p1_state is
					when w_init =>
						mt9_sdata_io 		<= '1';
						if(p1_tempo = 400000)then
							p1_state			<= w_start;
						else
							p1_tempo 		<= p1_tempo + 1;
							p1_state			<= w_init;
						end if;	
						
					when w_start =>
						if(mt9_sclk = '1')then
							mt9_sdata_io 	<= '0';
							p1_cnt1	 		<= 0;
							p1_state			<= w_slave_addr_wr;
						end if;
						
					when w_slave_addr_wr =>
						if(mt9_sclk = '0')then
							if( p1_cnt1 < 8 )then
								mt9_sdata_io <= int_slave_addr_wr(7-p1_cnt1);
								p1_cnt1 <= p1_cnt1 + 1;
								p1_state <= w_slave_addr_wr;
							else
								mt9_sdata_io <= 'Z';
								p1_state <= w_ack1;
							end if;									
						end if;
					
					when w_ack1 =>
						p1_cnt1 <= 0;
						mt9_sdata_io <= 'Z';
						if(mt9_sclk = '1')then
							p1_state <= w_reg_addr_msb;
						end if;
						
					when w_reg_addr_msb =>
						if(mt9_sclk = '0')then
							if( p1_cnt1 < 8 )then
								mt9_sdata_io <= int_reg_start_addr(int_cnt_reg_write)(15-p1_cnt1);
								p1_cnt1 <= p1_cnt1 + 1;
								p1_state <= w_reg_addr_msb;
							else
								mt9_sdata_io <= 'Z';
								p1_cnt1 <= 0;
								p1_state <= w_ack2;
							end if;					
						end if;
						
					when w_ack2 =>
						mt9_sdata_io <= 'Z';
						if(mt9_sclk = '1')then
							p1_state <= w_reg_addr_lsb;
						end if;
						
					when w_reg_addr_lsb =>
						if(mt9_sclk = '0')then
							if( p1_cnt1 < 8 )then
								mt9_sdata_io <= int_reg_start_addr(int_cnt_reg_write)(7-p1_cnt1);
								p1_cnt1 <= p1_cnt1 + 1;
								p1_state <= w_reg_addr_lsb;
							else
								mt9_sdata_io <= 'Z';
								p1_cnt1 <= 0;
								p1_state <= w_ack3;
							end if;					
						end if;	
					
					when w_ack3 =>
						mt9_sdata_io <= 'Z';
						if(mt9_sclk = '1')then
							p1_state <= w_write_data_msb;
						end if;
							
					when w_write_data_msb =>
						if(mt9_sclk = '0')then
							if( p1_cnt1 < 8 )then
								mt9_sdata_io <= int_reg_start_data(int_cnt_reg_write)(15-p1_cnt1);
								p1_cnt1 <= p1_cnt1 + 1;
								p1_state <= w_write_data_msb;
							else
								mt9_sdata_io <= 'Z';
								p1_cnt1 <= 0;
								p1_state <= w_ack4;
							end if;					
						end if;	
					
					when w_ack4 =>
						mt9_sdata_io <= 'Z';
						if(mt9_sclk = '1')then
							p1_state <= w_write_data_lsb;
						end if;
						
					when w_write_data_lsb =>
						if(mt9_sclk = '0')then
							if( p1_cnt1 < 8 )then
								mt9_sdata_io <= int_reg_start_data(int_cnt_reg_write)(7-p1_cnt1);
								p1_cnt1 <= p1_cnt1 + 1;
								p1_state <= w_write_data_lsb;
							else
								mt9_sdata_io <= 'Z';
								p1_cnt1 <= 0;
								p1_state <= w_ack5;
							end if;					
						end if;		
						
					when w_ack5 =>
						mt9_sdata_io <= '0';
						if(mt9_sclk = '1')then
							p1_state <= w_stop;
						end if;	
						
					when w_stop =>
						if(mt9_sclk = '1')then
							mt9_sdata_io<= '1';
							p1_cnt1 		<= 0;
							p1_tempo		<= 1;
							if( int_cnt_reg_write = gen_num_reg-1)then
								p1_state 	<= w_fin;
							else
								int_cnt_reg_write <= int_cnt_reg_write+1;
								p1_state <= w_start;
							end if;
						end if;
						
						
					when w_fin =>
						mt9_sdata_io <= '1';
						mt9_conf_done <= '1';
						
					when others =>
				end case;
	
			end if;
		end process p1_write_reg;
	
	end rtl;
