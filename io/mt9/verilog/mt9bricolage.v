module mt9bricolage (
	
	//camera interface
	mt9_pixclk_i,
	mt9_lval_i,
	mt9_fval_i,
	mt9_data_i,
	
	mt9_extclk_o,
	mt9_standby_o,
	mt9_reset_n_o,
	mt9_oe_n_o,
	mt9_trigger_o,	
	mt9_saddr_o,		
	mt9_sdata_io,	
	mt9_sclk_o,		
	
	//CLOCK50 domain
	clk_proc,
	reset_n,
	
	//Avalon-MM Slave interface
	addr_rel_i, 
	wr_i,
	datawr_i,
	rd_i,
	datard_o,
	
	//Stream interface
	out_data,
	out_dv,
	out_fv

);

parameter DATA_WIDTH = 32;	
parameter PIXEL_WIDTH = 8;
parameter FIFO_DEPTH = 2048;
parameter DEFAULT_SCR = 0;
parameter DEFAULT_FLOWLENGHT = 254*254;

/* Camera Interface */
input mt9_pixclk_i;
input mt9_lval_i;
input mt9_fval_i;
input [11:0] mt9_data_i;

output mt9_extclk_o;
output mt9_reset_n_o;	
output mt9_standby_o;	
output mt9_oe_n_o;		
output mt9_trigger_o;	
output mt9_saddr_o;
inout mt9_sdata_io;
output mt9_sclk_o;

/* CLOCK50 domain */
input clk_proc;
input reset_n;

/* Avalon-MM interface */
input [2:0] addr_rel_i;
input wr_i;
input rd_i;

input [DATA_WIDTH-1:0] datawr_i;
output [DATA_WIDTH-1:0]	datard_o;

/* Flow interface */
output [PIXEL_WIDTH-1:0] out_data;
output	out_dv;
output	out_fv;

/* ########################## */
/* Internal signal definition */

/* Register definitons */
wire Sclk_100k;
wire Sclk_50k;

/* Wire definitons */
wire Ext_clk_9M;
wire mt9_regconf_done;

/* ########################## */

mt9 #(
	.GEN_NUM_REG(9)
) mt9_inst  (
		.mt9_extclk(Ext_clk_9M), 	
		.mt9_sclk(Sclk_50k), 		
		.mt9_sclkdouble(Sclk_100k), 
		
		.mt9_extclk_o(mt9_extclk_o),	
		.mt9_reset_n_o(mt9_reset_n_o),	
		.mt9_standby_o(mt9_standby_o),	
		.mt9_oe_n_o(mt9_oe_n_o),		
		.mt9_trigger_o(mt9_trigger_o),	
		.mt9_saddr_o(mt9_saddr_o),		
		.mt9_sdata_io(mt9_sdata_io),	
		.mt9_sclk_o(mt9_sclk_o),		
		
		.mt9_regconf_done(mt9_regconf_done)

);	 

VideoSampler #(
	.DATA_WIDTH(DATA_WIDTH),
	.PIXEL_WIDTH(PIXEL_WIDTH),
	.FIFO_DEPTH(FIFO_DEPTH),
	.DEFAULT_SCR(DEFAULT_SCR),
	.DEFAULT_FLOWLENGHT(DEFAULT_FLOWLENGHT)
) VideoSampler_inst(
	
	//inputs from camera
	.pclk_i(mt9_pixclk_i),
	.href_i(mt9_lval_i),
	.vsync_i(mt9_fval_i),
	
	.pixel_i(mt9_data_i[11:4]),
	
	//input from CLOCK50 domain
	.clk_i(clk_proc),
	.reset_n_i(reset_n),
	
	//Avalon-MM Slave interface
	.address_i(addr_rel_i), 
	.write_i(wr_i),
	.writedata_i(datawr_i),
	.read_i(rd_i),
	.readdata_o(datard_o),
	
	//Stream interface
	.data_o(out_data),
	.dv_o(out_dv),
	.fv_o(out_fv)

);


///* 	Dumb I2C clock generation
// *	This is due to the limited clk range span of CycloneV's PLLs
// */
//reg [31:0] counter500;
//always @ (posedge clk_proc or negedge reset_n)
//	if (reset_n == 0)
//		counter500 <= 0;
//	else	
//		if (counter500 < 499)
//			counter500 <= counter500 + 1'b1;
//		else	
//			counter500 <= 0;
//
//wire counter500_top;
//assign counter500_top = (counter500 == 499);			
//			
//always @ (posedge counter500_top)
//	Sclk_100k <= ~Sclk_100k;
//
//reg [31:0] counter1000;
//always @ (posedge clk_proc or negedge reset_n)
//	if (reset_n == 0)
//		counter1000 <= 0;
//	else	
//		if (counter1000 < 999)
//			counter1000 <= counter1000 + 1'b1;
//		else	
//			counter1000 <= 0;
//
//wire counter1000_top;
//assign counter1000_top = (counter1000 == 999);			
//
//
//always @ (posedge counter1000_top)
//	Sclk_50k <= ~Sclk_50k;
	
/* MT9 PLL */	
pll pll_inst (
		.inclk0(clk_proc),		
		.c0(Ext_clk_9M),	
		.c1(Sclk_100k),
		.c2(Sclk_50k)
);	 

endmodule
