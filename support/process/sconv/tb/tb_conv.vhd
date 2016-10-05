library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

	
entity tb_conv is
end tb_conv;

architecture tb_arc of tb_conv is
	signal in_datas, w11s , w12s , w13s , w21s , w22s , w23s , w31s , w32s , w33s , out_datas 			 : std_logic_vector (7 downto 0)	:=	"00000000";
	signal in_dvs,in_fvs,mrs,out_dvs,out_fvs								 		 											 : std_logic	:=	'0';
	signal clks				  		 																										 : std_logic := '0';				
	
	component conv
		generic (
				LINE_WIDTH_MAX 	: integer;
				PIX_WIDTH 			: integer
		);
		
		port(
			clk 														: in std_logic;
			reset 													: in std_logic;
													
	-- IN FLOW												
			in_data 												: in std_logic_vector((PIX_WIDTH-1) downto 0);
			in_fv 													: in std_logic;
			in_dv 													: in std_logic;
	
	--IN kernel
			w11,w12,w13,w21,w22,w23,w31,w32,w33	:	in std_logic_vector ((PIX_WIDTH-1) downto 0);
			
	--OUT flow
			out_data												: out	std_logic_vector (7 downto 0);
			out_fv													: out	std_logic;
			out_dv													: out	std_logic
			);
		end component;


	begin
	i	:	conv 
	generic map(
	LINE_WIDTH_MAX			=>	5,
	PIX_WIDTH					=>	8
	)

	port map (
			clks,
			mrs,
			in_datas,
			in_fvs,
			in_dvs,
			w11s , w12s , w13s , w21s , w22s , w23s , w31s , w32s , w33s,
			out_datas,	
			out_fvs,	
			out_dvs		
			);

	clks	<= not (clks) after 50 ns;


stim_dv	:	process
	begin
		in_dvs	<= '0';
		wait for 100 ns;
		in_dvs	<= '1';
		wait for 500 ns;
		in_dvs	<= '0';
		wait for 200 ns;
		in_dvs	<= '1';
		wait for 100 ns;
		in_dvs	<= '0';
		wait for 100 ns;
		in_dvs	<= '1';
		wait for 100 ns;
		in_dvs	<= '0';
		wait for 100 ns;
	end process;
	
stim_fv	:	process
	begin
		in_fvs	<= '0';
		wait for 100 ns;
		in_fvs	<= '1';
		wait for 2000 ns;
	end process;
	
test	:	process
			variable i	:	integer	:= 0;
			begin
			in_datas 		<= "00000000";
			mrs				<= '1';
			wait for 100 ns;
			
			
			mrs	<= '0';
			
			w11s	 <= std_logic_vector(to_unsigned(1,8));
			w12s	 <= std_logic_vector(to_unsigned(1,8));
			w13s	 <= std_logic_vector(to_unsigned(1,8));
			w21s	 <= std_logic_vector(to_unsigned(1,8));
			w22s	 <= std_logic_vector(to_unsigned(1,8));
			w23s	 <= std_logic_vector(to_unsigned(1,8));
			w31s	 <= std_logic_vector(to_unsigned(1,8));
			w32s	 <= std_logic_vector(to_unsigned(1,8));
			w33s	 <= std_logic_vector(to_unsigned(1,8));

			for i in 1 to 100 loop
				wait for 50 ns;
				in_datas <= std_logic_vector(to_unsigned(i,8));
			end loop;
			
	end process;
end tb_arc;
