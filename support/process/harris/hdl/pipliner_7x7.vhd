library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use ieee.math_real.all;
library std;
library altera_mf;
use altera_mf.altera_mf_components.all;
use work.harris_package_components.all;
--use work.harris_package_variables.all;

entity pipliner_7x7 is
	generic (
		LINE_WIDTH_MAX : integer;
		PIX_WIDTH : integer;
                HALF_WINDOW_WIDTH: integer  -- The total window's width is :(HALF_WINDOW_WIDTH*2+1) : Should be an odd number	
		
	);
	port (
		clk_proc      : in std_logic;
		reset_n       : in std_logic;

		in_data       : in std_logic_vector((PIX_WIDTH-1) downto 0);
		in_fv         : in std_logic;
		in_dv         : in std_logic;

		out_data      : out std_logic_vector((PIX_WIDTH-1) downto 0);
		out_fv        : out std_logic;
		out_dv        : out std_logic;
		
		enable_i      : in std_logic;
		widthimg_i    : in std_logic_vector(15 downto 0);
                pixel_table_7_7 : out pixel_matrix
	);

end pipliner_7x7;



architecture rtl of pipliner_7x7 is

type              pixel_mask is array (0 to 2,0 to 2) of signed((PIX_WIDTH) downto 0);
type              pix_out_signal is array (0 to 5) of std_logic_vector((PIX_WIDTH-1) downto 0);
--type              pixel_matrix is array (0 to 6,0 to 6) of std_logic_vector((PIX_WIDTH-1) downto 0);
--type              filter_matrix is array (0 to 6,0 to 6) of std_logic_vector(RESULT_LENGTH downto 0);
constant          RESULT_LENGHT : integer := 64;   
constant          FIFO_LENGHT : integer := LINE_WIDTH_MAX-7;      
constant          FIFO_LENGHT_WIDTH : integer := integer(ceil(log2(real(FIFO_LENGHT))));
constant          Ix_sobel_mask:pixel_mask:=((to_signed(-1,9),to_signed(0,9),to_signed(1,9)),(to_signed(-1,9),to_signed(0,9),to_signed(1,9)),(to_signed(-1,9),to_signed(0,9),to_signed(1,9)));
constant          Iy_sobel_mask:pixel_mask:=((to_signed(-1,9),to_signed(-1,9),to_signed(-1,9)),(to_signed(0,9),to_signed(0,9),to_signed(0,9)),(to_signed(1,9),to_signed(1,9),to_signed(1,9))); 
signal            fv_signal,out_clk_dv:std_logic; 
signal            widthimg_temp : std_logic_vector(15 downto 0):=widthimg_i;
signal            sig_wrreq:std_logic:='1';
signal            sig_rdreq:std_logic:='0';
signal            line_pix_out:pix_out_signal;
shared variable   R:std_logic_vector((RESULT_LENGHT-1) downto 0); 
shared variable   Prev_R_max:std_logic_vector((RESULT_LENGHT-1) downto 0):=x"00000001DCD65000"; 
shared variable   R_max:std_logic_vector((RESULT_LENGHT-1) downto 0):=x"00000001DCD65000";   
shared variable   conv_value_x,conv_value_y:signed(17 downto 0):=to_signed(0,18);
shared variable   conv_value:integer:=0;
shared variable   param_changing_reset:std_logic:='0';      
shared variable   Ixx,Ixy,Iyy:signed(31 downto 0):=to_signed(0,32);
shared variable   cast_36_bits:std_logic_vector(35 downto 0); 
shared variable   aclr:std_logic:='0';
shared variable   Ixx_vec,Iyy_vec:std_logic_vector(31 downto 0);
shared variable   mult_a,mult_b,mult_2_a,mult_2_b,mult_3_a,mult_3_b:std_logic_vector(31 downto 0);
shared variable   mult_s,mult_2_s,mult_3_s,comp_a,comp_a_2,comp_b,comp_b_2,add_a_1,add_b_1,add_b_2,add_s_inter,add_s :std_logic_vector(63 downto 0);
shared variable   comp_s,comp_s_2:std_logic:='1';
shared variable   pixel_matrix_kernel:pixel_matrix;





component scfifo
   generic
   (        LPM_WIDTH: POSITIVE;
            LPM_WIDTHU: POSITIVE;
	    LPM_NUMWORDS: POSITIVE;
            LPM_SHOWAHEAD: STRING := "OFF";
	    ALLOW_RWCYCLE_WHEN_FULL: STRING := "OFF";
	    OVERFLOW_CHECKING: STRING:= "ON";
	    UNDERFLOW_CHECKING: STRING:= "ON"
	);
	port
	(
	    data: in std_logic_vector(LPM_WIDTH-1 downto 0);
	    clock, wrreq, rdreq, aclr: in std_logic;
	    full, empty, almost_full, almost_empty: out std_logic;
	    q: out std_logic_vector(LPM_WIDTH-1 downto 0);
	    usedw: out std_logic_vector(LPM_WIDTHU-1 downto 0)
	);
end component;




begin


        sig_wrreq<='1';


G_1 : for i in 0 to 5 generate
          line_fifo : scfifo
          generic map (
         	LPM_WIDTH	=>PIX_WIDTH,
    	        LPM_WIDTHU	=>FIFO_LENGHT_WIDTH,
    	        LPM_NUMWORDS    =>FIFO_LENGHT
	              )
          port map(
		data => pixel_matrix_kernel(i+1,0),
		clock => clk_proc,
		wrreq => in_dv, 
		q => line_pix_out(i),
		rdreq => sig_rdreq and in_dv,
		aclr =>param_changing_reset or(not(reset_n))
                   );
          end generate;




    process (clk_proc, reset_n)


    variable x_pos,y_pos : unsigned(15 downto 0);
    variable counter:integer:=0;


	begin
             
                fv_signal<=in_fv;

		if(reset_n='0') then 
			x_pos := to_unsigned(0, 16);      
			y_pos := to_unsigned(0, 16);         
                        out_clk_dv<='0';                   

		elsif(rising_edge(clk_proc)) then

                        fv_signal<=in_fv;                 
                        out_clk_dv<='0';                      
			if(in_fv='0') then
				x_pos := to_unsigned(0, 16);y_pos := to_unsigned(0, 16);
                                out_clk_dv<='0';

------------------------------------------------------------------------------------------------------ 
			elsif(in_dv='1') then


                                counter:=counter+1;
                                if(counter=(unsigned(widthimg_i)-8)) then 
                                sig_rdreq<='1';
                                end if;
                              
                                out_clk_dv<='1';

                                for o in 0 to 6 loop  
                                      for p in 0 to 5 loop
                                           pixel_matrix_kernel(o,p):=pixel_matrix_kernel(o,p+1);
                                      end loop;

                                     if (o<6) then
                                      pixel_matrix_kernel(o,6):=line_pix_out(o);
                                     end if;
                                end loop;
                                pixel_matrix_kernel(6,6):=in_data;

                                                                           
                                ----------- end of line ----------------
                                  if(x_pos=unsigned(widthimg_i)) then      
                                     y_pos := y_pos+1;                      
                                     x_pos := to_unsigned (1, 16);
                                  else   
                                     x_pos := x_pos+1;
                                  end if;
                               -----------------------------------------
                                              
                               ----------------------- bloquage et débloquage de l'horloge -----------------------------------------------------
	
                       	          if (y_pos<=to_unsigned (HALF_WINDOW_WIDTH-1, 16)) then
					    out_clk_dv<='0';                       							
                                  end if;                                     
                                ----------------------- blocage de bords spéciale pour les deux premiers élements de bords ----------------------
                                  if (x_pos<=to_unsigned (HALF_WINDOW_WIDTH, 16)) then   
                                            if (y_pos=to_unsigned (3, 16)) then
					            out_clk_dv<='0';							
                                            end if;
                                  end if;    
				-----------------------------------------------------------------------------------------------------------------                                               
                      
		          else
                       end if;

                                -------------- changing widthimg_i parameter---------------------------------------------------------------------

                                  if (unsigned(widthimg_i)=unsigned(widthimg_temp)) then
                                       param_changing_reset:='0';                          
                                  else
                                       param_changing_reset:='1';
                                       counter:=0;
                                       sig_rdreq<='0';
                                  end if;
                                  widthimg_temp<=widthimg_i;
                                -----------------------------------------------------------------------------
                


                       else
                   end if;
	end process;
	out_data<= std_logic_vector(to_unsigned(conv_value, 8));
	out_dv <=  out_clk_dv; 
	out_fv <= fv_signal;
        pixel_table_7_7<=pixel_matrix_kernel;

end rtl;
