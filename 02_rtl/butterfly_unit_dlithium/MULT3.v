module MULT3 (
	clock,
	dataa,
	datab,
	result);

	input	  clock;
	input signed	[31:0]  dataa;
	input signed	[31:0]  datab;
	output signed	[63:0]  result;

assign result = dataa * datab;

endmodule