------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package caph_processing_component is


component dy_net
  port (
    i_f: out std_logic;
    i: in std_logic_vector(9 downto 0);
    i_wr: in std_logic;
    o_e: out std_logic;
    o: out std_logic_vector(9 downto 0);
    o_rd: in std_logic;
    clock: in std_logic;
    reset: in std_logic
    );
end component;

component conv33_port_net is
  port (
    i_f: out std_logic;
    i: in std_logic_vector(9 downto 0);
    i_wr: in std_logic;
    k0_f: out std_logic;
    k0: in std_logic_vector(15 downto 0);
    k0_wr: in std_logic;
    k1_f: out std_logic;
    k1: in std_logic_vector(15 downto 0);
    k1_wr: in std_logic;
    k2_f: out std_logic;
    k2: in std_logic_vector(15 downto 0);
    k2_wr: in std_logic;
    k3_f: out std_logic;
    k3: in std_logic_vector(15 downto 0);
    k3_wr: in std_logic;
    k4_f: out std_logic;
    k4: in std_logic_vector(15 downto 0);
    k4_wr: in std_logic;
    k5_f: out std_logic;
    k5: in std_logic_vector(15 downto 0);
    k5_wr: in std_logic;
    k6_f: out std_logic;
    k6: in std_logic_vector(15 downto 0);
    k6_wr: in std_logic;
    k7_f: out std_logic;
    k7: in std_logic_vector(15 downto 0);
    k7_wr: in std_logic;
    k8_f: out std_logic;
    k8: in std_logic_vector(15 downto 0);
    k8_wr: in std_logic;
    n_f: out std_logic;
    n: in std_logic_vector(7 downto 0);
    n_wr: in std_logic;
    o_e: out std_logic;
    o: out std_logic_vector(9 downto 0);
    o_rd: in std_logic;
    clock: in std_logic;
    reset: in std_logic
    );
end component;


component dx_net
  port (
    w3_f: out std_logic;
    w3: in std_logic_vector(9 downto 0);
    w3_wr: in std_logic;
    w6_e: out std_logic;
    w6: out std_logic_vector(9 downto 0);
    w6_rd: in std_logic;
    clock: in std_logic;
    reset: in std_logic
    );
end component;


	component inv_net is
	  port (
		w3_f: out std_logic;
		w3: in std_logic_vector(9 downto 0);
		w3_wr: in std_logic;
		w6_e: out std_logic;
		w6: out std_logic_vector(9 downto 0);
		w6_rd: in std_logic;
		clock: in std_logic;
		reset: in std_logic
		);
	end component;
	
	component conv_net is
	  port (
		w8_f: out std_logic;
		w8: in std_logic_vector(9 downto 0);
		w8_wr: in std_logic;
		w15_e: out std_logic;
		w15: out std_logic_vector(9 downto 0);
		w15_rd: in std_logic;
		clock: in std_logic;
		reset: in std_logic
		);
	end component;

	
component port_test_net
  port (
    w4_f: out std_logic;
    w4: in std_logic_vector(9 downto 0);
    w4_wr: in std_logic;
    w6_f: out std_logic;
    w6: in std_logic_vector(7 downto 0);
    w6_wr: in std_logic;
    w9_e: out std_logic;
    w9: out std_logic_vector(9 downto 0);
    w9_rd: in std_logic;
    clock: in std_logic;
    reset: in std_logic
    );
end component;



end caph_processing_component;
