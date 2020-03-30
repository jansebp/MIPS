`timescale 1ns/10ps

module regbank_testbench();
    logic clk, rst;
    logic [4:0] a1, a2, a3;
    logic [31:0] wd3;
    logic we3, clk_regbank, rst_regbank;
    logic [31:0] rd1, rd2;
    logic [31:0] rd1_esp, rd2_esp;

    logic [5:0] qt_erros, idx;
    logic [113:0] vetor_teste [31:0];

	regbank DUV(.clk(clk_regbank), .rst(rst_regbank), .we3(we3),
	    .a1(a1), .a2(a2), .a3(a3), .wd3(wd3), .rd1(rd1), .rd2(rd2));

	always begin
		clk = 1;
		#10;
		clk = 0;
		#5;
	end

    initial begin
        $readmemb("C:/Users/janse/Documents/GitHub/MIPS/regbank/simulation/modelsim/regbank.tv", vetor_teste);

        idx = 0; qt_erros = 0;

        rst=1'b1;
        #5;
        rst=0;

        $display("########## Testbench do Banco de Registradores ##########");
        $display("Resultado:");
    end

    always @(posedge clk) begin
        #1 {a1[4:0], a2[4:0], a3[4:0], wd3[31:0], we3, clk_regbank, rst_regbank,
                     rd1_esp[31:0], rd2_esp[31:0]} = vetor_teste[idx];
    end

    always @ (negedge clk)
        if (~rst) begin
            if ((rd1 !== rd1_esp) | (rd2 !== rd2_esp)) begin
                if ((rd1 !== 32'bx) | (rd2 !== 32'bx)) begin
                    $display(">> Erro!");
                    $display(">>>> Input A1 = %b", {a1});
                    $display(">>>> Input A2 = %b", {a2});
                    $display(">>>> Input A3 = %b", {a3});
                    $display(">>>> Input WD3 = %b", {wd3});
                    $display(">>>> Input WE3 = %b", {we3});
                    $display(">>>> Input CLK = %b", {clk_regbank});
                    $display(">>>> Input RST = %b", {rst_regbank});
                    $display(">>>> Output RD1 = %b ; Output Esperado: %b", rd1, rd1_esp);
                    $display(">>>> Output RD2 = %b ; Output Esperado: %b", rd2, rd2_esp);
                    qt_erros = qt_erros + 1;
                end
            end
            
            idx = idx + 1;

            if(vetor_teste[idx] === 114'bx) begin
                $display(">> Finalizado!");
                $display(">>>> %d testes executados com %d erros", idx, qt_erros);
                $stop;
            end
        end
endmodule
