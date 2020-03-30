`timescale 1ns/10ps

module flopenr32_testbench();
    logic clk, rst, clk_in, en, rst_in;
    logic [31:0] D;
    logic [31:0] Q, Q_esp;

    logic [3:0] qt_erros, idx;
    logic [66:0] vetor_teste [8:0];

    flopenr32 DUV(.clk_in(clk_in), .en(en), .rst_in(rst_in), .d(D), .q(Q));

    always begin
        clk = 1;
        #10;
        clk = 0;
        #5;
    end

    initial begin
        $readmemb("C:/Users/janse/Documents/GitHub/MIPS/flopenr/simulation/modelsim/flopenr32.tv", vetor_teste);

        idx = 0; qt_erros = 0;

        rst = 1'b1;
        #5;
        rst = 0;

        $display("########## Testbench do Registrador com Reset e Enable ##########");
        $display("Resultado:");
    end


    always @(posedge clk) begin
        {clk_in, en, rst_in, D[31:0], Q_esp[31:0]} = vetor_teste[idx];
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

        if(vetor_teste[idx] === 67'bx) begin
            $display(">> Finalizado!");
            $display(">>>> %d testes executados com %d erros", idx, qt_erros);
            $stop;
        end
    end
endmodule
