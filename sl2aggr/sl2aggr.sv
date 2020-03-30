module sl2aggr(
    input logic [25:0] inADDR,
    input logic [31:0] inPC,
    output logic [31:0] y);

    assign y = {inPC[31:28], inADDR[25:0], 2'b00};
endmodule
