`timescale 1ns/10ps

module controller_testbench();

    logic clk, rst;
    logic IORD, MEMTOREG, IRWRITE, REGWRITE, PCWRITE, BRANCH, ALUSRCA, REGDST, MEMWRITE, CLOCK, RESET;
    logic IORD_esp, MEMTOREG_esp, IRWRITE_esp, REGWRITE_esp, PCWRITE_esp, BRANCH_esp, ALUSRCA_esp, REGDST_esp, MEMWRITE_esp;

    logic [5:0] FUNCT, OPCODE;
    logic [2:0] ALUCONTROL_esp, ALUCONTROL;
    logic [1:0] ALUSRCB, ALUSRCB_esp, PCSRC, PCSRC_esp;
    logic [5:0] idx, qt_erros;
    logic [29:0] vetor_teste[55:0];

    controller DUV(.Funct(FUNCT),.Opcode(OPCODE),.IorD(IORD),.MemtoReg(MEMTOREG),.IRWrite(IRWRITE),.RegWrite(REGWRITE),.PCWrite(PCWRITE),.PCSrc(PCSRC),
                 .Branch(BRANCH),.ALUSrcA(ALUSRCA),.reset(RESET),.clk(CLOCK),.RegDst(REGDST),.ALUSrcB(ALUSRCB),.ULAControle(ULACONTROLE),.MemWrite(MEMWRITE));

    always begin
        clk = 1;
        #10;
        clk = 0;
        #5;
    end

    initial begin
        $readmemb("controller.tv", vetor_teste);

        idx = 0; qt_erros = 0;

        rst = 1'b1;
        #8;
        rst = 0;

        $display("########## Testbench da Unidade de Controle ##########");
        $display("Resultado:");
    end


    always @(posedge clk) begin
        {FUNCT, OPCODE, CLOCK, RESET, ALUCONTROL_esp, ALUSRCB_esp, PCSRC_esp, IORD_esp, IRWRITE_esp, REGDST_esp,
        MEMTOREG_esp, REGWRITE_esp, ALUSRCA_esp, BRANCH_esp, PCWRITE_esp, MEMWRITE_esp} = vetor_teste[idx];
    end

    always @(negedge clk)
    if (~rst) begin
        if((IORD != IORD_esp) | (IRWRITE != IRWRITE_esp) | (REGDST != REGDST_esp) | (MEMTOREG != MEMTOREG_esp) |
            (REGWRITE != REGWRITE_esp) | (ALUSRCA != ALUSRCA_esp) | (BRANCH != BRANCH_esp) | (PCWRITE != PCWRITE_esp)
            | (MEMWRITE != MEMWRITE_esp) | (ALUSRCB != ALUSRCB_esp) | (PCSRC != PCSRC_esp)
            | (ALUCONTROL != ALUCONTROL_esp)) begin

            $display(">> Erro!");
            $display(">>>> Input FUNCT = %b", {FUNCT});
            $display(">>>> Input OPCODE = %b", {OPCODE});
            $display(">>>> Input CLOCK = %b", {CLOCK});
            $display(">>>> Input RESET = %b", {RESET});
            $display(">>>> Output IORD = %b ; IORD Esperado: %b", IORD, IORD_esp);
            $display(">>>> Output IRWRITE = %b ; IRWRITE Esperado: %b", IRWRITE, IRWRITE_esp);
            $display(">>>> Output REGDST = %b ; REGDST Esperado: %b", REGDST, REGDST_esp);
            $display(">>>> Output MEMTOREG = %b ; MEMTOREG Esperado: %b", MEMTOREG, MEMTOREG_esp);
            $display(">>>> Output REGWRITE = %b ; REGWRITE Esperado: %b", REGWRITE, REGWRITE_esp);
            $display(">>>> Output ALUSRCA = %b ; ALUSRCA Esperado: %b", ALUSRCA, ALUSRCA_esp);
            $display(">>>> Output ALUSRCB = %b ; ALUSRCB Esperado: %b", ALUSRCB, ALUSRCB_esp);
            $display(">>>> Output ALUCONTROL = %b ; ALUCONTROL Esperado: %b", ALUCONTROL, ALUCONTROL_esp);
            $display(">>>> Output BRANCH = %b ; BRANCH Esperado: %b", BRANCH, BRANCH_esp);
            $display(">>>> Output PCWRITE = %b ; PCWRITE Esperado: %b", PCWRITE, PCWRITE_esp);
            $display(">>>> Output MEMWRITE = %b ; MEMWRITE Esperado: %b", MEMWRITE, MEMWRITE_esp);
            $display(">>>> Output PCSRC = %b ; PCSRC Esperado: %b", PCSRC, PCSRC_esp);

            qt_erros = qt_erros + 1;

        end;

        idx = idx + 1;

        if(vetor_teste[idx] === 30'bx) begin
            $display(">> Finalizado!");
            $display("%d testes executados com %d erros", idx, qt_erros);
            $stop;
        end
    end
endmodule
