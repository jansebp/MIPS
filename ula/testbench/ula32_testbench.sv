`timescale 1ns/10ps

module ula32_testbench();

logic clk, rst;
logic [2:0] ULAcontrole;
logic [31:0] SrcA, SrcB, ULAout, ULAout_esp;
logic addSub, overflow, overflow_esp, zero, zero_esp;

logic [4:0] qt_erros, idx;
logic [101:0] vetor_teste [26:0];

ula32 DUV(.ULAcontrole(ULAcontrole), .SrcA(SrcA), .SrcB(SrcB), .addSub(addSub), .ULAsaida(ULAout), .overflow(overflow), .zero(zero));

always begin
	clk = 1;
	#25;
	clk = 0;
	#5;
end

initial begin
    $readmemb("C:/Users/janse/Documents/GitHub/MIPS/ula/simulation/modelsim/ula32.tv", vetor_teste);

    idx = 0; qt_erros = 0;

    rst=1'b1;
    #5;
    rst=0;

    $display("########## Testbench da ULA de 32 bits ##########");
    $display("Resultado:");
end


always @(posedge clk) begin
	{ULAcontrole[2:0], SrcA[31:0], SrcB[31:0], addSub, ULAout_esp[31:0], overflow_esp, zero_esp} = vetor_teste[idx];
end

always @(negedge clk)
if (~rst) begin
	if ((ULAout !== ULAout_esp) | (zero !== zero_esp) | (overflow !== overflow_esp)) begin
		$display(">> Erro!");
		$display(">>>> Operacao = %b", {ULAcontrole});
		$display(">>>> Input A = %b", {SrcA});
		$display(">>>> Input B = %b", {SrcB});
		$display(">>>> Input flag ADD_SUB = %b", {addSub});
		$display(">>>> Output = %b ; Output Esperado: %b", ULAout, ULAout_esp);
		$display(">>>> Overflow = %b ; Overflow Esperado: %b", overflow, overflow_esp);
		$display(">>>> Zero = %b ; Zero Esperado: %b", zero, zero_esp);
		qt_erros = qt_erros + 1;
	end

	idx = idx + 1;

	if(vetor_teste[idx] === 102'bx) begin
		$display(">> Finalizado!");
		$display(">>>> %d testes executados com %d erros", idx, qt_erros);
		$stop;
	end
end


endmodule
