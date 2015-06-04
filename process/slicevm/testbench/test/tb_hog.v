
`timescale 1ns/100ps
module tb_svmrow();

reg clk;
reg reset_n;
reg dvi;
reg [7:0] data;
reg signed [8:0] svcoeff_in;

wire signed [8:0] svcoeff_out;

wire dvo;
wire [7:0] svmres;

parameter BLOCKSIZE = 32;
parameter WPI = 40;
parameter WINCOLS = 8;
parameter WINROWS = 16;

initial begin
	$dumpfile("tb_svmrow.vcd");
	$dumpvars;
	
	$display ("tb_svmrow: svmrow testbench started!");
	
	$display ("tb_svmrow: BLOCKSIZE \t%d", BLOCKSIZE);
	$display ("tb_svmrow: WPI \t%d", WPI);
	$display ("tb_svmrow: WINROWS \t%d", WINROWS);
	
	clk = 0;
	dvi = 0;
	data = 0;
	svcoeff_in = 0;
	reset_n = 1;
	data = 7;

	#1 reset_n = 1'd0;
	#2 reset_n = 1'd1;
	#3 dvi = 1;
		
end

always #1 clk = ~clk;
	
	
//~ always@(posedge clk)
		//~ dvi <= $random;	
	
always@ (posedge clk)
	svcoeff_in <= $random;
	
always@ (posedge clk)
	data <= $random;


svmrow #( 
	.BLOCKSIZE(32),
	.WPI(40),
	.WINCOLS(8),
	.WINROWS(16) )
svmrow_inst(  
.clk(clk),
.reset_n(reset_n),
.data(data),
.dvi_in(dvi),
.svcoeff_in(svcoeff_in),
.svcoeff_out(svcoeff_out),
.svmres(svmres),
.dvo_out(dvo)
);




endmodule

