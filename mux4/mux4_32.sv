module mux4_32(
    input logic [1:0] s,
    input logic [31:0] d0, d1, d2, d3,
    output logic [31:0] y);

    logic [31:0] y0, y1;

    mux2_32 m0(s[0], d0, d1, y0);
    mux2_32 m1(s[0], d2, d3, y1);
    mux2_32 m2(s[1], y0, y1, y);
endmodule
