library IEEE;
    use IEEE.STD_LOGIC_1164.all;
    use IEEE.NUMERIC_STD.all;
use ieee.math_real.all;

library ALTERA_MF;
    use ALTERA_MF.all;

entity gp_fifo is
    generic (
        DATA_WIDTH      : positive;
        FIFO_DEPTH      : positive
    );
    port (
        clk             : in std_logic;
        reset_n         : in std_logic;

        -- writer
        data_wr         : in std_logic;
        data_in         : in std_logic_vector(DATA_WIDTH-1 downto 0);
        full            : out std_logic;

        -- reader
        data_rd         : in std_logic;
        data_out        : out std_logic_vector(DATA_WIDTH-1 downto 0);
        empty           : out std_logic
    );
end gp_fifo;

architecture rtl of gp_fifo is
-- signals
    signal reset_s : std_logic;
    
-- components
    component scfifo
    generic (
        ADD_RAM_OUTPUT_REGISTER : string;
        INTENDED_DEVICE_FAMILY  : string;
        LPM_NUMWORDS            : natural;
        LPM_SHOWAHEAD           : string;
        LPM_TYPE                : string;
        LPM_WIDTH               : natural;
        LPM_WIDTHU              : natural;
        OVERFLOW_CHECKING       : string;
        UNDERFLOW_CHECKING      : string;
        USE_EAB                 : string
    );
    port (
        clock       : in std_logic;
        aclr        : in std_logic;
        data        : in std_logic_vector (LPM_WIDTH-1 downto 0);
        wrreq       : in std_logic;
        full        : out std_logic;
        rdreq       : in std_logic;
        empty       : out std_logic;
        q           : out std_logic_vector (LPM_WIDTH-1 downto 0)
    );
    end component;

-- instantiation
    begin
    scfifo_component : scfifo
        generic map (
            ADD_RAM_OUTPUT_REGISTER => "OFF",
            INTENDED_DEVICE_FAMILY  => "Cyclone III",
            LPM_NUMWORDS            => FIFO_DEPTH,
            LPM_SHOWAHEAD           => "OFF",
            LPM_TYPE                => "scfifo",
            LPM_WIDTH               => DATA_WIDTH,
            LPM_WIDTHU              => integer(ceil(log2(real(FIFO_DEPTH)))),
            OVERFLOW_CHECKING       => "ON",
            UNDERFLOW_CHECKING      => "ON",
            USE_EAB                 => "ON"
        )
        port map (
            clock       => clk,
            aclr        => reset_s,
            data        => data_in,
            wrreq       => data_wr,
            full        => full,
            rdreq       => data_rd,
            empty       => empty,
            q           => data_out
        );
end rtl;
