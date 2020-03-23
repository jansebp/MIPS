module flopenr(
    input logic d,
    input logic en,
    input logic clk,
    input logic reset,
    output logic q);

    always_ff @(posedge clk, posedge reset)
        if (reset) q <= 0;
        else if (en) q <= d;
endmodule