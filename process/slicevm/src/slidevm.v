module slidevm(  
clk,
reset_n,

in_fv,
in_dv,
in_data,

//~ svcoeff_in,
//~ loadcoeff,

out_fv,
out_dv,
out_data,

addr_rel_i,
wr_i,
datawr_i,
rd_i,

datard_o

);

/* Flow parameters */
parameter IN_SIZE = 8;
parameter OUT_SIZE = 32;

/* Default parameters */
parameter DWIDTH = 8;
parameter CWIDTH = 9;
parameter BLOCKSIZE = 16;
parameter WPI = 40;
parameter WINCOLS = 8;
parameter WINROWS = 16;
parameter HPI = 20;

input clk;
input reset_n;

input in_fv;
input in_dv;
input [DWIDTH-1:0] in_data;


wire loadcoeff;
reg loadcoeff_valid;
wire signed [CWIDTH-1:0] svcoeff_in;

output out_fv;
output out_dv;
output signed [31:0] out_data;

//% \{
//% Avalon-MM interface
//%
input  addr_rel_i; 
input  wr_i;
input  rd_i;
input  [31:0] datawr_i;
output [31:0] datard_o;
//% \}

/*! \{ Status and Control Register */
reg [31:0] scr, scr_new;
/*! \} */

/*! \{  Avalon-MM Parameters */
reg [31:0] load, load_new;
/*! \} */

/*! \{ Internal registers */
reg [31:0] readdata, readdata_new;
/*  \} */

/* Wire definitions */
wire done;
wire newblock;
wire newwin;
wire newrow;

wire [WINROWS:0] download;
wire [WINROWS:0] dvo_row;
wire [31:0] svmrow_data [WINROWS:0];
wire out_dv_int;
wire dvo_int_negedge;
wire [WINROWS:0] out_cv_int;

/* Register definitions */
reg [$clog2(BLOCKSIZE)-1:0] dvcount;
reg [$clog2(WINCOLS)-1:0] blockcount;
reg [$clog2(WPI)-1:0] wincount;
reg [WINROWS:0] token;
reg [$clog2(WINROWS):0] outcontrol;
reg [$clog2(WINROWS+1):0] token_counter;
reg dvo_int_d;
reg [$clog2(HPI)-1:0] outrow_count;


/* dvcount */
always@(posedge clk or negedge reset_n)
	if (reset_n == 0)
		dvcount <= 0;
	else if (newblock & in_dv)	
		dvcount <= 0;
	else if (in_dv)
		dvcount <= dvcount + 1'b1;	
		
/* blockcount */		
always@(posedge clk or negedge reset_n)
	if (reset_n == 0)
		blockcount <= 0;
	else if (newwin & in_dv)
		blockcount <= 0;
	else if (newblock & in_dv)
		blockcount <= blockcount + 1'b1;			

/* wincount */
always@(posedge clk or negedge reset_n)
	if (reset_n == 0)
		wincount <= 0;
	else if (newrow & in_dv)	
		wincount <= 0;
	else if (newwin & in_dv)
		wincount <= wincount + 1'b1;	
		
		
assign newblock = ((dvcount == (BLOCKSIZE-1))) ? 1'b1 : 1'b0;
assign newwin  = (newblock && (blockcount == WINCOLS-1)) ? 1'b1 : 1'b0;
assign newrow = (newwin && (wincount == (WPI-1) ))? 1'b1 : 1'b0;
wire bypass;

reg [10:0] bypass_count;
always@(posedge clk or negedge reset_n)
	if (reset_n == 0)
		bypass_count <= 0;
	else
		if (in_fv)
			bypass_count <= 0;
		else if (bypass)
			bypass_count <= bypass_count + 1;

assign bypass = (bypass_count < WINCOLS*BLOCKSIZE) && (in_fv == 0);			

		

/* Token manager 
 * each token_gen instance has activetoken(ti), download(ti) and 
 * lastimagerow sensitivity list
 * OP:  each activetoken signal, token(ti) goes in active mode. 
 *      When download(ti) goes high, the respective token is cleared
 *
 * END: this happens when rowcount reaches (HPI-WINROWS). This means that 
 *      will not be any other activation, since the last activated svmrow
 *      takes last cell row. No more activetoken are sent, system is 
 *      waiting all pipeline flows to complete.
 *
 */

genvar ti;
generate
for(ti=0; ti < (WINROWS+1); ti=ti+1)
	begin: token_gen
	always@(posedge clk or negedge reset_n)
		if (reset_n == 0)
			token[ti] <= (ti==0) ? 1'b1 : 1'b0;
		else if (download[ti])
			token[ti] <= 1'b0;
		else if (	newrow 
					&& (token_counter == ti)
					&& in_dv)
			token[ti] <= 1'b1;
	end
endgenerate

/* Token counter */
always@(posedge clk or negedge reset_n)
	if (reset_n == 0)
		token_counter <= 1;
	else
		if (token_counter == WINROWS+1)
			token_counter <= 0;
		else if (newrow & in_dv)
			token_counter <= token_counter + 1;

/* svmrow_gen 
 * NOTE: WINROWS+1 svmrow_mem are instantiated to ensure continuous data flow
 */
wire [(CWIDTH-1):0] svcoeff_chain [WINROWS:0];
genvar index;
generate
for (index=0; index < WINROWS+1; index = index + 1)
	begin: svmrow_gen
		svmrow_mem 
		#( 
	.DWIDTH(DWIDTH),
	.CWIDTH(CWIDTH),
	.BLOCKSIZE(BLOCKSIZE),
	.WPI(WPI),
	.WINCOLS(WINCOLS),
	.WINROWS(WINROWS) )
		
		svmrow_mem_inst(  
		.clk(clk),
		.data(in_data),
		.reset_n(reset_n),
		.dvi_in(token[index] & in_dv),
		.dvi_bypass(bypass),
		.svcoeff_in((index==0) ? ( (loadcoeff) ? svcoeff_in : svcoeff_chain[WINROWS]) : svcoeff_chain[index-1]),
		.in_cv(in_dv & (wincount == 0)),
		.loadcoeff(loadcoeff_valid),
		.svcoeff_out(svcoeff_chain[index]),
		.download(download[index]),
		.done(),
		.svm_data(svmrow_data[index]),
		.dvo(dvo_row[index])
		);
	end
endgenerate

/* Output multiplexing */
always@(posedge clk or negedge reset_n)
	if (reset_n == 0)
		dvo_int_d <= 1'b0;
	else
		dvo_int_d <= out_dv_int;

assign dvo_int_negedge = ~out_dv_int & dvo_int_d;

always@(posedge clk or negedge reset_n)
	if (reset_n == 0)
		outcontrol <= 0;
	else if (dvo_int_negedge)
		if (outcontrol == WINROWS)
			outcontrol <= 0;
		else
			outcontrol <= outcontrol + 1;

always@(posedge clk or negedge reset_n)
	if (reset_n == 0)
		outrow_count <= 0;			
	else
		if(outrow_count == HPI)
			outrow_count <= 0;
		else if (dvo_int_negedge)
			outrow_count <= outrow_count + 1;


assign out_dv_int = dvo_row[outcontrol];

assign out_fv = (outrow_count < HPI-WINROWS+1);

assign out_dv = (out_fv) ? dvo_row[outcontrol] : 1'b0;

assign out_data = svmrow_data[outcontrol];

/* -------------- Avalon-MM Interface -------------- 

	SCR				-	R/W
	LOAD			-   R/W

*/

assign loadcoeff = scr[1];
always@(posedge clk or negedge reset_n)
	if (reset_n == 0)
		loadcoeff_valid <= 0;
	else
		loadcoeff_valid <= loadcoeff & addr_rel_i & wr_i;

assign svcoeff_in = $signed(load[8:0]);

//%
//% Avalon-MM registers write
//% \code
always @ (*)
	if (wr_i)
		case(addr_rel_i)
		1'd0: 
			begin 
				scr_new = datawr_i;
				load_new = load;
			end
		1'd1: 
			begin 
				scr_new = scr;
				load_new = datawr_i;
			end
			
		default:
			begin 
				scr_new = scr;
				load_new = load;
			end			
		endcase
	else /* write disabled */
		begin 
			scr_new = scr;
			load_new = load;
		end				
//% \endcode
	
	
/*! Read phase 
*/	
always @ (*)
	if (rd_i)
		case(addr_rel_i)
			1'd0:		readdata_new = scr;
			1'd1:		readdata_new = load;	
			default:	readdata_new = 32'd0;
		endcase
	else 
		readdata_new = readdata;

/* Internal register update */
always @ (posedge clk or negedge reset_n)
	if (reset_n == 1'b0)
		begin
			scr			<= 32'd0;	
			load		<= 32'd0;
			readdata	<= 32'd0;
		end
	else 
		begin
			scr 	<= scr_new;
			load 	<= load_new;
		end
		
assign datard_o = readdata;



endmodule
