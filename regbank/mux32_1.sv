module mux32_1(
    input logic [31:0][31:0] a,
    input logic [4:0] sel,
    output logic [31:0] y);

always_comb begin
    y = a[sel];
    end
endmodule