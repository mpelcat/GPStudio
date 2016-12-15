/*
 * CameraOneFrame architecture
 * 
 * Copyright (c) 2014, 
 *  Luca Maggiani <maggiani.luca@gmail.com>
 *  Scuola Superiore Sant'Anna (http://www.sssup.it) and
 *  Consorzio Nazionale Interuniversitario per le Telecomunicazioni
 *  (http://www.cnit.it).
 *
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are
 * met:
 * 
 * * Redistributions of source code must retain the above copyright
 *   notice, this list of conditions and the following disclaimer.
 * * Redistributions in binary form must reproduce the above
 *   copyright notice, this list of conditions and the following disclaimer
 *   in the documentation and/or other materials provided with the
 *   distribution.
 * * Neither the name of the  nor the names of its
 *   contributors may be used to endorse or promote products derived from
 *   this software without specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * 
 */

/*
 * eshift_reg module
 * Created by LMag 2013
 *
 * Enhanced Shift Register for GradientHW configuration
 * 
 *
 *  8Mag13 v1.0 - first release
 * 
 * 
 *
 * TO DO:
 *
 */	

module eshift_reg	(
		clk,
		clken,
		shiftin,
		shiftout,
		taps,
		aclr,
		
		res_config
		);
				
input	clk, clken, aclr;
input [7:0] shiftin;

output [7:0] shiftout, taps;

input [7:0] res_config;

parameter WIDTH_64   = 8'd0;
parameter WIDTH_128  = 8'd1;
parameter WIDTH_192  = 8'd2;
parameter WIDTH_256  = 8'd3;
parameter WIDTH_320  = 8'd4;
parameter WIDTH_640  = 8'd5;
parameter WIDTH_960  = 8'd6;
parameter WIDTH_1280  = 8'd7;


/* ############################################# */	
/*    Power management HDL - work in progress    */
/* ############################################# */
	
wire clken0, clken1, clken2, clken3, clken4, clken5, clken6, clken7;
//reg clken0, clken1, clken2, clken3, clken4;

// testing code
//assign clken0 = clken;
//assign clken1 = (res_config > WIDTH_64) ? clken : 1'b0;
//assign clken2 = (res_config > WIDTH_128) ? clken : 1'b0;
//assign clken3 = (res_config > WIDTH_192) ? clken : 1'b0;
//assign clken4 = (res_config > WIDTH_256) ? clken : 1'b0;

assign clken0 = clken;	
assign clken1 = clken;	
assign clken2 = clken;	
assign clken3 = clken;	
assign clken4 = clken;	
assign clken5 = clken;	
assign clken6 = clken;	
assign clken7 = clken;	


/* ############################################# */
/* ######## Shift multiplex controller ######### */
/* ############################################# */

wire [7:0] in0, in1, in2, in3, in4, in5, in6, in7;
wire [7:0] out0, out1, out2, out3, out4, out5, out6, out7;

assign in0 = shiftin;

reg [7:0] shiftout;
always@(*)
	begin
		case(res_config)
			WIDTH_64:  shiftout = out0;
			WIDTH_128: shiftout = out1;
			WIDTH_192: shiftout = out2;
			WIDTH_256: shiftout = out3;
			WIDTH_320: shiftout = out4;
			WIDTH_640: shiftout = out5;
			WIDTH_960: shiftout = out6;
			WIDTH_1280: shiftout = out7;
			
			default:
				shiftout = 8'd0;
		endcase
	end
	
assign in1 = out0;	
assign in2 = out1;	
assign in3 = out2;	
assign in4 = out3;	
assign in5 = out4;	
assign in6 = out5;	
assign in7 = out6;	

/*#############################################*/

	
	altshift_taps	
	#(
		.lpm_hint("RAM_BLOCK_TYPE=M9K"),
		.lpm_type("altshift_taps"),
		.number_of_taps(1),
		.tap_distance(61),
		.width(8)
		
	)	altshift_taps_inst_0 (
				.clock (clk),
				.clken (clken0),
				.shiftin (in0),
				.shiftout (out0),
				.taps ()
				// synopsys translate_off
				,
				.aclr ()
				// synopsys translate_on
				);
	
	altshift_taps	
	#(
		.lpm_hint("RAM_BLOCK_TYPE=M9K"),
		.lpm_type("altshift_taps"),
		.number_of_taps(1),
		.tap_distance(64),
		.width(8)		
		
	)	altshift_taps_inst_1 (
		.clock (clk),
		.clken (clken1),
		.shiftin (in1),
		.shiftout (out1),
		.taps ()
		// synopsys translate_off
		,
		.aclr ()
		// synopsys translate_on
		);	
		
	altshift_taps	
	#(
		.lpm_hint("RAM_BLOCK_TYPE=M9K"),
		.lpm_type("altshift_taps"),
		.number_of_taps(1),
		.tap_distance(64),
		.width(8)	
		
	)	altshift_taps_inst_2 (
		.clock (clk),
		.clken (clken2),
		.shiftin (in2),
		.shiftout (out2),
		.taps ()
		// synopsys translate_off
		,
		.aclr ()
		// synopsys translate_on
		);


	altshift_taps 
	#(
		.lpm_hint("RAM_BLOCK_TYPE=M9K"),
		.lpm_type("altshift_taps"),
		.number_of_taps(1),
		.tap_distance(64),
		.width(8)
	
	)	altshift_taps_inst_3 (
		.clock (clk),
		.clken (clken3),
		.shiftin (in3),
		.shiftout (out3),
		.taps ()
		// synopsys translate_off
		,
		.aclr ()
		// synopsys translate_on
		);



	altshift_taps	
	#(
		.lpm_hint("RAM_BLOCK_TYPE=M9K"),
		.lpm_type("altshift_taps"),
		.number_of_taps(1),
		.tap_distance(64),
		.width(8)
	
	)	altshift_taps_inst_4 (
		.clock (clk),
		.clken (clken4),
		.shiftin (in4),
		.shiftout (out4),
		.taps ()
		// synopsys translate_off
		,
		.aclr ()
		// synopsys translate_on
		);
		
	altshift_taps	
	#(
		.lpm_hint("RAM_BLOCK_TYPE=M9K"),
		.lpm_type("altshift_taps"),
		.number_of_taps(1),
		.tap_distance(320),
		.width(8)
	
	)	altshift_taps_inst_5 (
		.clock (clk),
		.clken (clken5),
		.shiftin (in5),
		.shiftout (out5),
		.taps ()
		// synopsys translate_off
		,
		.aclr ()
		// synopsys translate_on
		);
		
	altshift_taps
	#(
		.lpm_hint("RAM_BLOCK_TYPE=M9K"),
		.lpm_type("altshift_taps"),
		.number_of_taps(1),
		.tap_distance(320),
		.width(8)
	
	)	altshift_taps_inst_6 (
		.clock (clk),
		.clken (clken6),
		.shiftin (in6),
		.shiftout (out6),
		.taps ()
		// synopsys translate_off
		,
		.aclr ()
		// synopsys translate_on
		);
		
	altshift_taps	
	#(
		.lpm_hint("RAM_BLOCK_TYPE=M9K"),
		.lpm_type("altshift_taps"),
		.number_of_taps(1),
		.tap_distance(320),
		.width(8)
	
	)	altshift_taps_inst_7 (
		.clock (clk),
		.clken (clken7),
		.shiftin (in7),
		.shiftout (out7),
		.taps ()
		// synopsys translate_off
		,
		.aclr ()
		// synopsys translate_on
		);

		
endmodule
