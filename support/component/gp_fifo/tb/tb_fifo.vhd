library IEEE;
	use IEEE.STD_LOGIC_1164.all;
	use IEEE.NUMERIC_STD.all;


library ALTERA_MF;
	use ALTERA_MF.all;

entity tb_fifo is
end tb_fifo;

architecture sim of tb_fifo is
	---------------------------------------------------------
	--	CONSTANTS
	---------------------------------------------------------
	constant FIFO_DEPTH_CONST		: positive:=4;
	constant DATA_WIDTH_CONST		: positive:=8;
	


	---------------------------------------------------------
	--	SIGNALS
	---------------------------------------------------------
	signal clk_s			: std_logic;
	signal reset_n_s		: std_logic;
	signal data_wr_s		: std_logic;
	signal data_in_s		: std_logic_vector(DATA_WIDTH_CONST-1 downto 0);
	signal full_s			: std_logic;
	signal data_rd_s		: std_logic;
	signal data_ou_s		: std_logic_vector(DATA_WIDTH_CONST-1 downto 0);
	signal empty_s			: std_logic;

	---------------------------------------------------------
	--	C.U.T
	---------------------------------------------------------
	component gp_fifo
		generic (
			DATA_WIDTH		: positive;
			FIFO_DEPTH		: positive
		);
		port (
			clk			: in std_logic;
			reset_n			: in std_logic;
			data_wr			: in std_logic;
			data_in			: in std_logic_vector(DATA_WIDTH-1 downto 0);
			full			: out std_logic;
			data_rd			: in std_logic;
			data_out		: out std_logic_vector(DATA_WIDTH-1 downto 0);
			empty			: out std_logic
		);
	end component;

	begin
		---------------------------------------------------------
		--	C.U.T INSTANSTATION
		---------------------------------------------------------
		gp_fifo_inst : gp_fifo
			generic map(
				DATA_WIDTH		=>	DATA_WIDTH_CONST,
				FIFO_DEPTH		=>	FIFO_DEPTH_CONST
			)

			port map(
				clk				=> clk_s,
				reset_n				=> reset_n_s,
				data_wr				=> data_wr_s,
				data_in				=> data_in_s,
				full				=> full_s,
				data_rd				=> data_rd_s,
				data_out			=> data_ou_s,
				empty				=> empty_s
			);
		---------------------------------------------------------
		--	STIMULUS
		---------------------------------------------------------

		-- Clock
		clk_stim : process
			begin
				clk_s <= '1';
				wait for 20 ns;
				clk_s <= '0';
				wait for 20 ns;
		end process;

		--	Initial Reset
		init_reset : process
			begin
				reset_n_s 	<=	'0' ;
				wait for 60 ns ;
				reset_n_s 	<=	'1' ;
				wait;
		end process;

		--	Write in FIFO stimulus
		dw_stim : process
			begin
				data_wr_s <= '0';
				wait for 70 ns;
				data_wr_s <= '1';
				wait for 20 ns;
				data_wr_s <= '0';
				wait for 20 ns;
				data_wr_s <= '1';
				wait for 60 ns;
				data_wr_s <= '0';
				wait for 40 ns;
				data_wr_s <= '1';
				wait for 80 ns;
				data_wr_s <= '0';
				wait for 60 ns;
		end process;

		-- Read From FIFO simulus
		rd_stim : process
			begin
				data_rd_s <= '0';
				wait for 150 ns;
				data_rd_s <= '1';
				wait for 20 ns;
				data_rd_s <= '0';
				wait for 20 ns;
				data_rd_s <= '1';
				wait for 60 ns;
				data_rd_s <= '0';
				wait for 20 ns;
				data_rd_s <= '1';
				wait for 40 ns;
			end process;

		-- In data stimulus
		data_stim : process
		variable i	:	integer	:= 0;
		begin
			for i in 1 to 100 loop
				data_in_s <= std_logic_vector(to_unsigned(i,DATA_WIDTH_CONST));
				wait for 20 ns;
			end loop;
		end process;
	
end architecture;
