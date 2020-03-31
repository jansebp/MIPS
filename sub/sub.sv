module sub(
        input logic a, b, cin,
        output logic s, cout);

    logic p, g;

    assign p = a ^ b;
    assign g = ~p;

    assign s = p ^ cin;
    assign cout = (cin & g) | (b & ~a);
endmodule
