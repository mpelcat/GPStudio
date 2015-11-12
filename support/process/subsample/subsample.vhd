LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
Use ieee.numeric_std.all;

    
ENTITY subsample IS

    generic
    (    
        Image_width    : integer  :=    6;
        Image_heigh    : integer  :=    6;
        pixel_depth    : integer  :=    8;
        pixel_parity: std_logic  :=    '1'; -- 1: odd ; 0: even
        line_parity: std_logic  :=    '1' -- 1: odd ; 0: even
    
    );

    PORT(
            clk,reset: in std_logic;
            frame_valid_i, data_valid_i : in std_logic;
            frame_valid_o, data_valid_o : out std_logic;
            
            image_i: in std_logic_vector((pixel_depth)-1 downto 0); 
            image_o: out std_logic_vector((pixel_depth)-1 downto 0)

            );
END subsample;

ARCHITECTURE rtl of subsample is

Begin


 process(clk,reset)
 variable pixel_count:  std_logic_vector(10 downto 0);  
 variable line_count:  std_logic_vector(10 downto 0);  

  
        begin
        
        if( reset = '0' )then
            image_o <= ((others => '0'));
           pixel_count:=(others => '0');
            line_count:=(others => '0');
        elsif( clk'event and clk = '1' )then

        if(data_valid_i= '1')then
            
            -- pixel and line counter
            pixel_count:=pixel_count+'1';
            if(pixel_count= Image_width)then
                line_count:=line_count+'1';
                pixel_count:=(others => '0');
            end if;

            if(line_count= Image_heigh)then
                line_count:=(others => '0');
            end if;    
        

            -- each odd/even line is valid                
            if( line_count(0)= line_parity)then
                -- each odd/even pixel is valid        
                    if(pixel_count(0)= pixel_parity)then
                        image_o<=image_i;
                        data_valid_o<= '1';
                    else
                        image_o <= ((others => '0'));
                        data_valid_o<= '0';
                    end if;    
            else
                image_o <= ((others => '0'));
                data_valid_o<= '0';
            end if;        
            
            end if;
        end if;
    end process;    

frame_valid_o <= frame_valid_i;

END rtl;