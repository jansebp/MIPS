`timescale 1ns/100ps

module inv_testbench();

logic clk, rst;
logic A;
logic Y, Output_esperado;

logic [1:0] qt_erros, idx;
logic [1:0] vetor_teste [1:0];

inv DUV(.a(A), .y(Y));

always begin
	clk = 1;
	#10;
	clk = 0;
	#10;
end

initial begin
$readmemb("C:/Users/janse/Documents/GitHub/MIPS/inv/simulation/modelsim/inv.tv", vetor_teste);

idx = 0; qt_erros = 0;

rst=1'b1;
#10;
rst=0;

$display("########## Testbench do Inversor ##########");
$display("Resultado:");
end


always @(posedge clk) begin
	{A, Output_esperado} = vetor_teste[idx];
end

always @(negedge clk)
if (~rst) begin
	if (Y !== Output_esperado) begin
		$display(">> Erro!");
		$display(">>>> Input = %b", {A});
		$display(">>>> Output = %b ; Output Esperado: %b", Y, Output_esperado);
		qt_erros = qt_erros + 1;
	end

	idx = idx + 1;

	if(vetor_teste[idx] === 2'bx) begin
		$display(">> Finalizado!");
		$display(">>>> %d testes executados com %d erros", idx, qt_erros);
		$stop;
	end
end


endmodule
