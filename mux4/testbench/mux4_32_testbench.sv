`timescale 1ns/10ps

module mux4_32_testbench();
    logic clk, rst;
    logic [1:0] s;
    logic [31:0] d0, d1, d2, d3;
    logic [31:0] Q, Q_esp;

    logic [2:0] qt_erros, idx;
    logic [161:0] vetor_teste [3:0];

    mux4_32 DUV(.s(s), .d0(d0), .d1(d1), .d2(d2), .d3(d3), .y(Q));

    always begin
        clk = 1;
        #10;
        clk = 0;
        #5;
    end

    initial begin
        $readmemb("mux4_32.tv", vetor_teste);

        idx = 0; qt_erros = 0;

        rst = 1'b1;
        #5;
        rst = 0;

        $display("########## Testbench do MUX 4:1 32 Bits ##########");
        $display("Resultado:");
    end


    always @(posedge clk) begin
        {s[1:0], d0[31:0], d1[31:0], d2[31:0], d3[31:0], Q_esp[31:0]} = vetor_teste[idx];
    end

    always @(negedge clk)
    if (~rst) begin
        if (Q !== Q_esp) begin
            $display(">> Erro!");
            $display(">>>> Input D0 = %b", {d0});
            $display(">>>> Input D1 = %b", {d1});
				$display(">>>> Input D2 = %b", {d2});
				$display(">>>> Input D3 = %b", {d3});
            $display(">>>> Output = %b ; Output Esperado: %b", Q, Q_esp);
            qt_erros = qt_erros + 1;
        end

        idx = idx + 1;

        if(vetor_teste[idx] === 162'bx) begin
            $display(">> Finalizado!");
            $display(">>>> %d testes executados com %d erros", idx, qt_erros);
            $stop;
        end
    end
endmodule
