`timescale 1ns/100ps

module decoder_testbench();

logic clk, rst;
logic [4:0] Input;
logic [31:0] Output, Output_esperado;

logic [5:0] qt_erros, idx;
logic [36:0] vetor_teste [31:0];

decoder DUV(.in(Input), .out(Output));

always begin
	clk = 1;
	#10;
	clk = 0;
	#10;
end

initial begin
$readmemb("C:/Users/janse/Documents/GitHub/MIPS/decoder/simulation/modelsim/decoder.tv", vetor_teste);

idx = 0; qt_erros = 0;

rst=1'b1;
#10;
rst=0;

$display("########## Testbench do Decoder ##########");
$display("Resultado:");
end


always @(posedge clk) begin
	{Input, Output_esperado} = vetor_teste[idx];
end

always @(negedge clk)
if (~rst) begin
	if (Output !== Output_esperado) begin
		$display(">> Erro!");
		$display(">>>> Input = %b", {Input});
		$display(">>>> Output = %b ; Output Esperado: %b", Output, Output_esperado);
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