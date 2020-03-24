`timescale 1ns/100ps

module ula_testbench();

logic clk, rst;
logic [2:0] ulaOp
logic in_A, in_B, c_In;
logic Y, Output_esperado;

logic [6:0] qt_erros, idx;
logic [7:0] vetor_teste [63:0];

inv DUV(.ulaOp(ulaOp), .a(in_A), .b(in_B), .c(c_In), .y(Y));

always begin
	clk = 1;
	#10;
	clk = 0;
	#10;
end

initial begin
$readmemb("C:/Users/janse/Documents/GitHub/MIPS/ula/simulation/modelsim/ula.tv", vetor_teste);

idx = 0; qt_erros = 0;

rst=1'b1;
#10;
rst=0;

$display("########## Testbench do Inversor ##########");
$display("Resultado:");
end


always @(posedge clk) begin
	{ulaOp[2:0], in_A, in_B, c_In, Output_esperado} = vetor_teste[idx];
end

always @(negedge clk)
if (~rst) begin
	if (Y !== Output_esperado) begin
		$display(">> Erro!");
		$display(">>>> Operacao = %b", {ulaOp});
		$display(">>>> Input A = %b", {in_A});
		$display(">>>> Input B = %b", {in_B});
		$display(">>>> Input Cin = %b", {c_In});
		$display(">>>> Output = %b ; Output Esperado: %b", Y, Output_esperado);
		qt_erros = qt_erros + 1;
	end

	idx = idx + 1;

	if(vetor_teste[idx] === 8'bx) begin
		$display(">> Finalizado!");
		$display(">>>> %d testes executados com %d erros", idx, qt_erros);
		$stop;
	end
end


endmodule
