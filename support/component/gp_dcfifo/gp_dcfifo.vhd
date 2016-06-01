library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
library std;

entity gp_dcfifo is
	generic (
		DATA_WIDTH		: positive;
		FIFO_DEPTH		: positive
	)
	port (
		reset_n			: in std_logic;
		
		-- writer
		clk_wr			: in std_logic;
		data_wr			: in std_logic;
		data_in			: in std_logic_vector(DATA_WIDTH-1 downto 0);
		full			: out std_logic;
		
		-- reader
		clk_rd			: in std_logic;
		data_rd			: in std_logic;
		data_out		: out std_logic_vector(DATA_WIDTH-1 downto 0);
		empty			: out std_logic
	);
end gp_dcfifo;
