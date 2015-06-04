
`timescale 1ns/100ps
module tb_svmrow_mem();


parameter DWIDTH = 8;
parameter CWIDTH = 9;
parameter BLOCKSIZE = 16;
parameter WPI = 4;
parameter WINCOLS = 8;
parameter WINROWS = 16;

reg clk;
reg toto;
reg reset_n;
reg dvi;
reg [DWIDTH-1:0] data;
reg dvi_bypass;
reg signed [CWIDTH-1:0] svcoeff_in;
reg cond;

wire [$clog2(WPI)-1:0] wincount;

wire signed [CWIDTH-1:0] svcoeff_out;

wire dvo;
wire done;
wire signed [31:0] svm_data;

integer fp_image, fp_coeff, r, i;
integer fp_test;

reg [31:0] counter_data;
reg [31:0] counter_coeff;

reg signed [31:0] acc [(WPI*WINCOLS-1):0];

reg [31:0] dvo_count;

`define COEFF_FILE "ds_fpga_th20_integer.txt"
`define IMG_FILE "test_p2.txt"

initial begin
	$dumpfile("/tmp/tb_svmrow_mem.vcd");
	$dumpvars;
	
	$display ("svmrow_mem testbench started!");
	$display ("-> loading image from %s", `IMG_FILE);
	$display ("-> loading coeff from %s", `COEFF_FILE);
	$display ("-> DWIDTH \t%d", DWIDTH);	
	$display ("-> CWIDTH \t%d", CWIDTH);	
	$display ("-> BLOCKSIZE \t%d", BLOCKSIZE);
	$display ("-> WINCOLS \t%d", WINCOLS);
	$display ("-> WPI \t%d", WPI);
	$display ("-> WINROWS \t%d", WINROWS);
	
	
	
	clk = 0;
	toto = 0;
	cond = 1;
	dvi = 0;
	data = 0;
	svcoeff_in = 0;
	reset_n = 1;
	data = 0;
	counter_data = 0;
	counter_coeff = 0;

	#1 reset_n = 1'd0;
	#2 reset_n = 1'd1;
	

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
	
	fp_test = $fopen("toto.txt", "w");	
	if(!fp_test) 
	begin
		$display("Error opening fp_test");
		$finish;
	end
	
	for(i=0; i<(WPI*WINCOLS); i=i+1)
		acc[i] = 0;
			
end

always #1 clk = ~clk;

always@(posedge clk or negedge reset_n)
	if (reset_n == 0)
		dvi_bypass <= 0;
	else		
		if(! $feof(fp_image))
			dvi_bypass <= 0;	
		else
			dvi_bypass <= 1;
	
always@(posedge clk or negedge reset_n)
	if (reset_n == 0)
		dvi <= 0;
	else		
		if(! $feof(fp_image) && cond)
			dvi <= $random;	
		else
			dvi <= 0;
		
always@ (posedge clk)
	if (dvi && wincount == 0)
		if(!$feof(fp_coeff))
			r = $fscanf(fp_coeff," %d\n", svcoeff_in); 
		else
			svcoeff_in <= 0;

always #33000 toto = ~toto;
			
always@(posedge toto)
			begin
				cond = 0;
				$rewind(fp_coeff);
				$rewind(fp_image);
				for(i=0; i<(WPI*WINCOLS); i=i+1)
					acc[i] = 0;
					
				#1000; 	
				cond = 1;
			end
	
always@ (posedge clk)
	if (dvi)
		if(! $feof(fp_image))
			r = $fscanf(fp_image," %d\n", data); 
		else
			data <= 0;

/* Data storage */		
reg [7:0] datamem [8191:0];
reg signed [8:0] coeffmem [2047:0];		

always@(posedge clk)
	if (dvi)
		counter_data <= counter_data + 1;
		
always@(posedge clk)
	if (dvi)
		datamem[counter_data] <= data;
		
always@(posedge clk)
	if (dvi && wincount == 0)
		counter_coeff <= counter_coeff + 1;
	
always@(posedge clk)
	if (dvi && wincount == 0)
			coeffmem[counter_coeff] <= svcoeff_in;	

/* Test stored values (toto.txt) */			
//~ integer i;
//~ always@(posedge finish_s)
		//~ for(i=0; i<8192; i=i+1)
			//~ $fwrite(fp_test, "%d\n", datamem[i]);
			
/* Selfcheck */		

integer x, y;
integer index;

always@(posedge clk or negedge reset_n)
	if (reset_n == 0)
		dvo_count <= 0;
	else if (dvo)
		dvo_count <= dvo_count + 1;
	else 
		dvo_count <= 0;

always@(posedge dvo)
for (index=0; index< (WPI*WINCOLS); index=index+1)
	begin
		for(y=0; y< WINROWS; y=y+1)
			for(x=0; x< (BLOCKSIZE*WINCOLS); x=x+1)
				begin
					acc[index] = acc[index] + $signed({1'b0,datamem[x + y*BLOCKSIZE*WINCOLS*WPI + BLOCKSIZE*index]})*coeffmem[x + y*(BLOCKSIZE*WINCOLS)];
				end	 
		$fwrite(fp_test,"%d\n", acc[index]);	
	end	
	
always@(posedge clk)
	if (dvo)
		if (svm_data != acc[dvo_count])
			$display("ERROR!%d, time = %d, value testbench = %d, value svmrow_mem = ", dvo_count, $time, acc[dvo_count], svm_data);
		else
			$display("OK!%d, time = %d, value testbench = %d, value svmrow_mem = ", dvo_count, $time, acc[dvo_count], svm_data);		

svmrow_mem #( 
	.DWIDTH(DWIDTH),
	.CWIDTH(CWIDTH),
	.BLOCKSIZE(BLOCKSIZE),
	.WPI(WPI),
	.WINCOLS(WINCOLS),
	.WINROWS(WINROWS) )
svmrow_inst(  
.clk(clk),
.reset_n(reset_n),
.data(data),
.dvi_in(dvi),
.dvi_bypass(dvi_bypass),
.svcoeff_in(svcoeff_in),
.svcoeff_out(svcoeff_out),
.wincount(wincount),
.download(),
.done(done),
.svm_data(svm_data),
.dvo(dvo)
);




endmodule

