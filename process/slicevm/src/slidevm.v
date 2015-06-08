module slidevm(  
clk,
reset_n,

data,
dvi_in,
in_fv,
svcoeff_in,
svcoeff_out,

wincount,
slide_data,
dvo
);

/* Default parameters */
parameter DWIDTH = 8;
parameter CWIDTH = 9;
parameter BLOCKSIZE = 16;
parameter BPW = 8;
parameter WPI = 40;
parameter WINCOLS = 8;
parameter WINROWS = 16;
parameter HPI = 20;

input clk;
input [DWIDTH-1:0] data;
input reset_n;
input dvi_in;
input signed [CWIDTH-1:0] svcoeff_in;
input in_fv;

output signed [CWIDTH-1:0] svcoeff_out;
output [$clog2(WPI)-1:0] wincount;
output [31:0] slide_data;
output dvo;

/* Wire definitions */
wire done;
wire newblock;
wire newwin;
wire newrow;
wire lastimagerow;
wire [WINROWS:0] download;
wire [WINROWS:0] dvo_row;
wire [31:0] svmrow_data [WINROWS:0];
wire dvo_int;
wire dvo_int_negedge;

/* Register definitions */
reg [$clog2(BLOCKSIZE)-1:0] dvcount;
reg [$clog2(WINCOLS)-1:0] blockcount;
reg [$clog2(WPI)-1:0] wincount;
reg [$clog2(WINROWS+HPI)-1:0] hrowcount;
reg [WINROWS:0] token;
reg [$clog2(WINROWS):0] outcontrol;
reg lir_token;
reg [$clog2(WINROWS+1):0] token_counter;
reg fsm_coeff, fsm_coeff_new;
reg dvo_int_d;
reg [$clog2(HPI)-1:0] outrow_count;


/* FSM counter */


/* dvcount */
always@(posedge clk or negedge reset_n)
	if (reset_n == 0)
		dvcount <= 0;
	else if (newblock & dvi_in)	
		dvcount <= 0;
	else if (dvi_in)
		dvcount <= dvcount + 1'b1;	
		
/* blockcount */		
always@(posedge clk or negedge reset_n)
	if (reset_n == 0)
		blockcount <= 0;
	else if (newwin & dvi_in)
		blockcount <= 0;
	else if (newblock & dvi_in)
		blockcount <= blockcount + 1'b1;			

/* wincount */
always@(posedge clk or negedge reset_n)
	if (reset_n == 0)
		wincount <= 0;
	else if (newrow & dvi_in)	
		wincount <= 0;
	else if (newwin & dvi_in)
		wincount <= wincount + 1'b1;	

/* hrowcount */
always@(posedge clk or negedge reset_n)	
	if (reset_n == 0)
		hrowcount <= 0;
	//~ else if (lastimagerow & dvi_in)
			//~ rowcount <= 0;
	else if (newrow & dvi_in)
		hrowcount <= hrowcount + 1'b1;
		
		
assign newblock = ((dvcount == (BLOCKSIZE-1))) ? 1'b1 : 1'b0;
assign newwin  = (newblock && (blockcount == BPW-1)) ? 1'b1 : 1'b0;
assign newrow = (newwin && (wincount == (WPI-1) ))? 1'b1 : 1'b0;
//~ assign lastimagerow = ( newrow && (rowcount == HPI-1)) ? 1'b1 : 1'b0;
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

assign bypass = (bypass_count < WINCOLS) && (in_fv == 0);			

		

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
 *      TODO: modify effect of lastimagerow!
 *            SlideVM should act as a close cycle machine  
 *
 */

genvar ti;
generate
for(ti=0; ti < (WINROWS+1); ti=ti+1)
	begin: token_gen
	always@(posedge clk or negedge reset_n)
		if (reset_n == 0)
			token[ti] <= (ti==0) ? 1'b1 : 1'b0;
		//~ else if (lastimagerow && dvi_in)
			//~ token[0] <= 1'b1; /* TODO: to be connected also to frame valid! */
		else if (download[ti])
			token[ti] <= 1'b0;
		else if (	newrow 
					//&& (hrowcount < HPI-1) 
					//&& ((ti == 0)? (hrowcount[$clog2(WINROWS)-1:0] == {WINROWS{1'b1}}) : (hrowcount[$clog2(WINROWS)-1:0] == (ti-1)) )
					//&& (hrowcount[$clog2(WINROWS+1)-1:0] == )
					&& (token_counter == ti)
					&& dvi_in)
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
		else if (newrow & dvi_in)
			token_counter <= token_counter + 1;

/* Input coeff mux control */
always@(posedge clk or negedge reset_n)
	if (reset_n == 0)
		fsm_coeff <= 1'b1;
	else
		fsm_coeff <= fsm_coeff_new;
		
always@(*)
	case(fsm_coeff)
		1'b0:
			fsm_coeff_new = fsm_coeff;	
		1'b1:
			if(token[0] == 1'b0)
				fsm_coeff_new = 1'b0;
			else
				fsm_coeff_new = 1'b1;
				
		default:
			fsm_coeff_new = 1'b1;
	endcase

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
		.data(data),
		.reset_n(reset_n),
		.dvi_in(token[index] & dvi_in),
		.dvi_bypass(bypass),
		.svcoeff_in((index==0) ? ( (fsm_coeff) ? svcoeff_in : svcoeff_chain[WINROWS]) : svcoeff_chain[index-1]),
		.svcoeff_out(svcoeff_chain[index]),
		.wincount(),
		.download(download[index]),
		.done(),
		.svm_data(svmrow_data[index]),
		.dvo(dvo_row[index])
		);
	end
endgenerate

/* Output multiplexing */
assign dvo_int = dvo_row[outcontrol];

always@(posedge clk or negedge reset_n)
	if (reset_n == 0)
		dvo_int_d <= 1'b0;
	else
		dvo_int_d <= dvo_int;

assign dvo_int_negedge = ~dvo_int & dvo_int_d;

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


assign dvo = (outrow_count < HPI-WINROWS+1) ? dvo_row[outcontrol] : 1'b0;

assign slide_data = svmrow_data[outcontrol];

assign svcoeff_out = svcoeff_chain[WINROWS];




endmodule
