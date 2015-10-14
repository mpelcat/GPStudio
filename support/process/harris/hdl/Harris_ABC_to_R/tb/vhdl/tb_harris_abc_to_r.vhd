------------------------------------------------------------------------------
-- Title      : Harris ABC module test bench 
-- Project    : Harris ABC
------------------------------------------------------------------------------
-- File       : tb_harris_abc.vhd
-- Author     : N. Roudel
-- Company    : Wisip
-- Created    : 2014-02-10
-- Last update: 2014-02-10
-- Platform   :
-- Standard   :
------------------------------------------------------------------------------
-- Description:
------------------------------------------------------------------------------
-- Copyright (c) 2013, 2014 - Wisip
------------------------------------------------------------------------------
-- Revisions  :
-- Date         Version  Author     Description
-- 2014-02-10   1.0      N. Roudel  File created
------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;


library harris_abc_to_r_lib;
use harris_abc_to_r_lib.harris_abc_to_r_comp.all;


entity tb_harris_abc_to_r is
end tb_harris_abc_to_r;

architecture behavioral of tb_harris_abc_to_r is

	constant CLOCK_T_ON  : time := 5 ns;
	constant CLOCK_T_OFF : time := 5 ns;
	constant RESET_T_ON  : time := 1 us;
	constant IM_WIDTH	 : positive := 64;
	constant IM_HEIGHT	 : positive := 64;
	constant PIXOUT_DELAY: positive := 18;
	
	signal clk_s  			: std_logic; 
	signal rst_s  			: std_logic;
		
	signal data_valid_i_s	: std_logic;
	signal frame_valid_i_s	: std_logic;
	
	signal	R_s				:  std_logic_vector(61 downto 0);
	
	signal Aw_i_s			: std_logic_vector(29 downto 0);
	signal Bw_i_s			: std_logic_vector(29 downto 0);
	signal Cw_i_s			: std_logic_vector(29 downto 0);
		
	signal data_valid_o_s	: std_logic;
	signal frame_valid_o_s	: std_logic;
	signal cnt_line_s  		: integer := 0;
	

begin

	harris_abc_to_r_INST : component harris_abc_to_r
		port map (
			rst_i  		=> rst_s ,
			clk_i  		=> clk_s ,
			frame_valid_i=> frame_valid_i_s,
			data_valid_i=> data_valid_i_s,
			Aw_i		=> Aw_i_s,
            Bw_i		=> Bw_i_s,
			Cw_i		=> Cw_i_s,
			data_valid_o=> data_valid_o_s,
			frame_valid_o=> frame_valid_o_s,
			R_o			=> R_s	
		);

------------------------------------------------------------------------------

	CLOCK_PROC : process 
	begin
		while true loop
			clk_s <= '0';
			wait for CLOCK_T_OFF;
			clk_s <= '1';
			wait for CLOCK_T_ON;
		end loop;
		wait;
	end process;

	RESET_PROC : process 
	begin
		rst_s <= '1';
		wait for RESET_T_ON;
		rst_s <= '0';
		wait;
	end process;	
	
	
	FRAME_VALID_PROC : process
	begin
		frame_valid_i_s 	<= '0';
		wait until rst_s = '1';
		wait until rst_s = '0';
		wait for 8*CLOCK_T_ON;
		for i in 1 to 1000*1000 loop
			for i in 1 to IM_WIDTH*IM_WIDTH+4*IM_WIDTH loop
				wait until rising_edge(clk_s);
					frame_valid_i_s 	<= '1';
			end loop;

			frame_valid_i_s 	<= '0';
			wait for 12*CLOCK_T_ON;
		end loop;	
		wait;
	end process;
	
	DATA_VALID_PROC : process
	begin
		data_valid_i_s 	<= '0';
		cnt_line_s		<= 0;
		wait until frame_valid_i_s = '0';
		wait until frame_valid_i_s = '1';
		for i in 1 to 1000*1000 loop			
			wait for 4*CLOCK_T_ON;
			if( frame_valid_i_s = '1' )then
				for i in 1 to IM_WIDTH+1 loop
					wait until rising_edge(clk_s);					
						data_valid_i_s <= '1';					
			end loop;
			

			data_valid_i_s  <= '0';
			wait for 4*CLOCK_T_ON;
			end if;
		end loop;	
		wait;
	end process;
	
	DATA_IN_PROC : process
	begin
		Aw_i_s <= (others => '0');
		Bw_i_s <= (others => '1');
		Cw_i_s <= (others => '0');
		wait until data_valid_i_s = '1';
		for i in 1 to 100*100 loop			
			wait until clk_s'event and clk_s='1' and data_valid_i_s = '1';
				Aw_i_s <= Aw_i_s + 10;
				Bw_i_s <= Bw_i_s - 20;
				Cw_i_s <= Cw_i_s - 30;
				
		end loop;		
		wait;
	end process;
	
end behavioral;