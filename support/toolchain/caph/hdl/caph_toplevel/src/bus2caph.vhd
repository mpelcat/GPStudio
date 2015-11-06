-- **************************************************************************
--	bus2caph 
-- **************************************************************************
-- 03/12/2014
--------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

-- entity "uses" the package   
--use work.ComFlow_pkg.all;
use work.caph_flow_pkg.caph_ports_t;

entity bus2caph is
  generic (
	NB_PORTS:positive := 0
 );
  port(
	clk_i : in std_logic;
	rst_n_i : in std_logic;
				
	-- quartus declaration
	addr_i : in std_logic_vector(3 DOWNTO 0);
	wr_i : in std_logic;
	datawr_i : in std_logic_vector(31 downto 0);

	enable_o : out std_logic;

--	port_o : out std_logic_vector(31 downto 0);

	ports: out caph_ports_t;

	imwidth_o		: out std_logic_vector(31 downto 0);
	imheight_o		: out std_logic_vector(31 downto 0)
 );
 
end bus2caph;

architecture rtl of bus2caph is

	constant ENABLE_0_REG_ADDR	: std_logic_vector(3 downto 0) := X"0";
	constant IMWIDTH_REG_ADDR	: std_logic_vector(3 downto 0) := X"1";
	constant IMHEIGHT_REG_ADDR	: std_logic_vector(3 downto 0) := X"2";

	-- Listes des ports utilisées dans caph
 	constant PORT_k0_REG_ADDR	: std_logic_vector(3 downto 0) := X"3";
 	constant PORT_k1_REG_ADDR	: std_logic_vector(3 downto 0) := X"4";
 	constant PORT_k2_REG_ADDR	: std_logic_vector(3 downto 0) := X"5";
 	constant PORT_k3_REG_ADDR	: std_logic_vector(3 downto 0) := X"6";
 	constant PORT_k4_REG_ADDR	: std_logic_vector(3 downto 0) := X"7";
 	constant PORT_k5_REG_ADDR	: std_logic_vector(3 downto 0) := X"8";
 	constant PORT_k6_REG_ADDR	: std_logic_vector(3 downto 0) := X"9";
 	constant PORT_k7_REG_ADDR	: std_logic_vector(3 downto 0) := X"A";
 	constant PORT_k8_REG_ADDR	: std_logic_vector(3 downto 0) := X"B";
 	constant PORT_N_REG_ADDR	: std_logic_vector(3 downto 0) := X"C";


begin

REG:process (clk_i, rst_n_i) 
begin
	if (rst_n_i = '0') then	
		enable_o <= '0';
--		port_o <= (others=>'0');
		imwidth_o <= X"00000140";
		imheight_o <= X"000000F0";
		for i in 0 to NB_PORTS-1 loop
			ports(i).wr <='0';
		end loop;
	elsif rising_edge(clk_i) then
		if(wr_i = '1') then
			case addr_i is
				when ENABLE_0_REG_ADDR =>		
					enable_o <= datawr_i(0);
				when IMWIDTH_REG_ADDR =>		
					imwidth_o <= datawr_i;
				when IMHEIGHT_REG_ADDR =>		
					imheight_o <= datawr_i;	
				when PORT_k0_REG_ADDR =>		
					ports(0).wr <= '1';
					ports(0).data <= datawr_i;
				when PORT_k1_REG_ADDR =>		
					ports(1).wr <= '1';
					ports(1).data <= datawr_i;
				when PORT_k2_REG_ADDR =>		
					ports(2).wr <= '1';
					ports(2).data <= datawr_i;
				when PORT_k3_REG_ADDR =>		
					ports(3).wr <= '1';
					ports(3).data <= datawr_i;
				when PORT_k4_REG_ADDR =>		
					ports(4).wr <= '1';
					ports(4).data <= datawr_i;
				when PORT_k5_REG_ADDR =>		
					ports(5).wr <= '1';
					ports(5).data <= datawr_i;
				when PORT_k6_REG_ADDR =>		
					ports(6).wr <= '1';
					ports(6).data <= datawr_i;
				when PORT_k7_REG_ADDR =>		
					ports(7).wr <= '1';
					ports(7).data <= datawr_i;
				when PORT_k8_REG_ADDR =>		
					ports(8).wr <= '1';
					ports(8).data <= datawr_i;
				when PORT_N_REG_ADDR =>		
					ports(9).wr <= '1';
					ports(9).data <= datawr_i;
				when others =>	
					
			end case;
		else
			for i in 0 to NB_PORTS-1 loop
				ports(i).wr <='0';
			end loop;
		end if;	
	end if;
end process;


end rtl;

