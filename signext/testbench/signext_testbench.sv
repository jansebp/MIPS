`timescale 1ns/10ps

module signext_testbench();
    logic clk, rst;
    logic [15:0] a;
    logic [31:0] Q, Q_esp;

    logic [3:0] qt_erros, idx;
    logic [47:0] vetor_teste [7:0];

    signext DUV(.a(a), .y(Q));

    always begin
        clk = 1;
        #10;
        clk = 0;
        #5;
    end

    initial begin
        $readmemb("C:/Users/janse/Documents/GitHub/MIPS/signext/simulation/modelsim/signext.tv", vetor_teste);

        idx = 0; qt_erros = 0;

        rst = 1'b1;
        #5;
        rst = 0;

        $display("########## Testbench do Extensor de Sinal 16:32 ##########");
        $display("Resultado:");
    end


    always @(posedge clk) begin
        {a[15:0], Q_esp[31:0]} = vetor_teste[idx];
    end

    always @(negedge clk)
    if (~rst) begin
        if (Q !== Q_esp) begin
            $display(">> Erro!");
            $display(">>>> Input = %b", {a});
            $display(">>>> Output = %b ; Output Esperado: %b", Q, Q_esp);
            qt_erros = qt_erros + 1;
        end

        idx = idx + 1;

        if(vetor_teste[idx] === 48'bx) begin
            $display(">> Finalizado!");
            $display(">>>> %d testes executados com %d erros", idx, qt_erros);
            $stop;
        end
    end
endmodule
