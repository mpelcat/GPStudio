library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

package ethernet_package is 
	function get_length (depth : integer) return integer;
	
	 type rgmii_t is record
		data 	: std_logic_vector(3 downto 0);
		dv		: std_logic;
    end record;
	 
	 type gmii_t is record
	    data		: std_logic_vector(7 downto 0);
	    dv		: std_logic;
    end record;
	 
	 type flag is record
		good		: std_logic;
	   bad		: std_logic;
    end record;
		
	type flow_t is 
	record
		dv		: std_logic;
		fv		: std_logic;
		data	: std_logic_vector(7 downto 0);
	end record;
	
	type fifo_ID is array (0 to 15) of std_logic_vector(15 downto 0);
	type fifo_size is array (0 to 15) of integer range 0 to 32768;
	type fifo_out_clk is array (0 to 15) of std_logic;
	type param_t is array(0 to 49) of std_logic_vector(31 downto 0);
end ethernet_package;

package body ethernet_package is 

function get_length (depth : integer) return integer is 
variable result : integer range 0 to 20;
begin
	result	:= integer(ceil(log2(real(depth))));
	return result;
end function;
	
end package body;




