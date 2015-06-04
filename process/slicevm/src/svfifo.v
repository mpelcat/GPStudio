module svfifo(  
clk,
reset_n,
dv,
fifo_in,
stage,
fifo_out,
svcoeff
);

parameter CWIDTH = 9;
parameter STAGE = 32;

input clk;
input reset_n;

input dv;

input [CWIDTH-1:0] fifo_in;
input [2:0] stage;

output [CWIDTH-1:0] fifo_out;
output [CWIDTH-1:0] svcoeff;

/* Wire definitions */

wire [CWIDTH-1:0] fifo_out_int;

/* Register definitions */

	altshift_taps	
	#(	.intended_device_family("Cyclone IV E"),
		.lpm_hint("RAM_BLOCK_TYPE=M9K"),
		.lpm_type("altshift_taps"),
		.number_of_taps(1),
		.tap_distance(STAGE),
		.width(CWIDTH)
	)
	altshift_taps_inst (
				.clock (clk),
				.clken (dv),
				.shiftin (fifo_in),
				.shiftout (fifo_out_int),
				.taps ()
				// synopsys translate_off
				,
				.aclr (~reset_n)
				// synopsys translate_on
				);
				
assign fifo_out = dv ? fifo_out_int : {CWIDTH{1'b0}}; 				
assign svcoeff = dv ? fifo_in : {CWIDTH{1'b0}};

//~ reg [8:0] scfifo [STAGE-1:0];
//~ integer i;
//~ always@(posedge clk or negedge reset_n)
	//~ if (reset_n == 0)
		//~ for(i=0; i<STAGE;i=i+1)
			//~ scfifo[i] <= 0;
	//~ else
		//~ if (dv)
			//~ begin
				//~ scfifo[0] <= fifo_in;
				//~ for(i=1; i<STAGE;i=i+1)
					//~ scfifo[i] <= scfifo[i-1];
			//~ end
//~ 
//~ assign svcoeff = dv ? fifo_in : 0;
//~ assign fifo_out = dv ? scfifo[STAGE-1] : 0;	

endmodule
