module mux2_32(
    input logic s,
    input logic [31:0] d0, d1,
    output logic [31:0] y);

    assign y = s ? d1 : d0;
endmodule
