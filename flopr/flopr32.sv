module flopr32(
    input logic clk_in, rst_in,
    input logic [31:0] d,
    output logic [31:0]q
    );

    genvar j;
    generate for (j = 0; j < 32; j++) begin: registers
        flopr registers(
            .clk_in(clk_in),
				.rst_in(rst_in),
				.d(d[j]),
				.q(q[j])
				);
		end
	endgenerate
endmodule
