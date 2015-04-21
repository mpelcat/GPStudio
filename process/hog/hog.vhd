library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
library std;

entity hog is
	generic (
		intBusSize : integer;
		IN1_SIZE   : integer;
		OUT1_SIZE  : integer
	);
	port (
		clk_proc  : in std_logic;

		------------------------ in1 flow -----------------------
		in1_data  : in std_logic_vector(IN1_SIZE-1 downto 0);
		in1_fv    : in std_logic;
		in1_dv    : in std_logic;

		------------------------ out1 flow ----------------------
		out1_data : out std_logic_vector(OUT1_SIZE-1 downto 0);
		out1_fv   : out std_logic;
		out1_dv   : out std_logic
	);
end hog;

architecture rtl of hog is

begin

end rtl;
