library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
library std;

entity dynthreshold_process is
	generic (
		CLK_PROC_FREQ : integer;
		IN_SIZE       : integer;
		OUT_SIZE      : integer
	);
	port (
		clk_proc              : in std_logic;
		reset_n               : in std_logic;

		---------------- dynamic parameters ports ---------------
		status_reg_enable_bit : in std_logic;
		widthimg_reg_value    : in std_logic_vector(15 downto 0);
		heigtimg_reg_value    : in std_logic_vector(15 downto 0);
		desired_ratio_reg     : in std_logic_vector(31 downto 0);

		------------------------- in flow -----------------------
		in_data               : in std_logic_vector(IN_SIZE-1 downto 0);
		in_fv                 : in std_logic;
		in_dv                 : in std_logic;

		------------------------ out flow -----------------------
		out_data              : out std_logic_vector(OUT_SIZE-1 downto 0);
		out_fv                : out std_logic;
		out_dv                : out std_logic
	);
end dynthreshold_process;

architecture rtl of dynthreshold_process is

signal enabled : std_logic;
-- Desired ratio of white pixels in percent
signal current_desired_ratio : unsigned(31 downto 0);
-- 32 bits as max width*height is still under 32 bits (1280*960) 
--signal current_resolution    : unsigned(31 downto 0);
signal lower_border_threshold : unsigned(IN_SIZE-1 downto 0):=(others=>'0');
signal upper_border_threshold : unsigned(IN_SIZE-1 downto 0):=(others=>'1');


begin
	data_process : process (clk_proc, reset_n)

	variable white_px_counter   : integer; --unsigned(31 downto 0);	
	variable img_px_counter	    : integer; --unsigned(31 downto 0);

	variable current_ratio	    : unsigned(31 downto 0);
	variable old_ratio	        : unsigned(31 downto 0);

	variable current_threshold  : unsigned(IN_SIZE-1 downto 0);
	variable old_threshold      : unsigned(IN_SIZE-1 downto 0);

	begin
		if(reset_n='0') then
			enabled <= '0';
			out_data <= (others => '0');
			out_dv <= '0';
			out_fv <= '0';
			current_threshold := (others => '0');
		elsif(rising_edge(clk_proc)) then
			-- Waiting for an image flow
			if(in_fv = '0') then
				-- Update params here, between two images processing

				-- Updating threshold
				if(img_px_counter /= 0 and enabled = '1') then
					----current_ratio :=unsigned(integer(current_white_px*100/current_resolution),32); 
					-- WIP : multiply desired_ratio by img_px_counter instead of dividing
					current_ratio :=to_unsigned(white_px_counter*100/img_px_counter,32); 
					-- Updating threshold only if the new ratio is closer to desired ratio
					--if(abs(signed(current_desired_ratio)-signed(current_ratio)) < abs(signed(current_desired_ratio)-signed(old_ratio)))then
						if(current_ratio > current_desired_ratio) then
							-- Too many white pixels spotted, increasing threshold value
							--if(current_threshold < upper_border_threshold) then
							--	current_threshold := current_threshold + 2;
							--end if;
							current_threshold := current_threshold+(upper_border_threshold-current_threshold)/2;
						elsif current_ratio < current_desired_ratio   then
							-- Not enough white pixels, lowering threshold value
							--if(current_threshold > lower_border_threshold) then
							--	current_threshold := current_threshold - 2;					
							--end if;
							current_threshold := current_threshold/2;
						--else    -- Reached targeted ratio
						end if;
					--end if;
					
					old_ratio     := current_ratio;
					old_threshold := current_threshold;
				end if;

				-- Updating image resolution
				--current_resolution <= unsigned(widthimg_reg_value)*unsigned(heigtimg_reg_value);
				-- Updating commanded ratio
				current_desired_ratio <= unsigned(desired_ratio_reg);
				-- Reset pixel counter
				img_px_counter := 0;
				white_px_counter := 0;

				enabled <= status_reg_enable_bit;
            		end if;

			if(enabled = '1') then
				if(in_dv='1' and in_fv='1') then
					-- Binarisation process
					if(unsigned(in_data) < current_threshold) then
						out_data <= (others => '0');
					else
						out_data <= (others => '1');
						white_px_counter := white_px_counter + 1;
					end if;
					img_px_counter := img_px_counter + 1;
				end if;		
			else
				out_data <= in_data;
			end if;

			out_dv <= in_dv;
			out_fv <= in_fv;
		end if;
	end process;
end rtl;
