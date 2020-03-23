module decoder(
    input logic [4:0] in,
    output logic [31:0] out);

    logic [31:0] aux = 1;
    assign out = aux << in;
endmodule