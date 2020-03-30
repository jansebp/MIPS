module mux2_5(
    input logic s,
    input logic [4:0] d0, d1,
    output logic [4:0] y);

    assign y = s ? d1 : d0;
endmodule
