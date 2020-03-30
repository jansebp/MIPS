module regbank(
	input logic [4:0] a1, a2, a3,
	input logic [31:0] wd3,
	input logic clk, rst, we3,
	output logic [31:0] rd1, rd2
	);
	
	logic [31:0] decoder_s;
	logic [31:0][31:0] registers_s;
	
	decoder decoder(a3, decoder_s);
	
	genvar j;
	
	generate for(j = 1; j < 32; j++) begin: registers
			flopenr32_regbank reg32(.clk_in(clk), .en(decoder_s[j]), .rst_in(rst), .regWrite(we3), .d(wd3), .q(registers_s[j]));
		end
	endgenerate
	
	mux32_1 mux1(.a(registers_s), .sel(a1), .y(rd1));
	mux32_1 mux2(.a(registers_s), .sel(a2), .y(rd2));
endmodule
