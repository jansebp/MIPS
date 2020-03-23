module ula32(
        input logic [31:0] a, b,
        input logic cin,
        input logic [2:0] ULAcontrole,
        output logic [31:0] ULAsaida,
        output logic cout, zero);

    logic [31:0] saidaAND, saidaOR, saidaNOR, saidaXOR, saidaNAND, saidaSTL, saidaADD, saidaSUB;
    logic cou0, cout1;

    and32 ULAand(saidaAND,a,b);                 //000
    or32 ULAor(saidaOR,a,b);                    //001
    nor32 ULAnor(saidaNOR,a,b);                 //011
    xor32 ULAxor(saidaXOR,a,b);                 //100
    nand32 ULAnand(saidaNAND,a,b);              //101
    stl ULAstl(a,b,saidaSTL);                   //111
    somador32 ULAadd(a,b,cin,saidaADD,cout0);   //010
    subtrator32 ULAsub(a,b,cin,saidaSUB,cout1); //110

    assign zero = (ULAsaida == 32'b00000000000000000000000000000000);
    mux muxcout(cout0, cout1, ULAcontrole[2], cout);    //cout 0 quando não sub ou add
    mux8 ULAmux(saidaAND, saidaOR, saidaADD, saidaNOR, saidaXOR, saidaNAND, saidaSUB, saidaSTL, ULAcontrole, ULAsaida);

endmodule