------------------------------------------------------------------------------
-- Title      : Matrix 3x3 Builder module test bench 
-- Project    : Matrix 3x3 Builder
------------------------------------------------------------------------------
-- File       : tb_matrix_3x3_builder.vhd
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

library matrix_3x3_builder_8b_lib;
use matrix_3x3_builder_8b_lib.matrix_3x3_builder_8b_comp.all;

library matrix_3x3_builder_18b_lib;
use matrix_3x3_builder_18b_lib.matrix_3x3_builder_18b_comp.all;

library matrix_type_lib;
use matrix_type_lib.matrix_type_comp.all;

entity tb_matrix_3x3_builder is
end tb_matrix_3x3_builder;

architecture behavioral of tb_matrix_3x3_builder is

	constant CLOCK_T_ON  : time := 5 ns;
	constant CLOCK_T_OFF : time := 5 ns;
	constant RESET_T_ON  : time := 1 us;
	constant IM_WIDTH	 : positive := 10;
	
	signal clk_s  			: std_logic;
	signal rst_s  			: std_logic;
	signal data_i1_s  		: std_logic_vector(7 downto 0) := x"01";
	signal data_i2_s  		: std_logic_vector(17 downto 0) := "000000000000000001";
	signal data_valid_i_s	: std_logic;
	signal frame_valid_i_s	: std_logic;
	signal data_valid_i1_s	: std_logic;
	signal data_valid_i2_s	: std_logic;
	signal data_valid_o1_s	: std_logic;
	signal data_valid_o2_s	: std_logic;
	signal data_o1_s  		: matrix_3x3_8b_t;
	signal data_o2_s  		: matrix_3x3_18b_t;
	signal cnt_line_s  		: integer := 0;
	signal frame_valid_o1_s	: std_logic;
	signal frame_valid_o2_s	: std_logic;
	
	
begin

	MATRIX_3x3_BUILDER_8B_INST : component matrix_3x3_builder_8b
		generic map(
			IM_WIDTH  => IM_WIDTH
		)
		port map (
			rst_i  		=> rst_s ,
			clk_i  		=> clk_s ,
			frame_valid_i=> frame_valid_i_s,
			data_valid_i=> data_valid_i1_s,
			data_i 		=> data_i1_s,
			frame_valid_o=> frame_valid_o1_s,
			data_valid_o=> data_valid_o1_s,
			data_o		=> data_o1_s
		);
		
		
	MATRIX_3x3_BUILDER_18B_INST : component matrix_3x3_builder_18b
		generic map(
			IM_WIDTH  => IM_WIDTH
		)
		port map (
			rst_i  		=> rst_s ,
			clk_i  		=> clk_s ,
			frame_valid_i=> frame_valid_i_s,
			data_valid_i=> data_valid_i2_s,
			data_i 		=> data_i2_s,
			frame_valid_o=> frame_valid_o2_s,
			data_valid_o=> data_valid_o2_s,
			data_o		=> data_o2_s
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

	data_valid_i1_s  <= data_valid_i_s;
	data_valid_i2_s  <= data_valid_i_s;
	
	DATA_IN_PROC : process
	variable cnt : positive;
	begin
		data_i1_s <= x"01";
		data_i2_s <= "000000000000000001";
		cnt := 1;

		
		for i in 1 to IM_WIDTH*1000 loop
		wait until clk_s'event and clk_s='1';
			data_i1_s <= data_i1_s + 1;
			data_i2_s <= data_i2_s + 1;
		end loop;
		
		wait;
	end process;
	
end behavioral;