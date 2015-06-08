
module slice_mem_opt(
clk,
data,
reset_n,
dvi,
download,
svcoeff,
msb,
regout,

newblock

);

parameter DWIDTH = 8;
parameter CWIDTH = 9;
parameter BLOCKSIZE = 32;
parameter WINCOLS = 8;
parameter WPI  = 40;

input clk;
input [DWIDTH-1:0] data;
input reset_n;

input dvi;
input download;

input signed [CWIDTH-1:0] svcoeff;

input newblock;

output msb;
output signed [31:0] regout;

/* Registers definition */
reg newwin_d, newwin_d2;
reg signed [31:0] mem_out;
reg signed [31:0] mult_out;
reg signed [31:0] tmp;
reg [$clog2(WINCOLS)-1:0] blockcount;
reg [31:0] adder;

/* Wire definition */
wire signed [31:0] fifo_out;
wire [31:0] shiftin;
wire clken;
wire newwin;

/* mult_out */
always@(posedge clk or negedge reset_n)
	begin
		if (reset_n == 0)
			mult_out <= 0;
		else if(download)
			mult_out <= 0;	
		else if (dvi) 
			mult_out <= svcoeff * $signed({1'b0,data});		
		else
			mult_out <= mult_out;	
	end

/* newwin signal delay */
always@(posedge clk or negedge reset_n)
	if (reset_n == 0)
		newwin_d <= 0;
	else if (dvi | download)
		newwin_d <= newwin;
		
always@(posedge clk or negedge reset_n)
	if (reset_n == 0)
		newwin_d2 <= 0;
	else if (dvi | download)
		newwin_d2 <= newwin_d;

/* tmp register (fast accumulator) */
always@(posedge clk or negedge reset_n)
	begin
		if (reset_n == 0)
			tmp <= 0;
		else if (download)
			tmp <= 0;
		else if (dvi)
			tmp <= adder;	
	end

/* Adder */
wire [31:0] muxout;
always@(*)
	adder = mult_out + muxout;

assign muxout = (newwin_d2) ? fifo_out : tmp;
	
/* blockcount local register */
/* TODO: it works only with power-2 blocksize */	
always@(posedge clk or negedge reset_n)
	if (reset_n == 0)
		blockcount <= 0;
	else if (dvi & newblock)	
		blockcount <= blockcount + 1;		

assign newwin  = (newblock && (blockcount == WINCOLS-1)) ? 1'b1 : 1'b0;
		

/* Shifter input signals */	
assign shiftin = (newwin_d) ? adder : tmp;	
assign clken = (newwin_d & dvi) || download;
	
	altshift_taps	
	#(	.intended_device_family("Cyclone IV E"),
		//.lpm_hint("RAM_BLOCK_TYPE=M9K"),
		.lpm_type("altshift_taps"),
		.number_of_taps(1),
		.tap_distance(WPI),
		.width(32)
	)
	altshift_taps_inst (
				.clock (clk),
				.clken (clken),
				.shiftin (shiftin),
				.shiftout (fifo_out),
				.taps ()
				// synopsys translate_off
				,
				.aclr (~reset_n)
				// synopsys translate_on
				);


/* dummy output (to be removed) */
assign regout = fifo_out;		
assign msb = fifo_out > 0? 1: 0;
	
endmodule

