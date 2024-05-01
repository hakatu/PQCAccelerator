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

module fifoctrlbrampack ( 
    clk,
    rst,

    fiford,    // FIFO control
    fifowr,

    fifofull,  // high when fifo full
    notempty,  // high when fifo not empty
    fifolen,   // fifo length

    fifo_data_in,  // data input,
    fifo_data_out // data output
);
///////////////////////////////////////////////////////////////
//param and ports
    parameters ADDRBIT = 4; //dep of FIFO
    parameters DATAWIDTH = 13; //data width of FIFO

    //wire
    input clk;
    input rst;
    input fiford;    // FIFO control
    input fifowr;
    
    output fifofull;  // high when fifo full
    output notempty;  // high when fifo not empty
    output [ADDRBIT-1:0] fifolen;   // fifo length

    input [DATAWIDTH-1:0] fifo_data_in;  // data input,
    output [DATAWIDTH-1:0] fifo_data_out; // data output
///////////////////////////////////////////////////////////////
//internal wires
    wire write;
    wire [ADDRBIT-1:0] wraddr;
    wire read;
    wire [ADDRBIT-1:0] rdaddr;

    // Instantiate the fifoctrlx module
    fifoctrlx #(ADDRBIT
    ) ififoctrl (
        .clk(clk),
        .reset(reset),
        // Connect input and output ports of fifoctrlx here
        .fiford(fiford),    // FIFO control
        .fifowr(fifowr),

        .fifofull(fifofull),  // high when fifo full
        .notempty(notempty),  // high when fifo not empty
        .fifolen(fifolen),   // fifo length


                // Connect to memories
        .write(write),     // enable to write memories
        .wraddr(wraddr),    // write address of memories
        .read(read),      // enable to read memories
        .rdaddr(rdaddr)     // read address of memories
    );


    // Instantiate the BRAM module
     alram112x #(DATAWIDTH,ADDRBIT) ialram112x
    (
     .clkw(clk),//clock write
     .clkr(clk),//clock read
     .rst(rst),
     
     .rdo(fifo_data_out),//data from ram
     .ra(rdaddr),//read address
     
     .wdi(fifo_data_in),//data to ram
     .wa(wraddr),//write address
     .we(write) //write enable
     );

endmodule