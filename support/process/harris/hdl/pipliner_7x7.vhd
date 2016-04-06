library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use ieee.math_real.all;
library std;
library altera_mf;
use altera_mf.altera_mf_components.all;

entity pipliner_7x7 is
	generic (
		LINE_WIDTH_MAX : integer;
		PIX_WIDTH : integer
		
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
		widthimg_i    : in std_logic_vector(15 downto 0)
	);

end pipliner_7x7;



architecture rtl of pipliner_7x7 is


type              pixel_matrix is array (0 to 6,0 to 6) of std_logic_vector((PIX_WIDTH-1) downto 0);
type              pixel_mask is array (0 to 2,0 to 2) of signed((PIX_WIDTH) downto 0);
type              pix_out_signal is array (0 to 5) of std_logic_vector((PIX_WIDTH-1) downto 0);
constant          FIFO_LENGHT : integer := LINE_WIDTH_MAX-7;      
constant          FIFO_LENGHT_WIDTH : integer := integer(ceil(log2(real(FIFO_LENGHT))));
constant          Ix_sobel_mask:pixel_mask:=((to_signed(-1,9),to_signed(0,9),to_signed(1,9)),(to_signed(-1,9),to_signed(0,9),to_signed(1,9)),(to_signed(-1,9),to_signed(0,9),to_signed(1,9)));
constant          Iy_sobel_mask:pixel_mask:=((to_signed(-1,9),to_signed(-1,9),to_signed(-1,9)),(to_signed(0,9),to_signed(0,9),to_signed(0,9)),(to_signed(1,9),to_signed(1,9),to_signed(1,9))); 
signal            fv_signal,out_clk_dv:std_logic; 
signal            var_calc_std : std_logic_vector((PIX_WIDTH-1) downto 0);
signal            widthimg_temp : std_logic_vector(15 downto 0):=widthimg_i;
signal            sig_wrreq:std_logic:='1';
signal            sig_rdreq:std_logic:='0';
signal            line_pix_out:pix_out_signal;
signal            R:signed(63 downto 0):=to_signed(0,64);
shared variable   conv_value_x,conv_value_y:signed(17 downto 0):=to_signed(0,18);
shared variable   conv_value:integer:=0;
shared variable   param_changing_reset:std_logic:='0';      
shared variable   Ixx,Ixy,Iyy:signed(31 downto 0):=to_signed(0,32);
shared variable   cast_36_bits:std_logic_vector(35 downto 0);
shared variable   R_max:signed(63 downto 0):=to_signed(0,64); 
shared variable   Prev_R_max_vector:std_logic_vector(63 downto 0):=x"00000001DCD65000"; 
shared variable   Previous_R_max:signed(63 downto 0):=signed(Prev_R_max_vector);
shared variable   Ixx_vec,Iyy_vec:std_logic_vector(31 downto 0);
shared variable   mult_a,mult_b,mult_2_a,mult_2_b,mult_3_a,mult_3_b:std_logic_vector(31 downto 0);
shared variable   mult_s,mult_2_s,mult_3_s,comp_a,comp_a_2,comp_b,comp_b_2,add_a_1,add_b_1,add_b_2,add_s_inter,add_s :std_logic_vector(63 downto 0);
shared variable   comp_s,comp_s_2:std_logic;
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




component LPM_MULT
  generic ( LPM_WIDTHA         : natural;                
            LPM_WIDTHB         : natural;                
            LPM_WIDTHS         : natural := 1;            
            LPM_WIDTHP         : natural;                
            LPM_REPRESENTATION : string := "SIGNED";        
            LPM_PIPELINE       : natural := 0;         
            LPM_TYPE           : string;
            LPM_HINT           : string  := "UNUSED");

  port    ( DATAA              : in std_logic_vector(LPM_WIDTHA-1 downto 0);
            DATAB              : in std_logic_vector(LPM_WIDTHB-1 downto 0);
            ACLR               : in std_logic := '0';
            SUM                : in std_logic_vector(LPM_WIDTHS-1 downto 0) := (OTHERS => '0');
            RESULT             : out std_logic_vector(LPM_WIDTHP-1 downto 0));
end component;


component LPM_COMPARE
  generic ( LPM_WIDTH          : natural:=64;
            LPM_REPRESENTATION : string := "SIGNED";
            LPM_PIPELINE       : natural := 0;
            LPM_TYPE: string   := "LPM_COMPARE";
            LPM_HINT : string  := "UNUSED");

  port (    DATAA              : in std_logic_vector(LPM_WIDTH-1 downto 0);
            DATAB              : in std_logic_vector(LPM_WIDTH-1 downto 0);
            ACLR               : in std_logic := '0';
            AGB                : out std_logic;
            AGEB               : out std_logic;
            AEB                : out std_logic;
            ANEB               : out std_logic;
            ALB                : out std_logic;
            ALEB               : out std_logic);
end component;


component LPM_ADD_SUB
  generic ( LPM_WIDTH          : natural:=64;
            LPM_DIRECTION      : string := "ADD";
            LPM_REPRESENTATION : string                        := "SIGNED";
            LPM_PIPELINE       : natural                            := 0;
            LPM_TYPE           : string                                 := "LPM_ADD_SUB";
            LPM_HINT           : string                                 := "UNUSED");
  port (    DATAA              : in std_logic_vector(LPM_WIDTH-1 downto 0);
            DATAB              : in std_logic_vector(LPM_WIDTH-1 downto 0);
            ACLR               : in std_logic                               := '0';
            CLOCK              : in std_logic                              := '0';
            CLKEN              : in std_logic                              := '1';
            CIN                : in std_logic          := 'Z';
            ADD_SUB            : in std_logic      := '1';
            RESULT             : out std_logic_vector(LPM_WIDTH-1 downto 0);
            COUT               : out std_logic;
            OVERFLOW           : out std_logic);
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

mult_inst:LPM_MULT
  generic map ( LPM_WIDTHA         =>32,
            LPM_WIDTHB         =>32,
            LPM_WIDTHS         =>1,           
            LPM_WIDTHP         =>64,
            LPM_REPRESENTATION =>"SIGNED",        
            LPM_PIPELINE       =>0,         
            LPM_TYPE           =>"LPM_MULT",
            LPM_HINT           =>"UNUSED"
           )

  port  map   ( DATAA              => mult_a,
                DATAB              => mult_b,
                ACLR               => '0',
                RESULT             => mult_s
              );

mult_inst_2:LPM_MULT
  generic map ( LPM_WIDTHA         =>32,
            LPM_WIDTHB         =>32,
            LPM_WIDTHS         =>1,           
            LPM_WIDTHP         =>64,
            LPM_REPRESENTATION =>"SIGNED",        
            LPM_PIPELINE       =>0,         
            LPM_TYPE           =>"LPM_MULT",
            LPM_HINT           =>"UNUSED"
           )

  port  map   ( DATAA              => mult_2_a,
                DATAB              => mult_2_b,
                ACLR               => '0',
                RESULT             => mult_2_s
              );

mult_inst_3:LPM_MULT
  generic map ( LPM_WIDTHA         =>32,
            LPM_WIDTHB         =>32,
            LPM_WIDTHS         =>1,           
            LPM_WIDTHP         =>64,
            LPM_REPRESENTATION =>"SIGNED",        
            LPM_PIPELINE       =>0,         
            LPM_TYPE           =>"LPM_MULT",
            LPM_HINT           =>"UNUSED"
           )

  port  map   ( DATAA          => mult_3_a,
                DATAB          => mult_3_b,
                ACLR           => '0',
                RESULT         => mult_3_s
              );


comp_inst_1: LPM_COMPARE
  generic map (LPM_WIDTH => 64,
               LPM_REPRESENTATION =>"SIGNED",
               LPM_PIPELINE => 0,
               LPM_TYPE=>"LPM_COMPARE",
               LPM_HINT=>"UNUSED"
             )

  port map(      DATAA =>comp_a,
            DATAB =>comp_b,
            ACLR =>'0',
            AGB => comp_s
           );

comp_inst_2: LPM_COMPARE
  generic map (LPM_WIDTH => 64,
               LPM_REPRESENTATION =>"SIGNED",
               LPM_PIPELINE => 0,
               LPM_TYPE=>"LPM_COMPARE",
               LPM_HINT=>"UNUSED"
             )

  port map(      DATAA =>comp_a_2,
            DATAB =>comp_b_2,
            ACLR =>'0',
            AGB => comp_s_2
           );







LMP_ADD_SUB_inst_1: LPM_ADD_SUB
  generic map ( LPM_WIDTH                             =>64,
            LPM_DIRECTION                             =>"DEFAULT",
            LPM_REPRESENTATION                        =>"SIGNED",
            LPM_PIPELINE                              =>0,
            LPM_TYPE                                  =>"LPM_ADD_SUB",
            LPM_HINT                                  =>"UNUSED")

  port map (DATAA =>add_a_1,
            DATAB =>add_b_1,
            ACLR => '0',
            CIN =>'Z',
            ADD_SUB => '0',
            RESULT =>add_s_inter
           );


LMP_ADD_SUB_inst_2: LPM_ADD_SUB
  generic map ( LPM_WIDTH                             =>64,
            LPM_DIRECTION                             =>"DEFAULT",
            LPM_REPRESENTATION                        =>"SIGNED",
            LPM_PIPELINE                              =>0,
            LPM_TYPE                                  =>"LPM_ADD_SUB",
            LPM_HINT                                  =>"UNUSED")

  port map (DATAA =>add_s_inter,
            DATAB =>add_b_2,
            ACLR => '0',
            CIN =>'Z',
            ADD_SUB => '0',
            RESULT =>add_s
           );






process (in_fv)




begin

if(falling_edge(in_fv)) then
    Previous_R_max:=R_max;

    

end if;

end process;





    process (clk_proc, reset_n)


    variable var_calc:integer;

    variable x_pos : unsigned(15 downto 0);
    variable y_pos : unsigned(15 downto 0);

    variable xpos_nbr:unsigned(7 downto 0):=to_unsigned(0,8);

   

    variable comp:signed(63 downto 0);

    variable comp_std,R_std_64,shifted_R_8_1,shifted_R_8_2:std_logic_vector(63 downto 0):=x"00000012A05F2000";  

    variable temp_1,temp_2,temp_3:signed(31 downto 0);
    variable Ixx_max,Iyy_max:signed(31 downto 0);
    
    variable borders_num:integer;


    variable mult_a_max,mult_b_max:std_logic_vector(31 downto 0);
    variable mult_s_max:std_logic_vector(63 downto 0);

   

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
                                R_max:=to_signed(0,64);

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

                                conv_value:=to_integer(unsigned(pixel_matrix_kernel(3,3)));
                              


                               
                                  Ixx:=to_signed(+0,32);Ixy:=to_signed(+0,32);Iyy:=to_signed(+0,32);
                                  for i in 1 to 5 loop 
                                      for j in 1 to 5 loop

                                                conv_value_x:=to_signed(0,18);
                                                conv_value_y:=to_signed(0,18);

                                                for m in 0 to 2 loop  
                                                      for n in 0 to 2 loop
                                                             conv_value_x:= conv_value_x+signed('0' & pixel_matrix_kernel(i+m-1,j+n-1))*Ix_sobel_mask(m,n);
                                                             conv_value_y:= conv_value_y+signed('0' & pixel_matrix_kernel(i+m-1,j+n-1))*Iy_sobel_mask(m,n);
                                                      end loop;
                                                end loop;
                                    
                                                cast_36_bits:=std_logic_vector(conv_value_x*conv_value_x);                                      
                                                Ixx:=Ixx+signed(cast_36_bits(34) & cast_36_bits(30 downto 0));  

                                                cast_36_bits:=std_logic_vector(conv_value_x*conv_value_y); 
                                                Ixy:=Ixy+signed(cast_36_bits(34) & cast_36_bits(30 downto 0));

                                                cast_36_bits:=std_logic_vector(conv_value_y*conv_value_y);
                                                Iyy:=Iyy+signed(cast_36_bits(34) & cast_36_bits(30 downto 0));
                                               

                                       end loop;
                                  end loop;

                                  
 
                                comp:=signed(comp_std);
                                  
                                Ixx_vec:=std_logic_vector(Ixx);
                                Iyy_vec:=std_logic_vector(Iyy);
 
                                mult_a:=Ixx_vec;
                                mult_b:=Iyy_vec;

                                Ixx_vec:=std_logic_vector(Ixx+Iyy);
                                Iyy_vec:=Ixx_vec(31)&Ixx_vec(31)&Ixx_vec(31)&Ixx_vec(31 downto 3);
                                mult_2_a:=Ixx_vec;
                                mult_2_b:=Iyy_vec;


                
                                


                                Iyy_vec:=std_logic_vector(Ixy);
                                mult_3_a:=Iyy_vec;
                                mult_3_b:=Iyy_vec;

                    
                              
                                  add_a_1:=mult_s;
                                  add_b_1:=mult_3_s;
                                  add_b_2:=mult_2_s;

                                  R<=signed(mult_s)-signed(mult_3_s)-signed(mult_2_s);


                             

                                  shifted_R_8_1:=std_logic_vector(Previous_R_max);
                                  shifted_R_8_2:=shifted_R_8_1(63)&shifted_R_8_1(63)&shifted_R_8_1(63)&shifted_R_8_1(63 downto 3);

                                    comp_b:=comp_std;
                                    comp_a:=add_s;
 
                                  if (comp_s='1') then 
                                         conv_value:=0;
                                  end if;



                   -----------------------------------------------------------------------------

                                 if (R>R_max) then
                                         R_max:=R; 
                                 end if;
                   ---------------------------------------------------------------------              

                                                               	  			 			                       
                                --compute the data *************************
                                  var_calc:=0;                                   
                                  var_calc:=var_calc/1;
                                  var_calc_std <="10000000";
                                --*******************************************

                               
                                ----------- end of line ----------------
                                  if(x_pos=unsigned(widthimg_i)) then      
                                     y_pos := y_pos+1;                      
                                     x_pos := to_unsigned (1, 16);
                                  else   
                                     x_pos := x_pos+1;
                                  end if;
                                ---------------- Borders detection ----------------------------------------------
                                  if (x_pos=to_unsigned (1, 16)) then
                                            borders_num:=6;  -- was of 2
                                  end if;
                                ---------------------------------------------------------------------------------

                                ---------------- Borders processing ---------------------------------------------
                                  if (borders_num>0) then
                                            borders_num:=borders_num-1;  
                                            var_calc_std <=(others=>'0');     
                                  end if; 
                                ---------------------------------------------------------------------------------

                                ---------------- Borders managing for the first line ----------------------------
                                  if (y_pos=to_unsigned (2, 16)) then
                                        if (x_pos>to_unsigned (1, 16)) then
				            var_calc_std <=(others=>'0');							
                                        end if;
                                  end if;
                                -----------------------------------------------------------------------------------------------------------------


                                
                                  if (y_pos=to_unsigned (0, 16)) or (y_pos=to_unsigned (1, 16)) or (y_pos=to_unsigned (2, 16)) then
					    out_clk_dv<='0';                       							
                                  end if;
                                

                                -----------------------------------------------------------------------------------------------------------------
                                ----------------------- bloquage et débloquage de l'horloge -----------------------------------------------------

					
                       	          if (y_pos=to_unsigned (0, 16)) or (y_pos=to_unsigned (1, 16)) or (y_pos=to_unsigned (2, 16)) then
					    out_clk_dv<='0';                       							
                                  end if;                                     
                                ----------------------- blocage de bords spéciale pour les deux premiers élements de bords ----------------------
                                  if (x_pos<=to_unsigned (3, 16)) then
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

end rtl;
