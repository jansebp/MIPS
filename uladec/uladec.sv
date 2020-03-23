module aludec(
        input logic [5:0] funct,
        input logic [2:0] ALUop,
        output logic [2:0] ALUcontrol

    always_comb begin
        case(ALUop)
            3'b000: ALUcontrol = 3'b010;    // ADD (LW/SW/ADDI)
            3'b001: ALUcontrol = 3'b110;    // SUB (BEQ)
            3'b010: begin                   // funct (R-Type)
                case (funct)
                    6'b100000: ALUcontrol = 3'b010; // ADD
                    6'b100010: ALUcontrol = 3'b110; // SUB
                    6'b100100: ALUcontrol = 3'b000; // AND
                    6'b100101: ALUcontrol = 3'b001; // OR
                    6'b101010: ALUcontrol = 3'b111; // SLT
                    6'b100110: ALUcontrol = 3'b011; // NOR
                    6'b100111: ALUcontrol = 3'b100; // XOR
                    default:   ALUcontrol = 3'b101; // NAND
                endcase
                end
            3'b011: ALUcontrol = 3'b111;    //
            3'b100: ALUcontrol = 3'b110;    //
            3'b110: ALUcontrol = 3'b001;    //
            3'b111: ALUcontrol = 3'b011;    //
            default:ALUcontrol = 3'b101;    //
        endcase
        end
endmodule