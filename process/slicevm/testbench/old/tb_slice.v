
`timescale 1ns/100ps
module tb_slice();

reg clk;
reg reset_n;
reg dvi;
reg [7:0] data;
reg signed [8:0] svcoeff;
wire done0,done1,done2,done3,done4,done5,done6,done7;
wire dvo0,dvo1,dvo2,dvo3,dvo4,dvo5,dvo6,dvo7;
wire download;

wire [1:0] state;

reg [31:0] dvcount;
reg [4:0] rowcount;
reg [31:0] win_wr, win_rd;
/* Self-check */
reg signed [31:0] acc_test [127:0];

wire [31:0] regout0;

integer i;

parameter BLOCKSIZE = 32;
parameter WPI  = 32;
parameter WINROWS = 16;

initial begin
	$dumpfile("tb_slice.vcd");
	$dumpvars;
	
	$display("tb_slice: slice testbench started!");
	$display ("tb_slice: BLOCKSIZE \t%d", BLOCKSIZE);
	$display ("tb_slice: WPI \t%d", WPI);
	$display ("tb_slice: WINROWS \t%d", WINROWS);
	
	clk = 0;
	dvi = 0;
	data = 0;
	svcoeff = 0;
	reset_n = 1;
	data = 7;
	win_wr = 0;
	win_rd = 0;

	#1 reset_n = 1'd0;
	#2 reset_n = 1'd1;
	//~ #3 dvi = 1;
	
	for(i=0;i<128;i=i+1)
		acc_test[i] = 0;
	
end

always #1 clk = ~clk;

always@(posedge clk)
	if (reset_n == 0)
		dvi <= 0;
	else
		dvi <= ((state == 0)? 1 : 0);
	
		
always@ (posedge clk)
	svcoeff <= $random;
	
always@ (posedge clk)
	data <= $random;
	
always@(posedge clk or negedge reset_n)	
	if (reset_n == 0)
		rowcount <= 0;
	else
		if (download || dvo0)
			rowcount <= 0;
		else if (done0)
			rowcount <= rowcount + 1;
			

assign download = (rowcount == (WINROWS-1) && done0) ? 1 : 0;

wire wininc;

always@(posedge clk or negedge reset_n)
	if (reset_n == 0)
		dvcount <= 0;
	else if (wininc || download)	
		dvcount <= 0;
	else if (dvi)
		dvcount <= dvcount + 1;		

assign wininc = (dvcount == (BLOCKSIZE-1)) ? 1 : 0;


assign dvi0 = dvi;

slice #(	
	.BLOCKSIZE(BLOCKSIZE),
	.WPI(WPI))
slice_inst0(
.clk(clk),
.data(data),
.reset_n(reset_n),
.dvi(dvi0),
.download(download),
.svcoeff(svcoeff),
.state(state),
.currwin(),
.clr_mem(clr_mem),
.msb(msb),
.regout(regout0),
.done(done0),
.dvo(dvo0)
);



/* Self-check */

always@(posedge clk)
	if (dvi)
		if (win_wr == (WPI-1) && wininc)
			win_wr <= 0;
		else if (wininc)
			win_wr <= win_wr + 1;
			
always@(posedge clk)
	if (dvo0)
		if (win_rd == (WPI-1))
			win_rd <= 0;
		else
			win_rd <= win_rd + 1;

	
always@(posedge clk or negedge reset_n)
	if (clr_mem)
		for(i=0;i<(WPI);i=i+1)
			acc_test[i] <= 0;
	else	
		if (dvi0 && state == 0)
			acc_test[win_wr] <= acc_test[win_wr] + $signed({1'b0,data})*svcoeff;
		
always@(posedge clk)
		if (dvo0)
			if (acc_test[win_rd] != regout0)
				$display("Computing error! Win #%d %d %d", win_rd, acc_test[win_rd], regout0);


/* These acc# below are redundant, just to see the waveforms on GTKwave */

//~ reg signed [31:0] acc0;				
//~ always@(posedge clk or negedge reset_n)
	//~ if (reset_n == 0)
		//~ acc0 <= 0;
	//~ else if (clr_mem)
		//~ acc0 <= 0;
	//~ else	
		//~ if (dvi0 && (state == 0)  && win_wr == 0)
				//~ acc0 <= acc0 + $signed({1'b0,data})*svcoeff;
//~ 
//~ reg signed [31:0] acc1;				
//~ always@(posedge clk or negedge reset_n)
	//~ if (reset_n == 0)
		//~ acc1 <= 0;
	//~ else if (clr_mem)
		//~ acc1 <= 0;
	//~ else	
		//~ if (dvi0 && state == 0 && win_wr == 1)
				//~ acc1 <= acc1 + $signed({1'b0,data})*svcoeff;
				//~ 
//~ reg signed [31:0] acc38;				
//~ always@(posedge clk or negedge reset_n)
	//~ if (reset_n == 0)
		//~ acc38 <= 0;
	//~ else if (clr_mem)
		//~ acc38 <= 0;
	//~ else	
		//~ if (dvi0 && state == 0 && win_wr == 38)
				//~ acc38 <= acc38 + $signed({1'b0,data})*svcoeff;						
				//~ 
//~ reg signed [31:0] acc39;				
//~ always@(posedge clk or negedge reset_n)
	//~ if (reset_n == 0)
		//~ acc39 <= 0;
	//~ else if (clr_mem)
		//~ acc39 <= 0;
	//~ else	
		//~ if (dvi0 && state == 0 && win_wr == 39)
				//~ acc39 <= acc39 + $signed({1'b0,data})*svcoeff;							
					

endmodule
