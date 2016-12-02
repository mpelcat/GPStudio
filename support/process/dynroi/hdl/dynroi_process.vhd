library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
library std;

entity dynroi_process is
	generic (
		CLK_PROC_FREQ : integer;
		IN_SIZE       : integer;
		IN_X_SIZE     : integer;
		IN_Y_SIZE     : integer;
		IN_W_SIZE     : integer;
		IN_H_SIZE     : integer;
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

		------------------------ in_x flow ----------------------
		in_x_data                : in std_logic_vector(IN_X_SIZE-1 downto 0);
		in_x_fv                  : in std_logic;
		in_x_dv                  : in std_logic;

		------------------------ in_y flow ----------------------
		in_y_data                : in std_logic_vector(IN_Y_SIZE-1 downto 0);
		in_y_fv                  : in std_logic;
		in_y_dv                  : in std_logic;

		------------------------ in_w flow ----------------------
		in_w_data                : in std_logic_vector(IN_W_SIZE-1 downto 0);
		in_w_fv                  : in std_logic;
		in_w_dv                  : in std_logic;

		------------------------ in_h flow ----------------------
		in_h_data                : in std_logic_vector(IN_H_SIZE-1 downto 0);
		in_h_fv                  : in std_logic;
		in_h_dv                  : in std_logic;

		------------------------ out flow -----------------------
		out_data                 : out std_logic_vector(OUT_SIZE-1 downto 0);
		out_fv                   : out std_logic;
		out_dv                   : out std_logic
	);
end dynroi_process;


architecture rtl of dynroi_process is

constant X_COUNTER_SIZE : integer := 12;
constant Y_COUNTER_SIZE : integer := 12;

signal x_pos    : unsigned(X_COUNTER_SIZE-1 downto 0);
signal y_pos    : unsigned(Y_COUNTER_SIZE-1 downto 0);

-- bypass overloads in values and uses GUI values
signal bypass_enabled : std_logic;
-- If block_enabled is false, this IP acts as a wire
signal block_enabled  : std_logic;
-- The current command for the extraction of the ROI
signal local_x std_logic_vector(IN_X_SIZE-1 downto 0);
signal local_y std_logic_vector(IN_Y_SIZE-1 downto 0);
signal local_w std_logic_vector(IN_W_SIZE-1 downto 0);
signal local_h std_logic_vector(IN_H_SIZE-1 downto 0);

begin
    data_process : process (clk_proc, reset_n)
    begin
        if(reset_n='0') then
            out_data 	   <= (others => '0');
            out_dv   	   <= '0';
            out_fv   	   <= '0';
            x_pos 	 	   <= to_unsigned(0, X_COUNTER_SIZE);
            y_pos    	   <= to_unsigned(0, Y_COUNTER_SIZE);
            bypass_enabled <= '0';
            block_enabled  <= '1';
        elsif(rising_edge(clk_proc)) then
			-- Updating command parameters between 2 images
			if(in_fv = '0') then
				x_pos    		<= to_unsigned(0, X_COUNTER_SIZE);
                y_pos    		<= to_unsigned(0, Y_COUNTER_SIZE);
                bypass_enabled 	<= status_reg_bypass_bit;
                enabled  		<= status_reg_enable_bit;
                
                if(bypass_enabled = '1') then
					-- Take GUI parameters
					local_x <= out_offset_reg_out_x_reg;
					local_y <= out_offset_reg_out_y_reg;
					local_w <= out_offset_reg_out_w_reg;
					local_h <= out_offset_reg_out_h_reg;
				else --Take input parameters	
					if(in_x_fv = '1' and in_x_dv = '1') then
						local_x <= in_x_data;
					end if;
					if(in_y_fv = '1' and in_y_dv = '1') then
						local_y <= in_y_data;
					end if;
					if(in_w_fv = '1' and in_w_dv = '1') then
						local_w <= in_w_data;
					end if;
					if(in_h_fv = '1' and in_h_dv = '1') then
						local_h <= in_h_data;
					end if;
				end if;
				
				
				-- WIP control new command values
				--
			else
			--WIP
				if(enabled = '1') then
					if(in_dv = '1') then
							-- Following current line
							x_pos <= x_pos + 1;
							
							-- End of line
							if(x_pos=unsigned(in_size_reg_in_w_reg)-1) then
								y_pos <= y_pos + 1;
								x_pos <= to_unsigned(0, X_COUNTER_SIZE);
							end if;
					end if;
				end if;
			end if;
        
			-- OLD
            if(in_fv = '1'
             and enabled = '1'
             and (unsigned(out_offset_reg_out_x_reg) < unsigned(in_size_reg_in_w_reg))
             and (unsigned(out_offset_reg_out_y_reg) < unsigned(in_size_reg_in_h_reg))) then
                out_fv <= '1';
            else
                out_fv <= '0';
            end if;
            
            out_dv <= '0';

            if(in_fv = '0') then
                x_pos    <= to_unsigned(0, X_COUNTER_SIZE);
                y_pos    <= to_unsigned(0, Y_COUNTER_SIZE);
                bypass_enabled <= status_reg_bypass_bit;
                enabled  <= status_reg_enable_bit;
            else
                if(in_dv = '1' and enabled = '1') then
                    -- Following current line
                    x_pos <= x_pos + 1;
                    
                    -- End of line
                    if(x_pos=unsigned(in_size_reg_in_w_reg)-1) then
                        y_pos <= y_pos + 1;
                        x_pos <= to_unsigned(0, X_COUNTER_SIZE);
                    end if;
                    -- If bypass_s is false we are using in_ params x,y,w,h
                    if(bypass_enabled = '0') then
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
