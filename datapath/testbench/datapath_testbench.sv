`timescale 1ns/10ps

module datapath_testbench();

    logic clk,rst;
    logic IORD, MEMTOREG, IRWRITE, REGWRITE, PCWRITE, BRANCH, ALUSRCA, REGDST, CLOCK, RESET;
    logic [1:0] ALUSRCB, PCSRC;
    logic [2:0] ALUCONTROL;
    logic [31:0] WD, WD_esperado, RD, ADR, ADR_esperado;
    logic overflow;
    logic [5:0] qt_erros, idx;
    logic [112:0]vetor_teste[33:0];

    datapath DUV(CLOCK, RESET, IORD, REGDST, MEMTOREG, IRWRITE, REGWRITE, ALUSRCA, BRANCH, PCWRITE,
        ALUSRCB, PCSRC, ALUCONTROL, RD, ADR, WD, overflow
        );

    always begin
        clk = 1;
        #10;
        clk = 0;
        #5;
    end

    initial begin
        $readmemb("datapath.tv", vetor_teste);

        idx = 0; qt_erros = 0;

        rst=1'b1;
        #8;
        rst=0;
		  
        $display("########## Testbench do Datapath ##########");
        $display("Resultado:");
    end

    always @(posedge clk) begin
        {CLOCK,RESET,IORD,IRWRITE,REGDST,MEMTOREG,REGWRITE,ALUSRCA,ALUSRCB,ALUCONTROL,BRANCH,PCWRITE,PCSRC,RD,ADR_esperado,WD_esperado} = vetor_teste[idx];
    end

    always @(negedge clk)
    if (~rst) begin
        if ((WD !== WD_esperado) | (ADR !== ADR_esperado)) begin
            if ((WD !== 32'bx) & (ADR !== 32'bx)) begin
                $display(">> Erro!");
                $display(">>>> Input CLK = %b", {CLOCK});
                $display(">>>> Input RESET = %b", {RESET});
                $display(">>>> Input IORD = %b", {IORD});
                $display(">>>> Input IRWRITE = %b", {IORD});
                $display(">>>> Input REGDST = %b", {IORD});
                $display(">>>> Input MEMTOREG = %b", {IORD});
                $display(">>>> Input REGWRITE = %b", {IORD});
                $display(">>>> Input ALUSRCA = %b", {IORD});
                $display(">>>> Input ALUSRCB = %b", {IORD});
                $display(">>>> Input ALUCONTROL = %b", {IORD});
                $display(">>>> Input BRANCH = %b", {IORD});
                $display(">>>> Input PCWRITE = %b", {IORD});
                $display(">>>> Input PCSRC = %b", {IORD});
                $display(">>>> Input RD = %b", {IORD});
                $display(">>>> Output ADR = %b ; ADR Esperado: %b", ADR, ADR_esperado);
                $display(">>>> Output WD = %b ; WD Esperado: %b", WD, WD_esperado);
                qt_erros = qt_erros + 1;
            end
	    end

        idx = idx + 1;

        if(vetor_teste[idx] === 113'bx) begin
            $display(">> Finalizado!");
            $display("%d testes executados com %d erros", idx, qt_erros);
            $stop;
        end
    end
endmodule
