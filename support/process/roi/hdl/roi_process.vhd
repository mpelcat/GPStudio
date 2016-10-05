library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
library std;

entity roi_process is
    generic (
        CLK_PROC_FREQ : integer;
        IN_SIZE       : integer;
        OUT_SIZE      : integer
    );
    port (
        clk_proc                 : in std_logic;
        reset_n                  : in std_logic;

        ---------------- dynamic parameters ports ---------------
        status_reg_enable_bit    : in std_logic;
        status_reg_bypass_bit    : in std_logic;
        in_size_reg_in_w_reg     : in std_logic_vector(11 downto 0);
        in_size_reg_in_h_reg     : in std_logic_vector(11 downto 0);
        out_size_reg_out_w_reg   : in std_logic_vector(11 downto 0);
        out_size_reg_out_h_reg   : in std_logic_vector(11 downto 0);
        out_offset_reg_out_x_reg : in std_logic_vector(11 downto 0);
        out_offset_reg_out_y_reg : in std_logic_vector(11 downto 0);

        ------------------------- in flow -----------------------
        in_data                  : in std_logic_vector(IN_SIZE-1 downto 0);
        in_fv                    : in std_logic;
        in_dv                    : in std_logic;

        ------------------------ out flow -----------------------
        out_data                 : out std_logic_vector(OUT_SIZE-1 downto 0);
        out_fv                   : out std_logic;
        out_dv                   : out std_logic
    );
end roi_process;

architecture rtl of roi_process is

constant X_COUNTER_SIZE : integer := 12;
constant Y_COUNTER_SIZE : integer := 12;

signal x_pos    : unsigned(X_COUNTER_SIZE-1 downto 0);
signal y_pos    : unsigned(Y_COUNTER_SIZE-1 downto 0);
signal bypass_s : std_logic;

begin
    data_process : process (clk_proc, reset_n)
    begin
        if(reset_n='0') then
            out_data <= (others => '0');
            out_dv <= '0';
            out_fv <= '0';
            
            x_pos <= to_unsigned(0, X_COUNTER_SIZE);
            y_pos <= to_unsigned(0, Y_COUNTER_SIZE);
            bypass_s <= '0';
        elsif(rising_edge(clk_proc)) then
            if(in_fv = '1'
             and status_reg_enable_bit = '1'
             and (unsigned(out_offset_reg_out_x_reg) < unsigned(in_size_reg_in_w_reg))
             and (unsigned(out_offset_reg_out_y_reg) < unsigned(in_size_reg_in_h_reg))) then
                out_fv <= '1';
            else
                out_fv <= '0';
            end if;
            out_dv <= '0';

            if(in_fv = '0') then
                x_pos <= to_unsigned(0, X_COUNTER_SIZE);
                y_pos <= to_unsigned(0, Y_COUNTER_SIZE);
                
                bypass_s <= status_reg_bypass_bit;
            else
                if(in_dv = '1' and status_reg_enable_bit = '1') then
                    x_pos <= x_pos + 1;
                    
                    if(x_pos=unsigned(in_size_reg_in_w_reg)-1) then
                        y_pos <= y_pos + 1;
                        x_pos <= to_unsigned(0, X_COUNTER_SIZE);
                    end if;
                    
                    if(bypass_s = '0') then
                        if(y_pos >= unsigned(out_offset_reg_out_y_reg)
                        and y_pos < (unsigned(out_offset_reg_out_y_reg) + unsigned(out_size_reg_out_h_reg))
                        and x_pos >= unsigned(out_offset_reg_out_x_reg)
                        and x_pos < (unsigned(out_offset_reg_out_x_reg) + unsigned(out_size_reg_out_w_reg))) then
                            out_dv <= '1';
                            out_data <= in_data;
                        end if;
                    else
                        out_dv <= '1';
                        out_data <= in_data;
                    end if;
                end if;
            end if;
        end if;
    end process;
end rtl;
