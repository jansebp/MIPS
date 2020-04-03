module controller(
    input logic [5:0] Opcode, Funct,
    input logic clk, reset,
    output logic MemtoReg, RegDst, IorD, ALUSrcA, IRWrite, MemWrite, PCWrite, Branch, RegWrite,
    output logic [1:0] ALUSrcB, PCSrc,
    output logic [2:0] ULAControle
    );

    logic [1:0]ULAOp;

    fsm fsm(.Opcode(Opcode), .clk(clk), .reset(reset), .MemtoReg(MemtoReg), .RegDst(RegDst), .IorD(IorD)
		, .ALUSrcA(ALUSrcA), .IRWrite(IRWrite), .MemWrite(MemWrite), .PCWrite(PCWrite), .Branch(Branch)
		,.RegWrite(RegWrite), .ULAOp(ULAOp), .ALUSrcB(ALUSrcB), .PCSrc(PCSrc));

    ula_decoder ula_decoder(.ULAOp(ULAOp), .Funct(Funct), .ULAControle(ULAControle));
endmodule
