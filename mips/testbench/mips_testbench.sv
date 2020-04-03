`timescale 1ns/10ps
module mips_testbench();

    logic clk, rst;
    logic RESET, CLOCK, MEMWRITE, MEMWRITE_esp;
    logic [31:0] WD, WD_esp, ADR, ADR_esp, RD;
    logic [6:0] idx, qt_erros;
    logic [67:0] vetor_teste[66:0];
    logic [7:0] memory[127:0];
    
    integer file;
    integer count;
    
    mips DUV(.reset(RESET), .clk(CLOCK), .wd(WD), .adr(ADR), .rd(RD), .MemWrite(MEMWRITE));

    always begin
        clk = 1;
        #10;
        clk = 0;
        #5;
    end
    
    initial begin
        $readmemb("mips.tv", vetor_teste);
    
        idx = 0; qt_erros = 0;

        rst = 1'b1;
        #5;
        rst = 0;

        file = $fopen("memory.tv", "w");

        for(int i = 0; i < 128; i++) begin
            memory[i] = 8'b00000000;
        end
    
        {memory[0], memory[1], memory[2], memory[3]} = 32'b10001100000000010000000000100000; // primeira instrucao - lw
		  {memory[4], memory[5], memory[6], memory[7]} = 32'b10101100000000010000000000100100; // segunda instrucao - sw
		  {memory[8], memory[9], memory[10], memory[11]} = 32'b10001100000000100000000000101000; // terceira instrucao - lw
		  {memory[12], memory[13], memory[14], memory[15]} = 32'b00100000010000110000000000000001; // quarta instrucao - addi
		  {memory[16], memory[17], memory[18], memory[19]} = 32'b10101100000000110000000001000000; // quinta instrucao - sw
		  {memory[20], memory[21], memory[22], memory[23]} = 32'b00001000000000000000000000010011;// sexta instrucao - jump
		  {memory[76], memory[77], memory[78], memory[79]} = 32'b00000000001000100010000000100000; // setima instrucao - add
		  {memory[80], memory[81], memory[82], memory[83]} = 32'b10101100000001000000000000101100; // oitava instrucao - sw
		  {memory[32], memory[33], memory[34], memory[35]} = 32'b00000000000000000000000000001111; // carregando valor na memoria
		  {memory[40], memory[41], memory[42], memory[43]} = 32'b00000000000000000000000000001100; // carregando valor na memoria
    
        count = 0;
        $fwrite(file,"------------Memoria inicial------------\n");

        for(int i = 0; i < 128; i++) begin
            if(count == 4 ) begin
                $fwrite(file,"\n");
                count = 0;
            end

            if(count == 0)
                $fwrite(file,"[0x%2h]",127- i);

            $fwrite(file,"%b",memory[127-i]);
            count++;
        end

        $display("########## Testbench do MIPS ##########");
        $display("Resultado:");
    end
    
    always @(posedge MEMWRITE)  begin
        {memory[ADR], memory[ADR+1], memory[ADR+2], memory[ADR+3]} = WD;
    end
    
    always @(posedge clk) begin
        {CLOCK, RESET, ADR_esp, WD_esp, MEMWRITE_esp} = vetor_teste[idx];
    
        if(RESET == 1'b1)
            RD = {memory[0], memory[1], memory[2], memory[3]};
        else
            RD = {memory[ADR], memory[ADR+1], memory[ADR+2], memory[ADR+3]};
    end
    
    always @(negedge clk)
        if (~rst) begin
            if (((WD != WD_esp) & (WD != 32'bx))
                | ((ADR != ADR_esp) & (ADR != 32'bx))
                | ((MEMWRITE != MEMWRITE_esp) & (MEMWRITE != 32'bx))) begin

                    $display(">> Erro!");
                    $display(">>>> Input CLOCK = %b", {CLOCK});
                    $display(">>>> Input RESET = %b", {RESET});
                    $display(">>>> Input RD = %b", {RD});
                    $display(">>>> Output WD = %b ; WD Esperado: %b", WD, WD_esp);
                    $display(">>>> Output ADR = %b ; ADR Esperado: %b", ADR, ADR_esp);
                    $display(">>>> Output MEMWRITE = %b ; MEMWRITE Esperado: %b", MEMWRITE, MEMWRITE_esp);

                    qt_erros = qt_erros + 1;
                end

            idx = idx + 1;

            if(vetor_teste[idx] === 68'bx) begin
                $display(">> Finalizado!");
                $display("%d testes executados com %d erros", idx, qt_erros);

                #1
                count = 0;

                $fwrite(file,"\n-------------Memoria final-------------\n");

                for(int i = 0; i < 128; i++) begin
                    if(count == 4 ) begin
                        $fwrite(file,"\n");
                        count = 0;
                    end

                    if(count == 0)
                        $fwrite(file,"[0x%2h]",127- i);

                    $fwrite(file,"%b",memory[127-i]);
                    count++;
                end

                $stop;
            end
        end
endmodule
