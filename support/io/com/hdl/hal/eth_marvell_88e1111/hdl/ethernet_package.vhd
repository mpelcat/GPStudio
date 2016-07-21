-- Package used in ethernet_udp block

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package ethernet_package is 
	
	 type rgmii_t is record
		data 	    : std_logic_vector(3 downto 0);
		dv		    : std_logic;
    end record;
	 
	 type gmii_t is record
	    data		: std_logic_vector(7 downto 0);
	    dv		    : std_logic;
    end record;
	 
	 type flag is record
        good		: std_logic;
        bad		    : std_logic;
    end record;
end ethernet_package;





