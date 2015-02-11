/*
 * CameraOneFrame architecture
 * 
 * Copyright (c) 2014, 
 *  Luca Maggiani <maggiani.luca@gmail.com>, 
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

module matrix_prod(
	clk_i,
	
	reset_n_i,
	
	sclr_i,
	
	pix01_i,
	pix10_i,
	pix12_i,
	pix21_i,
	sin_i,
	cos_i,
	
	dv0_i,
	dv1_i,
	dv2_i,
 
	data_o
 );
 
parameter DATA_WIDTH = 8;
parameter COEF_WIDTH = 9; 
 
input clk_i;
input reset_n_i;
input dv0_i;
input dv1_i;
input dv2_i;
input sclr_i;

input [DATA_WIDTH-1:0] pix01_i, pix10_i, pix12_i, pix21_i;
input [COEF_WIDTH-1:0] sin_i;
input [COEF_WIDTH-1:0] cos_i;

output [((COEF_WIDTH + DATA_WIDTH)+1):0] data_o;

/* Internal register definitions */
reg signed [DATA_WIDTH:0] tmpsin;
reg signed [DATA_WIDTH:0] tmpcos;

reg signed [(COEF_WIDTH + DATA_WIDTH):0] multsin;		
reg signed [(COEF_WIDTH + DATA_WIDTH):0] multcos;

reg signed [((COEF_WIDTH + DATA_WIDTH)+1):0] finaladd;

//~ reg dv_d1, dv_d2;

/* Internal wire definitions */
wire signed [COEF_WIDTH-1:0] sin_wire;
wire signed [COEF_WIDTH-1:0] cos_wire;


always@(posedge clk_i or negedge reset_n_i)
	if (reset_n_i == 0)	
		tmpsin <= {(DATA_WIDTH+1){1'b0}};
	else if (dv0_i)
		tmpsin <= pix21_i - pix01_i;
	else
		tmpsin <= tmpsin;

always@(posedge clk_i or negedge reset_n_i)
	if (reset_n_i == 0)	
		tmpcos <= {(DATA_WIDTH+1){1'b0}};
	else if (dv0_i)
		tmpcos <= pix10_i - pix12_i; 
	else 
		tmpcos <= tmpcos;


//~ always@(posedge clk_i or negedge reset_n_i)
	//~ if (reset_n_i == 0)	
		//~ begin
			//~ dv_d1 <= 0;
			//~ dv_d2 <= 0;
		//~ end
	//~ else if (dv_i) 
		//~ begin
			//~ dv_d1 <= dv_i;
			//~ dv_d2 <= dv_d1;
		//~ end


assign sin_wire = sin_i;	
assign cos_wire = cos_i;	
		
always@(posedge clk_i or negedge reset_n_i)
	if (reset_n_i == 0)	
		begin
			multsin <= {(COEF_WIDTH + DATA_WIDTH + 1){1'b0}};
			multcos <= {(COEF_WIDTH + DATA_WIDTH + 1){1'b0}};
		end
	else if (dv1_i)  
		begin
			multsin <= tmpsin * sin_wire;
			multcos <= tmpcos * cos_wire;
		end

		
always@(posedge clk_i or negedge reset_n_i)
	if (reset_n_i == 0)	
		begin
			finaladd <= {((COEF_WIDTH + DATA_WIDTH)+2){1'b0}};
		end
	else if (dv2_i) 
		begin 
			finaladd <= multsin + multcos;
		end

assign data_o = (finaladd > 0) ? finaladd : (~finaladd + 1'b1);		

		
endmodule
 
