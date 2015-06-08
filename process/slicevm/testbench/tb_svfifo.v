
`timescale 1ns/100ps
module tb_svfifo(  );

/* Wire definitions */
wire [8:0] fifo_out;
wire [8:0] svcoeff;


/* Register definitions */
reg clk;
reg reset_n;
reg dv;
reg [8:0] fifo_in;

initial begin
	$dumpfile("/tmp/tb_svfifo.vcd");
	$dumpvars;
	
	clk = 0;
	dv = 0;
	fifo_in = 0;
	reset_n = 1;

	#1 reset_n = 1'd0;
	#2 reset_n = 1'd1;
	
end

always #1 clk = ~clk;

always@(posedge clk)
	#1 dv <= ~dv;
		
always@ (posedge clk)
	fifo_in <= $random;

svfifo 
#(.STAGE(32)) svfifo_inst(  
.clk(clk),
.reset_n(reset_n),
.dv(dv),
.fifo_in(fifo_in),
.stage(),
.fifo_out(fifo_out),
.svcoeff(svcoeff)
);


	

endmodule
