module flopr(
    input logic d,
    input logic clk,
    input logic reset,
    output logic q);

    always_ff @(posedge clk, posedge reset)
        if (reset) q <= 0;
        else q <= d;
endmodule