library verilog;
use verilog.vl_types.all;
entity normhw is
    generic(
        IN_WIDTH        : integer := 16;
        OUT_WIDTH       : integer := 16;
        NWORDS          : integer := 8;
        NPIPELINE       : integer := 10
    );
    port(
        clk_proc        : in     vl_logic;
        reset_n         : in     vl_logic;
        in_fv           : in     vl_logic;
        in_dv           : in     vl_logic;
        in_data         : in     vl_logic_vector;
        out_fv          : out    vl_logic;
        out_dv          : out    vl_logic;
        out_data        : out    vl_logic_vector;
        addr_rel_i      : in     vl_logic;
        wr_i            : in     vl_logic;
        datawr_i        : in     vl_logic_vector(31 downto 0);
        rd_i            : in     vl_logic;
        datard_o        : out    vl_logic_vector(31 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of IN_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of OUT_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of NWORDS : constant is 1;
    attribute mti_svvh_generic_type of NPIPELINE : constant is 1;
end normhw;
