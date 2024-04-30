`timescale 1ns / 1ps

module tb_butterfly;

    // Inputs
    reg clk;
    reg rst_n;
    reg [31:0] a;
    reg [31:0] b;
    reg [31:0] w;
    reg [1:0] mode;

    // Outputs
    wire [31:0] c;
    wire [31:0] d;

    // Instantiate the Unit Under Test (UUT)
    butterfly uut (
        .clk(clk),
        .rst_n(rst_n),
        .a(a), 
        .b(b), 
        .w(w), 
        .mode(mode), 
        .c(c), 
        .d(d)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #10 clk = ~clk; // 50MHz clock
    end

    // Test stimulus
    initial begin
        // Initialize Inputs
        a = 0;
        b = 0;
        w = 0;
        rst_n = 1;
        mode = 2'b00; // NTT mode

        // Apply test stimulus
        #100; // Wait for 100ns
        rst_n = 0;
        a = 32'h0000; // Assign some value
        b = 32'h0000; // Assign some value
        w = 32'd25847; // Assign some value

        #200; // Wait for 20ns for NTT operation
        // Check results for NTT operation
        a = -2; // Assign some value
        b = 32'h0; // Assign some value
        w = 32'd25847; // Assign some value
        #200; // Wait for 20ns for NTT operation
        // Check results for NTT operation
        a = 32'h0; // Assign some value
        b = -1; // Assign some value
        w = 32'd25847; // Assign some value
	#20;
        a = 32'h2; // Assign some value
        b = 32'h0; // Assign some value
        w = 32'd25847; // Assign some value
        // Reuse or change values of a, b, w as needed
        #20;
        #200; // Wait for 20ns for INTT operation
        // Check results for INTT operation
        mode = 2'b01;
        // Apply test stimulus
        
        #100; // Wait for 100ns
        a = -948721; // Assign some value
        b = -7061865; // Assign some value
        w = -1976782; // Assign some value      
                #100; // Wait for 100ns
        a = 2902405; // Assign some value
        b = 1101013; // Assign some value
        w = 846154; // Assign some value   
                #100; // Wait for 100ns
        a = 2350421; // Assign some value
        b = -1288543; // Assign some value
        w = -1400424; // Assign some value   
                #100; // Wait for 100ns
        a = -758808; // Assign some value
        b = 6854994; // Assign some value
        w = -3937738; // Assign some value     
        // Additional test cases can be added here

        // Finish the simulation
        
        #100; 
        $finish;
    end
      
endmodule