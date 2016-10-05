library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
library std;

entity threshold_process is
	generic (
		CLK_PROC_FREQ : integer;
		IN_SIZE       : integer;
		OUT_SIZE      : integer
	);
	port (
		clk_proc      : in std_logic;
		reset_n       : in std_logic;

		---------------- dynamic parameters ports ---------------
		threshold_reg : in std_logic_vector(31 downto 0);

		------------------------- in flow -----------------------
		in_data       : in std_logic_vector(IN_SIZE-1 downto 0);
		in_fv         : in std_logic;
		in_dv         : in std_logic;

		------------------------ out flow -----------------------
		out_data      : out std_logic_vector(OUT_SIZE-1 downto 0);
		out_fv        : out std_logic;
		out_dv        : out std_logic
	);
end threshold_process;

architecture rtl of threshold_process is

begin
	data_process : process (clk_proc, reset_n)
	begin
		if(reset_n='0') then
			out_data <= (others => '0');
			out_dv <= '0';
			out_fv <= '0';
		elsif(rising_edge(clk_proc)) then
			out_dv <= in_dv;
			out_fv <= in_fv;

			if(in_dv='1' and in_fv='1') then
				if(in_data >= threshold_reg(IN_SIZE-1 downto 0)) then
					out_data <= (others => '1');
				else
					out_data <= (others => '0');
				end if;
			end if;
		end if;
	end process;
end rtl;
