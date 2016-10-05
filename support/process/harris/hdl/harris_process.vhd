library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use ieee.math_real.all;
library std;
library altera_mf;
use altera_mf.altera_mf_components.all;
use work.harris_package_components.all;

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

        signal temp_out_data:std_logic_vector(7 downto 0);
        signal temp_out_dv,temp_out_fv:std_logic; 
	signal	out_dvp,out_fvp	: std_logic;
	

----------------------------------------------------------------------------------------

type              pixel_mask is array (0 to 2,0 to 2) of signed((PIX_WIDTH) downto 0);
type              pix_out_signal is array (0 to 5) of std_logic_vector((PIX_WIDTH-1) downto 0);
type              pixel_matrix is array (0 to 6,0 to 6) of std_logic_vector((PIX_WIDTH-1) downto 0);
--type              filter_matrix is array (0 to 6,0 to 6) of std_logic_vector(RESULT_LENGTH downto 0);
constant          RESULT_LENGHT : integer:=44; 
constant          FILTER_RESULT_LENGTH:integer:=28;
constant          FIFO_LENGHT : integer := LINE_WIDTH_MAX-7;      
constant          FIFO_LENGHT_WIDTH : integer := integer(ceil(log2(real(FIFO_LENGHT))));
constant          Ix_sobel_mask:pixel_mask:=((to_signed(-1,9),to_signed(0,9),to_signed(1,9)),(to_signed(-1,9),to_signed(0,9),to_signed(1,9)),(to_signed(-1,9),to_signed(0,9),to_signed(1,9)));
constant          Iy_sobel_mask:pixel_mask:=((to_signed(-1,9),to_signed(-1,9),to_signed(-1,9)),(to_signed(0,9),to_signed(0,9),to_signed(0,9)),(to_signed(1,9),to_signed(1,9),to_signed(1,9))); 
signal            widthimg_temp : std_logic_vector(15 downto 0):=widthimg_i;
signal            sig_wrreq:std_logic:='1';
signal            sig_rdreq,fv_signal,out_clk_dv,filtering_halt:std_logic:='0';-------------------
signal            line_pix_out:pix_out_signal;
signal            pixel_table_7_7:pixel_matrix;
signal            pixel_table_filtering :filter_matrix;
signal            local_out_data:std_logic_vector((PIX_WIDTH-1) downto 0);
shared variable   R:std_logic_vector((RESULT_LENGHT-1) downto 0); 
shared variable   Prev_R_max:std_logic_vector((RESULT_LENGHT-1) downto 0):=x"001DCD65000"; 
shared variable   R_max:std_logic_vector((RESULT_LENGHT-1) downto 0):=x"001DCD65000";   
shared variable   conv_value_x,conv_value_y:signed(17 downto 0):=to_signed(0,18);
shared variable   conv_value:integer:=0;
shared variable   param_changing_reset:std_logic:='0';      
shared variable   Ixx,Ixy,Iyy:signed(31 downto 0):=to_signed(0,32);
shared variable   test_temp:signed((RESULT_LENGHT-1) downto 0):=to_signed(0,RESULT_LENGHT);
shared variable   cast_36_bits:std_logic_vector(35 downto 0); 
shared variable   aclr:std_logic:='0';
shared variable   Ixx_vec,Iyy_vec:std_logic_vector(31 downto 0);
shared variable   mult_a,mult_b,mult_2_a,mult_2_b,mult_3_a,mult_3_b:std_logic_vector(31 downto 0);
shared variable   mult_s,mult_2_s,mult_3_s,comp_a,comp_a_2,comp_b,comp_b_2,add_a_1,add_b_1,add_b_2,add_s_inter,add_s :std_logic_vector((RESULT_LENGHT-1) downto 0);
shared variable   comp_s,comp_s_2:std_logic:='1';
--shared variable   pixel_matrix_kernel:pixel_matrix;

--we suppose we will detect 200 harris point
-------------------------------------------------------------------
type              coord_table is array (0 to 199) of unsigned(15 downto 0);
shared variable   x_coordinates,y_coordinates:coord_table;
shared variable  coord_table_index, display_coord_index:integer:=0;
-------------------------------------------------------------------

shared variable HALF_WINDOW_WIDTH: integer:=3;



signal start_of_display:std_logic:='0';

signal pixel_value_display:std_logic_vector((PIX_WIDTH-1) downto 0);

signal inter_communication:std_logic_vector((FILTER_RESULT_LENGTH-1) downto 0);







----------------------------------------------------------------------------------------
	
	component pipliner_7x7
		generic (
			LINE_WIDTH_MAX 	: integer;
			PIX_WIDTH 		: integer;
                        HALF_WINDOW_WIDTH: integer  -- The total window's width is :(HALF_WINDOW_WIDTH*2+1) : Should be an odd number	
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
				
		enable_i    	        : in std_logic;
		widthimg_i              : in std_logic_vector(15 downto 0);
                pixel_table_7_7         : out pixel_matrix
		
	);
	end component;


component pipliner_filter
		generic (
			LINE_WIDTH_MAX 	: integer;
			PIX_WIDTH 		: integer;
                        HALF_WINDOW_WIDTH: integer  -- The total window's width is :(HALF_WINDOW_WIDTH*2+1) : Should be an odd number	
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
				
		enable_i    	        : in std_logic;
		widthimg_i              : in std_logic_vector(15 downto 0);
                pixel_table_7_7         : out filter_matrix
		
	);
	end component;
	
	begin
	
	
	inst_pipliner_1	:	pipliner_7x7	
		generic map(
		LINE_WIDTH_MAX 	=> LINE_WIDTH_MAX,
		PIX_WIDTH 		=> PIX_WIDTH,
                HALF_WINDOW_WIDTH=>HALF_WINDOW_WIDTH--3  -- The total window's width is :(HALF_WINDOW_WIDTH*2+1) : Should be an odd number		 
		)
		port map (
		clk_proc=>	clk_proc,						
		reset_n =>	reset_n,				
		in_data	=>	in_data,				
		in_fv 	=>	in_fv,					
		in_dv 	=>	in_dv,                    ------------------				
		out_fv 	=>	fv_signal,--out_fv,	  ------------------	
		out_dv 	=>	out_clk_dv, --out_dv      ------------------
                --out_data=>      out_data,			
		enable_i    =>	enable_i ,   	
		widthimg_i 	=>	widthimg_i,
                pixel_table_7_7=> pixel_table_7_7         ------------------
   	
		);

        inst_pipliner_2	:	pipliner_filter	
		generic map(
		LINE_WIDTH_MAX 	=> LINE_WIDTH_MAX,
		PIX_WIDTH 		=> FILTER_RESULT_LENGTH,--RESULT_LENGHT,
                HALF_WINDOW_WIDTH=>HALF_WINDOW_WIDTH--3  -- The total window's width is :(HALF_WINDOW_WIDTH*2+1) : Should be an odd number		 
		)
		port map (
		clk_proc=>	clk_proc ,--and filtering_halt,   -- signal : filtering_halt						
		reset_n =>	reset_n,				
		in_data	=>	inter_communication,--x"2222",--R,		  --*******		
		in_fv 	=>	in_fv,--fv_signal,                    --*******					
		in_dv 	=>	in_dv,--out_clk_dv,                    --*******				
		--out_fv 	=>	fv_signal,--out_fv,	  ------------------	
		--out_dv 	=>	out_clk_dv, --out_dv      ------------------
                --out_data=>      out_data,			
		enable_i    =>	enable_i ,   	
		widthimg_i  =>	widthimg_i,
                pixel_table_7_7=> pixel_table_filtering    ------------------	
		);

     --######################################################################################################




mult_inst:LPM_MULT
  generic map ( LPM_WIDTHA     =>32,
            LPM_WIDTHB         =>32,
            LPM_WIDTHS         =>1,           
            LPM_WIDTHP         =>RESULT_LENGHT,
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
  generic map ( LPM_WIDTHA     =>32,
            LPM_WIDTHB         =>32,
            LPM_WIDTHS         =>1,           
            LPM_WIDTHP         =>RESULT_LENGHT,
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
  generic map ( LPM_WIDTHA     =>32,
            LPM_WIDTHB         =>32,
            LPM_WIDTHS         =>1,           
            LPM_WIDTHP         =>RESULT_LENGHT,
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
  generic map (LPM_WIDTH => RESULT_LENGHT,
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
  generic map (LPM_WIDTH => RESULT_LENGHT,
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
  generic map ( LPM_WIDTH                             =>RESULT_LENGHT,
            LPM_DIRECTION                             =>"DEFAULT",
            LPM_REPRESENTATION                        =>"SIGNED",
            LPM_PIPELINE                              =>0,
            LPM_TYPE                                  =>"LPM_ADD_SUB",
            LPM_HINT                                  =>"UNUSED")

  port map (DATAA =>add_a_1,
            DATAB =>add_b_1,
            ACLR => '0',
            CIN =>'0',
            ADD_SUB => '0',
            RESULT =>add_s_inter
           );


LMP_ADD_SUB_inst_2: LPM_ADD_SUB
  generic map ( LPM_WIDTH                             =>RESULT_LENGHT,
            LPM_DIRECTION                             =>"DEFAULT",
            LPM_REPRESENTATION                        =>"SIGNED",
            LPM_PIPELINE                              =>0,
            LPM_TYPE                                  =>"LPM_ADD_SUB",
            LPM_HINT                                  =>"UNUSED")

  port map (DATAA =>add_s_inter,
            DATAB =>add_b_2,
            ACLR => '0',
            CIN =>'0',
            ADD_SUB => '0',
            RESULT =>add_s
           );



    process (clk_proc, reset_n)


    variable x_pos,y_pos : unsigned(15 downto 0);
    variable comp_std,R_std_64,shifted_R_8_1,shifted_R_8_2:std_logic_vector((RESULT_LENGHT-1) downto 0):= x"001DCD65000";
    variable Ixx_max,Iyy_max:signed(31 downto 0);  
    variable counter:integer:=0;


 

    



---- for the filtering
       variable x_window_width,y_window_width:integer:=7;
       variable n_step_window_valid:std_logic:='0';

       variable filter_max_value:std_logic_vector((FILTER_RESULT_LENGTH-1) downto 0);                                  
       variable harris_candidates,index_filtering_y,index_filtering_x:integer:=0;
       variable prev_index_filtering_y,prev_index_filtering_x,temp_x,temp_y:unsigned(15 downto 0):=to_unsigned(0,16);

       variable start_of_filtering:std_logic:='0';
       --variable start_of_display:std_logic='0';




	begin
             
       

		if(reset_n='0') then 
			x_pos := to_unsigned(0, 16);y_pos := to_unsigned(0, 16);         
                                     

		elsif(rising_edge(clk_proc)) then
                   
			if(in_fv='0') then
		        x_pos := to_unsigned(0, 16);y_pos := to_unsigned(0, 16);
                        Prev_R_max:=R_max;
                        --R_max:=x"0001DCD65000";
                        start_of_display<='0';

                        x_window_width:=7;y_window_width:=7;
                        start_of_filtering:='0';
                        filtering_halt<='0';
                        coord_table_index:=0;
                        display_coord_index:=0;

------------------------------------------------------------------------------------------------------ 
			elsif(in_dv='1') then    


                               harris_candidates:=0;
                                ----------- end of line ----------------
                                if(x_pos=unsigned(widthimg_i)) then      
                                       y_pos := y_pos+1;                      
                                       x_pos := to_unsigned (1, 16);
                                else   
                                       x_pos := x_pos+1;
                                end if;
                                ----------------------------------------- 
                          

                                ---------------- n step window validation ---------
                                 -- n : the actual step  =7
                                 --  
             
                                 n_step_window_valid:='0';

 
                                 if ((x_pos mod x_window_width)=0) and ((y_pos mod y_window_width)=0) then

                                   n_step_window_valid:='1';
                                 end if;
                                 
                                ---------------------------------------------------

 
   
                       if (y_pos=to_unsigned (HALF_WINDOW_WIDTH*2, 16)) and (x_pos=to_unsigned (HALF_WINDOW_WIDTH*2+1, 16)) then

                               filtering_halt<='1';

                       end if;

                                          
                                  conv_value:=to_integer(unsigned(pixel_table_7_7(3,3)));
                               
                                  Ixx:=to_signed(+0,32);Ixy:=to_signed(+0,32);Iyy:=to_signed(+0,32);
                                  for i in 1 to 5 loop 
                                      for j in 1 to 5 loop
                                                conv_value_x:=to_signed(0,18);conv_value_y:=to_signed(0,18);
                                                for m in 0 to 2 loop  
                                                      for n in 0 to 2 loop
                                                             conv_value_x:= conv_value_x+signed('0' & pixel_table_7_7(i+m-1,j+n-1))*Ix_sobel_mask(m,n);
                                                             conv_value_y:= conv_value_y+signed('0' & pixel_table_7_7(i+m-1,j+n-1))*Iy_sobel_mask(m,n);
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

     
                             
                                R:=add_s;
                                --shifted_R_8_2:=Prev_R_max(63)&Prev_R_max(63)&Prev_R_max(63)&Prev_R_max(63 downto 3);                                 
                                comp_b:=comp_std;
                                comp_a:=R;
                                    
 
                                --if (comp_s='1') then 

                                if(signed(R)>to_signed(50000,RESULT_LENGHT)) then  --signed(comp_std)
                                         conv_value:=0;
                                end if;


                                  if (n_step_window_valid='1') then
                                       -- conv_value:=0;
                                  end if;


                               
                                pixel_value_display <= pixel_table_7_7(3,3);


                --------------------------------------------------------------------conversion 64 bit to 32
                  --  inter_communication

                     if (signed(R)>to_signed(50000,RESULT_LENGHT)) then
                             test_temp:=signed(R)-to_signed(50000,RESULT_LENGHT);
                             shifted_R_8_2:=std_logic_vector(test_temp);
                             
           --                    conv_value:=0; ##############################################################################
                             
                             inter_communication<=shifted_R_8_2((FILTER_RESULT_LENGTH-1) downto 0);
                     else
                             inter_communication<=x"0000000";
                     end if;
                  -- 
                     if (signed(pixel_table_filtering(6,6))>to_signed(0,FILTER_RESULT_LENGTH) ) then

                           -- conv_value:=0;
                     end if;
                ------------------------------------------------------------------------
                                if (y_pos=to_unsigned(HALF_WINDOW_WIDTH, 16)) and (x_pos=to_unsigned (HALF_WINDOW_WIDTH+1, 16)) then
                 
				  start_of_display<='1';
                                            							
                                  
                                end if;   
         
                                if (x_pos>=to_unsigned (HALF_WINDOW_WIDTH+1, 16)) then
                                     start_of_filtering:='1';
                                end if;


                                --if(start_of_filtering='1') then
                                      harris_candidates:=0;
                                     -- if (n_step_window_valid='1') then
                                      
                                         filter_max_value:=x"0000000";--comp_std;                                      
                                         
                                         
                                         for v in 0 to 6 loop 
                                                for w in 0 to 6 loop
                                                       if (signed(pixel_table_filtering(v,w))>to_signed(0,FILTER_RESULT_LENGTH)) then
                                                              --   conv_value:=1;
                                                                 harris_candidates:=harris_candidates+1;
                                                                 if (signed(pixel_table_filtering(v,w))>signed(filter_max_value)) then
                                                                    filter_max_value:=pixel_table_filtering(v,w);                                                                 
                                                                    index_filtering_y:=v;
                                                                    index_filtering_x:=w;                                                         
                                                                 end if;     
                                                       end if;                                
                                                end loop;
                                         end loop;

                                  
                                --     if (harris_candidates>2) and (coord_table_index<=199) then  -- at least one harris point has bee detected

                                          -- filtrage ---------------------------
                                --         x_coordinates(coord_table_index):=x_pos+index_filtering_x+5;  -- | we select the maximum point coordinates
                               --          y_coordinates(coord_table_index):=y_pos+index_filtering_y+5;  -- |
                                --         coord_table_index:=coord_table_index+1;        
                                --     end if;               							
                                     -- end if;
                               -- end if;   


                              -- if (n_step_window_valid='1') then
                                   if (harris_candidates>=39) then
                                               pixel_value_display <= (others=>'0');
                                   end if;
                              -- end if;


                                   
                                    
                               --      if (x_pos=x_coordinates(display_coord_index)) and (y_pos=y_coordinates(display_coord_index)) then 
                               --           pixel_value_display <= (others=>'0');
                                --          if (display_coord_index<199) then
                                --            display_coord_index:=display_coord_index;
                                --          end if;
                                --     end if;
                    
                                 
		            else
                          end if;


                    else
                   end if;
	end process;

	--out_data<= pixel_value_display;                             --std_logic_vector(to_unsigned(conv_value, 8));
	--out_dv <=  out_clk_dv;--in_dv and start_of_display;                      --out_clk_dv; 
	--out_fv <= fv_signal;--in_fv;                                            --fv_signal;

        out_data<= std_logic_vector(to_unsigned(conv_value, 8));
	out_dv <=  out_clk_dv; 
	out_fv <= fv_signal;

	
	
	

	end DataFlow;	
