module flopr(
    input logic clk_in, rst_in,
    input logic d,
    output logic q
    );

    always_ff @(posedge clk_in, posedge rst_in)
        if (rst_in) q <= 1'b0;
        else q <= d;
endmodule
