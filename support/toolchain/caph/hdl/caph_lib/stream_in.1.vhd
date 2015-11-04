-----------------------------------------------------------------------------------------
--                                                                                     --
--                This file is part of the CAPH Compiler distribution                  --
--                            http://caph.univ-bpclermont.fr                           --
--                                                                                     --
--                                  Jocelyn SEROT                                      --
--                         Jocelyn.Serot@univ-bpclermont.fr                            --
--                                                                                     --
--         Copyright 2011-2015 Jocelyn SEROT.  All rights reserved.                    --
--  This file is distributed under the terms of the GNU Library General Public License --
--      with the special exception on linking described in file ../LICENSE.            --
--                                                                                     --
-----------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;	   
use std.textio.all;

entity stream_in is
  generic ( filename: string := "input.bin"; size: integer := 10; period: integer := 2; blanking: boolean := false );
  port (  full : in std_logic; 
          dout : out std_logic_vector(size-1 downto 0);
          wr : out std_logic;   -- write (push) signal, active 1 on clk^
          clk : in std_logic;
          rst : in std_logic
          );
end stream_in;

architecture beh of stream_in is
begin
  process
  file input_file: text;
  variable file_line: line;
  variable line_out: line;
  variable data: bit_vector(size-1 downto 0);
  begin
    if ( period < 1 ) then
      report "stream_in(" & filename & ") : period < 1"
      severity error;
    end if;
    wr <= '0';
    file_open(input_file,filename,READ_MODE);
    while not endfile(input_file) loop
      readline (input_file,file_line);
      read (file_line,data) ;
      for i in 0 to period-2 loop
        wait until rising_edge(clk);
      end loop;
      assert (full='0')
          report "stream_in(" & filename & ") : cannot write: downstream fifo is full !"
          severity warning;
      if ( blanking = false or data(size-1 downto size-2) /= "00" ) then 
          -- Note 2014-10-08, JS
          -- This conditionnal is a hack for implementing blanking :
          -- Special tokens 00xxxxx are supposed to mean "NO DATA"
          -- These tokens will be generated in the input .bin file by the [txt2bin] utility
          dout <= to_stdlogicvector(data); 
          wr <= '1';
          wait until rising_edge(clk);
          wr <= '0';
        end if;
    end loop;
    file_close(input_file);
    wait;
end process;
end;

