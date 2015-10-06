`timescale 1ns/100ps
module tb_gen();

	reg clk_proc;
	reg reset_n;
	
	reg addr_rel_i;
	reg wr_i;
	reg [31:0] datawr_i;
	reg start;
	reg rand;
	reg rand2;
	reg [31:0] counter;

	initial begin
		$dumpfile("/tmp/tb_gen.vcd");
        $dumpvars;
        
		clk_proc = 0;
		addr_rel_i = 0;
		wr_i = 0;
		datawr_i = 0;
		start = 0;
		rand = 0;
		rand2 = 0;
		counter = 0;
		
		#1 reset_n = 1'd0;
		#4 reset_n = 1'd1;	
		
		#6 datawr_i = 8192;
		#2 addr_rel_i =0;
		#2 wr_i = 1;
		#2 wr_i = 0;
		#2 start = 1;
				

	end
		
	always #1 clk_proc = ~clk_proc;
	

	always@(posedge clk_proc)
		rand <= $random;
	
	always@(posedge clk_proc)
		rand2 <= $random;	
	
	always@(posedge clk_proc)
		if (start == 1)
			if (rand && counter < 8192)
				begin
					#6 datawr_i <= $random; addr_rel_i <=1; wr_i <= 1;
					if(rand2)
						#2 wr_i <= 0;
				end
			else
				begin
					datawr_i <= 0;
					wr_i <= 0;
				end
	
	always@(posedge clk_proc)
		if (wr_i)
			counter <= counter + 1;
		else
			counter <= counter;

streamgen 
#(
	.OUT_WIDTH(16)
)
streamgen_inst(
	.clk_proc(clk_proc),
	.reset_n(reset_n),
	
	
	.out_fv(),
	.out_dv(),
	.out_data(),
	

	.addr_rel_i(addr_rel_i),
	.wr_i(wr_i),
	.datawr_i(datawr_i),
	.rd_i(1'b0),
	

	.datard_o()
	
);


endmodule
