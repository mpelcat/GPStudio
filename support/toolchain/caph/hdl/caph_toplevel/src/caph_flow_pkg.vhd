	 
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package caph_flow_pkg is

	constant MAX_IMAGE_WIDTH : integer	:= 1920;
	constant MAX_IMAGE_HEIGHT : integer	:= 1024;

	-- start of Frame & start of Line has same vhdl header
	-- End of Frame/Line too ... 
	
	constant SoF:integer := 0;
	constant EoF:integer := 1;
	
	constant SoL : integer := 0;
	constant EoL : integer := 1;
	
	constant Data:integer:= 2;
	
	constant TOKEN_HEADER_SIZE:integer :=2;
	
	-- codage des headers caph
	type my_caph_header_t is array (0 to 2) of std_logic_vector(1 downto 0);
	constant CaphHeader : my_caph_header_t := ("01","10","11");
	
	-- Must match caph_toplevel instanciation parameter ...
	constant MEM_ADDR_BUS_SIZE: integer := 4;
	type caph_port_t is
	record
	  data                        : std_logic_vector(31 downto 0);
	  wr						  : std_logic;
	  full	: std_logic;
	end record;

	constant NB_PORTS : integer := 10;
	type caph_ports_t is array (0 to NB_PORTS-1) of caph_port_t;
	
end package caph_flow_pkg;


	
