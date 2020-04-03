module datapath(
    input logic clk, reset,
    input logic IorD, RegDst, MemtoReg, IRWrite, WE3, ALUSrcA, Branch, PCWrite,
    input logic [1:0] ALUSrcB, PCSrc,
    input logic [2:0] ALUControl,
    input logic [31:0] RD,
    output logic [31:0] Adr, WD,
    output logic Overflow,
	 output [5:0] Op, Funct
    );

    logic Zero, outputAND_PC, PCEn;
    logic [31:0] inputPC, outputPC, outRegInstr, outRegData, outRegA, outRegB, WD3, RD1, RD2;
    logic [31:0] SrcA, SrcB, SignImm, outShift2, ALUOut, ALUResult;
    logic [31:0] inShift2, outShiftJump, jumpADDR;
    logic [4:0] A3;

    and andPC(outputAND_PC, Zero, Branch);
    or orPC(PCEn, outputAND_PC, PCWrite);

    flopenr32 reg_pc(.clk_in(clk), .en(PCEn), .rst_in(reset), .d(inputPC), .q(outputPC));
	 mux2_32 mux__1(.s(IorD), .d0(outputPC), .d1(ALUOut), .y(Adr));
    flopenr32 reg_instructions(.clk_in(clk), .en(IRWrite), .rst_in(reset), .d(RD), .q(outRegInstr));
    flopr32 reg_data(.clk_in(clk), .rst_in(reset), .d(RD), .q(outRegData));
    mux2_5 mux__2(.s(RegDst), .d0(outRegInstr[20:16]), .d1(outRegInstr[15:11]), .y(A3));
    mux2_32 mux__3(.s(MemtoReg), .d0(ALUOut), .d1(outRegData), .y(WD3));
    regbank register_bank(.a1(outRegInstr[25:21]), .a2(outRegInstr[20:16]), .a3(A3), .wd3(WD3), .clk(clk)
		, .rst(reset), .we3(WE3), .rd1(RD1), .rd2(RD2));
    
	 flopr32 reg_A(.clk_in(clk), .rst_in(reset), .d(RD1), .q(outRegA));
    flopr32 reg_B(.clk_in(clk), .rst_in(reset), .d(RD2), .q(outRegB));

    mux2_32 mux__4(.s(ALUSrcA), .d0(outputPC), .d1(outRegA), .y(SrcA));
    signext sign_extend(.a(outRegInstr[15:0]), .y(SignImm));
    sl2 shift_2(.a(SignImm), .y(outShift2));
    mux4_32 mux__5(.s(ALUSrcB), .d0(outRegB), .d1(32'd4), .d2(SignImm), .d3(outShift2), .y(SrcB));
    ula32 ula32(.ULAcontrole(ALUControl), .SrcA(SrcA), .SrcB(SrcB), .ULAsaida(ALUResult), .overflow(Overflow), .zero(Zero));
    flopr32 reg_ALUResult(.clk_in(clk), .rst_in(reset), .d(ALUResult), .q(ALUOut));

    //sl2aggr shift_2_pc(.inADDR(Instr[25:0]), .inPC(PC), .y(PCJUMP));
    assign inShift2[25:0] = outRegInstr[25:0];
    assign inShift2[31:26] = 6'b000000;

    sl2 shift_2_2(.a(inShift2), .y(outShiftJump));
    assign jumpADDR = {outputPC[31:28], outShiftJump[27:0]};

    mux4_32 mux__6(.s(PCSrc), .d0(ALUResult), .d1(ALUOut), .d2(jumpADDR), .y(inputPC));
	 
	 assign WD = outRegB;
	 assign Op = outRegInstr[31:26];
	 assign Funct = outRegInstr[5:0];
endmodule
