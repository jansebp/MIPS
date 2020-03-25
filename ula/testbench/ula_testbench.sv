`timescale 1ns/100ps

module ula_testbench();

logic clk, rst;
logic [2:0] ULAcontrole;
logic [31:0] in_A, in_B, Output_esperado;
logic c_In;
logic Y, zero, c_Out, zero_esperado, c_out_esperado;

logic [4:0] qt_erros, idx;
logic [17:0] vetor_teste [101:0];

ula DUV(.ULAcontrole(ULAcontrole), .a(in_A), .b(in_B), .cin(c_In), .ULAsaida(Y), .zero(zero), .cout(c_Out);

always begin
	clk = 1;
	#40;
	clk = 0;
	#40;
end

initial begin
$readmemb("C:/Users/janse/Documents/GitHub/MIPS/ula/simulation/modelsim/ula.tv", vetor_teste);

idx = 0; qt_erros = 0;

rst=1'b1;
#40;
rst=0;

$display("########## Testbench da ULA ##########");
$display("Resultado:");
end


always @(posedge clk) begin
	{ulaOp[2:0], in_A[31:0], in_B[31:0], c_In, Output_esperado[31:0], zero_esperado, c_out_esperado} = vetor_teste[idx];
end

always @(negedge clk)
if (~rst) begin
	if ((Y !== Output_esperado) | (zero !== zero_esperado) | (c_Out !== c_out_esperado)) begin
		$display(">> Erro!");
		$display(">>>> Operacao = %b", {ulaOp});
		$display(">>>> Input A = %b", {in_A});
		$display(">>>> Input B = %b", {in_B});
		$display(">>>> Input Cin = %b", {c_In});
		$display(">>>> Output = %b ; Output Esperado: %b", Y, Output_esperado);
		$display(">>>> Zero = %b ; Zero Esperado: %b", zero, zero_esperado);
		$display(">>>> C_Out = %b ; C_Out Esperado: %b", c_Out, c_out_esperado);
		qt_erros = qt_erros + 1;
	end

	idx = idx + 1;

	if(vetor_teste[idx] === 18'bx) begin
		$display(">> Finalizado!");
		$display(">>>> %d testes executados com %d erros", idx, qt_erros);
		$stop;
	end
end


endmodule
