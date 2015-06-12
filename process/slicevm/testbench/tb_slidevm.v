
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
localparam COEFFTOT = BLOCKSIZE*WINCOLS*WINROWS+64;

reg clk;
reg toto;
reg reset_n;
reg sendcoeff;
reg [DWIDTH-1:0] data;
reg [DWIDTH-1:0] datatmp;
reg signed [CWIDTH-1:0] svcoeff_in;
reg signed [CWIDTH-1:0] coefftmp;

wire coeffflow;
wire imageflow;
reg loadstart;
reg imagestart;

wire dvo;
wire signed [31:0] out_data;
reg dvi;
wire out_fv;

integer i;
integer fp_test;

reg [31:0] counter_coeff;
reg [31:0] dvo_row_count;

reg [31:0] counter_ok;
reg [31:0] counter_error;

reg signed [31:0] acc [(WPI*WINCOLS)-1:0];

reg [31:0] dvo_count;
reg [31:0] dvi_count;

reg addr_rel_i; 
reg  wr_i;
reg  [31:0] datawr_i;


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
	dvi = 0;
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
	loadstart = 0;
	sendcoeff = 0;
	imagestart = 0;
	
	addr_rel_i = 0; 
	wr_i = 0;
	datawr_i = 0;
	
	fp_test = $fopen("toto.txt", "w");	
	if(!fp_test) 
	begin
		$display("Error opening fp_test");
		$finish;
	end
	
	for(i=0; i<(WPI*WINCOLS); i=i+1)
		acc[i] = 0;

	#1 reset_n = 0;
	#2 reset_n = 1;	
	
	#2 addr_rel_i <= 0;
	#0 datawr_i <= 2;
	#2 wr_i <= 1;
	#2 wr_i <= 0;
	
	#2 addr_rel_i <= 1;
	
	#2 loadstart <= 1;

	

end

always #1 clk = ~clk;


assign imageflow = imagestart && (dvi_count < DATATOT);

assign coeffflow = loadstart && (counter_coeff < COEFFTOT);

always@(posedge clk) 
	if(loadstart)
		begin
			if (coeffflow)
				wr_i <= $random;
			else
				wr_i <= 0;
		end

always@(negedge coeffflow) 		
	if (loadstart)
		begin
			#0 wr_i <= 0;
			loadstart <= 0;
			
			#10 addr_rel_i <= 0;
			#0 datawr_i <= 1;
			#2 wr_i <= 1;
			#2 wr_i <= 0;
			
			#20 imagestart <= 1;
		end
		
			
always@(*) 
	if (loadstart)
		datawr_i = svcoeff_in;

always@ (posedge clk)
	if (coeffflow & wr_i)
		counter_coeff <= counter_coeff + 1;		

always@(posedge clk)
	if (imageflow)
		dvi <= $random;
	else
		dvi <= 0;
			
always@(posedge clk or negedge reset_n)
	if (reset_n == 0)
		dvi_count <= 0;
	else if(dvi)
		dvi_count <= dvi_count + 1;	
		
always@(posedge clk)
	begin
		datatmp <= {$random}%100;
		coefftmp <= $random % 100;
		data <= datatmp;
		datamem[dvi_count] <=  data;
		svcoeff_in <= coefftmp;
		coeffmem[counter_coeff] <= svcoeff_in;
	end
	
	
/* Automatic image send mechanism */
always@(negedge imageflow)
	begin
		#100 dvi_count <= 0;
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
		end	
		
wire signed [31:0] acc0, acc1;
assign acc0 = 	acc[0];	
assign acc1 = 	acc[1];		

wire signed [31:0] coeffmem0, coeffmem1, coeffmem2;
assign coeffmem0 = 	coeffmem[0];	
assign coeffmem1 = 	coeffmem[1];
assign coeffmem2 = 	coeffmem[2];		

wire signed [31:0] datamem0, datamem1;
assign datamem0 = 	datamem[0];	
assign datamem1 = 	datamem[1];			
		
always@(posedge dvo or negedge reset_n)
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
		if ((out_data - acc[dvo_count] )!= 0)
			begin
				$display("ERROR!%d, time = %d, value testbench = %d, value svmrow_mem = ", dvo_count, $time, acc[dvo_count], out_data);
				counter_error <= counter_error +1;
			end
		else
			begin
				$display("OK!%d, time = %d, value testbench = %d, value svmrow_mem = ", dvo_count, $time, acc[dvo_count], out_data);	
				counter_ok <= counter_ok +1;
			end
			
always@(negedge dvo)		
	$display("counter_ok = %d, counter_error = %d\n", counter_ok, counter_error);	
			
always@(posedge imageflow)
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

.in_fv(imageflow),
.in_dv(dvi & imageflow),
.in_data(data),


//~ .svcoeff_in(svcoeff_in),
//~ .loadcoeff(wr_i & coeffflow),

.out_fv(out_fv),
.out_dv(dvo),
.out_data(out_data),

.addr_rel_i(addr_rel_i),
.wr_i(wr_i),
.datawr_i(datawr_i),
.rd_i(1'b0),
.datard_o()

);



endmodule

