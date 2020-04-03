module fsm(
    input logic [5:0] Opcode,
    input logic clk, reset,
    output logic MemtoReg, RegDst, IorD, ALUSrcA, IRWrite, MemWrite, PCWrite, Branch, RegWrite,
    output logic [1:0] ULAOp, ALUSrcB, PCSrc);

    typedef enum logic [3:0]{S0,S1,S2,S3,S4,S5,S6,S7,S8,S9,S10,S11} State;

    State current_state, next_state;

    always_ff @(posedge clk, posedge reset) begin
        if(reset)begin
            current_state <= S0;
            end
        else
            current_state <= next_state;
    end

    always_comb begin
	//next_state = S0;

        case(current_state)
            S0: begin  // Fetch
                IorD = 1'b0;
                ALUSrcA = 1'b0;
                ALUSrcB = 2'b01;
                ULAOp = 2'b00;
                PCSrc = 2'b00;
                IRWrite = 1'b1;
                PCWrite = 1'b1;

                // Para completar as saídas
                MemtoReg = 1'bx;
                RegDst = 1'bx;
                MemWrite = 1'b0;
                Branch = 1'b0;
                RegWrite = 1'b0;

                next_state = S1;
            end

            S1: begin // Decode

                ALUSrcA = 1'b0;
                ALUSrcB = 2'b11;
                ULAOp = 2'b00;

                // para completar as saídas
                MemtoReg = 1'bx;
                RegDst = 1'bx;
                MemWrite = 1'b0;
                Branch = 1'b0;
                RegWrite = 1'b0;
                IorD = 1'bx;
                PCSrc = 2'bxx;
                IRWrite = 1'b0;
                PCWrite = 1'b0;
                case(Opcode)
                    6'd0: begin
                        next_state = S6; // r type
                    end

                    6'd35: begin
                        next_state = S2; // lw
                    end

                    6'd43: begin
                        next_state = S2; // sw
                    end

                    6'd4: begin
                        next_state = S8; // beq
                    end

                    6'd8: begin
                        next_state = S9; // addi
                    end

                    6'd2: begin
                        next_state = S11; // j
                    end

                    default: next_state = S0;

                endcase
            end

            S2: begin // MemAdr

                ALUSrcA = 1'b1;
                ALUSrcB = 2'b10;
                ULAOp = 2'b00;

                // para completar as saídas
                MemtoReg = 1'bx;
                RegDst = 1'bx;
                MemWrite = 1'b0;
                Branch = 1'b0;
                RegWrite = 1'b0;
                IorD = 1'bx;
                PCSrc = 2'bxx;
                IRWrite = 1'b0;
                PCWrite = 1'b0;

                case(Opcode)
                    6'd35: begin
                        next_state = S3; // lw
                    end

                    6'd43: begin
                        next_state = S5; // sw
                    end

                    default: next_state= S0;

                endcase
            end

            S3: begin // MemRead

                IorD = 1'b1;

                // para completar as saídas
                MemtoReg = 1'bx;
                RegDst = 1'bx;
                MemWrite = 1'b0;
                Branch = 1'b0;
                RegWrite = 1'b0;
                ALUSrcA = 1'bx;
                ALUSrcB = 2'bxx;
                ULAOp = 2'b00;
                PCSrc = 2'bxx;
                IRWrite = 1'b0;
                PCWrite = 1'b0;

                next_state = S4;
            end

            S4: begin // MemWriteback

                RegDst = 1'b0;
                MemtoReg = 1'b1;
                RegWrite = 1'b1;

                // para completar as saídas
                MemWrite = 1'b0;
                Branch = 1'b0;
                IorD = 1'bx;
                ALUSrcA = 1'bx;
                ALUSrcB = 2'bxx;
                ULAOp = 2'b00;
                PCSrc = 2'bxx;
                IRWrite = 1'b0;
                PCWrite = 1'b0;

                next_state = S0;
            end

            S5: begin // MemWrite

                IorD = 1'b1;
                MemWrite = 1'b1;

                // para completar as saídas
                MemtoReg = 1'bx;
                RegDst = 1'bx;
                Branch = 1'b0;
                RegWrite = 1'b0;
                ALUSrcA = 1'bx;
                ALUSrcB = 2'bxx;
                ULAOp = 2'b00;
                PCSrc = 2'bxx;
                IRWrite = 1'b0;
                PCWrite = 1'b0;

                next_state = S0;
            end

            S7: begin // ALUWriteback

                RegDst   = 1'b1;
                MemtoReg = 1'b0;
                RegWrite = 1'b1;

                // para completar as saídas
                MemWrite = 1'b0;
                Branch = 1'b0;
                IorD = 1'bx;
                ALUSrcA = 1'bx;
                ALUSrcB = 2'bxx;
                ULAOp = 2'b00;
                PCSrc = 2'bxx;
                IRWrite = 1'b0;
                PCWrite = 1'b0;

                next_state = S0;
            end

            S8: begin // Branch

                ALUSrcA = 1'b1;
                ALUSrcB = 2'b00;
                PCSrc = 2'b01;
                ULAOp = 2'b01;
                Branch = 1'b1;

                // para completar as saídas
                MemtoReg = 1'bx;
                RegDst = 1'bx;
                MemWrite = 1'b0;
                RegWrite = 1'b0;
                IorD = 1'bx;
                IRWrite = 1'b0;
                PCWrite = 1'b0;

                next_state = S0;
            end

            S10: begin // ADDIWriteback

                RegDst = 1'b0;
                MemtoReg = 1'b0;
                RegWrite = 1'b1;

                // para completar as saídas
                MemWrite = 1'b0;
                Branch = 1'b0;
                IorD = 1'bx;
                ALUSrcA = 1'bx;
                ALUSrcB = 2'bxx;
                ULAOp = 2'b00;
                PCSrc = 2'bxx;
                IRWrite = 1'b0;
                PCWrite = 1'b0;

                next_state = S0;
            end

            S11: begin // Jump

                PCSrc = 2'b10;
                PCWrite = 1'b1;

                // para completar as saídas
                MemtoReg = 1'bx;
                RegDst = 1'bx;
                MemWrite = 1'b0;
                Branch = 1'b0;
                RegWrite = 1'b0;
                IorD = 1'bx;
                ALUSrcA = 1'bx;
                ALUSrcB = 2'bxx;
                ULAOp = 2'b00;
                IRWrite = 1'b0;

                next_state = S0;

            end

            S9: begin // ADDIExecute

                ALUSrcA = 1'b1;
                ALUSrcB = 2'b10;
                ULAOp = 2'b00;

                // para completar as saídas
                MemtoReg = 1'bx;
                RegDst = 1'bx;
                MemWrite = 1'b0;
                Branch = 1'b0;
                RegWrite = 1'b0;
                IorD = 1'bx;
                PCSrc = 2'bxx;
                IRWrite = 1'b0;
                PCWrite = 1'b0;

                next_state = S10;

            end

            S6: begin // Execute

                ALUSrcA = 1'b1;
                ALUSrcB = 2'b00;

                // para completar as saídas
                MemtoReg = 1'bx;
                RegDst = 1'bx;
                MemWrite = 1'b0;
                Branch = 1'b0;
                RegWrite = 1'b0;
                IorD = 1'bx;
                //ULAOp = 2'b00;
                PCSrc = 2'bxx;
                IRWrite = 1'b0;
                PCWrite = 1'b0;

                case(Opcode)

                    6'b001000: begin // ADDI - ADD
                        ULAOp = 2'b00;
                    end
                    6'b001001: begin // ADDIU - ADD
                        ULAOp = 2'b00;
                    end
                    6'b000100: begin // BEQ - SUB
                        ULAOp = 2'b01;
                    end
                    6'b010100: begin // BEQL - SUB
                        ULAOp = 2'b01;
                    end
                    6'b000101: begin // BNE - SUB
                        ULAOp = 2'b01;
                    end

                    default: ULAOp = 2'b00;

                endcase

                next_state = S7;
            end

            default: begin
                // para completar as saídas
                MemtoReg = 1'bx;
                RegDst = 1'bx;
                MemWrite = 1'b0;
                Branch = 1'b0;
                RegWrite = 1'b0;
                IorD = 1'bx;
                ALUSrcA = 1'bx;
                ALUSrcB = 2'bxx;
                ULAOp = 2'b00;
                PCSrc = 2'bxx;
                IRWrite = 1'b0;
                PCWrite = 1'b0;

                next_state = S0;
            end
        endcase
    end
endmodule
