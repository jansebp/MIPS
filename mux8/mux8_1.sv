module mux8_1(
    input logic [2:0] s,
    input logic d0, d1, d2, d3, d4, d5, d6, d7,
    output logic y);

    logic y0, y1;

    mux4_1 m0(s[1:0], d0, d1, d2, d3, y0);
    mux4_1 m1(s[1:0], d4, d5, d6, d7, y1);
    mux2_1 m2(s[2], y0, y1, y);
endmodule
