/*! 
 *  \file      ram_subcell.v
 *  \brief     RAM cell instance, uses feedback signal to perform read-modify-write operations
 *  \author    Luca Maggiani
 *  \version   1.0
 *  \date      Jan 2014
 *  \pre       It needs ram_module instances
 *  \see       ram_subcell
 *  \see       ram_module
 */


module ram_subcell(
	clk,
	reset_n,
	
	data_a,
	data_b,
	
	data_valid_in,
	
	address_a_valid,
		
	memory_clear,
	enable_wire,
	
	q_b,
	q_a,

	address_a,
	address_b

);

parameter HISTOGRAM_WIDTH = 16;
parameter HISTMEM_WORD = 1024;
localparam HISTMEM_ADDR_WIDTH = $clog2(HISTMEM_WORD);

localparam READ_STATE  = 2'b01;
localparam WRITE_STATE = 2'b10;

input clk, reset_n;

input [(HISTOGRAM_WIDTH-1):0] data_a, data_b;
input data_valid_in, memory_clear;

input address_a_valid;

input enable_wire;

output [(HISTOGRAM_WIDTH-1):0] q_a, q_b;

input [(HISTMEM_ADDR_WIDTH-1):0] address_a;

input [(HISTMEM_ADDR_WIDTH-1):0] address_b;

reg memory_clear_reg;

wire wren_a;
wire wren_b;
wire [(HISTOGRAM_WIDTH-1):0] ram_data_in;

reg [(HISTMEM_ADDR_WIDTH-1):0] address_a_reg;

reg [1:0] state, state_new;

/* ######################	
   #
   # FSM subcell control
   #
   ######################
*/

always@(posedge clk or negedge reset_n)
	if (reset_n == 1'b0)
		address_a_reg <= {HISTOGRAM_WIDTH{1'b0}};
	else 
		if (address_a_valid)
			address_a_reg <= address_a;
		else
			address_a_reg <= address_a_reg;

always@(posedge clk or negedge reset_n)
	if (reset_n == 1'b0)
		state <= READ_STATE;
	else 
		state <= state_new;
		

always@(*)
	case(state)
	READ_STATE:
		begin
			if (data_valid_in)
				state_new = WRITE_STATE;
			else 
				state_new = READ_STATE;
		end
	WRITE_STATE:
		begin
			state_new = READ_STATE;
		end
	default:
		state_new = READ_STATE;
	endcase
	
altsyncram	#(
		.address_reg_b("CLOCK0"),
		.clock_enable_input_a("NORMAL"),
		.clock_enable_input_b("NORMAL"),
		.clock_enable_output_a("NORMAL"),
		.clock_enable_output_b("NORMAL"),
		.indata_reg_b("CLOCK0"),
		.intended_device_family("Cyclone IV E"),
		.lpm_type("altsyncram"),
		.numwords_a(HISTMEM_WORD),
		.numwords_b(HISTMEM_WORD),
		.operation_mode("BIDIR_DUAL_PORT"),
		.outdata_aclr_a("NONE"),
		.outdata_aclr_b("NONE"),
		.outdata_reg_b("CLOCK0"),
		.power_up_uninitialized("FALSE"),
		.ram_block_type("M9K"),
		.read_during_write_mode_mixed_ports("OLD_DATA"),
		.widthad_a(HISTMEM_ADDR_WIDTH),
		.widthad_b(HISTMEM_ADDR_WIDTH),
		.width_a(HISTOGRAM_WIDTH),
		.width_b(HISTOGRAM_WIDTH),
		.width_byteena_a(1),
		.width_byteena_b(1),
		.wrcontrol_wraddress_reg_b("CLOCK0")	
)

ram_module_inst (
				.clock0 (clk),
				.wren_a (wren_a),
				.address_b (address_b),
				.clocken0 (enable_wire),
				.data_b (data_b),
				.wren_b (wren_b),
				.address_a (address_a_reg),
				.data_a (ram_data_in),
				.q_a (q_a),
				.q_b (q_b),
				.aclr0 (1'b0),
				.aclr1 (1'b0),
				.addressstall_a (1'b0),
				.addressstall_b (1'b0),
				.byteena_a (1'b1),
				.byteena_b (1'b1),
				.clock1 (1'b1),
				.clocken1 (1'b1),
				.clocken2 (1'b1),
				.clocken3 (1'b1),
				.eccstatus (),
				.rden_a (1'b1),
				.rden_b (1'b1)
		);
		

			
assign wren_a = (state == WRITE_STATE)? 1'b1: 1'b0;
assign wren_b = memory_clear;

			
assign ram_data_in = data_a + q_a;




endmodule


