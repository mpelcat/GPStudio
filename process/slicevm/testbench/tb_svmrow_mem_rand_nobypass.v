
`timescale 1ns/100ps
module tb_svmrow_mem_rand_nobypass();


parameter DWIDTH = 8;
parameter CWIDTH = 9;
parameter BLOCKSIZE = 8;
parameter WPI = 8;
parameter WINCOLS = 8;
parameter WINROWS = 16;
parameter DOWNLOAD_TIME = WPI*WINCOLS+15;

reg clk;
reg toto;
reg reset_n;
reg dvi;
reg [DWIDTH-1:0] data;
reg [DWIDTH-1:0] datatmp;
reg dvi_bypass;
reg signed [CWIDTH-1:0] svcoeff_in;
reg signed [CWIDTH-1:0] coefftmp;
reg [31:0] waitdownload;

wire [$clog2(WPI)-1:0] wincount;

wire signed [CWIDTH-1:0] svcoeff_out;

wire dvo;
wire done;
wire download;
wire signed [31:0] svm_data;

integer fp_image, fp_coeff, r, i;
integer fp_test;

reg [31:0] counter_data;
reg [31:0] counter_coeff;

reg signed [31:0] acc [(WPI*WINCOLS)-1:0];

reg [31:0] dvo_count;
reg [31:0] dvi_count;

reg [7:0] datamem [(BLOCKSIZE*WINCOLS*WINROWS*WPI)-1:0];
reg signed [8:0] coeffmem [(BLOCKSIZE*WINCOLS*WINROWS)-1:0];	


initial begin
	$dumpfile("/tmp/tb_svmrow_mem_rand_nobypass.vcd");
	$dumpvars;
	
	$display ("svmrow_mem_rand_nobypass testbench started!");
	$display ("-> DWIDTH \t%d", DWIDTH);	
	$display ("-> CWIDTH \t%d", CWIDTH);	
	$display ("-> BLOCKSIZE \t%d", BLOCKSIZE);
	$display ("-> WINCOLS \t%d", WINCOLS);
	$display ("-> WPI \t%d", WPI);
	$display ("-> WINROWS \t%d", WINROWS);
	
	
	
	clk = 0;
	toto = 0;
	dvi = 0;
	data = 0;
	svcoeff_in = 0;
	coefftmp = 0;
	reset_n = 1;
	data = 0;
	datatmp = 0;
	counter_coeff = 0;
	dvi_bypass = 0;
	counter_data = 0;
	dvi_count = 0;
	waitdownload = 0;
	

	fp_test = $fopen("toto.txt", "w");	
	if(!fp_test) 
	begin
		$display("Error opening fp_test");
		$finish;
	end
	
	for(i=0; i<(WPI*WINCOLS); i=i+1)
		acc[i] = 0;

	#1 reset_n = 1'd0;
	#2 reset_n = 1'd1;	

end

always #1 clk = ~clk;

wire imageflow;
assign imageflow = (dvi_count < BLOCKSIZE*WPI*WINROWS*WINCOLS+BLOCKSIZE*WINCOLS);	

always@(posedge clk or negedge reset_n)	
	if (reset_n == 0)
		dvi <= 0;
	else
		if(imageflow)
			dvi <= $random;	
		else
			dvi <= 0;


always@(posedge clk)		
	if(dvi)
		dvi_count <= dvi_count + 1;		
	else if (waitdownload == DOWNLOAD_TIME)	
		dvi_count <= 0;
		
always@(posedge clk)
	begin
		datatmp <= {$random}%100;
		coefftmp <= $random % 100;
		data <= datatmp;
		datamem[dvi_count] <= data;
		svcoeff_in <= coefftmp;
		coeffmem[counter_coeff] <= svcoeff_in;
	end
	
always@ (posedge clk)
	if (dvi && wincount == 0)
		counter_coeff <= counter_coeff + 1;	
	else if (waitdownload == DOWNLOAD_TIME)	
		counter_coeff <= 0;		
		
always@ (posedge clk)
	if (dvi)
		counter_data <= counter_data + 1;		
	else if (waitdownload == DOWNLOAD_TIME)	
		counter_data <= 0;	
			
always@ (posedge clk)
	if (waitdownload == DOWNLOAD_TIME)	
		for(i=0; i<(WPI*WINCOLS); i=i+1)
			acc[i] = 0;

/* Test stored values (toto.txt) */			
//~ always@(posedge dvo)
		//~ for(i=0; i<2048; i=i+1)
			//~ $fwrite(fp_test, "%d\n", coeffmem[i]);
			
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

always@(posedge download)
	for (index=0; index< (WPI*WINCOLS); index=index+1)
		begin
			for(y=0; y< WINROWS; y=y+1)
				for(x=0; x< (BLOCKSIZE*WINCOLS); x=x+1)
					begin
						acc[index] = acc[index] + $signed({1'b0,datamem[x + y*BLOCKSIZE*WINCOLS*WPI + BLOCKSIZE*index]})*coeffmem[x + y*(BLOCKSIZE*WINCOLS)];
					end	 
			$fwrite(fp_test,"%d\n", acc[index]);	
		end	
		
wire signed [31:0] acc0, acc1;
assign acc0 = 	acc[0];	
assign acc1 = 	acc[1];	
	
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
.dvi_in(dvi & imageflow),
.dvi_bypass(dvi_bypass),
.svcoeff_in(svcoeff_in),
.svcoeff_out(svcoeff_out),
.wincount(wincount),
.download(download),
.done(done),
.svm_data(svm_data),
.dvo(dvo)
);




endmodule

