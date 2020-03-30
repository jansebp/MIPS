`timescale 1ns/10ps

module flopr_testbench();
    logic clk, rst, clk_in, rst_in;
    logic D;
    logic Q, Q_esp;

    logic [31:0] qt_erros, idx;
    logic [3:0] vetor_teste [22:0];

    flopr DUV(.clk_in(clk_in), .rst_in(rst_in), .d(D), .q(Q));

    always begin
        clk = 1;
        #10;
        clk = 0;
        #5;
    end

    initial begin
        $readmemb("flopr.tv", vetor_teste);

        idx = 0; qt_erros = 0;

        rst = 1'b1;
        #5;
        rst = 0;

        $display("########## Testbench do Registrador Resettable ##########");
        $display("Resultado:");
    end


    always @(posedge clk) begin
        {clk_in, rst_in, D, Q_esp} = vetor_teste[idx];
    end

    always @(negedge clk)
    if (~rst) begin
        if (Q !== Q_esp) begin
            $display(">> Erro!");
            $display(">>>> Input = %b", {D});
            $display(">>>> Output = %b ; Output Esperado: %b", Q, Q_esp);
            qt_erros = qt_erros + 1;
        end

        idx = idx + 1;

        if(vetor_teste[idx] === 4'bx) begin
            $display(">> Finalizado!");
            $display(">>>> %d testes executados com %d erros", idx, qt_erros);
            $stop;
        end
    end
endmodule
