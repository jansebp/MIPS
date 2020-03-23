module tristate(
    input logic a,
    input logic en,
    output tri y);

    assign y = en ? a : 1'bz;
endmodule