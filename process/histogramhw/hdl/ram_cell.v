/*! 
 *  \file      ram_cell.v
 *  \brief     Configurable Histogram Cell instance (as part of the HistogramHW module)
 *  \details   This module computes Histograms over a line of pixel cells.
 *  \author    Luca Maggiani
 *  \version   1.0
 *  \date      Jan 2014
 *  \pre       It needs ram_subcell and ram_module instances
 *  \param[in] data_in, dir_max, data_valid_in
 *  \param[out] data_out, data_valid_out
 *  \todo      Why it does not work on odd cell width???
 *  \todo      Different reset_n handling (could onoff signal be a reset 
 *             trigger? (as an onoff_n signal)
 *  \todo      32bit RAM extension (and data bus as well)
 *  \see       ram_subcell
 *  \see       ram_module
 */

module ram_cell(
	clk,
	reset_n,
		
	data_in,
	dir_max,
	data_valid_in,
	
	data_out,
	data_valid_out,
	
	cellwidth,
	cellinrow,
	cellheight,
	storecycles,
	
	onoff,
	mode,
	n_bin_exp,
	
	newcell_signal,
	newline_signal,
	loadcompleted,
	storecompleted,
	
	count_store_int,
	address_a_int
);

parameter HISTOGRAM_WIDTH = 16;
parameter HISTMEM_WORD = 1024;
localparam HISTMEM_ADDR_WIDTH = $clog2(HISTMEM_WORD);



input clk, reset_n;

input [15:0] data_in;
input [7:0] dir_max;
input data_valid_in;

//% \brief cell width (in pixel) minus 1
input [9:0] cellwidth;

//% \brief number of cells in a complete frame row minus 1
input [9:0] cellinrow;

//% \brief cell height (in pixel) minus 1
input [9:0] cellheight;


//% \brief number of data_valid_out pulse during store phase
//% storecycles could be computed as: 
//% \f[ store\_cycles = \frac{RAM\_WIDTH}{2^{n\_bin\_exp}}   \f]
//% where: 
//% - n_bin_exp input parameter
//% - RAM_WIDTH number of memory location (now is fixed to 1024)
//% 
input [15:0] storecycles;

//% \brief Activation signal 
//% onoff = 1 means active
//% onoff = 0 means not active
input onoff;

//% \brief Operation mode configuration
//% - mode = 0 means \a Luminance histogram
//% - mode = 1 means \a Gradient histogram 
input mode;

//% \brief Number of Bins
//% Accepted values are:
//% - n_bin_exp = 2
//% - n_bin_exp = 3
//% - n_bin_exp = 4 which means \f$ 2^4 \f$ bins
input [3:0] n_bin_exp;

//% \todo 32bit extension for luminance histogram
output [(HISTOGRAM_WIDTH-1):0] data_out;

//% asserted when valid data are sent to output
output data_valid_out;

output newcell_signal;
output newline_signal;
output loadcompleted;
output storecompleted;

output [15:0] count_store_int;
output [(HISTMEM_ADDR_WIDTH-1):0] address_a_int;

/*! @brief Memory address LSBs
 *  @detail These signals point the current memory location
 *          according to the mode configuration 
 *  @{
 */
reg [7:0] address_lowbits, address_lowbits_new;
/*! @} */

reg [(HISTMEM_ADDR_WIDTH-1):0] address_a;
reg [(HISTOGRAM_WIDTH-1):0] data_a;
reg [(HISTOGRAM_WIDTH-1):0] data_a_d1;
reg data_valid_in_msk;

/*! @brief Internal registers
 *  @{
 */
reg [9:0] count_cellwidth;
reg [9:0] count_cellinrow;
reg [9:0] count_cellheight;
wire [15:0] count_store;
//! @}

//~ reg loadcompleted_d1;

/*! @brief Data valid signal to subcells
 *  @{
 */
reg data_valid_subcell_0, data_valid_subcell_1; 
//! @}

reg [3:0] store_fsm, store_fsm_new;

/*! @brief count_store register extended by 1bit
 *  @details It is used during the store phase to perform a 2cycles 
 *           store and clean operation
 *  @{
 */
reg [15+1:0] count_store_extended;
//! @}

//% \brief It acts as a subcell trigger
reg active_cell;

/*! @brief It represents the count_store_extended LSB.
 *  @{
 */
wire store_clean_state;
//! @}

//% Asserted during switch to another cell
wire newcell_signal;
//% Asserted when an image line has been scanned (and resets count_cellwidth)
wire newline_signal;
//% Asserted when the load phase is completed
wire loadcompleted;
//% Asserted when the store phase is completed
wire storecompleted;

wire [(HISTOGRAM_WIDTH-1):0] q_b_subcell_0, q_b_subcell_1;
wire clear_signal;

localparam START_STATE = 4'b0001;
localparam WAIT_MEM    = 4'b0010;
localparam WORK_STATE  = 4'b0100;
localparam END_STATE   = 4'b1000;


// keep in mind!
// mode = 0 luminance
// mode = 1 hog

//%
//% address_lowbits_new
//% 
always@(*)
	case (mode)
		1'b0: address_lowbits_new[7:0] = data_in[7:0];
		1'b1: address_lowbits_new[7:0] = dir_max[7:0];
		default:
			address_lowbits_new[7:0] = data_in[7:0];
	endcase
		
//%
//% address_lowbits
//%	
always@(posedge clk or negedge reset_n)
	if (reset_n == 0)
		address_lowbits <= 8'b0;
	else
		address_lowbits <= address_lowbits_new;

//%
//% address_a
//%
always@(*)
	case (n_bin_exp)
		// 4 bins
		4'd2: address_a = {count_cellinrow[(HISTMEM_ADDR_WIDTH-1)-2:0], address_lowbits[1:0]};
		// 8 bins
		4'd3: address_a = {count_cellinrow[(HISTMEM_ADDR_WIDTH-1)-3:0], address_lowbits[2:0]};
		// 16 bins
		4'd4: address_a = {count_cellinrow[(HISTMEM_ADDR_WIDTH-1)-4:0], address_lowbits[3:0]};
		// 256 bins
		4'd8: address_a = {count_cellinrow[(HISTMEM_ADDR_WIDTH-1)-8:0], address_lowbits[7:0]};
	default:
		//% 16 bins default
		address_a = {count_cellinrow[(HISTMEM_ADDR_WIDTH-1)-4:0], address_lowbits[3:0]};
	endcase

//%
//% data_valid_in_msk
//%			
always@(posedge clk or negedge reset_n)
	if (reset_n == 0)
		data_valid_in_msk <= 1'b0;
	else
		data_valid_in_msk <= data_valid_in & onoff;

//%
//% data_a
//%
always@(posedge clk or negedge reset_n)
	if (reset_n == 0)
		data_a <= {HISTOGRAM_WIDTH{1'b0}};
	else
		data_a <= (mode == 1) ? data_in : 1; 
//%
//% data_a_d1
//%
always@(posedge clk or negedge reset_n)
	if (reset_n == 0)
		data_a_d1 <= {HISTOGRAM_WIDTH{1'b0}};
	else
		data_a_d1 <= data_a; 
		
		
//%
//% active_cell
//%
always@(posedge clk or negedge reset_n)
	if (reset_n == 1'b0)
		active_cell = 1'b0;
	else
		if (data_valid_in_msk)
			active_cell <= ~active_cell;
		else
			active_cell <= active_cell;

//%
//% data_valid_subcell_0
//%
always@(posedge clk or negedge reset_n)
	if (reset_n == 0)
		data_valid_subcell_0 <= 1'b0;
	 else
		data_valid_subcell_0 <= data_valid_in_msk & ~active_cell;//~count_cellwidth[0];
	
//%
//% data_valid_subcell_1
//%
always@(posedge clk or negedge reset_n)
	if (reset_n == 0)
		data_valid_subcell_1 <= 1'b0;
	else
		data_valid_subcell_1 <= data_valid_in_msk & active_cell;//count_cellwidth[0];

//%
//% newcell_signal
//%
assign newcell_signal = (count_cellwidth == cellwidth) 
                        && data_valid_in_msk;

//%
//% count_cellwidth
//%
always@(posedge clk or negedge reset_n)
	if (reset_n == 0)
		count_cellwidth <= 10'b0;
	else
		if (onoff == 0)
			count_cellwidth <= 10'b0;
		else
			if (newcell_signal)
				count_cellwidth <= 10'b0;
			else
				if (data_valid_in_msk)
					count_cellwidth <= count_cellwidth + 1;
				else
					count_cellwidth <= count_cellwidth;
//%
//% newline_signal
//%
assign newline_signal = (count_cellinrow == cellinrow) 
                        && (count_cellwidth == cellwidth) 
                        && data_valid_in_msk;

//%
//% count_cellinrow
//%
always@(posedge clk or negedge reset_n)
	if (reset_n == 0)
		count_cellinrow <= 10'b0;
	else
		if (onoff == 0)
			count_cellinrow <= 10'b0;
		else
			if (newline_signal)
				count_cellinrow <= 10'b0;
			else
				if (newcell_signal)
					count_cellinrow <= count_cellinrow + 1;
				else
					count_cellinrow <= count_cellinrow;

//%
//% loadcompleted
//%
assign loadcompleted = (count_cellheight == cellheight) 
                       && (count_cellinrow == cellinrow) 
                       && (count_cellwidth == cellwidth) 
                       && data_valid_in_msk;

//%
//% count_cellheight
//%
always@(posedge clk or negedge reset_n)
	if (reset_n == 0)
		count_cellheight <= 10'd0;
	else
		if (onoff == 0)
			count_cellheight <= 10'd0;
		else
			if (loadcompleted)
				count_cellheight <= 10'd0;
			else
				if (newline_signal)
					count_cellheight <= count_cellheight + 1;
				else
					count_cellheight <= count_cellheight;
		
//% 
//% loadcompleted_d1
//%	acts as a store phase delay (useful on a one cell histogram test)
//% 		
//~ always@(posedge clk or negedge reset_n)
	//~ if (reset_n == 0)
		//~ loadcompleted_d1 <= 0;
	//~ else
		//~ loadcompleted_d1 <= loadcompleted;
					
//% 
//% store_fsm
//%					
always@(posedge clk or negedge reset_n)
	if (reset_n == 0)
		store_fsm <= START_STATE;
	else
		store_fsm <= store_fsm_new;
		
//%
//% store_fsm_new
//%
always@(*)
	case (store_fsm)
	START_STATE:
		if (onoff == 1'b0)
			store_fsm_new = START_STATE;
		else
			if (loadcompleted)
				store_fsm_new = WAIT_MEM;
			else
				store_fsm_new = START_STATE;
	WAIT_MEM:
		if (onoff == 1'b0)
			store_fsm_new = START_STATE;
		else
			store_fsm_new = WORK_STATE;
	WORK_STATE:
		if (onoff == 1'b0)
			store_fsm_new = START_STATE;
		else
			if (storecompleted)
				store_fsm_new = END_STATE;
			else
				store_fsm_new = WORK_STATE;
	END_STATE:
		store_fsm_new = START_STATE;
	endcase
	
//%
//% store_clean_state
//%
assign store_clean_state = count_store_extended[0];
/*
always@(posedge clk or negedge reset_n)
	if (reset_n == 0)
		store_clean_state <= 1'b0;
	else
		if (onoff == 0)
			store_clean_state <= 1'b0;
		else
			if ((store_fsm == WORK_STATE) || (store_fsm == WAIT_MEM))
				store_clean_state <= ~store_clean_state;
			else
				store_clean_state <= store_clean_state;
*/

//%
//% storecompleted
//% asserted when the store_fsm has completed
assign storecompleted = (count_store == storecycles);

//%
//% count_store
//%

assign count_store = count_store_extended[16:1];

/*
always@(posedge clk or negedge reset_n)
	if (reset_n == 0)
		count_store <= 16'd0;
	else
		if (onoff == 0)
			count_store <= 16'b0;
		else
			if (storecompleted)
				count_store <= 16'b0;
			else
				count_store <= count_store + store_clean_state;
*/

//%
//% count_store_extended
//%
always@(posedge clk or negedge reset_n)
	if (reset_n == 0)
		count_store_extended <= 17'd0;
	else
		if (onoff == 0)
			count_store_extended <= 17'd0;
		else
			if (storecompleted)
				count_store_extended <= 17'd0;
			else
				if ((store_fsm == WORK_STATE) || (store_fsm == WAIT_MEM))
					count_store_extended <= count_store_extended + 1'b1;
				else
					count_store_extended <= count_store_extended;


//%
//% data_valid_out
//%				
assign data_valid_out = ~store_clean_state && (store_fsm == WORK_STATE); 

//%
//% data_out
//%
assign data_out = q_b_subcell_0 + q_b_subcell_1;
			
//%
//% clear_signal
//%
assign clear_signal = (store_clean_state == 1'b1);		

assign count_store_int = count_store;
assign address_a_int = address_a;
		
ram_subcell 
	#(	.HISTMEM_WORD(HISTMEM_WORD),
		.HISTOGRAM_WIDTH(HISTOGRAM_WIDTH) )
		
	ram_subcell_0 (
	.clk(clk),
	.reset_n(reset_n),
	
	.data_a(data_a_d1),
	.data_b({HISTOGRAM_WIDTH{1'b0}}),
	
	.data_valid_in(data_valid_subcell_0),
	
	.address_a_valid(~active_cell),
		
	.memory_clear(clear_signal),
	.enable_wire(onoff),
	
	.q_b(q_b_subcell_0),
	.q_a(),

	.address_a(address_a),
	.address_b(count_store[(HISTMEM_ADDR_WIDTH-1):0])
);

ram_subcell 
	#(	.HISTMEM_WORD(HISTMEM_WORD),
		.HISTOGRAM_WIDTH(HISTOGRAM_WIDTH) )
		
	ram_subcell_1 (
	.clk(clk),
	.reset_n(reset_n),
	
	.data_a(data_a_d1),
	.data_b({HISTOGRAM_WIDTH{1'b0}}),
	
	.data_valid_in(data_valid_subcell_1),
	
	.address_a_valid(active_cell),
		
	.memory_clear(clear_signal),
	.enable_wire(onoff),
	
	.q_b(q_b_subcell_1),
	.q_a(),

	.address_a(address_a),
	.address_b(count_store[(HISTMEM_ADDR_WIDTH-1):0])
);

endmodule


