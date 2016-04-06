library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use ieee.math_real.all;
library std;
library altera_mf;
use altera_mf.altera_mf_components.all;

entity harris_process is

		generic (
			LINE_WIDTH_MAX 	: integer;
			PIX_WIDTH 	: integer
		);
		
		port(
			clk_proc 		: in std_logic;
			reset_n 		: in std_logic;
	
			in_data 		: in std_logic_vector((PIX_WIDTH-1) downto 0);
			in_fv 			: in std_logic;
			in_dv 			: in std_logic;
		
			out_data		: out	std_logic_vector (PIX_WIDTH-1 downto 0);
			out_fv			: out	std_logic;
			out_dv			: out	std_logic;

			enable_i 		: in std_logic;
			widthimg_i 		: in std_logic_vector(15 downto 0)
			);
end harris_process;


architecture DataFlow of harris_process is

	signal 	i00,i01,i02 	                : std_logic_vector (PIX_WIDTH-1 downto 0);
	signal	i10,i11,i12		        : std_logic_vector (PIX_WIDTH-1 downto 0);
	signal	i20,i21,i22		        : std_logic_vector (PIX_WIDTH-1 downto 0);

        signal temp_out_data:std_logic_vector(7 downto 0);
        signal temp_out_dv,temp_out_fv:std_logic; 

	signal	out_dvp,out_fvp	: std_logic;
	
	
	component pipliner_7x7
		generic (
			LINE_WIDTH_MAX 	: integer;
			PIX_WIDTH 		: integer
		);
	
		port (
		clk_proc		: in std_logic;
		reset_n 		: in std_logic;

		in_data 		: in std_logic_vector((PIX_WIDTH-1) downto 0);
		in_fv 			: in std_logic;
		in_dv 			: in std_logic;

		out_fv 			: out std_logic;
		out_dv 			: out std_logic;
                out_data 		: out std_logic_vector((PIX_WIDTH-1) downto 0);
				
		enable_i    	: in std_logic;
		widthimg_i      : in std_logic_vector(15 downto 0)
		
	);
	end component;
	
	begin
	
	
	inst_pipliner	:	pipliner_7x7	
		generic map(
		LINE_WIDTH_MAX 	=> LINE_WIDTH_MAX,
		PIX_WIDTH 		=> PIX_WIDTH 		 
		)
		
		port map (
		clk_proc=>	clk_proc,						
		reset_n =>	reset_n,				
		in_data	=>	in_data,				
		in_fv 	=>	in_fv,					
		in_dv 	=>	in_dv,				
		out_fv 	=>	out_fv,		
		out_dv 	=>	out_dv,
                out_data=>      out_data,			
		enable_i    =>	enable_i ,   	
		widthimg_i 	=>	widthimg_i 	
		);
	
	
	

	end DataFlow;	
