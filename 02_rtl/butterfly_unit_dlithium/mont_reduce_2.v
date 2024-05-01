module mont_reduce_2(
a,
t,
result
);

parameter KYBER_Q = 8380417 ;// q
parameter WIDTH = 32    ; // Output bit-width for int16_t

input signed [63:0] a;      // 32-bit input integer
input signed [31:0] t;      // 32-bit input integer
output reg signed [WIDTH-1:0] result; // 16-bit output integer

// Local variable for intermediate calculation
reg signed [63:0] t2;

always @ (a) begin
    t2 = a - t*KYBER_Q;    // Subtract (t * KYBER_Q) from a
    result = t2[63:32];        // Right shift by 16 to get the final result
end

endmodule