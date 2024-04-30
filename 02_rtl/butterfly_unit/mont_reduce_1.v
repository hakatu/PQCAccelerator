module mont_reduce_1(
a,
t
);

parameter MONT = -1044 ;  // 2^16 mod q
parameter QINV = 58728449  ; // q^-1 mod 2^16
parameter WIDTH = 32    ; // Output bit-width for int16_t

input signed [63:0] a;      // 32-bit input integer
output reg signed [WIDTH-1:0] t; // 16-bit output integer


always @ (a) begin
    t = a * QINV;  // Multiply with QINV
end

endmodule