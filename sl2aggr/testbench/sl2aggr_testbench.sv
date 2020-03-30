`timescale 1ns/10ps

module sl2aggr_testbench();
    logic clk, rst;
    logic [25:0] inADDR;
    logic [31:0] inPC;
    logic [31:0] Q, Q_esp;

    logic [2:0] qt_erros, idx;
    logic [89:0] vetor_teste [5:0];

    sl2aggr DUV(.inADDR(inADDR), .inPC(inPC), .y(Q));

    always begin
        clk = 1;
        #10;
        clk = 0;
        #5;
    end

    initial begin
        $readmemb("C:/Users/janse/Documents/GitHub/MIPS/sl2aggr/simulation/modelsim/sl2aggr.tv", vetor_teste);

        idx = 0; qt_erros = 0;

        rst = 1'b1;
        #5;
        rst = 0;

        $display("########## Testbench do Deslocador de Sinal Agregador ##########");
        $display("Resultado:");
    end


    always @(posedge clk) begin
        {inADDR[25:0], inPC[31:0], Q_esp[31:0]} = vetor_teste[idx];
    end

    always @(negedge clk)
    if (~rst) begin
        if (Q !== Q_esp) begin
            $display(">> Erro!");
            $display(">>>> Input ADDR = %b", {inADDR});
            $display(">>>> Input PC = %b", {inPC});
            $display(">>>> Output = %b ; Output Esperado: %b", Q, Q_esp);
            qt_erros = qt_erros + 1;
        end

        idx = idx + 1;

        if(vetor_teste[idx] === 90'bx) begin
            $display(">> Finalizado!");
            $display(">>>> %d testes executados com %d erros", idx, qt_erros);
            $stop;
        end
    end
endmodule
