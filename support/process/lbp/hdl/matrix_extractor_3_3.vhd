library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use IEEE.math_real.all;
library std;
library altera_mf;
use altera_mf.altera_mf_components.all;

entity matrix_extractor_3_3 is
	generic (
		LINE_WIDTH_MAX : integer;
		PIX_WIDTH : integer;
		OUTVALUE_WIDTH : integer
	);
	port (
		clk_proc : in std_logic;
		reset_n : in std_logic;

		------------------------- in flow -----------------------
		in_data : in std_logic_vector((PIX_WIDTH-1) downto 0);
		in_fv : in std_logic;
		in_dv : in std_logic;

		------------------------ out flow -----------------------
		out_data : out std_logic_vector((PIX_WIDTH-1) downto 0);
		out_fv : out std_logic;
		out_dv : out std_logic;
		
		------------------------ matrix out ---------------------
		p00, p01, p02 : out std_logic_vector((PIX_WIDTH-1) downto 0);
		p10, p11, p12 : out std_logic_vector((PIX_WIDTH-1) downto 0);
		p20, p21, p22 : out std_logic_vector((PIX_WIDTH-1) downto 0);
		matrix_dv : out std_logic;
		
		---------------------- computed value -------------------
		value_data : in std_logic_vector((OUTVALUE_WIDTH-1) downto 0);
		value_dv : in std_logic;

		------------------------- params ------------------------
		enable_i : in std_logic;
		widthimg_i : in std_logic_vector(15 downto 0)
	);
end matrix_extractor_3_3;

architecture rtl of matrix_extractor_3_3 is

constant FIFO_LENGHT : integer := LINE_WIDTH_MAX;
constant FIFO_LENGHT_WIDTH : integer := integer(ceil(log2(real(FIFO_LENGHT))));

component scfifo
   generic
   (
		LPM_WIDTH: POSITIVE;
		LPM_WIDTHU: POSITIVE;
		LPM_NUMWORDS: POSITIVE;
		LPM_SHOWAHEAD: STRING := "OFF";
		ALLOW_RWCYCLE_WHEN_FULL: STRING := "OFF";
		MAXIMIZE_SPEED: POSITIVE:= 5;
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

signal enable_reg :		std_logic;

signal x_pos : unsigned(15 downto 0);
signal y_pos : unsigned(15 downto 0);

signal p00_s, p01_s, p02_s : std_logic_vector((PIX_WIDTH-1) downto 0);
signal p10_s, p11_s, p12_s : std_logic_vector((PIX_WIDTH-1) downto 0);
signal p20_s, p21_s, p22_s : std_logic_vector((PIX_WIDTH-1) downto 0);

signal line0_read : std_logic;
signal line0_write : std_logic;
signal line0_empty : std_logic;
signal line0_pix_out : std_logic_vector((PIX_WIDTH-1) downto 0);

signal line1_read : std_logic;
signal line1_write : std_logic;
signal line1_empty : std_logic;
signal line1_pix_out : std_logic_vector((PIX_WIDTH-1) downto 0);

signal linedv_read : std_logic;
signal linedv_write : std_logic;
signal linedv_empty : std_logic;

signal dummy_dv : std_logic;
signal out_dv_s : std_logic;
signal cell : std_logic_vector((LINE_WIDTH_MAX-1) downto 0);

signal matrix_dv_s : std_logic;

begin

	line0_fifo : scfifo
    generic map (
    	LPM_WIDTH	=>	PIX_WIDTH,
    	LPM_WIDTHU	=> FIFO_LENGHT_WIDTH,
    	LPM_NUMWORDS => FIFO_LENGHT
	)
    port map (
		data => p20_s,
		clock => clk_proc,
		wrreq => line0_write,
		q => p12_s,
		rdreq => line0_read,
		aclr => not(reset_n),
		empty => line0_empty
    );

	line1_fifo : scfifo
    generic map (
    	LPM_WIDTH	=>	PIX_WIDTH,
    	LPM_WIDTHU	=> FIFO_LENGHT_WIDTH,
    	LPM_NUMWORDS => FIFO_LENGHT
	)
    port map (
		data => p10_s,
		clock => clk_proc,
		wrreq => line1_write,
		q => p02_s,
		rdreq => line1_read,
		aclr => not(reset_n),
		empty => line1_empty
    );

    process (clk_proc, reset_n)
	begin
		if(reset_n='0') then
			x_pos <= to_unsigned(0, 16);
			y_pos <= to_unsigned(0, 16);
			line0_read <= '0';
			line0_write <= '0';
			line1_read <= '0';
			line0_write <= '0';
			
		elsif(rising_edge(clk_proc)) then
			matrix_dv <= matrix_dv_s;
			dummy_dv <= matrix_dv_s;
			matrix_dv_s <= '0';
			if(in_fv='0') then
				x_pos <= to_unsigned(0, 16);
				y_pos <= to_unsigned(0, 16);
				line0_read <= '0';
				line0_write <= '0';
				line1_read <= '0';
				line0_write <= '0';

			else
				if (line0_read='1') then
					p11_s <= p12_s;
					p10_s <= p11_s;
				end if;
				if (line1_read='1') then
					p01_s <= p02_s;
					p00_s <= p01_s;
				end if;
				
				if (in_dv='1') then
					x_pos <= x_pos+1;
					
					p22_s <= in_data;
					p21_s <= p22_s;
					p20_s <= p21_s;
					
					if(x_pos<=to_unsigned(1, 16)) then
						line0_write <= '0';
						line1_write <= '0';
					elsif(x_pos=unsigned(widthimg_i)-1) then
						line0_write <= '0';
						line1_write <= '0';
						y_pos <= y_pos+1;
						x_pos <= to_unsigned(0, 16);
					else
						line0_write <= '1';
						if(y_pos>to_unsigned(1, 16)) then
							line1_write <= '1';
							matrix_dv_s <= '1';
						else
							line1_write <= '0';
						end if;
					end if;
					
					if(y_pos=to_unsigned(0, 16)) then
						line0_read <= '0';
						line1_read <= '0';
					elsif(y_pos>to_unsigned(1, 16)) then
						line0_read <= '1';
						line1_read <= '1';
					else
						line1_read <= '0';
						line0_read <= '1';
					end if;
				else
					line0_read <= '0';
					line0_write <= '0';
					line1_read <= '0';
					line0_write <= '0';
				end if;
			end if;
		end if;
	end process;

	p00 <= p00_s; p01 <= p01_s; p02 <= p02_s;
	p10 <= p10_s; p11 <= p11_s; p12 <= p12_s;
	p20 <= p20_s; p21 <= p21_s; p22 <= p22_s;

	out_data <= value_data;
	out_dv   <= value_dv;
	out_fv   <= in_fv;
end rtl;
