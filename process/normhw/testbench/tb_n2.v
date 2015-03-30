
`timescale 1ns/100ps
module tb_n2();

	
	reg clk;
	reg reset_n;
	reg [15:0] in_data;
	reg in_dv;
	reg in_fv;
	wire out_fv;
	wire out_dv;
	wire [15:0] out_data;
		
	reg [31:0] counter;	
	reg [31:0] toto;	
		
	initial begin
		$dumpfile("/tmp/tb_n2.vcd");
        $dumpvars;
        
        		   
		clk = 0;				
		reset_n = 1;
		in_dv =0;
		in_data =0;
		
		counter = 0;
		toto = 0;

		#1 reset_n = 1'd0;
		#4 reset_n = 1'd1;

	
	end
	
	always #1 clk = ~clk;
	always@(posedge clk) 
		if (reset_n == 0)
			in_dv <= 0;
		else
			if (counter < 127 || toto > 1)
				in_dv <= $random;
			else
				in_dv <= 0;
				
	always@(posedge clk) 
		in_fv <= reset_n;
		//~ if (reset_n == 0)
			//~ in_fv <= 0;
		//~ else
			//~ if (counter < 127 || toto > 1)
				//~ in_fv <= 1;
			//~ else
				//~ in_fv <= 0;	
				
	always@(posedge clk) 
		if (reset_n == 0)
			toto <= 0;
		else
			if(counter >= 127)
				toto <= toto + 1;
		
	always@(posedge clk) 
		if (reset_n == 0)
			in_data <= 0;
		else	
			if (counter < 127 || toto > 1)
				in_data <= $random;
			else
				in_data <= 0;
	
	always@(posedge clk) 
		if (reset_n == 0)		
			counter <= 0;
		else
			if (in_dv)
				counter <= counter + 1;
		
normhw normhw_inst(

	.clk_proc(clk),
	.reset_n(reset_n),

	.in_fv(in_fv),
	.in_dv(in_dv),
	.in_data(in_data),

	.out_fv(out_fv),
	.out_dv(out_dv),
	.out_data(out_data),
	
	.addr_rel_i(),
	.wr_i(),
	.datawr_i(),
	.rd_i(),
	
	.datard_o()
);

endmodule
