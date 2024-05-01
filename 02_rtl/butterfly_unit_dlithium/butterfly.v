`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/15/2023 04:09:59 PM
// Design Name: 
// Module Name: butterfly
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module butterfly(
	clk,
	rst,
	mode,
	a,
	b,
	w,
	c,
	d
	);
    
	input clk;
	input rst;
	input [31:0] a;
	input [31:0] b;
	input [31:0] w;
	input [1:0] mode; //00: NTT; 01:NTT; 10:Bypass; 11: Idle
//	output reg [31:0] c;
//	output reg [31:0] d;
	output [31:0] c;
	output [31:0] d;

	wire [31:0] c_ntt,c_intt,c_bp;
	wire [31:0] d_ntt,d_intt,d_bp;
	wire [63:0] sum; 
	wire [63:0] sub;
	wire [63:0] mult_vw, mult_uw;
	wire [31:0] t_vw;
	wire [31:0] ba_vw;
	wire [63:0] add_a,add_b,sub_a,sub_b, sub_t;
	wire [31:0] cmux,dmux;
	wire [31:0] sub_m;
	wire sum_c, sub_c;
	
	reg [31:0] a1, b1, a2, b2, a3, b3, a4, b4, a5, b5;
   reg [31:0] t_vw1, ba_vw1;
   reg [63:0] mult_vw1, mult_uw1, mult_vw2, mult_uw2, mult_vw3, mult_uw3;
	reg [63:0] sum1;
	reg [63:0] sub1, sub_t1;
	reg [63:0] add_a1,add_b1,sub_a1,sub_b1;
   reg [1:0] mode1, mode2, mode3, mode4, mode5;

	MULT3 iMULT_0(clk,b,w,mult_vw);
	MULT3 iMULT_1(clk,a,w,mult_uw);
   always @(posedge clk) begin
	   if(rst) begin
		   a1 <= 'd0;
			b1 <= 'd0;
		   mult_vw1 <= 'd0;
			mult_uw1 <= 'd0;
			mode1 <= 'd0;
		end else begin
		   a1 <= a;
			b1 <= b;
		   mult_vw1 <= mult_vw;
			mult_uw1 <= mult_uw;
		   mode1 <= mode;	
		end
	end
	
	mont_reduce_1 imont_reduce_1_0 (mult_vw1,t_vw);

	always @(posedge clk) begin
	   if(rst) begin
		   a2 <= 'd0;
			b2 <= 'd0;
		   mult_vw2 <= 'd0;
			mult_uw2 <= 'd0;
			t_vw1 <= 'd0;
			mode2 <= 'd0;	
		end else begin
		   a2 <= a1;
			b2 <= b1;
		   mult_vw2 <= mult_vw1;
			mult_uw2 <= mult_uw1;
			t_vw1 <= t_vw;
			mode2 <= mode1;	
		end
	end
	
	mont_reduce_2 imont_reduce_2_0 (mult_vw2,t_vw1,ba_vw);

	always @(posedge clk) begin
	   if(rst) begin
		   a3 <= 'd0;
			b3 <= 'd0;
		   ba_vw1 <= 'd0;
			mode3 <= 'd0;
		   mult_vw3 <= 'd0;
			mult_uw3 <= 'd0;			
		end else begin
		   a3 <= a2;
			b3 <= b2;
		   ba_vw1 <= ba_vw;
			mode3 <= mode2;	
		   mult_vw3 <= mult_vw2;
			mult_uw3 <= mult_uw2;
		end
	end
	
	assign add_a = {32'b0, a3};
	assign add_b = (mode3==2'b00)? {32'b0, ba_vw1} : {32'b0, b3};
	assign sub_a = (mode3==2'b00)? {32'b0, a3} : mult_uw3;
	assign sub_b = (mode3==2'b00)? (~{32'b0, ba_vw1} + 1) : (~mult_vw3 + 1);
	
	always @(posedge clk) begin
	   if(rst) begin
		   a4 <= 'd0;
			b4 <= 'd0;
			mode4 <= 'd0;
			add_a1 <= 'd0;
			add_b1 <= 'd0;
			sub_a1 <= 'd0;
			sub_b1 <= 'd0;
		end else begin
		   a4 <= a3;
			b4 <= b3;
			mode4 <= mode3;
			add_a1 <= add_a;
			add_b1 <= add_b;
			sub_a1 <= sub_a;
			sub_b1 <= sub_b;
		end
	end
	
	Brent_Kung_Adder  iBKmodADD (add_a1,add_b1,{sum_c,sum});
	Brent_Kung_Adder  iBKmodSUB (sub_a1,sub_b1,{sub_c,sub});
	mont_reduce_1 imont_reduce_sub_1 (sub,sub_t);
	
	always @(posedge clk) begin
	   if(rst) begin
		   a5 <= 'd0;
			b5 <= 'd0;
		   sum1 <= 'd0;
			sub1 <= 'd0;
			sub_t1 <= 'd0;
			mode5 <= 'd0;
		end else begin
		   a5 <= a4;
			b5 <= b4;
		   sum1 <= sum;
			sub1 <= sub;
			sub_t1 <= sub_t;
			mode5 <= mode4;
		end
	end
	mont_reduce_2 imont_reduce_sub_2 (sub1,sub_t1,sub_m);
	
	//////////OUTPUT-mux///////////
	//mode NTT
	assign c_ntt = sum1[31:0];
	assign d_ntt = sub1[31:0];
	//mode INTT
	assign c_intt = sum1[31:0];
	assign d_intt = sub_m[31:0];
	//mode bypass
	assign c_bp = a5;
	assign d_bp = b5;

	mux_xx2_p imux_xx21 (clk,rst,c_ntt,c_intt,c_bp,16'b0,mode5,cmux);
	mux_xx2_p imux_xx22 (clk,rst,d_ntt,d_intt,d_bp,16'b0,mode5,dmux);
	
	assign c = cmux;
	assign d = dmux;
endmodule