module ula_decoder(
    input logic [5:0] Funct,
    input logic [1:0] ULAOp,
    output logic [2:0] ULAControle);

    always_comb begin
		case (ULAOp)
			2'b00: begin
				ULAControle = 3'b010; // add
			end
			2'b01: begin
				ULAControle = 3'b110; // sub
			end
			2'b10: begin
				case (Funct)
					6'b100000: begin
						ULAControle = 3'b010; // add
					end
					6'b100010: begin
						ULAControle = 3'b110; // sub
					end
					6'b100100: begin
						ULAControle = 3'b000; // and
					end
					6'b100101: begin
						ULAControle = 3'b001; // or
					end
					6'b101010: begin
						ULAControle = 3'b111; // slt
					end
					6'b100111: begin
                        ULAControle = 3'b011; // nor
                    end
                    6'b100110: begin
                        ULAControle = 3'b101; // xor
                    end
					default: ULAControle = 3'b010; // default add
				endcase
			end
			2'b11: begin
				case (Funct)
					6'b100000: begin
						ULAControle = 3'b010; // add
					end
					6'b100010: begin
						ULAControle = 3'b110; // sub
					end
					6'b100100: begin
						ULAControle = 3'b000; // and
					end
					6'b100101: begin
						ULAControle = 3'b001; // or
					end
					6'b101010: begin
						ULAControle = 3'b111; // slt
					end
					6'b100111: begin
                        ULAControle = 3'b011; // nor
                    end
                    6'b100110: begin
                        ULAControle = 3'b101; // xor
                    end
					default: ULAControle = 3'b010; // default add
				endcase
			end
			default: ULAControle = 3'b010; // default add
		endcase
    end
endmodule
