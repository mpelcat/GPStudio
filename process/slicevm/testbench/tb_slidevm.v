
`timescale 1ns/100ps
module tb_slidevm();


parameter DWIDTH = 8;
parameter CWIDTH = 9;
parameter BLOCKSIZE = 8;
parameter WPI = 4;
parameter WINCOLS = 8;
parameter WINROWS = 16;
parameter HPI = 19;

localparam DATATOT = BLOCKSIZE*WINCOLS*WPI*HPI;

reg clk;
reg toto;
reg reset_n;
reg dvi_orig;
reg [DWIDTH-1:0] data;
reg [DWIDTH-1:0] datatmp;
reg signed [CWIDTH-1:0] svcoeff_in;
reg signed [CWIDTH-1:0] coefftmp;

wire signed [CWIDTH-1:0] svcoeff_out;
wire [$clog2(WPI)-1:0] wincount;

wire dvo;
wire done;
wire signed [31:0] slide_data;
wire dvi;

integer fp_image, fp_coeff, r, i;
integer fp_test;

reg [31:0] counter_coeff;
reg [31:0] dvo_row_count;

reg [31:0] counter_ok;
reg [31:0] counter_error;

reg signed [31:0] acc [(WPI*WINCOLS)-1:0];

reg [31:0] dvo_count;
reg [31:0] dvi_count;


reg [DWIDTH-1:0] datamem [(DATATOT)-1:0];
reg signed [CWIDTH-1:0] coeffmem [(BLOCKSIZE*WINCOLS*WINROWS)-1:0];	


initial begin
	$dumpfile("/tmp/tb_slidevm.vcd");
	$dumpvars;
	
	$display ("slidevm testbench started!");
	$display ("-> DWIDTH \t%d", DWIDTH);	
	$display ("-> CWIDTH \t%d", CWIDTH);	
	$display ("-> BLOCKSIZE \t%d", BLOCKSIZE);
	$display ("-> WINCOLS \t%d", WINCOLS);
	$display ("-> WPI \t%d", WPI);
	$display ("-> WINROWS \t%d", WINROWS);
	$display ("-> HPI \t%d", HPI);
	
	
	
	clk = 0;
	dvi_orig = 0;
	data = 0;
	svcoeff_in = 0;
	coefftmp = 0;
	reset_n = 1;
	data = 0;
	datatmp = 0;
	counter_coeff = 0;
	dvi_count = 0;	
	dvo_row_count = 0;
	counter_ok = 0;
	counter_error = 0;
	

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
assign imageflow = (dvi_count < DATATOT);//+ BLOCKSIZE*WINCOLS);	
wire coeffflow;
assign coeffflow = (counter_coeff < BLOCKSIZE*WINCOLS*WINROWS);	

assign dvi = dvi_orig & imageflow;

always@(posedge clk or negedge reset_n)	
	if (reset_n == 0)
		dvi_orig <= 0;
	else
		if(imageflow)
			dvi_orig <= $random;	
		else
			dvi_orig <= 0;

always@(posedge clk)
	if ($time > 20000 && $time < 20002)
		dvi_count <= 0;
	else if (imageflow)		
		begin
			if(dvi)
				dvi_count <= dvi_count + 1;	
		end

always@ (posedge clk)
	if (coeffflow)
		if (dvi && wincount == 0)
			counter_coeff <= counter_coeff + 1;			
		
always@(posedge clk)
	begin
		datatmp <= {$random}%100;
		coefftmp <= $random % 100;
		data <= datatmp;
		datamem[dvi_count] <= data;
		svcoeff_in <= coefftmp;
		coeffmem[counter_coeff] <= svcoeff_in;
	end
	

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
						acc[index] = acc[index] + $signed({1'b0,datamem[x + y*BLOCKSIZE*WINCOLS*WPI + BLOCKSIZE*index + WPI*WINCOLS*BLOCKSIZE*dvo_row_count]})*coeffmem[x + y*(BLOCKSIZE*WINCOLS)];
					end	 
			$fwrite(fp_test,"%d\n", acc[index]);	
		end	
		
wire signed [31:0] acc0, acc1;
assign acc0 = 	acc[0];	
assign acc1 = 	acc[1];		

wire signed [31:0] coeffmem0, coeffmem1;
assign coeffmem0 = 	coeffmem[0];	
assign coeffmem1 = 	coeffmem[1];		

always@(negedge dvo or negedge reset_n)
	if (reset_n == 0)
		dvo_row_count <= 0;
	else if (imageflow == 0)
		dvo_row_count <= 0;
	else
		dvo_row_count <= dvo_row_count + 1;
		
always@(negedge dvo)		
	for(i=0; i<(WPI*WINCOLS); i=i+1)
		acc[i] = 0;
		
always@(posedge clk)
	if (dvo)
		if (slide_data != acc[dvo_count])
			begin
				$display("ERROR!%d, time = %d, value testbench = %d, value svmrow_mem = ", dvo_count, $time, acc[dvo_count], slide_data);
				counter_error <= counter_error +1;
			end
		else
			begin
				$display("OK!%d, time = %d, value testbench = %d, value svmrow_mem = ", dvo_count, $time, acc[dvo_count], slide_data);	
				counter_ok <= counter_ok +1;
			end
			
always@(negedge dvo)		
	$display("counter_ok = %d, counter_error = %d\n", counter_ok, counter_error);	
			
always@(negedge imageflow)
		for(i=0; i<BLOCKSIZE*WINCOLS*WINROWS ; i=i+1)
			$fwrite(fp_test, "%d\n", coeffmem[i]);			
			
slidevm #( 
	.DWIDTH(DWIDTH),
	.CWIDTH(CWIDTH),
	.BLOCKSIZE(BLOCKSIZE),
	.WPI(WPI),
	.WINCOLS(WINCOLS),
	.WINROWS(WINROWS),
	.HPI(HPI) )
slidevm_inst(  
.clk(clk),
.reset_n(reset_n),
.data(data),
.dvi_in(dvi),
.in_fv(imageflow),
.svcoeff_in(svcoeff_in),
.svcoeff_out(svcoeff_out),
.wincount(wincount),
.slide_data(slide_data),
.dvo(dvo)
);



endmodule

