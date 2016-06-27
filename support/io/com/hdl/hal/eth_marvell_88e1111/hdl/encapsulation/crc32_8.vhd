----------------------------------------------------------------------------------
-- Company: Laboratoire Leprince-Ringuet
-- Engineer: 
-- 
-- Create Date:    12:09:35 10/14/2011 
-- Design Name: 
-- Module Name:    crc32_8 - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- CRC Calculation
-- This VHDL code was generated using CRCGEN.PL version 1.7
-- Last Modified: 01/02/2002
-- Options Used:
--    Module Name = crc32
--      CRC Width = 32
--     Data Width = 8
--     CRC Init   = F
--     Polynomial = [0 -> 32]
--        1 1 1 0 1 1 0 1 1 0 1 1 1 0 0 0 1 0 0 0 0 0 1 1 0 0 1 0 0 0 0 0 1
--
-- Disclaimer: THESE DESIGNS ARE PROVIDED "AS IS" WITH NO WARRANTY 
--             WHATSOEVER AND XILINX SPECIFICALLY DISCLAIMS ANY 
--             IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR
--             A PARTICULAR PURPOSE, OR AGAINST INFRINGEMENT.
-- Copyright (c) 2001,2002 Xilinx, Inc.  All rights reserved.
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity crc32_8 is Port(
	CRC_REG : out STD_LOGIC_VECTOR(31 downto 0);
	CRC : out STD_LOGIC_VECTOR(7 downto 0);
	D : in STD_LOGIC_VECTOR(7 downto 0);
	CALC : in STD_LOGIC;
	INIT : in STD_LOGIC;--synchronous reset
	D_VALID : in STD_LOGIC;
	CLK : in STD_LOGIC;
	RESET : in STD_LOGIC);--asynchronous reset
end crc32_8;

architecture Behavioral of crc32_8 is
	signal next_crc : STD_LOGIC_VECTOR(31 downto 0);
	signal crcreg : STD_LOGIC_VECTOR(31 downto 0);
begin
	CRC_REG <= crcreg;
	--CRC XOR equations
	next_crc(0) <= crcreg(30) xor D(1) xor crcreg(24) xor D(7);
	next_crc(1) <= D(6) xor D(7) xor D(0) xor crcreg(30) xor crcreg(31) xor D(1) xor crcreg(24) xor crcreg(25);
	next_crc(2) <= crcreg(26) xor D(5) xor D(6) xor D(7) xor crcreg(30) xor D(0) xor D(1) xor crcreg(31) xor crcreg(24) xor crcreg(25);
	next_crc(3) <= D(4) xor crcreg(26) xor D(5) xor crcreg(27) xor D(6) xor D(0) xor crcreg(31) xor crcreg(25);
	next_crc(4) <= D(4) xor crcreg(26) xor D(5) xor crcreg(27) xor crcreg(28) xor D(7) xor crcreg(30) xor D(1) xor crcreg(24) xor D(3);
	next_crc(5) <= D(4) xor crcreg(27) xor D(6) xor crcreg(28) xor D(7) xor crcreg(29) xor crcreg(30) xor D(0) xor D(1) xor crcreg(31) xor D(2) xor crcreg(24) xor D(3) xor crcreg(25);
	next_crc(6) <= crcreg(26) xor D(5) xor D(6) xor crcreg(28) xor crcreg(29) xor D(0) xor crcreg(30) xor crcreg(31) xor D(1) xor D(2) xor D(3) xor crcreg(25);
	next_crc(7) <= D(4) xor crcreg(26) xor D(5) xor crcreg(27) xor D(7) xor crcreg(29) xor D(0) xor crcreg(31) xor D(2) xor crcreg(24);
	next_crc(8) <= D(4) xor crcreg(27) xor D(6) xor crcreg(28) xor D(7) xor crcreg(24) xor crcreg(0) xor D(3) xor crcreg(25);
	next_crc(9) <= crcreg(26) xor D(5) xor D(6) xor crcreg(28) xor crcreg(29) xor D(2) xor D(3) xor crcreg(25) xor crcreg(1);
	next_crc(10) <= D(4) xor crcreg(26) xor crcreg(2) xor D(5) xor crcreg(27) xor D(7) xor crcreg(29) xor D(2) xor crcreg(24);
	next_crc(11) <= D(4) xor crcreg(27) xor D(6) xor crcreg(3) xor crcreg(28) xor D(7) xor crcreg(24) xor D(3) xor crcreg(25);
	next_crc(12) <= crcreg(26) xor D(5) xor D(6) xor crcreg(28) xor D(7) xor crcreg(4) xor crcreg(29) xor crcreg(30) xor D(1) xor D(2) xor crcreg(24) xor D(3) xor crcreg(25);
	next_crc(13) <= D(4) xor crcreg(26) xor D(5) xor crcreg(27) xor D(6) xor crcreg(29) xor D(0) xor crcreg(30) xor crcreg(5) xor crcreg(31) xor D(1) xor D(2) xor crcreg(25);
	next_crc(14) <= D(4) xor crcreg(26) xor D(5) xor crcreg(27) xor crcreg(28) xor crcreg(30) xor D(0) xor D(1) xor crcreg(31) xor crcreg(6) xor D(3);
	next_crc(15) <= D(4) xor crcreg(27) xor crcreg(28) xor crcreg(29) xor D(0) xor crcreg(31) xor D(2) xor crcreg(7) xor D(3);
	next_crc(16) <= crcreg(28) xor D(7) xor crcreg(29) xor D(2) xor crcreg(24) xor D(3) xor crcreg(8);
	next_crc(17) <= crcreg(9) xor D(6) xor crcreg(29) xor crcreg(30) xor D(1) xor D(2) xor crcreg(25);
	next_crc(18) <= crcreg(26) xor D(5) xor crcreg(10) xor crcreg(30) xor D(0) xor D(1) xor crcreg(31);
	next_crc(19) <= D(4) xor crcreg(27) xor crcreg(11) xor D(0) xor crcreg(31);
	next_crc(20) <= crcreg(28) xor crcreg(12) xor D(3);
	next_crc(21) <= crcreg(29) xor crcreg(13) xor D(2);
	next_crc(22) <= D(7) xor crcreg(14) xor crcreg(24);
	next_crc(23) <= D(6) xor D(7) xor crcreg(30) xor D(1) xor crcreg(15) xor crcreg(24) xor crcreg(25);
	next_crc(24) <= crcreg(26) xor D(5) xor D(6) xor D(0) xor crcreg(31) xor crcreg(16) xor crcreg(25);
	next_crc(25) <= D(4) xor crcreg(17) xor crcreg(26) xor D(5) xor crcreg(27);
	next_crc(26) <= D(4) xor crcreg(18) xor crcreg(27) xor crcreg(28) xor D(7) xor crcreg(30) xor D(1) xor crcreg(24) xor D(3);
	next_crc(27) <= D(6) xor crcreg(19) xor crcreg(28) xor crcreg(29) xor D(0) xor crcreg(31) xor D(2) xor D(3) xor crcreg(25);
	next_crc(28) <= crcreg(26) xor D(5) xor crcreg(20) xor crcreg(29) xor crcreg(30) xor D(1) xor D(2);
	next_crc(29) <= D(4) xor crcreg(27) xor crcreg(21) xor crcreg(30) xor D(0) xor D(1) xor crcreg(31);
	next_crc(30) <= crcreg(28) xor D(0) xor crcreg(22) xor crcreg(31) xor D(3);
	next_crc(31) <= crcreg(29) xor crcreg(23) xor D(2);

	-- Infer CRC-32 registers
	-- The crcreg register stores the CRC-32 value.
	-- CRC is the most significant 8 bits of the CRC-32 value.
	--
	-- Truth Table:
	-- -----+---------+----------+----------------------------------------------
	-- CALC | D_VALID | crcreg   | CRC 
	-- -----+---------+----------+----------------------------------------------
	--  0   |     0   | crcreg   | CRC 
	--  0   |     1   |  shift   | bit-swapped, complimented msbyte of crcreg
	--  1   |     0   | crcreg   | CRC 
	--  1   |     1   | next_crc | bit-swapped, complimented msbyte of next_crc
	process(CLK, RESET)
	begin
		if RESET = '0' then
			crcreg <= x"FFFFFFFF";
			CRC <= x"FF";
		elsif CLK'event and CLK = '1' then
			if INIT = '1' then
				crcreg <= x"FFFFFFFF";
				CRC <= x"FF";
			elsif CALC = '1' and D_VALID = '1' then
				crcreg <= next_crc;
				CRC <= not(next_crc(24) & next_crc(25) & next_crc(26) & next_crc(27) & 
                   			next_crc(28) & next_crc(29) & next_crc(30) & next_crc(31));
			elsif CALC = '0' and D_VALID = '1' then
				crcreg <= crcreg(23 downto 0) & x"FF";
				CRC <= not(crcreg(16) & crcreg(17) & crcreg(18) & crcreg(19) &
                   			crcreg(20) & crcreg(21) & crcreg(22) & crcreg(23));
			end if;
		end if;
	end process;
end Behavioral;
