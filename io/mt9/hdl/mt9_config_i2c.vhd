library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
library std;

entity mt9_config_i2c is
	port(
		reset_n			:	in	std_logic;
		mt9_extclk 		: 	in	std_logic;
		mt9_sclk 		: 	in	std_logic;
		mt9_sclkdouble	: 	in	std_logic;

		mt9_extclk_o	:	out std_logic;
		mt9_reset_n_o	:	out std_logic;
		mt9_standby_o	:	out std_logic;
		mt9_oe_n_o		:	out std_logic;
		mt9_trigger_o	:	out std_logic;
		mt9_saddr_o		:	out std_logic;
		mt9_sdata_io	:	inout std_logic;
		mt9_sclk_o		:	out std_logic;

		-- connections from mt9_config_i2c
		xstart_i		: in std_logic_vector(31 downto 0);
		ystart_i		: in std_logic_vector(31 downto 0);
		xend_i			: in std_logic_vector(31 downto 0);
		yend_i			: in std_logic_vector(31 downto 0);
		autoexp_i		: in std_logic_vector(31 downto 0);
		integtime_i		: in std_logic_vector(31 downto 0);
		linelenght_i	: in std_logic_vector(31 downto 0);
		send_reconf_i	: in std_logic;

		mt9_conf_done_o : out std_logic

	);
end mt9_config_i2c;

architecture rtl of mt9_config_i2c is

	constant GEN_NUM_REG : integer := 10;
	
	-- MT9 I2C constant for comunication
	constant MT9_I2C_SLAVE_ADDR			: std_logic_vector(7 downto 0)	:= x"20";
	
	constant Y_ADDR_START_I2CREG		: std_logic_vector(15 downto 0) := x"3002";
	constant X_ADDR_START_I2CREG		: std_logic_vector(15 downto 0) := x"3004";
	constant Y_ADDR_END_I2CREG			: std_logic_vector(15 downto 0) := x"3006";
	constant X_ADDR_END_I2CREG			: std_logic_vector(15 downto 0) := x"3008";
	constant RESET_REGISTER_I2CREG		: std_logic_vector(15 downto 0) := x"301A";
	constant COARSE_INTEGR_TIME_I2CREG	: std_logic_vector(15 downto 0) := x"3012";
	constant AE_CTRL_REG_I2CREG			: std_logic_vector(15 downto 0) := x"3100";
	constant EMBEDDED_DATA_CTRL_I2CREG	: std_logic_vector(15 downto 0) := x"3064";
	constant PLL_MULTIPLIER_I2CREG		: std_logic_vector(15 downto 0) := x"3030";
	constant LINE_LENGHT_PCK_I2CREG		: std_logic_vector(15 downto 0) := x"300C";

	-- counter for power up timer and reset
	signal p0_cnt1 : integer range 1 to 200000 := 1;

	-- internal state of send_config_proc
	type p1_sm is (w_init, wait_config, w_start, w_slave_addr_wr, w_ack1, w_reg_addr_msb, w_ack2, w_reg_addr_lsb, w_ack3, w_write_data_msb, w_ack4, w_write_data_lsb, w_ack5, w_stop, w_fin);
	signal p1_state : p1_sm := w_init;

	signal p1_tempo 	: integer range 1 to 20000000*4 := 1;
	signal p1_cnt1 		: integer range 0 to 8 := 0;

	signal int_cnt_reg_write	:	integer range 0 to 10 := 0;
	signal int_slave_addr_wr: std_logic_vector(7 downto 0) := MT9_I2C_SLAVE_ADDR;

	-- array of value and adress to send via i2c
	type reg_tab is array (0 to GEN_NUM_REG+1) of std_logic_vector(15 downto 0);
	signal int_reg_start_addr: reg_tab := (others=>(others=>'0'));
	signal int_reg_start_data: reg_tab := (others=>(others=>'0'));

	signal mt9_conf_done : 	std_logic;
	signal int_reset_n	:	std_logic;

	signal timer_start	:	std_logic := '0';

begin

	mt9_extclk_o	<= mt9_extclk;
	mt9_oe_n_o		<= '0';
	mt9_standby_o	<= '0';
	mt9_trigger_o	<= '1';
	mt9_saddr_o		<= '0';
	mt9_reset_n_o  <= int_reset_n;
	mt9_sclk_o		<= mt9_sclk;

	int_slave_addr_wr <= MT9_I2C_SLAVE_ADDR;

	-- Reset register & i/o configuration
	int_reg_start_addr(0) <= RESET_REGISTER_I2CREG;	-- reset register
	int_reg_start_data(0) <= x"01DC";	-- 

	-- Y address start
	int_reg_start_addr(1) <= Y_ADDR_START_I2CREG;
	int_reg_start_data(1) <= ystart_i(15 downto 0);
	-- Y address end (reg_3006-reg_3002+1)
	int_reg_start_addr(2) <= Y_ADDR_END_I2CREG;
	int_reg_start_data(2) <= yend_i(15 downto 0);

	-- X address start
	int_reg_start_addr(3) <= X_ADDR_START_I2CREG;
	int_reg_start_data(3) <= xstart_i(15 downto 0);
	-- X address end (reg_3008-reg_3004+1)
	int_reg_start_addr(4) <= X_ADDR_END_I2CREG;
	int_reg_start_data(4) <= xend_i(15 downto 0);

	-- Coarse Integration Time = R0x3012 * RawTime. (RawTime = 50 µs)
	int_reg_start_addr(5) <= COARSE_INTEGR_TIME_I2CREG;
	int_reg_start_data(5) <= integtime_i(15 downto 0); --x"00E6";

	-- int_reg_start_addr(4) <= x"3070";	-- Test patterns
	-- int_reg_start_data(4) <= x"0002"; -- 3: 100% color bar test pattern
	-- int_reg_start_data(4) <= x"0003"; -- 3: Fade-to-grey color bar test pattern

	int_reg_start_addr(6) <= AE_CTRL_REG_I2CREG;	-- Auto Exposure
	int_reg_start_data(6) <= autoexp_i(15 downto 0);
	-- Autoexposure control: 	x"0000" disables AE,
	--							x"0001" enables AE,
	--							x"0003" enables AE + auto analog gain
	--							x"0013" enables AE + auto_gain (digital & analog)

	int_reg_start_addr(7) <= EMBEDDED_DATA_CTRL_I2CREG;	-- Embedded data
	int_reg_start_data(7) <= x"1802";	-- 1802: disabled embeded data
										-- 1982: enabled embeded data (default)

	int_reg_start_addr(8) <= PLL_MULTIPLIER_I2CREG;	-- pll_multiplier
	int_reg_start_data(8) <= x"002C";	-- multiplier set to 44

	int_reg_start_addr(9) <= LINE_LENGHT_PCK_I2CREG;	-- line lenght reg
	int_reg_start_data(9) <= linelenght_i(15 downto 0);

	-- Reset register & i/o configuration
	--int_reg_start_addr(9) <= RESET_REGISTER_I2CREG;	-- reset register
	--int_reg_start_data(9) <= x"01DC";	-- pass image sensor in streaming mode (video mode)

	timer_start_proc : process(reset_n, mt9_extclk)
	begin
		if(reset_n = '0') then
			p0_cnt1 		<= 1;
			timer_start		<= '0';
		elsif(rising_edge(mt9_extclk)) then
			if( p0_cnt1 < 20000) then
				int_reset_n 	<= '1';
				timer_start		<= '0';
				p0_cnt1 			<= p0_cnt1 + 1;
			elsif(p0_cnt1 < 190000) then
				p0_cnt1 		<= p0_cnt1 + 1;
				int_reset_n 	<= '0';
			else
				int_reset_n		<= '1';
				timer_start 	<= '1';
			end if;
		end if;
	end process;

	send_config_proc : process(reset_n, mt9_sclkdouble, timer_start)
	begin
		if(reset_n = '0' or timer_start = '0') then
			p1_state <= w_init;
			mt9_conf_done <= '0';
			p1_tempo <= 1;
		elsif(rising_edge(mt9_sclkdouble)) then
			case p1_state is
			
				when w_init =>
					mt9_conf_done <= '0';
					if(p1_tempo = 400000)then
						p1_state		<= wait_config;
					else
						p1_tempo 		<= p1_tempo + 1;
						p1_state		<= w_init;
					end if;
			
				when wait_config =>
					mt9_sdata_io 		<= '1';
					if(send_reconf_i = '1') then
						p1_state			<= w_start;
						int_cnt_reg_write	<= 0;
					end if;

				when w_start =>
					if(mt9_sclk = '1')then
						mt9_sdata_io 	<= '0';
						p1_cnt1	 		<= 0;
						p1_state		<= w_slave_addr_wr;
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
						if( int_cnt_reg_write = GEN_NUM_REG-1)then
							p1_state 	<= w_fin;
						else
							int_cnt_reg_write <= int_cnt_reg_write+1;
							p1_state <= w_start;
						end if;
					end if;

				when w_fin =>
					mt9_sdata_io <= '1';
					mt9_conf_done <= '1';
					p1_state <= wait_config;

				when others =>
			end case;

		end if;
	end process;

	mt9_conf_done_o <= mt9_conf_done;

end rtl;
