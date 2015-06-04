
`timescale 1ns/100ps
module tb_svmrow_mem();


parameter DWIDTH = 8;
parameter CWIDTH = 9;
parameter BLOCKSIZE = 16;
parameter BPW = 8;
parameter WPI = 32;
parameter WINCOLS = 8;
parameter WINROWS = 16;

reg clk;
reg reset_n;
reg dvi;
reg [DWIDTH-1:0] data;
reg signed [CWIDTH-1:0] svcoeff_in;

wire [$clog2(WPI)-1:0] wincount;

wire signed [CWIDTH-1:0] svcoeff_out;

wire dvo;
wire [WINCOLS-1:0] svmres;

integer fp_image, fp_coeff, r;

`define COEFF_FILE "ds_fpga_th20_integer.txt"
`define IMG_FILE "p_slice0.txt"

initial begin
	$dumpfile("/tmp/tb_svmrow_mem.vcd");
	$dumpvars;
	
	$display ("svmrow_mem testbench started!");
	$display ("-> loading image from %s", `IMG_FILE);
	$display ("-> loading coeff from %s", `COEFF_FILE);
	$display ("-> DWIDTH \t%d", DWIDTH);	
	$display ("-> CWIDTH \t%d", CWIDTH);	
	$display ("-> BLOCKSIZE \t%d", BLOCKSIZE);
	$display ("-> BPW \t%d", BPW);
	$display ("-> WPI \t%d", WPI);
	$display ("-> WINROWS \t%d", WINROWS);
	
	
	
	clk = 0;
	dvi = 0;
	data = 0;
	svcoeff_in = 0;
	reset_n = 1;
	data = 0;

	#1 reset_n = 1'd0;
	#2 reset_n = 1'd1;
	//~ #2 dvi = 1;
	

	fp_image = $fopen(`IMG_FILE, "r");	
	if(!fp_image) 
	begin
		$display("Error opening fp_image");
		$finish;
	end
	
	fp_coeff = $fopen(`COEFF_FILE, "r");	
	if(!fp_coeff) 
	begin
		$display("Error opening fp_coeff");
		$finish;
	end

	r = $fscanf(fp_coeff," %d\n", svcoeff_in); 
	r = $fscanf(fp_image," %d\n", data); 
			
end

always #1 clk = ~clk;
	
always@(posedge clk or negedge reset_n)
	if (reset_n == 0)
		dvi <= 0;
	else		
		dvi <= 1;	
	
always@ (posedge clk)
	if (dvi && wincount == 1)
		if(!$feof(fp_coeff))
			r = $fscanf(fp_coeff," %d\n", svcoeff_in); 
		else
			svcoeff_in <= 0;	
	
always@ (posedge clk)
	if (dvi && wincount == 1)
		if(! $feof(fp_image))
			r = $fscanf(fp_image," %d\n", data); 
		else
			$finish;

svmrow_mem #( 
	.DWIDTH(DWIDTH),
	.CWIDTH(CWIDTH),
	.BLOCKSIZE(BLOCKSIZE),
	.BPW(BPW),
	.WPI(WPI),
	.WINCOLS(WINCOLS),
	.WINROWS(WINROWS) )
svmrow_inst(  
.clk(clk),
.reset_n(reset_n),
.data(data),
.dvi_in(dvi),
.svcoeff_in(svcoeff_in),
.svcoeff_out(svcoeff_out),
.wincount(wincount),
.svmres(svmres),
.dvo(dvo)
);




endmodule

