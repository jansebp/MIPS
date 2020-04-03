`timescale 1ns/10ps

module ula_testbench();

    logic clk, rst;
    logic [2:0] ULAcontrole;
    logic in_A, in_B, ULAout, ULAout_esp;
    logic c_In, addSub;

    logic [6:0] qt_erros, idx;
    logic [7:0] vetor_teste [63:0];

    ula DUV(.ULAcontrole(ULAcontrole), .a(in_A), .b(in_B), .cin(c_In), .addsub(addSub), .ULAsaida(ULAout));

    always begin
        clk = 1;
        #10;
        clk = 0;
        #5;
    end

    initial begin
        $readmemb("ula.tv", vetor_teste);

        idx = 0; qt_erros = 0;

        rst=1'b1;
        #5;
        rst=0;

        $display("########## Testbench da ULA ##########");
        $display("Resultado:");
    end

    always @(posedge clk) begin
        {ULAcontrole[2:0], in_A, in_B, c_In, addSub, ULAout_esp} = vetor_teste[idx];
    end

    always @(negedge clk)
    if (~rst) begin
        if (ULAout !== ULAout_esp) begin
            $display(">> Erro!");
            $display(">>>> Operacao = %b", {ULAcontrole});
            $display(">>>> Input A = %b", {in_A});
            $display(">>>> Input B = %b", {in_B});
            $display(">>>> Input Cin = %b", {c_In});
            $display(">>>> Input Flag ADD_SUB = %b", {addSub});
            $display(">>>> Output = %b ; Output Esperado: %b", ULAout, ULAout_esp);
            qt_erros = qt_erros + 1;
        end

        idx = idx + 1;

        if(vetor_teste[idx] === 8'bx) begin
            $display(">> Finalizado!");
            $display(">>>> %d testes executados com %d erros", idx, qt_erros);
            $stop;
        end
    end
endmodule
