module mips(input logic clk,reset,input logic [31:0]rd,output logic [31:0] wd, adr,output logic MemWrite);

logic IorD,MemtoReg,IRWrite,RegWrite,PCWrite,Branch,ALUSrcA,RegDst;
logic [1:0] ALUSrcB,PCSrc;
logic [2:0] ALUControl;
logic [5:0]Opcode,Funct;

datapath datapath(.clk(clk), .reset(reset), .IorD(IorD), .MemtoReg(MemtoReg), .IRWrite(IRWrite)
	, .Branch(Branch), .ALUSrcA(ALUSrcA), .RegDst(RegDst), .ALUSrcB(ALUSrcB), .PCSrc(PCSrc)
	, .ALUControl(ALUControl), .Op(Opcode), .Funct(Funct), .Adr(adr), .WD(wd), .RD(rd), .PCWrite(PCWrite)
	, .WE3(RegWrite));

controller controller(.clk(clk), .reset(reset), .IorD(IorD), .MemtoReg(MemtoReg), .IRWrite(IRWrite)
	, .Branch(Branch), .ALUSrcA(ALUSrcA), .RegDst(RegDst), .ALUSrcB(ALUSrcB), .PCSrc(PCSrc)
	, .ULAControle(ALUControl), .Opcode(Opcode), .Funct(Funct), .MemWrite(MemWrite), .PCWrite(PCWrite)
	, .RegWrite(RegWrite));
endmodule