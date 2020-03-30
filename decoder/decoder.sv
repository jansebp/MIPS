module decoder(
    input logic [4:0] a,
    output logic [31:0] y);

    logic [31:0] aux = 1;
    assign y = aux << a;
endmodule
