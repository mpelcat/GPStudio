------------------------------------------------------------------------------
-- Title      : Gradient 3x3 8 bits test bench 
-- Project    : Gradient 3x3 8 bits
------------------------------------------------------------------------------
-- File       : tb_gradient_3x3.vhd
-- Author     : N. Roudel
-- Company    : Wisip
-- Created    : 2014-02-07
-- Last update: 2014-02-07
-- Platform   :
-- Standard   :
------------------------------------------------------------------------------
-- Description:
------------------------------------------------------------------------------
-- Copyright (c) 2013, 2014 - Wisip
------------------------------------------------------------------------------
-- Revisions  :
-- Date         Version  Author     Description
-- 2014-02-07   1.0      N. Roudel  File created
------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

library gradient_3x3_lib;
use gradient_3x3_lib.gradient_3x3_comp.all;

library matrix_type_lib;
use matrix_type_lib.matrix_type_comp.all;

entity tb_gradient_3x3 is
end tb_gradient_3x3;

architecture behavioral of tb_gradient_3x3 is

	constant CLOCK_T_ON  : time := 5 ns;
	constant CLOCK_T_OFF : time := 5 ns;
	constant RESET_T_ON  : time := 1 us;
	constant IM_WIDTH	 : positive := 10;
	
	signal clk_s  			: std_logic;
	signal rst_s  			: std_logic;
	signal data_i_s  		: matrix_3x3_8b_t;
	signal frame_valid_i_s	: std_logic;
	signal data_valid_i_s	: std_logic;
	signal frame_valid_o_s	: std_logic;
	signal data_valid_o_s	: std_logic;
	signal Ixx_o_s  		: std_logic_vector(17 downto 0);
	signal Ixy_o_s  		: std_logic_vector(17 downto 0);
	signal Iyy_o_s  		: std_logic_vector(17 downto 0);
	
	
begin

	GRADIENT_3x3_INST : component gradient_3x3
		port map (
			rst_i  			=> rst_s ,
			clk_i  			=> clk_s ,
			frame_valid_i	=> frame_valid_i_s,
			data_valid_i	=> data_valid_i_s,
			data_i 			=> data_i_s,
			data_valid_o	=> data_valid_o_s,
			frame_valid_o	=> frame_valid_o_s,
			Ixx_o			=> Ixx_o_s,
			Ixy_o			=> Ixy_o_s,
			Iyy_o			=> Iyy_o_s
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
	variable cnt : positive;
	begin
		data_i_s(1) <= x"90";
		data_i_s(2) <= x"80";
		data_i_s(3) <= x"70";
		data_i_s(4) <= x"60";
		data_i_s(5) <= x"50";
		data_i_s(6) <= x"40";
		data_i_s(7) <= x"30";
		data_i_s(8) <= x"20";
		data_i_s(9) <= x"10";
		cnt := 1;
		
		for i in 1 to 1000*1000 loop
		wait until clk_s'event and clk_s='1';
			data_i_s(4) <= data_i_s(4) + x"10";
			data_i_s(2) <= data_i_s(2) + x"10";
			--if( data_i_s = x"12" or data_i_s = x"13" )then
				--data_valid_i_s <= '0';
			--else
				--data_valid_i_s <= '1';
			--end if;
			
			--if( cnt = 7*IM_WIDTH )then
			--	frame_valid_i_s <= '0';
			--	cnt := 1;
			--else
			--	frame_valid_i_s <= '1';
			--	cnt := cnt + 1;
			--end if;
		end loop;
		
		wait;
	end process;
	
end behavioral;