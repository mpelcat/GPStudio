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
 * StreamStore module
 * Created by Altera, modified by LMag 2012
 *
 * Stream converter to Avalon-MM bus
 *
 *
 * 30May12 v1.0 - first release, it uses a DCFIFO
 * 30Nov12 v2.0 - subtituted DCFIFO with a SCFIFO, major revision v2.0
 *  9Dic12 v2.3 - as before, introduced a synchronous reset of output register
 *   Mar13 v2.4 - configurable bus width				
 * 20Apr13 v3.0 - Major release, now has also an Avalon-MM Slave interface
 *                Pay attention on control_go!
 * 16May13 v3.1 - removed write_s signal and consequently the wr_i latency of 1 cycle on SoPC Builder
 * 20Nov13 v3.2 - added buffer_ovf_cnt, included user_buffer_empty check before rising control_done
 * 13Dic13 v3.3 - FIFO wrreq gating when control_done is high (avoid length underflow)
 *  4Mar14 v3.4 - added interrupt interface for control_done signal, minor code revision
 * 28Apr14 v3.4 - interrupt clear bug! (it should check addr_rel_i inspite of address!)
 *
 * TO DO:
 * 
 * 
 *
 */

// altera message_off 10230

module streamstore (

	//input
	clk_proc,
	reset_n,
	
	// user logic inputs and outputs
	in_dv,
	in_data,
	
	//  Avalon-MM Master interface
	master_address,
	master_write,
	master_byteenable,
	master_writedata,
	master_waitrequest,
	
	// Avalon-MM Slave interface
	addr_rel_i, 
	wr_i,
	datawr_i,
	rd_i,
	datard_o,
	
	irq_done
);

	parameter DATAWIDTH = 8;
	parameter BYTEENABLEWIDTH = 1;
	parameter ADDRESSWIDTH = 32;
	
	input clk_proc;
	input reset_n;
	
	wire control_done;

	wire control_fixed_location;
	assign control_fixed_location = scr[1];
	
	/*	Control go signal generation	*/
	reg control_go_tmp;
	always@(posedge clk_proc or negedge reset_n)
		if (reset_n == 1'b0)
			control_go_tmp <= 1'b0;
		else
			control_go_tmp <= scr[0];
		
	wire control_go;	
	assign control_go = ~control_go_tmp & scr[0];
	
	/*	Control done pulse generation	*/
	reg control_done_d1;
	always@(posedge clk_proc or negedge reset_n)
		if (reset_n == 1'b0)
			control_done_d1 <= 1'b0;
		else
			control_done_d1 <= control_done;
		
	wire control_done_pulse;	
	assign control_done_pulse = ~control_done_d1 & control_done;

	
	// user logic inputs and outputs
	input in_dv;
	input [DATAWIDTH-1:0] in_data;
	wire user_buffer_full;
	
	// master inputs and outputs
	input master_waitrequest;
	output wire [31:0] master_address;
	output wire master_write;
	output wire [BYTEENABLEWIDTH-1:0]master_byteenable;
	output wire [DATAWIDTH-1:0] master_writedata;
	
	//Avalon-MM interface
	input	[2:0] addr_rel_i; 
	input 	wr_i, rd_i;
	input [31:0] datawr_i;
	output [31:0]	datard_o;
	output irq_done;

	// internal control signals
	reg control_fixed_location_d1;
	reg [31:0] address;  // this increments for each word
	reg [31:0] length;
	wire increment_address;  // this increments the 'address' register when wr_i is asserted and waitrequest is de-asserted
	wire read_fifo;
    wire user_buffer_empty;

	reg done_int_flag;

	// registering the control_fixed_location bit
	always @ (posedge clk_proc or negedge reset_n)
	begin
		if (reset_n == 1'b0)
		begin
			control_fixed_location_d1 <= 0;
		end
		else
		begin
			if (control_go == 1)
			begin
				control_fixed_location_d1 <= control_fixed_location;
			end
		end
	end



	// master word increment counter
	always @ (posedge clk_proc or negedge reset_n)
	begin
		if (reset_n == 1'b0)
		begin
			address <= 0;
		end
		else
		begin
			if (control_go == 1)
			begin
				address <= control_write_base;
			end
			else if ((increment_address == 1) & (control_fixed_location_d1 == 0))
			begin
				address <= address + BYTEENABLEWIDTH;  // always performing word size accesses
			end
		end
	end


	// master length logic
	always @ (posedge clk_proc or negedge reset_n)
	begin
		if (reset_n == 1'b0)
		begin
			length <= 0;
		end
		else
		begin
			if (control_go == 1)
			begin
				length <= control_write_length;
			end
			else if (increment_address == 1)
			begin
				length <= length - BYTEENABLEWIDTH;  // always performing word size accesses
			end
		end
	end



	// controlled signals going to the master/control ports
	assign master_address = address;
	assign master_byteenable = -1;  // all ones, always performing word size accesses
	assign control_done = (length == 0) & (user_buffer_empty == 1);
	assign master_write = (user_buffer_empty == 0) & (control_done == 0);

	assign increment_address = (user_buffer_empty == 0) & (master_waitrequest == 0) & (control_done == 0);
	assign read_fifo = increment_address;
	
	scfifo scfifo_component (
		.sclr(control_go),
		.aclr (~reset_n),
		.clock (clk_proc),
		.data (in_data),
		.full (user_buffer_full),
		.empty (user_buffer_empty),
		.q (master_writedata),
		.rdreq (read_fifo),
		.wrreq (in_dv & (control_done == 0))
	);
		//defparam scfifo_component.intended_device_family = "Cyclone IV E";
		defparam scfifo_component.lpm_width = DATAWIDTH;
		defparam scfifo_component.lpm_numwords = 1024;
		defparam scfifo_component.lpm_widthu = 10;
		defparam scfifo_component.lpm_type = "scfifo";
		defparam scfifo_component.lpm_showahead = "ON";
		defparam scfifo_component.use_eab = "ON";
		defparam scfifo_component.add_ram_output_register = "OFF";
		defparam scfifo_component.underflow_checking = "ON";
		defparam scfifo_component.overflow_checking = "ON";
	

/* ######### Avalon-MM Slave Interface ##############

	SCR_STORE		-	R/W
	WRITE_BASE		-	R/W
	WRITE_LENGTH	-	R/W
*/

/* Status and Control Register */
reg [31:0] scr, scr_new;
reg [31:0] control_write_base, control_write_base_new;
reg [31:0] control_write_length, control_write_length_new;
reg [31:0] buffer_ovf_cnt, buffer_ovf_cnt_new;

/* Internal registers */
reg [31:0] datard_o, readdata_new;

/* wr_i phase */
always @ (*)
	if (wr_i)
		case(addr_rel_i)
		2'd0: 
			begin 
				scr_new[31:0] = datawr_i[31:0];
				control_write_base_new = control_write_base;
				control_write_length_new = control_write_length;
			end
		2'd1: 
			begin 
				scr_new[31:0] = scr[31:0];
				control_write_base_new = datawr_i;
				control_write_length_new = control_write_length;
			end
		2'd2:
			begin 
				scr_new[31:0] = scr[31:0];
				control_write_base_new = control_write_base;
				control_write_length_new = datawr_i;
			end
		default:
			begin 
				scr_new[31:0] = scr[31:0];
				control_write_base_new = control_write_base;
				control_write_length_new = control_write_length;
			end			
		endcase
	else /* wr_i disabled */
		begin 
			scr_new[31:0] = scr[31:0];
			control_write_base_new = control_write_base;
			control_write_length_new = control_write_length;
		end				
	
/* rd_i phase */	
always @ (*)
	if (rd_i)
		case(addr_rel_i) 
			3'd0:		readdata_new = scr;
			3'd1:		readdata_new = control_write_base;
			3'd2:		readdata_new = control_write_length;
			3'd3:		readdata_new = buffer_ovf_cnt;
			default:	readdata_new = 32'd0;
		endcase
	else 
		readdata_new = 32'd0;

/* Internal register update */

always @ (posedge clk_proc or negedge reset_n)
	if (reset_n == 1'b0)
		begin
			scr[31:0] <= { 29'b0, control_done, 1'b0, 1'b0};	
			control_write_base		<= 32'd0;
			control_write_length	<= 32'd0;
			buffer_ovf_cnt 			<= 32'd0;
			datard_o				<= 32'd0;
		end
	else 
		begin
			scr               		<= {length[28:0], 
										done_int_flag, control_done, scr_new[1:0]};
			control_write_base		<= control_write_base_new;
			control_write_length	<= control_write_length_new;
			buffer_ovf_cnt			<= buffer_ovf_cnt_new;
			datard_o				<= readdata_new;
		end
		
/* Interrupt flag handler */

assign irq_done = done_int_flag;

always@(posedge clk_proc or negedge reset_n)
	begin
		if (reset_n == 1'b0)
			done_int_flag <= 0;
		else if (wr_i && (addr_rel_i == 3'd0))
			done_int_flag <= 0;
		else if (control_done_pulse)
			done_int_flag <= 1;
	end

		
/*	Measuring if buffer_overflow occours */
always @ (*)
	begin
		if(scr[0])							
			if (user_buffer_full)						
				buffer_ovf_cnt_new	= buffer_ovf_cnt + 1;	
			else 
				buffer_ovf_cnt_new = buffer_ovf_cnt;	
		else 
				buffer_ovf_cnt_new = 32'b0;					
	end	
		

endmodule
