library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
library std;

entity gp_fifo is
	generic (
		DATA_WIDTH		: positive;
		FIFO_DEPTH		: positive
	)
	port (
		clk				: in std_logic;
		reset_n			: in std_logic;
		
		-- writer
		data_wr			: in std_logic;
		data_in			: in std_logic_vector(DATA_WIDTH-1 downto 0);
		full			: out std_logic;
		
		-- reader
		data_rd			: in std_logic;
		data_out		: out std_logic_vector(DATA_WIDTH-1 downto 0);
		empty			: out std_logic
	);
end gp_fifo;
