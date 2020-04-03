module ula(
        input logic [2:0] ULAcontrole,
        input logic a, b,
        input logic cin, addsub, less,
        output logic set, cout,
        output logic ULAsaida
        );

    logic saidaAND, saidaOR, saidaNOR, saidaXOR, saidaADD, saidaSUB, saidaDEF, bAux;
    logic cout0, cout1;

    and ULAand(saidaAND,a,b);                 //000
    or ULAor(saidaOR,a,b);                    //001
    nor ULAnor(saidaNOR,a,b);                 //011
    xor ULAxor(saidaXOR,a,b);                 //101

	 xor ULAaddsub(bAux, b, addsub);
	 adder ULAadd(.a(a), .b(bAux), .cin(cin), .s(saidaADD), .cout(cout));

    assign set = saidaADD;
	 mux8_1 ULAmux(.s(ULAcontrole), .d0(saidaAND), .d1(saidaOR), .d2(saidaADD), .d3(saidaNOR), .d4(saidaDEF)
		, .d5(saidaXOR), .d6(saidaADD), .d7(less), .y(ULAsaida));

endmodule
