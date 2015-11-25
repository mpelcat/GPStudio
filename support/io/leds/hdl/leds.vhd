library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
library std;

entity leds is
	generic (
		CLK_PROC_FREQ : integer := 48000000;
		LEDCOUNT : integer := 1
	);
	port (
		clk_proc : in std_logic;
		reset_n : in std_logic;

		--------------------- external ports --------------------
		o : out std_logic_vector(LEDCOUNT-1 downto 0);

		--======================= Slaves ========================

		------------------------- bus_sl ------------------------
		addr_rel_i : in std_logic_vector(1 downto 0);
		wr_i : in std_logic;
		rd_i : in std_logic;
		datawr_i : in std_logic_vector(31 downto 0);
		datard_o : out std_logic_vector(31 downto 0)
	);
end leds;

architecture rtl of leds is

	constant ENABLE_REG_ADDR	: natural := 0;
	
	signal led_reg				: std_logic_vector(LEDCOUNT-1 downto 0);
	
begin
process (clk_proc, reset_n)

begin
	if (reset_n='0') then
		led_reg <= (others => '0');
	elsif (clk_proc'event and clk_proc='1') then 

		if(wr_i='1') then
			case addr_rel_i is
				when std_logic_vector(to_unsigned(ENABLE_REG_ADDR, 2))=>
					led_reg <= datawr_i(LEDCOUNT-1 downto 0);
				when others=>
			end case;

		end if; 
	end if; 
end process;

	o <= led_reg;

end rtl;
