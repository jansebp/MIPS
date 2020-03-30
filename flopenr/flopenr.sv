module flopenr(
    input logic clk_in,
    input logic en,
    input logic rst_in,
    input logic d,
    output logic q);

    always_ff @(posedge clk_in, posedge rst_in)
        if (rst_in) q <= 0;
        else if (en) q <= d;
endmodule
