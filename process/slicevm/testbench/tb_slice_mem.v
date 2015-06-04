
`timescale 1ns/100ps
module tb_slice_mem();

parameter BLOCKSIZE = 8;
parameter WPI  = 32;
parameter WINROWS = 16;

reg clk;
reg reset_n;
reg dvi;
reg [7:0] data;
reg signed [8:0] svcoeff;
wire download;
wire done;

reg [$clog2(BLOCKSIZE)-1:0] dvcount;
reg [$clog2(WINROWS)-1:0] rowcount;
reg [31:0] win_wr, win_rd;

reg [2:0] state, state_new;

/* Self-check */
reg signed [31:0] acc_test [WPI-1:0];

wire [31:0] regout0;
wire dvo0;

parameter OP 		= 3'b000;
parameter WAIT1 	= 3'b001;
parameter WAIT2 	= 3'b011;
parameter DOWNLOAD 	= 3'b100;
parameter CLR 		= 3'b101;

integer i;
wire newwin;
wire newrow;

reg [$clog2(WPI)-1:0] wincount;



initial begin
	$dumpfile("/tmp/tb_slice_mem.vcd");
	$dumpvars;
	
	$display("tb_slice_mem: slice testbench started!");
	$display ("tb_slice_mem: BLOCKSIZE \t%d", BLOCKSIZE);
	$display ("tb_slice_mem: WPI \t%d", WPI);
	$display ("tb_slice_mem: WINROWS \t%d", WINROWS);
	
	clk = 0;
	dvi = 0;
	data = 0;
	win_wr = 0;
	win_rd = 0;
	svcoeff = 0;
	reset_n = 1;
	data = 7;

	#1 reset_n = 1'd0;
	#2 reset_n = 1'd1;
	#3 dvi = 1;
	
	for(i=0;i<WPI;i=i+1)
		acc_test[i] = 0;
	
end

always #1 clk = ~clk;

always@(posedge clk)
	if (reset_n == 0)
		dvi <= 0;
	else 
		dvi <= (state == OP) ? $random : 0;
		
always@ (posedge clk)
	if (dvi)
		svcoeff <= $random;
	
always@ (posedge clk)
	if (dvi)
		data <= $random;
	
always@(posedge clk or negedge reset_n)	
	if (reset_n == 0)
		rowcount <= 0;
	else if (done)
			rowcount <= 0;
	else if (newrow & dvi)
		rowcount <= rowcount + 1;

always@(posedge clk or negedge reset_n)
	if (reset_n == 0)
		wincount <= 0;
	else if ((newrow & dvi) || done || state == CLR)	
		wincount <= 0;
	else if ((newwin & dvi) || download)
		wincount <= wincount + 1;	

always@(posedge clk or negedge reset_n)
	if (reset_n == 0)
		dvcount <= 0;
	else if ((newwin & dvi) || done)	
		dvcount <= 0;
	else if (dvi)
		dvcount <= dvcount + 1;		

assign newwin = ((dvcount == (BLOCKSIZE-1)) || (state == DOWNLOAD)) ? 1 : 0;
assign newrow = (wincount == (WPI-1) && dvcount == (BLOCKSIZE-1))? 1 : 0;
assign done = (rowcount == (WINROWS-1) && wincount == (WPI-1) && dvcount == (BLOCKSIZE-1))  ? 1 : 0;
assign download = (state == DOWNLOAD);

always@(posedge clk or negedge reset_n)
	if (reset_n == 0)
		state <= 0;
	else 
		state <= state_new;
		
always@(*)
	case (state)
		OP:
			if(done)
				state_new = WAIT1;
			else
				state_new = OP;
		WAIT1:
			state_new = WAIT2;
		WAIT2:	
			state_new = DOWNLOAD;	
		DOWNLOAD:
			if(wincount == WPI-1)
				state_new = CLR;
			else
				state_new = DOWNLOAD;
		CLR:
			state_new = OP;
	default:
		state_new = OP;
	endcase


assign dvi0 = (state == OP) ? dvi : 0;

reg downloadstall;
always@(posedge clk or negedge reset_n)
	if (reset_n == 0)
		downloadstall <= 0;
	else
		downloadstall <= (state == DOWNLOAD);

assign dvo0 = downloadstall;

slice_mem #(	
	.BLOCKSIZE(BLOCKSIZE),
	.WPI(WPI))
slice_inst0(
.clk(clk),
.data(data),
.reset_n(reset_n),
.dvi(dvi0),
.download(download),
.svcoeff(svcoeff),
.msb(msb),
.regout(regout0),

.newwin(newwin)

);



/* Self-check */
always@(posedge clk)
	if (state == CLR)
		win_wr <= 0;
	else
		if (dvi0)
			if (win_wr == (WPI-1) && newwin)
				win_wr <= 0;
			else if (newwin)
				win_wr <= win_wr + 1;
			
always@(posedge clk)
	if (dvo0)
		if (win_rd == (WPI-1))
			win_rd <= 0;
		else
			win_rd <= win_rd + 1;
			
	
always@(posedge clk or negedge reset_n)
	if (state == CLR)
		for(i=0;i<(WPI);i=i+1)
			acc_test[i] <= 0;
	else
		if (dvi0)
			acc_test[win_wr] <= acc_test[win_wr] + $signed({1'b0,data})*svcoeff;
		
always@(posedge clk)
		if (dvo0)
			if (acc_test[win_rd] != regout0)
				$display("Computing error! Win #%d %d %d", win_rd, acc_test[win_rd], regout0);
				
always@(posedge clk)
	if (state == CLR)
		$display("Download compleded, OK! (DT = %d)", $time);
						
/* These acc# below are redundant, just to see the waveforms on GTKwave */

reg signed [31:0] acc0;				
always@(posedge clk or negedge reset_n)
	if (state == CLR)
		acc0 <= 0;
	else 	
		if (reset_n == 0)
			acc0 <= 0;
		else	
			if (dvi0 && win_wr == 0)
					acc0 <= acc0 + $signed({1'b0,data})*svcoeff;

reg signed [31:0] acc1;				
always@(posedge clk or negedge reset_n)
	if (state == CLR)
		acc1 <= 0;
	else 
	if (reset_n == 0)
		acc1 <= 0;
	else	
		if (dvi0 && win_wr == 1)
				acc1 <= acc1 + $signed({1'b0,data})*svcoeff;
				
reg signed [31:0] acc2;				
always@(posedge clk or negedge reset_n)
	if (state == CLR)
		acc2 <= 0;
	else 
	if (reset_n == 0)
		acc2 <= 0;
	else	
		if (dvi0 && win_wr == 2)
				acc2 <= acc2 + $signed({1'b0,data})*svcoeff;						
				
reg signed [31:0] acc3;				
always@(posedge clk or negedge reset_n)
	if (state == CLR)
		acc3 <= 0;
	else 
	if (reset_n == 0)
		acc3 <= 0;
	else	
		if (dvi0 && win_wr == 3)
				acc3 <= acc3 + $signed({1'b0,data})*svcoeff;							

reg signed [31:0] acc29;				
always@(posedge clk or negedge reset_n)
	if (state == CLR)
		acc29 <= 0;
	else 
	if (reset_n == 0)
		acc29 <= 0;
	else	
		if (dvi0 && win_wr == 29)
				acc29 <= acc29 + $signed({1'b0,data})*svcoeff;	

reg signed [31:0] acc30;				
always@(posedge clk or negedge reset_n)
	if (state == CLR)
		acc30 <= 0;
	else 
	if (reset_n == 0)
		acc30 <= 0;
	else	
		if (dvi0 && win_wr == 30)
				acc30 <= acc30 + $signed({1'b0,data})*svcoeff;	

reg signed [31:0] acc31;				
always@(posedge clk or negedge reset_n)
	if (state == CLR)
		acc31 <= 0;
	else 
	if (reset_n == 0)
		acc31 <= 0;
	else	
		if (dvi0 && win_wr == 31)
				acc31 <= acc31 + $signed({1'b0,data})*svcoeff;	

endmodule

