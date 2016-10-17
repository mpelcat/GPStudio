library ieee;
	use	ieee.std_logic_1164.all;
	use	ieee.numeric_std.all;

library work;
	use work.cnn_types.all;

entity sconvGen_process is
    generic(
        PIXEL_SIZE      :   integer;
        IMAGE_WIDTH     :   integer
        );
    port(
        clk	        :	in 	std_logic;
        reset_n	    :	in	std_logic;
        enable	    :	in	std_logic;

        in_data     :	in 	std_logic_vector ((PIXEL_SIZE-1) downto 0);
        in_dv	    :	in	std_logic;
        in_fv	    :	in	std_logic;

        out1_data   :	out	std_logic_vector ((PIXEL_SIZE-1) downto 0);
        out1_dv	    :	out	std_logic;
        out1_fv	    :	out	std_logic;

        out2_data   :	out	std_logic_vector ((PIXEL_SIZE-1) downto 0);
        out2_dv	    :	out	std_logic;
        out2_fv	    :	out	std_logic;

        out3_data   :	out	std_logic_vector ((PIXEL_SIZE-1) downto 0);
        out3_dv	    :	out	std_logic;
        out3_fv	    :	out	std_logic

    );
end entity;

architecture structural of sconvGen_process is
    --------------------------------------------------------------------------------
    -- COMPONENTS
    --------------------------------------------------------------------------------
    component neighExtractor
    generic(
		PIXEL_SIZE      :   integer;
		IMAGE_WIDTH     :   integer;
		KERNEL_SIZE     :   integer
	);

    port(
		clk	            :	in 	std_logic;
        reset_n	        :	in	std_logic;
        enable	        :	in	std_logic;
        in_data         :	in 	std_logic_vector((PIXEL_SIZE-1) downto 0);
        in_dv	        :	in	std_logic;
        in_fv	        :	in	std_logic;
        out_data        :	out	pixel_array (0 to (KERNEL_SIZE * KERNEL_SIZE)- 1);
        out_dv			:	out std_logic;
        out_fv			:	out std_logic
    );
    end component;

    --------------------------------------------------------------------------------
    component convElement
    generic(
        KERNEL_SIZE :    integer;
        PIXEL_SIZE  :    integer
    );

    port(
        clk         :   in  std_logic;
        reset_n     :   in  std_logic;
        enable      :   in  std_logic;
        in_data     :   in  pixel_array (0 to KERNEL_SIZE * KERNEL_SIZE - 1);
        in_dv    	:   in  std_logic;
        in_fv    	:   in  std_logic;
        in_kernel   :   in  pixel_array (0 to KERNEL_SIZE * KERNEL_SIZE - 1);
        in_norm     :   in  std_logic_vector(PIXEL_SIZE-1 downto 0);
        out_data    :   out std_logic_vector(PIXEL_SIZE-1 downto 0);
        out_dv    	:   out std_logic;
        out_fv    	:   out std_logic

    );
    end component;


    --------------------------------------------------------------------------------
    -- CONSTANTS
    --------------------------------------------------------------------------------
    -- Only for demo purpose
    constant CONST_C1_KERNEL_SIZE : integer := 3;
    constant CONST_C2_KERNEL_SIZE : integer := 5;
    constant CONST_C3_KERNEL_SIZE : integer := 11;

    constant CONST_C1_NORM  : std_logic_vector := std_logic_vector(to_unsigned(3,PIXEL_SIZE));
    constant CONST_C2_NORM  : std_logic_vector := std_logic_vector(to_unsigned(5,PIXEL_SIZE));
    constant CONST_C3_NORM  : std_logic_vector := std_logic_vector(to_unsigned(7,PIXEL_SIZE));

    constant CONST_C1_KERNEL : pixel_array (0 to CONST_C1_KERNEL_SIZE * CONST_C1_KERNEL_SIZE - 1) :=
        (others => (std_logic_vector(to_unsigned(1,PIXEL_SIZE))));

    constant CONST_C2_KERNEL : pixel_array (0 to CONST_C2_KERNEL_SIZE * CONST_C2_KERNEL_SIZE - 1) :=
        (others => (std_logic_vector(to_unsigned(1,PIXEL_SIZE))));

    constant CONST_C3_KERNEL : pixel_array (0 to CONST_C3_KERNEL_SIZE * CONST_C3_KERNEL_SIZE - 1) :=
        (others => (std_logic_vector(to_unsigned(1,PIXEL_SIZE))));





    --------------------------------------------------------------------------------
    -- SIGNALS
    --------------------------------------------------------------------------------
    signal ne1_data : pixel_array (0 to CONST_C1_KERNEL_SIZE * CONST_C1_KERNEL_SIZE - 1);
    signal ne2_data : pixel_array (0 to CONST_C2_KERNEL_SIZE * CONST_C2_KERNEL_SIZE - 1);
    signal ne3_data : pixel_array (0 to CONST_C3_KERNEL_SIZE * CONST_C3_KERNEL_SIZE - 1);

    signal ne1_dv   : std_logic;
    signal ne2_dv   : std_logic;
    signal ne3_dv   : std_logic;

    signal ne1_fv   : std_logic;
    signal ne2_fv   : std_logic;
    signal ne3_fv   : std_logic;




    --------------------------------------------------------------------------------
    -- STRUCTURAL DESCRIPTION
    --------------------------------------------------------------------------------

    begin

        NE1_INST : neighExtractor
        generic map(
            PIXEL_SIZE     =>  PIXEL_SIZE,
		    IMAGE_WIDTH    =>  IMAGE_WIDTH,
	        KERNEL_SIZE    =>  CONST_C1_KERNEL_SIZE
        )
        port map(
            clk	           =>  clk,
            reset_n	       =>  reset_n,
            enable	       =>  enable,
            in_data        =>  in_data,
            in_dv	       =>  in_dv,
            in_fv	       =>  in_fv,
            out_data       =>  ne1_data,
            out_dv		   =>  ne1_dv,
            out_fv		   =>  ne1_fv
        );

        --------------------------------------------------------------------------------

        NE2_INST : neighExtractor
        generic map(
            PIXEL_SIZE     =>  PIXEL_SIZE,
            IMAGE_WIDTH    =>  IMAGE_WIDTH,
            KERNEL_SIZE    =>  CONST_C2_KERNEL_SIZE
        )
        port map(
            clk	           =>  clk,
            reset_n	       =>  reset_n,
            enable	       =>  enable,
            in_data        =>  in_data,
            in_dv	       =>  in_dv,
            in_fv	       =>  in_fv,
            out_data       =>  ne2_data,
            out_dv		   =>  ne2_dv,
            out_fv		   =>  ne2_fv
        );

        --------------------------------------------------------------------------------

        NE3_INST : neighExtractor
        generic map(
            PIXEL_SIZE     =>  PIXEL_SIZE,
            IMAGE_WIDTH    =>  IMAGE_WIDTH,
            KERNEL_SIZE    =>  CONST_C3_KERNEL_SIZE
        )
        port map(
            clk	           =>  clk,
            reset_n	       =>  reset_n,
            enable	       =>  enable,
            in_data        =>  in_data,
            in_dv	       =>  in_dv,
            in_fv	       =>  in_fv,
            out_data       =>  ne3_data,
            out_dv		   =>  ne3_dv,
            out_fv		   =>  ne3_fv
        );

        --------------------------------------------------------------------------------

        CE1_INST : convElement
        generic map(
            PIXEL_SIZE     => PIXEL_SIZE,
            KERNEL_SIZE    => CONST_C1_KERNEL_SIZE
        )
        port map(
            clk            => clk,
            reset_n        => reset_n,
            enable         => enable,
            in_data        => ne1_data,
            in_dv    	   => ne1_dv,
            in_fv    	   => ne1_fv,
            in_kernel      => CONST_C1_KERNEL,
            in_norm        => CONST_C1_NORM,
            out_data       => out1_data,
            out_dv    	   => out1_dv,
            out_fv    	   => out1_fv
        );

        --------------------------------------------------------------------------------

        CE2_INST : convElement
        generic map(
            PIXEL_SIZE     => PIXEL_SIZE,
            KERNEL_SIZE    => CONST_C2_KERNEL_SIZE
        )
        port map(
            clk            => clk,
            reset_n        => reset_n,
            enable         => enable,
            in_data        => ne2_data,
            in_dv    	   => ne2_dv,
            in_fv    	   => ne2_fv,
            in_kernel      => CONST_C2_KERNEL,
            in_norm        => CONST_C2_NORM,
            out_data       => out2_data,
            out_dv    	   => out2_dv,
            out_fv    	   => out2_fv
        );

        --------------------------------------------------------------------------------

        CE3_INST : convElement
        generic map(
            PIXEL_SIZE     => PIXEL_SIZE,
            KERNEL_SIZE    => CONST_C3_KERNEL_SIZE
        )
        port map(
            clk            => clk,
            reset_n        => reset_n,
            enable         => enable,
            in_data        => ne3_data,
            in_dv    	   => ne3_dv,
            in_fv    	   => ne3_fv,
            in_kernel      => CONST_C3_KERNEL,
            in_norm        => CONST_C3_NORM,
            out_data       => out3_data,
            out_dv    	   => out3_dv,
            out_fv    	   => out3_fv
        );

end structural;
