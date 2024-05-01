module FBU(clk,rst_n,mode,a,b,w,c,d);
    
	input clk;
	input rst_n;
	input [31:0] a;
	input [31:0] b;
	input [31:0] w;
	input [1:0] mode; //00: NTT; 01:NTT; 10:Bypass; 11: Idle
	output [31:0] c;
	output [31:0] d;

	reg [31:0] a_temp;
	reg [31:0] b_temp;
	reg [31:0] w_temp;
	reg [1:0] mode_temp; //00: NTT; 01:NTT; 10:Bypass; 11: Idle
	reg [31:0] c_temp;
	reg [31:0] d_temp;


   always @(posedge clk, posedge rst_n) begin
	   if(rst_n) begin
			a_temp <= 'd0;
		   b_temp <= 'd0;
		   w_temp <= 'd0;
		   mode_temp <= 'd0;
		end else begin
	   	a_temp <= a;
   		b_temp <= b;
		   w_temp <= w;
		   mode_temp <= mode;		
		end
 	end
	butterfly butterfly_0 (.clk(clk),.rst_n(rst_n),.mode(mode_temp),.a(a_temp),.b(b_temp),.w(w_temp),.c(c_temp),.d(d_temp));
	   always @(posedge clk,posedge rst_n) begin
		   if(rst_n) begin
	   c <= 'd0;
		d <= 'd0;
		end else begin
	   c <= c_temp;
		d <= d_temp;	
		end
	end
endmodule