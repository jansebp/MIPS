`timescale 1ns/10ps

module mux2_32_testbench();
    logic clk, rst;
    logic s;
    logic [31:0] d0, d1;
    logic [31:0] Q, Q_esp;

    logic [3:0] qt_erros, idx;
    logic [96:0] vetor_teste [7:0];

    mux2_32 DUV(.s(s), .d0(d0), .d1(d1), .y(Q));

    always begin
        clk = 1;
        #10;
        clk = 0;
        #5;
    end

    initial begin
        $readmemb("C:/Users/janse/Documents/GitHub/MIPS/mux/simulation/modelsim/mux32.tv", vetor_teste);

        idx = 0; qt_erros = 0;

        rst = 1'b1;
        #5;
        rst = 0;

        $display("########## Testbench do MUX de 32 Bits ##########");
        $display("Resultado:");
    end


    always @(posedge clk) begin
        {s, d0[31:0], d1[31:0], Q_esp[31:0]} = vetor_teste[idx];
    end

    always @(negedge clk)
    if (~rst) begin
        if (Q !== Q_esp) begin
            $display(">> Erro!");
            $display(">>>> Input D0 = %b", {d0});
            $display(">>>> Input D1 = %b", {d1});
            $display(">>>> Output = %b ; Output Esperado: %b", Q, Q_esp);
            qt_erros = qt_erros + 1;
        end

        idx = idx + 1;

        if(vetor_teste[idx] === 97'bx) begin
            $display(">> Finalizado!");
            $display(">>>> %d testes executados com %d erros", idx, qt_erros);
            $stop;
        end
    end
endmodule
