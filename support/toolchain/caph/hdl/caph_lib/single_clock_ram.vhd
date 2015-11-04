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

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY single_clock_ram IS
 generic ( depth: integer := 10; size: integer := 10);
	PORT (
	clock: IN STD_LOGIC;
	data: IN STD_LOGIC_VECTOR (size-1 DOWNTO 0);
	write_address: IN INTEGER RANGE 0 to depth-1;
	read_address: IN INTEGER RANGE 0 to depth-1;
	we: IN STD_LOGIC;
	q: OUT STD_LOGIC_VECTOR (size-1 DOWNTO 0)
	);
END single_clock_ram;

ARCHITECTURE rtl OF single_clock_ram IS
	TYPE MEM IS ARRAY(0 TO depth) OF STD_LOGIC_VECTOR(size-1 DOWNTO 0);
	signal ram_block: MEM;
	--shared variable read_address_tmp: INTEGER RANGE 0 to depth;
	BEGIN
		PROCESS (clock)
		BEGIN
			IF (clock'event AND clock = '1') THEN
				IF (we = '1') THEN
				ram_block(write_address) <= data;
				END IF;

			END IF;
			--read_address_tmp := (read_address);
		END PROCESS;
		q <= ram_block(read_address);
END rtl;
