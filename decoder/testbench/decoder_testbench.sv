`timescale 1ns/100ps

module decoder_testbench();

logic clk, rst;
logic [4:0] a;
logic [31:0] Out, Out_esp;

logic [5:0] qt_erros, idx;
logic [36:0] vetor_teste [31:0];

decoder DUV(.a(a), .y(Out));

always begin
	clk = 1;
	#10;
	clk = 0;
	#5;
end

initial begin
    $readmemb("decoder.tv", vetor_teste);

    idx = 0; qt_erros = 0;

    rst=1'b1;
    #5;
    rst=0;

    $display("########## Testbench do Decoder ##########");
    $display("Resultado:");
end


always @(posedge clk) begin
	{a[4:0], Out_esp[31:0]} = vetor_teste[idx];
end

always @(negedge clk)
    if (~rst) begin
        if (Out !== Out_esp) begin
            $display(">> Erro!");
            $display(">>>> Input = %b", {a});
            $display(">>>> Output = %b ; Output Esperado: %b", Out, Out_esp);
            qt_erros = qt_erros + 1;
        end

        idx = idx + 1;

        if(vetor_teste[idx] === 37'bx) begin
            $display(">> Finalizado!");
            $display(">>>> %d testes executados com %d erros", idx, qt_erros);
            $stop;
        end
    end
endmodule
