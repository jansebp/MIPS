`timescale 1ns/10ps

module sub_testbench();
    logic clk, rst;
    logic a, b, cin;
    logic Out, Out_esp, cout, cout_esp;

    logic [3:0] qt_erros, idx;
    logic [4:0] vetor_teste [7:0];

    sub DUV(.a(a), .b(b), .cin(cin), .s(Out), .cout(cout));

    always begin
        clk = 1;
        #10;
        clk = 0;
        #5;
    end

    initial begin
        $readmemb("sub.tv", vetor_teste);

        idx = 0; qt_erros = 0;

        rst=1'b1;
        #5;
        rst=0;

        $display("########## Testbench do Subtrator ##########");
        $display("Resultado:");
    end


    always @(posedge clk) begin
        {a, b, cin, Out_esp, cout_esp} = vetor_teste[idx];
    end

    always @(negedge clk)
    if (~rst) begin
        if (Out !== Out_esp) begin
            $display(">> Erro!");
            $display(">>>> Input A = %b", {a});
            $display(">>>> Input B = %b", {b});
            $display(">>>> Input C_in = %b", {cin});
            $display(">>>> Output = %b ; Output Esperado: %b", Out, Out_esp);
            $display(">>>> C_Out = %b ; C_Out Esperado: %b", cout, cout_esp);
            qt_erros = qt_erros + 1;
        end

        idx = idx + 1;

        if(vetor_teste[idx] === 5'bx) begin
            $display(">> Finalizado!");
            $display(">>>> %d testes executados com %d erros", idx, qt_erros);
            $stop;
        end
    end
endmodule
