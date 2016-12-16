library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
library std;

entity dynroi_process is
	generic (
		CLK_PROC_FREQ : integer;
		IN_SIZE       : integer;
		COORD_SIZE    : integer;
		OUT_SIZE      : integer
	);
	port (
		clk_proc                 : in std_logic;
		reset_n                  : in std_logic;

		---------------- dynamic parameters ports ---------------
		-- enable IP output
		status_reg_enable_bit    : in std_logic;
		-- ignore commands and act as a wire
		status_reg_bypass_bit    : in std_logic;
		-- overload coord values with GUI commands
		status_reg_overload_bit  : in std_logic;
		-- image res
		in_size_reg_in_w_reg     : in std_logic_vector(11 downto 0);
		in_size_reg_in_h_reg     : in std_logic_vector(11 downto 0);
		-- overload commands
		out_size_reg_out_w_reg   : in std_logic_vector(11 downto 0);
		out_size_reg_out_h_reg   : in std_logic_vector(11 downto 0);
		out_offset_reg_out_x_reg : in std_logic_vector(11 downto 0);
		out_offset_reg_out_y_reg : in std_logic_vector(11 downto 0);

		------------------------- in flow -----------------------
		in_data                  : in std_logic_vector(IN_SIZE-1 downto 0);
		in_fv                    : in std_logic;
		in_dv                    : in std_logic;

		----------------------- coord flow ----------------------
		-- y,x,y,w coordinates to apply for ROI
		coord_data               : in std_logic_vector(COORD_SIZE-1 downto 0);
		coord_fv                 : in std_logic;
		coord_dv                 : in std_logic;

		------------------------ out flow -----------------------
		-- output video flow
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

-- If block_enabled is false, this IP has no output
signal block_enabled  	: std_logic;
-- Serial buffer for w,h,x,y coming from frame flow
-- 16 bits per parameter: 64 bits 
-- NB: img res must be less or equal to 2^16
signal frame_buffer 		      : std_logic_vector(63 downto 0);
signal frame_buffer_position      : integer range 63 to 0;
signal frame_buffer_is_filled  	  : std_logic;
--signal frame_buffer_has_been_used : std_logic;
-- The current command for the extraction of the ROI
signal local_x 					  : unsigned(X_COUNTER_SIZE-1 downto 0);
signal local_y 					  : unsigned(Y_COUNTER_SIZE-1 downto 0);
signal local_w 					  : unsigned(X_COUNTER_SIZE-1 downto 0);
signal local_h 					  : unsigned(Y_COUNTER_SIZE-1 downto 0);

begin
	-- Serial manager process
	serial_reception : process (clk_proc, reset_n)
	begin
	if reset_n = '0' then
		--Cleaning frame_buffer
		frame_buffer 			   <= (others=>'0');
		frame_buffer_position      <=  0;
		frame_buffer_is_filled     <= '0';
		--frame_buffer_has_been_used <= '0';
	elsif rising_edge(clk_proc) then
		-- frame_buffer update
		if coord_fv = '1' and coord_dv = '1' then
				-- The refresh is refreshed as soon as a new set of param arrives
				frame_buffer_is_filled <= '0';
				-- order --
				--MSB [y2,y1, x2,x1, h2,h1, w2,w1]  LSB--
				frame_buffer(frame_buffer_position+7 downto frame_buffer_position) <= coord_data;
				-- Moving in buffer
				if frame_buffer_position < 56 then
					frame_buffer_position <= frame_buffer_position + 8;	
				else -- Buffer filled
					frame_buffer_position <= 0;
					frame_buffer_is_filled <= '1';
				end if;
		end if;
	end if;
	end process;
	
	-- Image ROI process
    roi_process : process (clk_proc, reset_n)
    begin
        if reset_n='0' then
            out_data 	   		<= (others => '0');
            out_dv   	   		<= '0';
            out_fv   	   		<= '0';
            x_pos 	 	   		<= to_unsigned(0, X_COUNTER_SIZE);
            y_pos    	   		<= to_unsigned(0, Y_COUNTER_SIZE);
            block_enabled 		<= '1';
        elsif rising_edge(clk_proc) then
			out_fv 	 <= in_fv;
			out_dv 	 <= '0';
			out_data <= (others=>'0');
			if in_fv = '0' then			
				-- Updating command parameters between 2 images
				x_pos    			<= to_unsigned(0, X_COUNTER_SIZE);
                y_pos    			<= to_unsigned(0, Y_COUNTER_SIZE);
                block_enabled		<= status_reg_enable_bit;
                
                if status_reg_overload_bit = '1' then
					-- Take GUI parameters
					local_x <= unsigned(out_offset_reg_out_x_reg);
					local_y <= unsigned(out_offset_reg_out_y_reg);
					local_w <= unsigned(out_size_reg_out_w_reg);
					local_h <= unsigned(out_size_reg_out_h_reg);
				else --Take input parameters	
				    --MSB [y2,y2, x2,x1, h2,h1, w2,w1]  LSB--
					if frame_buffer_is_filled = '1' and block_enabled = '1' then 
							local_x <= unsigned(frame_buffer(X_COUNTER_SIZE-1 downto 0));
							local_y <= unsigned(frame_buffer(Y_COUNTER_SIZE-1+16 downto 16));
							local_w <= unsigned(frame_buffer(X_COUNTER_SIZE-1+32 downto 32));
							local_h <= unsigned(frame_buffer(Y_COUNTER_SIZE-1+48 downto 48));
					else
						--The buffer has not a complete set of params, everything is blocked
							local_x <= to_unsigned(170,local_x'length);--(others=>'0');
							local_y <= to_unsigned(040,local_y'length);--(others=>'0');
							local_w <= to_unsigned(110,local_w'length);--(others=>'0');
							local_h <= to_unsigned(110,local_w'length);--(others=>'0');
					end if;
				end if;
				
				
				
				-- width value control
				if local_x+local_w > unsigned(in_size_reg_in_w_reg(X_COUNTER_SIZE-1 downto 0)) then
					if local_x > unsigned(in_size_reg_in_w_reg(X_COUNTER_SIZE-1 downto 0)) then
						local_w <= (others=>'0');
					else 
						local_w <= unsigned(in_size_reg_in_w_reg(X_COUNTER_SIZE-1 downto 0))-local_x;
					end if;
				end if;
				
				-- height value control
				if local_y+local_h > unsigned(in_size_reg_in_h_reg(Y_COUNTER_SIZE-1 downto 0)) then
					if local_y > unsigned(in_size_reg_in_h_reg(Y_COUNTER_SIZE-1 downto 0)) then
						local_h <= (others=>'0');
					else 
						local_h <= unsigned(in_size_reg_in_h_reg(Y_COUNTER_SIZE-1 downto 0))-local_y;
					end if;
				end if;
					
			else
							
				if block_enabled = '1' and status_reg_enable_bit = '1' then					
				
					if in_dv = '1' then
					
							-- Following current line
							x_pos <= x_pos + 1;
							-- End of line
							if x_pos=unsigned(in_size_reg_in_w_reg)-1 then
								y_pos <= y_pos + 1;
								x_pos <= to_unsigned(0, X_COUNTER_SIZE);
							end if;
							
							if status_reg_bypass_bit = '0' then
								if (y_pos >= local_y
								and y_pos < local_y + local_h
								and x_pos >= local_x
								and x_pos < local_x + local_w) then
									out_dv <= '1';
									out_data <= in_data;
								end if;
							else
								out_dv <= '1';
								out_data <= in_data;
							end if;		
					 end if;
					 
				else -- block_enabled = 0: the component is disabled
					block_enabled <= '0';
					out_fv <= '0';
				end if;
			end if;
        end if;  
    end process;
end rtl;
