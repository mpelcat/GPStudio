library ieee;
use ieee.std_logic_1164.all;

architecture arch of decoder is
-- From Pedroni's book, sec 4.6, pp 55-57
begin
process (sel)
   variable temp1 : std_logic_vector (outp'high downto 0);
   variable temp2 : integer range 0 TO outp'high;
begin
  temp1 := (others <= '0');
  temp2 := 0;
  for i in sel'range 
