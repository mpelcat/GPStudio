library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
--use ieee.math_real.all;
library std;
library altera_mf;
use altera_mf.altera_mf_components.all;


package harris_package_components is

shared variable RESULT_LENGTH:integer:=44;
shared variable FILTER_RESULT_LENGTH:integer:=28;


type            pixel_matrix is array (0 to 6,0 to 6) of std_logic_vector(7 downto 0);
type            filter_matrix is array (0 to 6,0 to 6) of std_logic_vector((FILTER_RESULT_LENGTH-1) downto 0);

component LPM_MULT
  generic ( LPM_WIDTHA         : natural;                
            LPM_WIDTHB         : natural;                
            LPM_WIDTHS         : natural:=1;            
            LPM_WIDTHP         : natural;                
            LPM_REPRESENTATION : string:="SIGNED";        
            LPM_PIPELINE       : natural:=0;         
            LPM_TYPE           : string;
            LPM_HINT           : string:="UNUSED");

  port    ( DATAA              : in std_logic_vector(LPM_WIDTHA-1 downto 0);
            DATAB              : in std_logic_vector(LPM_WIDTHB-1 downto 0);
            ACLR               : in std_logic :='0';
            SUM                : in std_logic_vector(LPM_WIDTHS-1 downto 0):=(OTHERS=>'0');
            RESULT             : out std_logic_vector(LPM_WIDTHP-1 downto 0));
end component;


component LPM_COMPARE
  generic ( LPM_WIDTH          : natural:=RESULT_LENGTH;
            LPM_REPRESENTATION : string:="SIGNED";
            LPM_PIPELINE       : natural:=0;
            LPM_TYPE           : string:="LPM_COMPARE";
            LPM_HINT           : string:="UNUSED");

  port (    DATAA              : in std_logic_vector(LPM_WIDTH-1 downto 0);
            DATAB              : in std_logic_vector(LPM_WIDTH-1 downto 0);
            ACLR               : in std_logic :='0';
            AGB                : out std_logic;
            AGEB               : out std_logic;
            AEB                : out std_logic;
            ANEB               : out std_logic;
            ALB                : out std_logic;
            ALEB               : out std_logic);
end component;


component LPM_ADD_SUB
  generic ( LPM_WIDTH          : natural:=RESULT_LENGTH;
            LPM_DIRECTION      : string:="ADD";
            LPM_REPRESENTATION : string:="SIGNED";
            LPM_PIPELINE       : natural:=0;
            LPM_TYPE           : string:="LPM_ADD_SUB";
            LPM_HINT           : string:="UNUSED");
  port (    DATAA              : in std_logic_vector(LPM_WIDTH-1 downto 0);
            DATAB              : in std_logic_vector(LPM_WIDTH-1 downto 0);
            ACLR               : in std_logic:='0';
            CLOCK              : in std_logic:='0';
            CLKEN              : in std_logic:='1';
            CIN                : in std_logic:='Z';
            ADD_SUB            : in std_logic:='1';
            RESULT             : out std_logic_vector(LPM_WIDTH-1 downto 0);
            COUT               : out std_logic;
            OVERFLOW           : out std_logic);
end component;


end harris_package_components;



