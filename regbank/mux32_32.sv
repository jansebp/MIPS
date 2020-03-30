module mux32_32(
    input logic [4:0] s,
    input logic [31:0] d00, d01, d02, d03, d04, d05, d06, d07,
    input logic [31:0] d08, d09, d10, d11, d12, d13, d14, d15,
    input logic [31:0] d16, d17, d18, d19, d20, d21, d22, d23,
    input logic [31:0] d24, d25, d26, d27, d28, d29, d30, d31,
    output logic [31:0] y);

    logic [31:0] y0, y1, y2, y3;

    mux8_32 m0(s[2:0], d00, d01, d02, d03, d04, d05, d06, d07, y0);
    mux8_32 m1(s[2:0], d08, d09, d10, d11, d12, d13, d14, d15, y1);
    mux8_32 m2(s[2:0], d16, d17, d18, d19, d20, d21, d22, d23, y2);
    mux8_32 m3(s[2:0], d24, d25, d26, d27, d28, d29, d30, d31, y3);

    mux4_32 mOut(s[4:3], y0, y1, y2, y3, y);
endmodule
