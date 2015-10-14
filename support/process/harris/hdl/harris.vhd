-- sebastien.caux@hotmail.fr
----------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
library std;

use work.matrix_type_comp.all;
use work.matrix_3x3_builder_8b_comp.all;
use work.gradient_3x3_comp.all;
use work.matrix_3x3_builder_18b_comp.all;
use work.convolution_3x3_18b_comp.all;
use work.harris_abc_to_r_comp.all;

entity harris is
	generic (
			IM_WIDTH		:   positive := 64;
			IM_HEIGHT		:	positive := 64;
			HARRIS_TRSHLD	:	positive := 3000);
			
	port (
		clk_proc : in std_logic;
		reset_n  : in std_logic;

		------------------------- in flow -----------------------
		in_data : in std_logic_vector(7 downto 0);
		in_fv : in std_logic;
		in_dv : in std_logic;

		------------------------ out flow -----------------------
		out_data : out std_logic_vector(7 downto 0);
		out_fv : out std_logic;
		out_dv : out std_logic;
		
		-- R_o				: out std_logic_vector(61 downto 0);
		-- R_detect_o		: out std_logic;
		-- X_o				: out std_logic_vector(15 downto 0);
		-- Y_o				: out std_logic_vector(15 downto 0);
			
		--======================= Slaves ========================

		------------------------- bus_sl ------------------------
		addr_rel_i : in std_logic_vector(3 downto 0);
		wr_i : in std_logic;
		rd_i : in std_logic;
		datawr_i : in std_logic_vector(31 downto 0);
		datard_o : out std_logic_vector(31 downto 0));
end harris;

architecture rtl of harris is

	signal data_matrix_3x3_8b_int : matrix_3x3_8b_t;
	
	signal frame_valid_mat_to_grad_int : std_logic;
	signal data_valid_mat_to_grad_int : std_logic;
	
	signal frame_valid_grad_to_mat2_int : std_logic;
	signal data_valid_grad_to_mat2_int : std_logic;
	
	signal frame_valid_mat2_to_gauss_int : std_logic;
	signal data_valid_mat2_to_gauss_int : std_logic;
	
	signal frame_valid_gauss_to_r_int : std_logic;
	signal data_valid_gauss_to_r_int : std_logic; 

	signal frame_valid_r_to_max_int : std_logic;
	signal data_valid_r_to_max_int : std_logic;
	
	signal frame_valid_max_to_out_int : std_logic;
	signal data_valid_max_to_out_int : std_logic;
	
	signal Ixx_int		: std_logic_vector(17 downto 0);
	signal Iyy_int		: std_logic_vector(17 downto 0);
	signal Ixy_int		: std_logic_vector(17 downto 0);
	
	signal mask_gauss_int : matrix_3x3_8b_t;
	
	signal A_int		:	matrix_3x3_18b_t;
	signal B_int		:	matrix_3x3_18b_t;
	signal C_int		:	matrix_3x3_18b_t;
	
	signal Aw_int		:  std_logic_vector(29 downto 0);
	signal Bw_int		:  std_logic_vector(29 downto 0);
	signal Cw_int		:  std_logic_vector(29 downto 0);
	
	signal det_M_int	:	std_logic_vector(60 downto 0);
	signal det_M_plus1_int	:	std_logic_vector(60 downto 0);
	signal traceM_int	:	std_logic_vector(30 downto 0);
	signal traceM2_int	:	std_logic_vector(60 downto 0);
	signal ktraceM2_int	:	std_logic_vector(60 downto 0);
	
	signal R_int		:  std_logic_vector(61 downto 0);
	
	signal cnt_x_int	:	integer;
	signal cnt_y_int	:	integer;
	
	type fifo_t is array (0 to 2*IM_WIDTH + 2) of std_logic_vector(61 downto 0);
	signal fifolocal_int : fifo_t;
	
	
	type local_type is array (1 to 9) of std_logic_vector(61 downto 0);
	signal local	:	local_type;
	
	
	component slave_harris 
	  generic (
		DATA_WIDTH : integer := 32
		);
	  port(
		clk_i : in std_logic;
		rst_n_i : in std_logic;
					
		addr_i : in std_logic_vector(3 DOWNTO 0);		
		wr_i : in std_logic;
		datawr_i : in std_logic_vector(DATA_WIDTH-1 downto 0);
		harris_threshold_o : out std_logic_vector(31 downto 0)
		);
	end component;

	signal harris_threshold_r : std_logic_vector(31 downto 0):=(others=>'0');
	signal harris_threshold_r_ext : std_logic_vector(61 downto 0):=(others=>'0');
	
begin

--	X_o	<= std_logic_vector(to_unsigned(cnt_x_int,16));
--	Y_o	<= std_logic_vector(to_unsigned(cnt_y_int,16));



	p4:process(reset_n,clk_proc)
	begin
		if(reset_n = '0')then
			cnt_x_int <= -4;
			cnt_y_int <= -2;
		elsif( rising_edge(clk_proc) )then			
			if( frame_valid_max_to_out_int = '1' )then
				if( data_valid_max_to_out_int = '1' )then
					if(cnt_x_int = IM_WIDTH)then
						cnt_x_int <= 1;
						if(cnt_y_int = IM_HEIGHT )then
							cnt_y_int 		<= 1;
						else
							cnt_y_int <= cnt_y_int + 1;
						end if;
					else
						cnt_x_int <= cnt_x_int + 1;
					end if;
				end if;
			else
				cnt_x_int <= -4;
				cnt_y_int <= -2;
			end if;
		end if;
	end process;

	slave_harris_inst: component slave_harris
	GENERIC map(
		DATA_WIDTH  => 32
		)
	PORT map(
		rst_n_i	 		=> reset_n,
		clk_i 			=> clk_proc,
		addr_i 			=> addr_rel_i,
		wr_i 			=> wr_i,
		datawr_i 		=> datawr_i,
		harris_threshold_o => harris_threshold_r
		);	
		
		harris_threshold_r_ext <= X"0000000"& "00" & harris_threshold_r;
		
		
	cp0_matrix_builder8b: component matrix_3x3_builder_8b
	GENERIC map(
		IM_WIDTH => IM_WIDTH
		)
	PORT map(
		rst_i	 		=> not(reset_n),
		clk_i 			=> clk_proc,
		frame_valid_i	=> in_fv,
		data_valid_i	=> in_dv,
		data_i	 		=> in_data,
		frame_valid_o	=> frame_valid_mat_to_grad_int,
		data_valid_o	=> data_valid_mat_to_grad_int,
		data_o	 		=> data_matrix_3x3_8b_int
		);	
		

	cp1_IxxIxyIyy: component gradient_3x3
	PORT map(
		rst_i	 		=> not(reset_n),
		clk_i 			=> clk_proc,
		frame_valid_i   => frame_valid_mat_to_grad_int,
		data_valid_i    => data_valid_mat_to_grad_int,
		data_i	 		=> data_matrix_3x3_8b_int,
		frame_valid_o   => frame_valid_grad_to_mat2_int,		
		data_valid_o    => data_valid_grad_to_mat2_int,		
		Ixx_o			=> Ixx_int,
		Ixy_o	 		=> Ixy_int,
		Iyy_o	 		=> Iyy_int
	);
	

	cp2_build_matrice_A: component matrix_3x3_builder_18b
	GENERIC map(
		IM_WIDTH => IM_WIDTH
		)
	PORT map(
		rst_i	 		=> not(reset_n),
		clk_i 			=> clk_proc,
		frame_valid_i	=> frame_valid_grad_to_mat2_int,
		data_valid_i	=> data_valid_grad_to_mat2_int,
		data_i	 		=> Ixx_int,
		frame_valid_o	=> frame_valid_mat2_to_gauss_int,
		data_valid_o	=> data_valid_mat2_to_gauss_int,
		data_o	 		=> A_int
		);
	
		
	cp3_build_matrice_B: component matrix_3x3_builder_18b
	GENERIC map(
		IM_WIDTH => IM_WIDTH
		)
	PORT map(
		rst_i	 		=> not(reset_n),
		clk_i 			=> clk_proc,
		frame_valid_i	=> frame_valid_grad_to_mat2_int,
		data_valid_i	=> data_valid_grad_to_mat2_int,
		data_i	 		=> Iyy_int,
		frame_valid_o	=> open,
		data_valid_o	=> open,
		data_o	 		=> B_int
		);
		
	cp4_build_matrice_C: component matrix_3x3_builder_18b
	GENERIC map(
		IM_WIDTH => IM_WIDTH
		)
	PORT map(
		rst_i	 			=> not(reset_n),
		clk_i 				=> clk_proc,
		frame_valid_i	 	=> frame_valid_grad_to_mat2_int,
		data_valid_i	 	=> data_valid_grad_to_mat2_int,
		data_i	 			=> Ixy_int,
		frame_valid_o	 	=> open,
		data_valid_o	 	=> open,
		data_o	 			=> C_int
		);
		
		mask_gauss_int(1) <= x"01";
		mask_gauss_int(2) <= x"02";
		mask_gauss_int(3) <= x"01";
		
		mask_gauss_int(4) <= x"02";
		mask_gauss_int(5) <= x"04";
		mask_gauss_int(6) <= x"02";
		
		mask_gauss_int(7) <= x"01";
		mask_gauss_int(8) <= x"02";
		mask_gauss_int(9) <= x"01";
		
		
	cp5_Calc_Aw: component convolution_3x3_18b
	PORT map(
		rst_i	 		=> not(reset_n),
		clk_i 			=> clk_proc,
		frame_valid_i 	=> frame_valid_mat2_to_gauss_int,
		data_valid_i	=> data_valid_mat2_to_gauss_int,
		data_i 			=> A_int,
		mask_i	 		=> mask_gauss_int,
		frame_valid_o	=> frame_valid_gauss_to_r_int,	
		data_valid_o	=> data_valid_gauss_to_r_int,	
		data_o	 		=> Aw_int
	);
	
	cp6_Calc_Bw: component convolution_3x3_18b
	PORT map(
		rst_i	 		=> not(reset_n),
		clk_i 			=> clk_proc,
		frame_valid_i   => frame_valid_mat2_to_gauss_int,
		data_valid_i    => data_valid_mat2_to_gauss_int,
		data_i	 		=> B_int,
		mask_i	 		=> mask_gauss_int,
		frame_valid_o   => open,	
		data_valid_o    => open,	
		data_o	 		=> Bw_int
	);

	cp7_Calc_Cw: component convolution_3x3_18b
	PORT map(
		rst_i	 		=> not(reset_n),
		clk_i 			=> clk_proc,
		frame_valid_i   => frame_valid_mat2_to_gauss_int,
		data_valid_i	=> data_valid_mat2_to_gauss_int,
		data_i	 		=> C_int,
		mask_i	 		=> mask_gauss_int,
		frame_valid_o	=> open,	
		data_valid_o	=> open,	
		data_o	 		=> Cw_int
	);	

	cp8_Calc_R: component harris_abc_to_r
	PORT map(
		rst_i  			=> not(reset_n),
		clk_i			=> clk_proc,
		frame_valid_i	=> frame_valid_gauss_to_r_int,
		data_valid_i	=> data_valid_gauss_to_r_int,
		Aw_i	 		=> Aw_int,
		Bw_i	 		=> Bw_int,
		Cw_i	 		=> Cw_int,		
		frame_valid_o	=> frame_valid_r_to_max_int,
		data_valid_o	=> data_valid_r_to_max_int,
		R_o		 		=> R_int
	);
	
	p9_max_local: process(reset_n,clk_proc)
	begin
		if( reset_n = '0' )then
			fifolocal_int <= (others => (others => '0'));
--			R_detect_o 	  <= '0';
		elsif( rising_edge(clk_proc) )then
			if( data_valid_r_to_max_int = '1' )then
				for i in 1 to 2*IM_WIDTH + 2 loop
					fifolocal_int(i) <= fifolocal_int(i-1);
				end loop;
			
				fifolocal_int(0) <= R_int;		
				local(1) <= fifolocal_int(0*IM_WIDTH + 0);
				local(2) <= fifolocal_int(0*IM_WIDTH + 1);
				local(3) <= fifolocal_int(0*IM_WIDTH + 2);
				local(4) <= fifolocal_int(1*IM_WIDTH + 0);
				local(5) <= fifolocal_int(1*IM_WIDTH + 1);
				local(6) <= fifolocal_int(1*IM_WIDTH + 2);
				local(7) <= fifolocal_int(2*IM_WIDTH + 0);
				local(8) <= fifolocal_int(2*IM_WIDTH + 1);
				local(9) <= fifolocal_int(2*IM_WIDTH + 2);
				
				if(  (signed(local(5)) >  signed(harris_threshold_r_ext)) and local(5) > local(9) and local(5) > local(8) and local(5) > local(7) and local(5) > local(6) and local(5) > local(4) and local(5) > local(3) and local(5) > local(2) and local(5) > local(1) )then
					out_data	<= (others => '1');
--					R_detect_o 	<= '1';
--					R_o			<= local(5);
				else
					out_data	<= in_data(7 downto 1) & '0';
--					R_detect_o 	<= '0';
--					R_o			<= (others => '0');
				end if;	
			end if;
		end if;
	end process;
	
	p10_decal_valid: process(reset_n,clk_proc)
	begin
		if( reset_n = '0' )then
		elsif( rising_edge(clk_proc) )then			
			data_valid_max_to_out_int 	<= data_valid_r_to_max_int;
			frame_valid_max_to_out_int 	<= frame_valid_r_to_max_int;				
		end if;
	end process;
	
	out_fv <= frame_valid_max_to_out_int;
	out_dv <= data_valid_max_to_out_int;

end rtl;
