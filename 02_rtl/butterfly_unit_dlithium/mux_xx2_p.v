`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/15/2023 04:14:51 PM
// Design Name: 
// Module Name: mux_xx2
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

module mux_xx2_p(clk, rst_n, a,b,c,d,s,o);
    input clk;
	 input rst_n;
    input [1:0] s;
    input [31:0] a,b,c,d;
    output reg [31:0] o;
    
    always @(posedge clk, posedge rst_n) begin
	     if(rst_n) begin
		     o <= 'd0;
		  end
		  else begin
		     case(s)
           2'b00 : o <= a;
           2'b01 : o <= b;
           2'b10 : o <= c;
           default : o <= d;
           endcase
		  end
	 end
endmodule
