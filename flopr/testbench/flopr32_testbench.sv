`timescale 1ns/10ps

module flopr32_testbench();
    logic clk, rst, clk_in, rst_in;
    logic [31:0] D;
    logic [31:0] Q, Q_esp;

    logic [4:0] qt_erros, idx;
    logic [66:0] vetor_teste [8:0];

    flopr32 DUV(.clk_in(clk_in), .rst_in(rst_in), .d(D), .q(Q));

    always begin
        clk = 1;
        #10;
        clk = 0;
        #10;
    end

    initial begin
        $readmemb("flopr32.tv", vetor_teste);

        idx = 0; qt_erros = 0;

        rst = 1'b1;
        #10;
        rst = 0;

        $display("########## Testbench do Registrador Resettable ##########");
        $display("Resultado:");
    end


    always @(posedge clk) begin
        {clk_in, rst_in, D[31:0], Q_esp[31:0]} = vetor_teste[idx];
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

        if(vetor_teste[idx] === 66'bx) begin
            $display(">> Finalizado!");
            $display(">>>> %d testes executados com %d erros", idx, qt_erros);
            $stop;
        end
    end
endmodule
