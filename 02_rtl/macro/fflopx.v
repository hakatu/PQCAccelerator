//////////////////////////////////////////////////////////////////////////////////
//
//
// Filename        : fflopx.v
// Description     : variable size flip flop
//
//////////////////////////////////////////////////////////////////////////////////
module fflopx
    (
     clk,
     rst_,
     idat,
     odat
     );

parameter WIDTH = 8;
parameter RESET_VALUE = {WIDTH{1'b0}};

input   clk, rst_;

input  [WIDTH-1:0] idat;

output [WIDTH-1:0] odat;
reg    [WIDTH-1:0] odat;

always @ (posedge clk or negedge rst_)
    begin
    if(!rst_) odat <= RESET_VALUE;
    else odat <= idat;
    end

endmodule
