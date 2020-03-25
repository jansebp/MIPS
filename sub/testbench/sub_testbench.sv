`timescale 1ns/100ps

module sub_testbench();

logic clk, rst;
logic In_A, In_B, C_In;
logic Output, Output_esperado;

logic [3:0] qt_erros, idx;
logic [7:0] vetor_teste [4:0];

sub DUV(.inA(In_A), .inB(In_B), .cin(C_In), .y(Output));

always begin
	clk = 1;
	#10;
	clk = 0;
	#10;
end

initial begin
$readmemb("C:/Users/janse/Documents/GitHub/MIPS/sub/simulation/modelsim/sub.tv", vetor_teste);

idx = 0; qt_erros = 0;

rst=1'b1;
#10;
rst=0;

$display("########## Testbench do Subtrador ##########");
$display("Resultado:");
end


always @(posedge clk) begin
	{In_A, In_B, C_In, Output_esperado} = vetor_teste[idx];
end

always @(negedge clk)
if (~rst) begin
	if (Output !== Output_esperado) begin
		$display(">> Erro!");
		$display(">>>> Input A = %b", {In_A});
		$display(">>>> Input B = %b", {In_B});
		$display(">>>> Input Cin = %b", {C_In});
		$display(">>>> Output = %b ; Output Esperado: %b", Output, Output_esperado);
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
