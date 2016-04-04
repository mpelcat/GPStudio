--------------------------------------------------------
-- This bloc generates the baud counter which is used by 
-- the receiver and the transmitter to synchronize data 
-- with the GPS baud rate.
--------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity clk_gen is
port (
			clk_50M			: in std_logic;
			reset 			: in std_logic;
			enable 			: in std_logic;			
			count_max 		: in unsigned(15 downto 0);
			count_bd  		: out unsigned(15 downto 0);
			rst_count_bd 	: in std_logic
		);
end clk_gen;

architecture RTL of clk_gen is

signal count_bd_s 		: unsigned(15 downto 0);

begin

process(clk_50M,reset)
begin
	if reset='0' then
		count_bd_s <= x"0000";
	
	elsif clk_50M'event and clk_50M='1'then		
		if enable='1' then
			
			if rst_count_bd='1' or count_bd_s=count_max then		----- Reset the counter only when it reaches the max count defined by baud rate
				count_bd_s <= x"0000";					----- or when a reset is asked by UART blocks
			else
				count_bd_s <= count_bd_s +1;
			end if;		
		end if;	
		
	end if;
	
end process;

count_bd<= count_bd_s;

end RTL;
