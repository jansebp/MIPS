module ula32(
    input logic [2:0] ULAcontrole,
    input logic [31:0] SrcA, SrcB,
    output logic [31:0] ULAsaida,
    output logic overflow, zero
    );

    logic [31:0] cout, set;
	 logic addSub;
	
	 assign addSub = (ULAcontrole == 1'b110 || ULAcontrole == 1'b111) ? 1'b1 : 1'b0;

    ula ula0(ULAcontrole, SrcA[0], SrcB[0], addSub, addSub, set[31], set[0], cout[0], ULAsaida[0]);

    genvar j;

    generate
        for (j = 1; j < 32; j++) begin: ula
            ula ula(ULAcontrole, SrcA[j], SrcB[j], cout[j-1], addSub, 1'b0, set[j], cout[j], ULAsaida[j]);
        end
    endgenerate

    xor of(overflow, cout[31], cout[30]);
    nor z(zero, ULAsaida[31], ULAsaida[30], ULAsaida[29], ULAsaida[28], ULAsaida[27], ULAsaida[26],
        ULAsaida[25], ULAsaida[24], ULAsaida[23], ULAsaida[22], ULAsaida[21], ULAsaida[20], ULAsaida[19],
        ULAsaida[18], ULAsaida[17], ULAsaida[16], ULAsaida[15], ULAsaida[14], ULAsaida[13], ULAsaida[12],
        ULAsaida[11], ULAsaida[10], ULAsaida[9], ULAsaida[8], ULAsaida[7], ULAsaida[6], ULAsaida[5], 
		  ULAsaida[4], ULAsaida[3], ULAsaida[2], ULAsaida[1], ULAsaida[0]);
endmodule