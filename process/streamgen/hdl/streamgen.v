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
 * StreamGen module
 * Created by LMag 2013
 *
 * Stream Generator from an Avalon-MM location
 *
 *
 *   9Dic13 v0.1 - first release
 *
 * TO DO:
 * 
 * 
 *
 */

module streamgen(
	clk_proc,
	reset_n,
	
	//Data output
	out_fv,
	out_dv,
	out_data,
	
	//Avalon-MM inputs
	addr_rel_i,
	wr_i,
	datawr_i,
	rd_i,
	
	//Avalon-MM outputs
	datard_o
	
);

parameter OUT_WIDTH = 16;

input clk_proc;
input reset_n;

input addr_rel_i;
input [31:0] datawr_i; 
input wr_i;
input rd_i;

output [31:0] datard_o;

output out_fv;
output out_dv;
output [OUT_WIDTH-1:0] out_data;

reg [31:0] length, length_new;
reg [OUT_WIDTH-1:0] dr, dr_new;

reg readdata, readdata_new;

reg [OUT_WIDTH-1:0] out_data_r;		
reg out_dv_r;
reg state, state_new;

reg [31:0] count;

wire done;

wire init_counter;
wire newdata;

/*	###### Register map ######

	data		R/W
	
   31                            0
    -----------------------------
	|           length          |
	-----------------------------
	-----------------------------
	|           dr              |
	-----------------------------
	
*/

/*	Write operation	*/
always @ (*)
	if (wr_i)
		case(addr_rel_i)
			1'b0:
				begin
					length_new = datawr_i;
					dr_new = dr;
				end
			1'b1:
				begin
					length_new = length;
					dr_new = datawr_i;
				end
			default:
				begin
					length_new = length;
					dr_new = dr;
				end
		endcase
	else	/*	write does not enabled	*/
		begin
			length_new = length;
			dr_new = dr;
		end
		
	
/*	Read operation	*/	
always @ (*)
	if (rd_i)
		case(addr_rel_i)
			1'b0:	readdata_new = length;
			1'b1:	readdata_new = dr;
			default:
				readdata_new = readdata;
		endcase
	else 
		readdata_new = readdata;
		

/* Internal register */
always @ (posedge clk_proc or negedge reset_n)
	if (reset_n == 1'b0)
		begin
			length	<= 32'd76800;
			dr		<= 32'd0;
			readdata<= 32'b0;
		end
	else 
		begin
			length		<= length_new;
			dr		<= dr_new;
			readdata<= readdata_new;
		end
		
/* Control FSM */		
localparam INIT_STATE = 1'b0;
localparam SEND_STATE = 1'b1;

always @ (posedge clk_proc or negedge reset_n)
	if (reset_n == 1'b0)
		state <= INIT_STATE;
	else
		state <= state_new;


assign init_counter = (wr_i == 1'b1) && (addr_rel_i == 1'b0);
assign newdata = (wr_i == 1'b1) && (addr_rel_i == 1'b1);

always@(*)
	case(state)
	INIT_STATE:
		if(newdata)
			state_new = SEND_STATE;
		else
			state_new = INIT_STATE;
	SEND_STATE:
		if (init_counter || (count == 0 & ~newdata))
			state_new = INIT_STATE;
		else
			state_new = SEND_STATE;
	endcase
	
/* Internal counter */	
assign done = (count == 0);

always @ (posedge clk_proc or negedge reset_n)
	if (reset_n == 1'b0)	
		count <= length;
	else
		if(init_counter)
			count <= datawr_i;
		else if (done)
			count <= length;
		else
			if(newdata)
				count <= count - 1'b1;
			else
				count <= count;

/* Output signals */	
always @ (posedge clk_proc or negedge reset_n)
	if (reset_n == 1'b0)	
		out_dv_r <= 0;
	else
		out_dv_r <= newdata;

assign out_fv = (state == SEND_STATE);
assign out_dv = out_dv_r;
assign out_data = dr;

assign datard_o = readdata;		
		
endmodule
