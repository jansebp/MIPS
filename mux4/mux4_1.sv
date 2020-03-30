module mux4_1(
    input logic [1:0] s,
    input logic d0, d1, d2, d3,
    output logic y);

    logic y0, y1;

    mux2_1 m0(s[0], d0, d1, y0);
    mux2_1 m1(s[0], d2, d3, y1);
    mux2_1 m2(s[1], y0, y1, y);
endmodule
