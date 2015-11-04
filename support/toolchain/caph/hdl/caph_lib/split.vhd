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
use ieee.std_logic_1164.ALL;

--               +-----------+
--               |           |   d1_f
--               |           |<--------
--               |           |    d1
--         d_f   |           |-------->
--      <--------|           |   d1_wr
--          d    |           |-------->
--      -------->|  SPLIT    |
--         d_wr  |           |   d2_f
--      -------->|           |<--------
--               |           |    d2
--               |           |-------->
--               |           |   d2_wr
--               |           |-------->
--               +-----------+ 

entity split2 is
  generic ( size: integer := 10);
  port (  
          d_f:    out std_logic;
          d :     in std_logic_vector (size-1 downto 0);
          d_wr :  in std_logic;
          d1_f :  in std_logic; 
          d1 :    out std_logic_vector(size-1 downto 0);
          d1_wr : out std_logic;
          d2_f :  in std_logic; 
          d2 :    out std_logic_vector(size-1 downto 0);
          d2_wr : out std_logic
          );
end split2;

architecture arch of split2 is
begin
  d1 <= d;
  d2 <= d;
  d1_wr <= d_wr;
  d2_wr <= d_wr;
  d_f <= d1_f or d2_f;
end arch;

library ieee;
use ieee.std_logic_1164.ALL;

entity split3 is
  generic ( size: integer := 10);
  port (  
          d_f:    out std_logic;
          d :     in std_logic_vector (size-1 downto 0);
          d_wr :  in std_logic;
          d1_f :  in std_logic; 
          d1 :    out std_logic_vector(size-1 downto 0);
          d1_wr : out std_logic;
          d2_f :  in std_logic; 
          d2 :    out std_logic_vector(size-1 downto 0);
          d2_wr : out std_logic;
          d3_f :  in std_logic; 
          d3 :    out std_logic_vector(size-1 downto 0);
          d3_wr : out std_logic
          );
end split3;

architecture arch of split3 is
begin
  d1 <= d;
  d2 <= d;
  d3 <= d;
  d1_wr <= d_wr;
  d2_wr <= d_wr;
  d3_wr <= d_wr;
  d_f <= d1_f or d2_f or d3_f;
end arch;

library ieee;
use ieee.std_logic_1164.ALL;

entity split4 is
  generic ( size: integer := 10);
  port (  
          d_f:    out std_logic;
          d :     in std_logic_vector (size-1 downto 0);
          d_wr :  in std_logic;
          d1_f :  in std_logic; 
          d1 :    out std_logic_vector(size-1 downto 0);
          d1_wr : out std_logic;
          d2_f :  in std_logic; 
          d2 :    out std_logic_vector(size-1 downto 0);
          d2_wr : out std_logic;
          d3_f :  in std_logic; 
          d3 :    out std_logic_vector(size-1 downto 0);
          d3_wr : out std_logic;
          d4_f :  in std_logic; 
          d4 :    out std_logic_vector(size-1 downto 0);
          d4_wr : out std_logic
          );
end split4;

architecture arch of split4 is
begin
  d1 <= d;
  d2 <= d;
  d3 <= d;
  d4 <= d;
  d1_wr <= d_wr;
  d2_wr <= d_wr;
  d3_wr <= d_wr;
  d4_wr <= d_wr;
  d_f <= d1_f or d2_f or d3_f or d4_f;
end arch;

library ieee;
use ieee.std_logic_1164.ALL;

entity split5 is
  generic ( size: integer := 10);
  port (  
          d_f:    out std_logic;
          d :     in std_logic_vector (size-1 downto 0);
          d_wr :  in std_logic;
          d1_f :  in std_logic; 
          d1 :    out std_logic_vector(size-1 downto 0);
          d1_wr : out std_logic;
          d2_f :  in std_logic; 
          d2 :    out std_logic_vector(size-1 downto 0);
          d2_wr : out std_logic;
          d3_f :  in std_logic; 
          d3 :    out std_logic_vector(size-1 downto 0);
          d3_wr : out std_logic;
          d4_f :  in std_logic; 
          d4 :    out std_logic_vector(size-1 downto 0);
          d4_wr : out std_logic;
          d5_f :  in std_logic; 
          d5 :    out std_logic_vector(size-1 downto 0);
          d5_wr : out std_logic
          );
end split5;

architecture arch of split5 is
begin
  d1 <= d;
  d2 <= d;
  d3 <= d;
  d4 <= d;
  d5 <= d;
  d1_wr <= d_wr;
  d2_wr <= d_wr;
  d3_wr <= d_wr;
  d4_wr <= d_wr;
  d5_wr <= d_wr;
  d_f <= d1_f or d2_f or d3_f or d4_f or d5_f;
end arch;

library ieee;
use ieee.std_logic_1164.ALL;

entity split6 is
  generic ( size: integer := 10);
  port (  
          d_f:    out std_logic;
          d :     in std_logic_vector (size-1 downto 0);
          d_wr :  in std_logic;
          d1_f :  in std_logic; 
          d1 :    out std_logic_vector(size-1 downto 0);
          d1_wr : out std_logic;
          d2_f :  in std_logic; 
          d2 :    out std_logic_vector(size-1 downto 0);
          d2_wr : out std_logic;
          d3_f :  in std_logic; 
          d3 :    out std_logic_vector(size-1 downto 0);
          d3_wr : out std_logic;
          d4_f :  in std_logic; 
          d4 :    out std_logic_vector(size-1 downto 0);
          d4_wr : out std_logic;
          d5_f :  in std_logic; 
          d5 :    out std_logic_vector(size-1 downto 0);
          d5_wr : out std_logic;
          d6_f :  in std_logic; 
          d6 :    out std_logic_vector(size-1 downto 0);
          d6_wr : out std_logic
          );
end split6;

architecture arch of split6 is
begin
  d1 <= d;
  d2 <= d;
  d3 <= d;
  d4 <= d;
  d5 <= d;
  d6 <= d;
  d1_wr <= d_wr;
  d2_wr <= d_wr;
  d3_wr <= d_wr;
  d4_wr <= d_wr;
  d5_wr <= d_wr;
  d6_wr <= d_wr;
  d_f <= d1_f or d2_f or d3_f or d4_f or d5_f or d6_f;
end arch;
