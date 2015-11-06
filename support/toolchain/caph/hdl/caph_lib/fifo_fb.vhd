-----------------------------------------------------------------------------------------
--                                                                                     --
--                This file is part of the CAPH Compiler distribution                  --
--                            http://caph.univ-bpclermont.fr                           --
--                                                                                     --
--                           Jocelyn SEROT, Francois BERRY                      --
--                   {Jocelyn.Serot,Francois.Berry}@univ-bpclermont.fr           --
--                                                                                     --
--         Copyright 2011-2015 Jocelyn SEROT.  All rights reserved.                    --
--  This file is distributed under the terms of the GNU Library General Public License --
--      with the special exception on linking described in file ../LICENSE.            --
--                                                                                     --
-----------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fifo_fb is
generic
   (
       depth     : integer  := 8;  -- FIFO depth (number of cells)
       size      : integer  := 8;  -- FIFO width (size in bits of each cell)
       threshold : integer  := 32  -- Threshold for switching from a "small" (LE-based) to a "big" (RAM-based) implementation
   );

 port (
         full : out std_logic;
         datain : in std_logic_vector (size-1 downto 0);
         enw : in std_logic;
         empty : out std_logic;
         dataout : out std_logic_vector(size-1 downto 0);
         enr : in std_logic;
         clk : in std_logic;
         rst: in std_logic
         );
end fifo_fb;


architecture archi of fifo_fb is

 constant ad_Max : integer range 0 to depth-1:= depth-1;
 constant ad_Min : integer range 0 to depth-1:= 0;
 
 type fifo_length is array ( 0 to depth-1) of std_logic_vector((size-1) downto 0);
 signal tmp: fifo_length ;

 signal address: integer range 0 to depth-1 := ad_Max;

 signal we_a,enr_c,enw_c:std_logic;
 signal readaddr : natural range 0 to depth-1;
 signal writeaddr : natural range 0 to depth-1;

 signal cnt, cnt_c : integer  range 0 to depth-1:=0;
 signal inputD,outputD,inputR,outputR: STD_LOGIC_VECTOR (size-1 DOWNTO 0); 

 component single_clock_ram is
 generic ( depth: integer := 10; size: integer := 10);
	PORT (
	clock: IN STD_LOGIC;
	data: IN STD_LOGIC_VECTOR (size-1 DOWNTO 0);
	write_address: IN INTEGER RANGE 0 to depth-1;
	read_address: IN INTEGER RANGE 0 to depth-1;
	we: IN STD_LOGIC;
	q: OUT STD_LOGIC_VECTOR (size-1 DOWNTO 0)
	);
 end component;

 begin

   SMALL_FIFO: if depth<threshold generate

     shift_reg: process (clk)             -- shift register
     begin

       if (clk'event and clk='1' ) then

         if (enr='1' and enw='0') then    -- read
           for i in 0 to ad_Max-1 loop
             tmp(i+1) <= tmp(i);
           end loop;
         end if;

         if (enw='1' and enr='1') then    -- read & write
           if (address = ad_Max)  then   -- Tester cette condition .... !!
             tmp(address)<=datain;       -- J'ai envelevé le -1 ici
           else
             for i in 0 to ad_Max-1 loop
               tmp(i+1) <= tmp(i);
             end loop;
			 tmp(address+1)<=datain;	 -- j'ai rajouté +1
           end if;
         end if;

         if (enw='1' and enr='0') then    -- write
           tmp(address)<=datain;
         end if;

       end if;
     end process shift_reg;

     counter : process(clk, rst)          -- write address computation
     begin
       if ( rst='0' ) then  
         address <= ad_Max;
       elsif (clk='1' and clk'event) then

           if (enr = '1' and enw='0' and address < ad_Max) then -- read
             -- Read a new data in FIFO when is not empty 
             -- Read a new data in FIFO and Write simultaneously => No increment
             -- that's why wr='0'
               address <= address + 1;
           end if;

           if (enw = '1' and enr='0' and address > ad_Min) then -- write
             -- Write a new data in FIFO when is not full
             -- Read a new data in FIFO and Write simultaneously => No increment
             -- that's why rd='0'
               address <= address - 1;
           end if;
 
           if (enw = '1' and enr='1' and address= ad_Max) then  -- read & write
               address <= address;
           end if;

       end if;
   end process counter;

   flags : process(address,enw,enr)   -- empty/full flag generation
   begin
        if (  address > ad_Max-1 ) then
        -- if ( enr='1' and address > (ad_Max-2) ) then
           empty<= '1';
         else
           empty <='0';
         end if;

        if ( address < ad_Min+1 ) then
        -- if (enw = '1' and address < (ad_Min+2) ) then
           full<= '1';
         else
           full <='0';
         end if;

   end process flags;

   dataout <= tmp(depth-1);

  end generate;

  BIG_FIFO: if depth>=threshold generate

    MEM :single_clock_ram generic map (depth,size) port map (clk,inputR,writeaddr, readaddr, enw, outputR );
 
	process(clk)
	begin
      if ( clk'event and clk='1' ) then
        enw_c<=enw;
        enr_c<=enr;
        cnt_c<=cnt;
      end if;
	end process ;


	MUX: process(datain, outputD,outputR,enw_c,enr_c,cnt_c)
      -- Bypass when the FIFO is empty and we write and read simulaneoulsy
	begin
	
	if (cnt_c=0 and enr_c='1' and enw_c='1') then
		inputD<= datain;
		inputR<= (others => 'X');
		dataout<= outputD;
	else
		inputR<= datain;
		inputD<= (others => 'X');
		dataout<= outputR;
	end if;

	end process MUX;

    flags: process(cnt)
	begin
      if (  cnt  = 0 ) then empty <= '1'; else empty <='0'; end if;
      if ( cnt = depth ) then full<= '1'; else full <='0';end if;
	end process flags;

    process(clk,rst)
    begin
      if ( rst='0' ) then         
        readaddr <= 0;
        writeaddr <= 0;
        cnt <= 0;
      elsif ( clk'event and clk='1' ) then 
	 
        outputD<= inputD;
      
        if ( enr = '1'  ) then  -- Read
          if ( readaddr = depth-1 ) then
            readaddr <=  0; -- circular buffer
          else
            readaddr <= readaddr + 1; 
          end if; 
        end if;

        if ( enw = '1' and cnt < depth ) then  -- Write
          if ( writeaddr = depth-1 ) then
            writeaddr <=  0; -- circular buffer
          else
            writeaddr <= writeaddr + 1;   
          end if;
        end if;

        if ( enw = '1' and enr = '0' and cnt < depth ) then
          cnt <= cnt + 1;
        elsif ( enw = '0' and enr = '1' and cnt > 0) then
          cnt <= cnt - 1;
        end if;
		
      end if;
    end process;

  end generate;

end archi;
