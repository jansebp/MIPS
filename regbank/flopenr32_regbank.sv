module flopenr32_regbank(
    input logic clk_in, en, rst_in, regWrite,
    input logic [31:0] d,
    output logic [31:0] q
	 );

    logic write_s;
    assign write_s = regWrite & en;

    flopenr32 register(.clk_in(clk_in), .en(write_s), .rst_in(rst_in), .d(d), .q(q));
endmodule
