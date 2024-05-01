//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 1/5/2024
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

module compute_unit (
    clk,
    rst,

    //usage interface 
    idat1,
    idat2,
    idatwr,
    inrdy, //rdy take input


    odat1,
    odat2,
    odatrd,
    outrdy, //rdy take output
    //////
)
//////////////////////////////////////////////
//parameter

parameter ADDRBIT = 4; //dep of FIFO
parameter DATAWIDTH = 13; //data width of FIFO

//////////////////////////////////////////////
//ports
    input clk;
    input rst;

    //usage interface 
    input [DATAWIDTH-1:0] idat1;
    input [DATAWIDTH-1:0] idat2;
    input  idatwr;
    output inrdy; //rdy take input

    output [DATAWIDTH-1:0] odat1;
    output [DATAWIDTH-1:0] odat2;
    input  odatrd;
    output outrdy; //rdy take output
    //////
////////////generate 4 FF circle
//input FIFO
//wiring
//4 FIFO flags
wire fifofull1, notempty1,fifofull2, notempty2, fifofull3, notempty3,fifofull4, notempty4;
//4 FIFO length
wire [ADDRBIT-1:0] fifolen1, fifolen2, fifolen3, fifolen4;
////////////////////////////////////////////////

fifoctrlbrampack #(ADDRBIT,DATAWIDTH) iffctrlpck1 ( 
    .clk(clk),
    .rst(rst),

    .fiford(),    // FIFO control
    .fifowr(idatwr),

    .fifofull(fifofull1),  // high when fifo full
    .notempty(notempty1),  // high when fifo not empty
    .fifolen(),   // fifo length

    .fifo_data_in(idat1),  // data input,
    .fifo_data_out(ff1dout) // data output
);

fifoctrlbrampack #(ADDRBIT,DATAWIDTH) iffctrlpck2 ( 
    .clk(clk),
    .rst(rst),

    .fiford(),    // FIFO control
    .fifowr(idatwr),

    .fifofull(fifofull2),  // high when fifo full
    .notempty(notempty2),  // high when fifo not empty
    .fifolen(),   // fifo length

    .fifo_data_in(idat2),  // data input,
    .fifo_data_out(ff2dout) // data output
);

fifoctrlbrampack #(ADDRBIT,DATAWIDTH) iffctrlpck3 ( 
    .clk(clk),
    .rst(rst),

    .fiford(odatrd),    // FIFO control
    .fifowr(),

    .fifofull(fifofull3),  // high when fifo full
    .notempty(notempty3),  // high when fifo not empty
    .fifolen(),   // fifo length

    .fifo_data_in(),  // data input,
    .fifo_data_out(odat1) // data output
);

fifoctrlbrampack #(ADDRBIT,DATAWIDTH) iffctrlpck4 ( 
    .clk(clk),
    .rst(rst),

    .fiford(odatrd),    // FIFO control
    .fifowr(),

    .fifofull(fifofull4),  // high when fifo full
    .notempty(notempty4),  // high when fifo not empty
    .fifolen(),   // fifo length

    .fifo_data_in(),  // data input,
    .fifo_data_out(odat2) // data output
);
////////////////////////////////////////////////
//the only compute core right now is butterfly (dlithium), if later more func is added, this changes
butterfly ibutterfly(
	.clk(clk)
	.rst(rst)
	.mode(mode)
	.a()
	.b()
	.w()
	.c()
	.d()
	);

endmodule