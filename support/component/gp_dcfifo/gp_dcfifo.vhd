LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.math_real.all;
LIBRARY altera_mf;
USE altera_mf.all;

ENTITY gp_dcfifo IS
    GENERIC(FIFO_DEPTH  : positive;
            DATA_WIDTH  : positive);
	PORT
	(
		aclr		: IN STD_LOGIC;
        
        --- writer
		data		: IN STD_LOGIC_VECTOR (DATA_WIDTH-1 DOWNTO 0);
        wrclk		: IN STD_LOGIC ;
		wrreq		: IN STD_LOGIC ;
        wrfull		: OUT STD_LOGIC;
        
        --- reader
		rdclk		: IN STD_LOGIC ;
		rdreq		: IN STD_LOGIC ;
		q		    : OUT STD_LOGIC_VECTOR (DATA_WIDTH-1 DOWNTO 0);
		rdempty		: OUT STD_LOGIC
	);
END gp_dcfifo;


ARCHITECTURE SYN OF gp_dcfifo IS

	SIGNAL sub_wire0	: STD_LOGIC ;
	SIGNAL sub_wire1	: STD_LOGIC_VECTOR (DATA_WIDTH-1 DOWNTO 0);
	SIGNAL sub_wire2	: STD_LOGIC ;

	COMPONENT dcfifo
	GENERIC (
		intended_device_family		: STRING;
		lpm_numwords		        : NATURAL;
		lpm_showahead		        : STRING;
		lpm_type		            : STRING;
		lpm_width		            : NATURAL;
		lpm_widthu		            : NATURAL;
		overflow_checking		    : STRING;
		rdsync_delaypipe		    : NATURAL;
		read_aclr_synch		        : STRING;
		underflow_checking		    : STRING;
		use_eab		                : STRING;
		write_aclr_synch		    : STRING;
		wrsync_delaypipe		    : NATURAL
	);
	PORT (
			rdclk	: IN STD_LOGIC ;
			wrfull	: OUT STD_LOGIC ;
			q	    : OUT STD_LOGIC_VECTOR (DATA_WIDTH-1 DOWNTO 0);
			rdempty	: OUT STD_LOGIC ;
			wrclk	: IN STD_LOGIC ;
			wrreq	: IN STD_LOGIC ;
			aclr	: IN STD_LOGIC ;
			data	: IN STD_LOGIC_VECTOR (DATA_WIDTH-1 DOWNTO 0);
			rdreq	: IN STD_LOGIC 
	);
	END COMPONENT;

BEGIN
	wrfull          <= sub_wire0;
	q               <= sub_wire1(DATA_WIDTH-1 DOWNTO 0);
	rdempty         <= sub_wire2;

	dcfifo_component : dcfifo
	GENERIC MAP (
		intended_device_family  => "Cyclone III",
		lpm_numwords            => FIFO_DEPTH,
		lpm_showahead           => "OFF",
		lpm_type                => "dcfifo",
		lpm_width               => DATA_WIDTH,
		lpm_widthu              => integer(ceil(log2(real(FIFO_DEPTH)))),
		overflow_checking       => "ON",
		rdsync_delaypipe        => 4,
		read_aclr_synch         => "OFF",
		underflow_checking      => "ON",
		use_eab                 => "ON",
		write_aclr_synch        => "OFF",
		wrsync_delaypipe        => 4
	)
	PORT MAP (
		rdclk   => rdclk,
		wrclk   => wrclk,
		wrreq   => wrreq,
		aclr    => aclr,
		data    => data,
		rdreq   => rdreq,
		wrfull  => sub_wire0,
		q       => sub_wire1,
		rdempty => sub_wire2
	);



END SYN;