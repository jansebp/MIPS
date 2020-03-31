module datapath(
    input logic clk, reset,
    input logic IorD, RegDst, MemtoReg, IRWrite, WE3, ALUSrcA, Branch, PCWrite,
    input logic [1:0] ALUSrcB, PCSrc,
    input logic [2:0] ALUControl,
    input logic [31:0] RD,
    output logic [31:0] Adr, WD,
    output logic overflow,
	 output [5:0] Op, Funct
    );

    logic Zero, outputAND_PC, PCEn;
    logic [31:0] inputPC, outputPC, outRegInstr, outRegData, outRegA, outRegB, WD3, RD1, RD2;
    logic [31:0] SrcA, SrcB, SignImm, outShift2, ALUOut, ALUResult;
    logic [31:0] inShift2, outShiftJump, jumpADDR;
    logic [4:0] A3;

    and andPC(outputAND_PC, Zero, Branch);
    or orPC(PCEn, outputAND_PC, PCWrite);

    flopenr32 reg_pc(clk, PCEn, reset, inputPC, outputPC);
	 mux2_32 mux__1(IorD, outputPC, ALUOut, Adr);
    flopenr32 reg_instructions(clk, IRWrite, reset, RD, outRegInstr);
    flopr32 reg_data(clk, reset, RD, outRegData);
    mux2_5 mux__2(RegDst, outRegInstr[20:16], outRegInstr[15:11], A3);
    mux2_32 mux__3(MemtoReg, ALUOut, outRegData, WD3);
    regbank register_bank(outRegInstr[25:21], outRegInstr[20:16], A3, WD3, clk, reset, WE3, RD1, RD2);
    
	 flopr32 reg_A(clk, reset, RD1, outRegA);
    flopr32 reg_B(clk, reset, RD2, outRegB);

    assign WD = outRegB;

    mux2_32 mux__4(ALUSrcA, outputPC, outRegA, SrcA);
    signext sign_extend(outRegInstr[15:0], SignImm);
    sl2 shift_2(SignImm, outShift2);
    mux4_32 mux__5(ALUSrcB, outRegB, 32'b000000000000000000000000000000100, SignImm, outShift2, SrcB);
    ula32 ula32(ALUControl, SrcA, SrcB, ALUResult, Overflow, Zero);
    flopr32 reg_ALUResult(clk, reset, ALUResult, ALUOut);

    //sl2aggr shift_2_pc(.inADDR(Instr[25:0]), .inPC(PC), .y(PCJUMP));
    assign inShift2[25:0] = outRegInstr[25:0];
    assign inShift2[31:26] = 6'b000000;

    sl2 shift_2_2(inShift2, outShiftJump);
    assign jumpADDR = {outputPC[31:28], outShiftJump[27:0]};

    mux4_32 mux__6(.s(PCSrc), .d0(ALUResult), .d1(ALUOut), .d2(jumpADDR), .y(inputPC));
	 
	 assign Op = outRegInstr[31:26];
	 assign Funct = outRegInstr[5:0];
endmodule
