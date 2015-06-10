module svmrow_mem(  
clk,
data,
reset_n,
dvi_in,
dvi_bypass,
svcoeff_in,
in_cv,

svcoeff_out,
out_cv,

/* For debugging purpose */
wincount,

download,
done,
svm_data,
dvo
);

parameter DWIDTH = 8;
parameter CWIDTH = 9;
parameter BLOCKSIZE = 32;
parameter WPI = 40;
parameter WINCOLS = 8;
parameter WINROWS = 16;

input clk;
input [DWIDTH-1:0] data;
input reset_n;
input dvi_in;
input in_cv;
input dvi_bypass;
input signed [CWIDTH-1:0] svcoeff_in;
output signed [CWIDTH-1:0] svcoeff_out;

output [$clog2(WPI)-1:0] wincount;
output download;

output [31:0] svm_data;
output dvo;
output done;
output out_cv;


/* Wire definitions */
wire signed [31:0] regout[(WINCOLS-1):0];

wire [CWIDTH-1:0] svfifo_chain [(WINCOLS-1):0];
wire [CWIDTH-1:0] first_svchain;
wire [CWIDTH-1:0] svcoeff [(WINCOLS-1):0]; 

wire [CWIDTH*WINCOLS-1:0] svcoeffparallel;

wire newblock;
wire newwin;
wire newrow;
wire download;

wire shift_nextstep;
wire svchainmux;
wire download_pulse;

/* Register definitions */
reg [$clog2(BLOCKSIZE)-1:0] dvcount;
reg [$clog2(WINCOLS)-1:0] blockcount;
reg [$clog2(WPI)-1:0] wincount;
reg [$clog2(WINROWS)-1:0] rowcount;
reg [(WINCOLS-1):0] dvi;

reg dvo_fsm, dvo_fsm_new;

reg [2:0] mux_d;

parameter S0 = 0;
parameter S1 = 1;
parameter S2 = 2;
parameter S3 = 3;
parameter S4 = 4;
parameter S5 = 5;
parameter S6 = 6;
parameter S7 = 7;
parameter STEADY = 8;
parameter S0R = 9;
parameter S1R = 10;
parameter S2R = 11;
parameter S3R = 12;
parameter S4R = 13;
parameter S5R = 14;
parameter S6R = 15;
parameter S7R = 16;
parameter DOWNLOAD = 17;

reg [4:0] fsm, fsm_new;

/* FSM counter */

/* dvcount */
always@(posedge clk or negedge reset_n)
	if (reset_n == 0)
		dvcount <= 0;
	else if ((newblock & dvi_in) | download)	
		dvcount <= 0;
	else if (dvi_in)
		dvcount <= dvcount + 1'b1;	
		
/* blockcount */	
/* L: added done gathing on data valid (17oct14) */
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
	else if ((newrow & dvi_in) | download)	
		wincount <= 0;
	else if (newwin & dvi_in)
		wincount <= wincount + 1'b1;	

/* rowcount */
/* L: added done gathing on data valid (17oct14) */
always@(posedge clk or negedge reset_n)	
	if (reset_n == 0)
		rowcount <= 0;
	else if (done & dvi_in)
			rowcount <= 0;
	else if (newrow & dvi_in)
		rowcount <= rowcount + 1'b1;
		
		
assign newblock = (dvcount == (BLOCKSIZE-1)) ? 1'b1 : 1'b0;
assign newwin  = (newblock && (blockcount == WINCOLS-1)) ? 1'b1 : 1'b0;
assign newrow = (newwin && (wincount == (WPI-1) ))? 1'b1 : 1'b0;
assign done = (newrow && (rowcount == (WINROWS-1)))  ? 1'b1 : 1'b0;

assign download = (fsm == DOWNLOAD);		

/* Download token generation */
reg [WINCOLS-1:0] download_token;
reg [31:0] download_control;
wire download_done;

/* ###### Data valid signal management ###### */
always@(posedge clk or negedge reset_n)
	if (reset_n == 0)
		fsm <= S0;
	else
		fsm <= fsm_new;
		
/* L: added dvi_bypass for lastrow process (17oct14) 
 *    dvi_bypass it is used to adapt the signal
 */
always@(*)
	case (fsm)
	S0: fsm_new = (newblock & dvi_in) ? S1 : S0;  
	S1: fsm_new = (newblock & dvi_in) ? S2 : S1; 
	S2: fsm_new = (newblock & dvi_in) ? S3 : S2; 
	S3: fsm_new = (newblock & dvi_in) ? S4 : S3; 
	S4: fsm_new = (newblock & dvi_in) ? S5 : S4; 
	S5: fsm_new = (newblock & dvi_in) ? S6 : S5; 
	S6: fsm_new = (newblock & dvi_in) ? S7 : S6; 
	S7: fsm_new = (newblock & dvi_in)   ? STEADY : S7; 
	STEADY: fsm_new = (done & dvi_in)   ? S0R : STEADY; 
	S0R: fsm_new = ((newblock & dvi_in) | dvi_bypass) ? S1R : S0R; 
	S1R: fsm_new = ((newblock & dvi_in) | dvi_bypass) ? S2R : S1R; 
	S2R: fsm_new = ((newblock & dvi_in) | dvi_bypass) ? S3R : S2R; 
	S3R: fsm_new = ((newblock & dvi_in) | dvi_bypass) ? S4R : S3R; 
	S4R: fsm_new = ((newblock & dvi_in) | dvi_bypass) ? S5R : S4R; 
	S5R: fsm_new = ((newblock & dvi_in) | dvi_bypass) ? S6R : S5R; 
	S6R: fsm_new = ((newblock & dvi_in) | dvi_bypass) ? S7R : S6R; 
	S7R: fsm_new = ((newblock & dvi_in) | dvi_bypass) ? DOWNLOAD : S7R; 
	DOWNLOAD: fsm_new = (download_done) ? S0 : DOWNLOAD; 
	
	default:
		fsm_new = S0;
	
	endcase

/* Data valid distribution
 * note: dvi_in is gated by dvdistrib signal. This is to stop the shift
 * operation during download. (Is this useless? to be checked)
*/	

/* L: added dvi_bypass for lastrow process (17oct14) */

/* TODO: find a more flexible method! */
always@(*)
	case(fsm)
		S0: 		dvi = 8'b00000001 & {8{dvi_in}};
		S1: 		dvi = 8'b00000011 & {8{dvi_in}};
		S2: 		dvi = 8'b00000111 & {8{dvi_in}};
		S3: 		dvi = 8'b00001111 & {8{dvi_in}};
		S4: 		dvi = 8'b00011111 & {8{dvi_in}};
		S5: 		dvi = 8'b00111111 & {8{dvi_in}};
		S6: 		dvi = 8'b01111111 & {8{dvi_in}};
		S7: 		dvi = 8'b11111111 & {8{dvi_in}};
		STEADY:		dvi = 8'b11111111 & {8{dvi_in}};
		S0R: 		dvi = 8'b11111110 & {8{dvi_in}};
		S1R: 		dvi = 8'b11111100 & {8{dvi_in}};
		S2R: 		dvi = 8'b11111000 & {8{dvi_in}};
		S3R: 		dvi = 8'b11110000 & {8{dvi_in}};
		S4R: 		dvi = 8'b11100000 & {8{dvi_in}};
		S5R: 		dvi = 8'b11000000 & {8{dvi_in}};
		S6R: 		dvi = 8'b10000000 & {8{dvi_in}};
		S7R: 		dvi = 8'b00000000 & {8{dvi_in}};
		DOWNLOAD:	dvi = 8'b00000000;
	default:
		dvi = 8'b00000000;	
	endcase


/* Coefficients loopback */
/* 22May15: removed newwin dependency on svchainmux */
assign svchainmux = (fsm == STEADY) && (wincount != 0);
assign first_svchain = ( svchainmux ) ? svcoeff_out : svcoeff_in;	

assign out_cv = (wincount == 0) && dvi_in;

/* shift_nextstep (data valid for the coefficient shift register) */
/* Note: this expects a dvi masked with the dvi_in signal */
assign shift_nextstep = in_cv | (dvi != 0) | ((fsm == S7R) & dvi_in);//(dvi != 0) | ((fsm == S7R) & dvi_in);

/* SV network distribution
 * generic altshift instantiation
 */

altshift_taps	
#(	.lpm_hint("RAM_BLOCK_TYPE=M9K"),
	.lpm_type("altshift_taps"),
	.number_of_taps(WINCOLS),
	.tap_distance(BLOCKSIZE),
	.width(CWIDTH)
)
coeff_shift_inst (
			.clock (clk),
			.clken (shift_nextstep),
			.shiftin (first_svchain),
			.shiftout (svcoeff_out),
			.taps (svcoeffparallel)
			// synopsys translate_off
			,
			.aclr (~reset_n)
			// synopsys translate_on
			);

genvar i;
generate
	for (i=0; i < WINCOLS; i = i+1)
		begin: svcoeff_gen  
			if (i == 0)
				assign svcoeff[i] = first_svchain;
			else
				assign svcoeff[i] = svcoeffparallel[i*9-1:(i-1)*9];
		end
endgenerate

/* Slice
 * generic slice_mem instantiation
 */

genvar index;  
generate  
    for (index=0; index < WINCOLS; index=index+1)  
      begin: slice_mem_gen  
		slice_mem #(	
			.DWIDTH(DWIDTH),
			.CWIDTH(CWIDTH),
			.BLOCKSIZE(BLOCKSIZE),
			.WINCOLS(WINCOLS),
			.WPI(WPI))
		slice_mem_inst (
		.clk(clk),
		.data(data),
		.reset_n(reset_n),
		.dvi(dvi[index]),
		.download(download_pulse),
		.svcoeff(svcoeff[index]),
		.msb(),
		.regout(regout[index]),
		.newblock(newblock)
		);
      end  
endgenerate  

/* Data valid output counter */			
always@(posedge clk or negedge reset_n)
	if (reset_n == 0)
		download_control <= 0;
	else
		if (download_done)
			download_control <= 0;
		else
			if (download) 
				download_control <= download_control + 1;
			else
				download_control <= download_control;			

assign download_done = (download_control == WINCOLS*WPI-WINCOLS);
	
assign download_pulse = (download_control[2:0] == 3'b0) && download;		

/* Data valid output fsm */
always@(posedge clk or negedge reset_n)
	if (reset_n == 0)
		dvo_fsm <= 0;
	else
		dvo_fsm <= dvo_fsm_new;
				
always@(*)
	case(dvo_fsm)
		1'd0:
			if (download == 1'b1)
				dvo_fsm_new = 1'd1;
			else
				dvo_fsm_new = dvo_fsm;
		1'd1:
			if (download == 1'b0)
				dvo_fsm_new = 1'd0;
			else
				dvo_fsm_new = dvo_fsm;
		default:
			dvo_fsm_new <= 1'd0;
	endcase
		

assign dvo = dvo_fsm;				
		
/* Output data control */
always@(posedge clk or negedge reset_n)
	if (reset_n == 0)
		mux_d <= 0;
	else
		mux_d <= download_control[2:0];

/* Output data multiplexer */
assign svm_data = regout[mux_d];


endmodule
