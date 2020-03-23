module mux4(
    input logic d0, d1, d2, d3,
    input logic s0,
    input logic s1,
    output tri y);

    logic y0, y1;

    mux m0(d0, d1, s0, y0);
    mux m1(d2, d3, s0, y1);
    mux m2(y0, y1, s1, y);
endmodule