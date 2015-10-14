------------------------------------------------------------------------------
-- Title      : Convolution 3x3 18bits module test bench 
-- Project    : Convolution 3x3
------------------------------------------------------------------------------
-- File       : tb_convolution_3x3.vhd
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

library matrix_type_lib;
use matrix_type_lib.matrix_type_comp.all;

library convolution_3x3_18b_lib;
use convolution_3x3_18b_lib.convolution_3x3_18b_comp.all;


entity tb_convolution_3x3 is
end tb_convolution_3x3;

architecture behavioral of tb_convolution_3x3 is

	constant CLOCK_T_ON  : time := 5 ns;
	constant CLOCK_T_OFF : time := 5 ns;
	constant RESET_T_ON  : time := 1 us;
	constant IM_WIDTH	 : positive := 10;
	signal clk_s  			: std_logic;
	signal rst_s  			: std_logic;
	
	signal data_i_s  		: matrix_3x3_18b_t;
	signal mask_i_s  		: matrix_3x3_8b_t;	
	signal frame_valid_i_s	: std_logic;
	signal data_valid_i_s	: std_logic;
	
	signal data_o_s			: std_logic_vector(29 downto 0);
	signal frame_valid_o_s	: std_logic;
	signal data_valid_o_s	: std_logic;
	signal cnt_line_s  		: integer := 0;
	
begin

	CONVOLUTION_3x3_18B_INST : component convolution_3x3_18b
		port map (
			rst_i  		=> rst_s ,
			clk_i  		=> clk_s ,
			data_valid_i=> data_valid_i_s,
			frame_valid_i=> frame_valid_i_s,
			data_i 		=> data_i_s,
			mask_i		=> mask_i_s,
			
			frame_valid_o=> frame_valid_o_s,
			data_valid_o=> data_valid_o_s,
			data_o		=> data_o_s		
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
		mask_i_s <= (others => (others => '0'));
		mask_i_s(4) <= x"40";
		mask_i_s(2) <= "11111110";
		mask_i_s(9) <= "00000010";
		--mask_i_s.p15 <= "00000001";
		data_i_s	<= (others => (others => '0'));
		data_i_s(4)	<= "000000000000000001";
		wait until rst_s='0';		
		wait for 4*CLOCK_T_ON;
		
		for i in 1 to 100*1000 loop
		wait until clk_s'event and clk_s='1';
			data_i_s(4) <= data_i_s(4) + 1;
			--data_i_s <= data_i_s + 1;
			--if( data_i_s(11) > x"22" and data_i_s(11) < x"2C" )then
				--data_valid_i_s <= '0';
			--else
			--	data_valid_i_s <= '1';
			--end if;
		end loop;
		
		wait;
	end process;
	
end behavioral;