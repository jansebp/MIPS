from utils import util


class Inv:
    @staticmethod
    def inverter(value, number_bits):
        return value ^ number_bits


class Tristate:
    @staticmethod
    def tristate(input_a, input_en):
        if input_en == 1:
            return input_a
        else:
            return 'z'


class Mux:
    @staticmethod
    def mux(input_a, input_b, selection):
        if selection == 0:
            return input_a
        return input_b

    @staticmethod
    def mux4(input_a, input_b, input_c, input_d, input_s1, input_s2):
        out_mux1 = Mux.mux(input_a, input_b, input_s1)
        out_mux2 = Mux.mux(input_c, input_d, input_s1)

        return Mux.mux(out_mux1, out_mux2, input_s2)

    @staticmethod
    def mux4_v2(input_a, input_b, input_c, input_d, selection):
        if selection == 0:
            return input_a
        if selection == 1:
            return input_b
        if selection == 2:
            return input_c
        if selection == 3:
            return input_d

    @staticmethod
    def mux8(d0, d1, d2, d3, d4, d5, d6, d7, sel):
        selection = str(format(sel, '03b'))
        s1 = selection[1:]
        s2 = selection[:1]
        y0 = Mux.mux4_v2(d0, d1, d2, d3, int(s1, 2))
        y1 = Mux.mux4_v2(d4, d5, d6, d7, int(s1, 2))

        return Mux.mux(y0, y1, int(s2))

    @staticmethod
    def mux32(d0, d1, d2, d3, d4, d5, d6, d7,
              d8, d9, d10, d11, d12, d13, d14, d15,
              d16, d17, d18, d19, d20, d21, d22, d23,
              d24, d25, d26, d27, d28, d29, d30, d31,
              sel):
        selection = str(format(sel, '05b'))
        s1 = selection[:3]
        s2 = selection[3:]

        y0 = Mux.mux8(d0, d1, d2, d3, d4, d5, d6, d7, int(s1, 2))
        y1 = Mux.mux8(d8, d9, d10, d11, d12, d13, d14, d15, int(s1, 2))
        y2 = Mux.mux8(d16, d17, d18, d19, d20, d21, d22, d23, int(s1, 2))
        y3 = Mux.mux8(d24, d25, d26, d27, d28, d29, d30, d31, int(s1, 2))

        return Mux.mux4_v2(y0, y1, y2, y3, int(s2, 2))


class Flop:
    @staticmethod
    def flopr(in_d, in_clk, in_rst, q):
        if in_rst == 1:
            return 0

        if in_clk == 1:
            return in_d

        return q

    @staticmethod
    def flopenr(in_d, in_enable, in_clk, in_rst, q):
        if in_rst == 1:
            return 0

        if in_clk == 1:
            if in_enable == 1:
                return in_d

        return q

    @staticmethod
    def register_bank(a1, a2, a3, wd3, we3, clk, rst):
        output_and = [0] * 32
        output_register = [0] * 32
        output_decoder = list(map(int, Decoder.decoder(a3, 32)))

        for i in range(0, 32):
            output_and[i] = we3 & output_decoder[i]
            output_register[i] = Flop.flopenr(wd3, output_and[i], clk, rst, output_register[i])

        rd1 = Mux.mux32(output_register[0], output_register[1], output_register[2], output_register[3],
                        output_register[4], output_register[5], output_register[6], output_register[7],
                        output_register[8], output_register[9], output_register[10], output_register[11],
                        output_register[12], output_register[13], output_register[14], output_register[15],
                        output_register[16], output_register[17], output_register[18], output_register[19],
                        output_register[20], output_register[21], output_register[22], output_register[23],
                        output_register[24], output_register[25], output_register[26], output_register[27],
                        output_register[28], output_register[29], output_register[30], output_register[31],
                        a1)
        rd2 = Mux.mux32(output_register[0], output_register[1], output_register[2], output_register[3],
                        output_register[4], output_register[5], output_register[6], output_register[7],
                        output_register[8], output_register[9], output_register[10], output_register[11],
                        output_register[12], output_register[13], output_register[14], output_register[15],
                        output_register[16], output_register[17], output_register[18], output_register[19],
                        output_register[20], output_register[21], output_register[22], output_register[23],
                        output_register[24], output_register[25], output_register[26], output_register[27],
                        output_register[28], output_register[29], output_register[30], output_register[31],
                        a2)
        return rd1, rd2


class Signal:
    @staticmethod
    def signal_ext(input_value, qt_bits_input, qt_bits_output):
        formatter_input = '0' + str(qt_bits_input) + 'b'

        value = str(format(input_value, formatter_input))

        return str(value[:1]) * (qt_bits_output - qt_bits_input) + str(value)

    @staticmethod
    def shift_left(input_value, qt_shift, qt_bits_output):
        formatter_output = '0' + str(qt_bits_output) + 'b'
        output = input_value << qt_shift

        return str(format(output, formatter_output))[-qt_bits_output:]

    @staticmethod
    def shift_left_aggr(input_value_addr, input_value_reg, qt_shift, qt_bits_output):
        formatter_addr = '0' + str(qt_bits_output - 4) + 'b'
        formatter_reg = '0' + str(32) + 'b'

        reg = str(format(input_value_reg, formatter_reg))[:4]
        addr_shifted = str(format(input_value_addr << qt_shift, formatter_addr))[-(qt_bits_output - 4):]

        return str(reg + addr_shifted)[-qt_bits_output:]


class Decoder:
    @staticmethod
    def decoder(input_value, qt_bits_output):
        if input_value > qt_bits_output:
            raise ValueError('Quantidade de bits do input nao decodificavel em: ' + str(qt_bits_output))

        output = [0] * qt_bits_output
        output[(qt_bits_output - 1) - input_value] = 1

        return ''.join(map(str, output))


class Adder:
    @staticmethod
    def adder(in_a, in_b, c_in):
        p = in_a ^ in_b
        g = in_a & in_b

        output = p ^ c_in
        c_out = g | (p & c_in)

        return output, c_out


class Sub:
    @staticmethod
    def sub(in_a, in_b, c_in):
        maior = in_a if in_a > in_b else in_b
        bits_a = in_a.bit_length()

        if maior == 0:
            maior = 1
        if in_a == 0:
            bits_a = 1

        max_bits = util.qt_numbers_bit(maior.bit_length())

        p = in_a ^ in_b
        g = Inv.inverter(in_a ^ in_b, max_bits)

        output = p ^ c_in
        c_out = (c_in & g) | (in_b & Inv.inverter(in_a, util.qt_numbers_bit(bits_a)))

        return output, c_out


class ULA:
    @staticmethod
    def func_and(in_a, in_b):
        return in_a & in_b

    @staticmethod
    def func_or(in_a, in_b):
        return in_a | in_b

    @staticmethod
    def func_xor(in_a, in_b):
        return in_a ^ in_b

    @staticmethod
    def func_nor(in_a, in_b):
        maior = in_a if in_a > in_b else in_b

        if maior == 0:
            maior = 1

        return (in_a | in_b) ^ util.qt_numbers_bit(maior.bit_length())

    @staticmethod
    def func_nand(in_a, in_b):
        maior = in_a if in_a > in_b else in_b

        if maior == 0:
            maior = 1

        return (in_a & in_b) ^ util.qt_numbers_bit(maior.bit_length())

    @staticmethod
    def func_sum(in_a, in_b, c_in):
        p = in_a ^ in_b
        g = in_a & in_b

        output = p ^ c_in
        c_out = g | (p & c_in)

        return output, c_out

    @staticmethod
    def func_sub(in_a, in_b, c_in):
        if in_a < in_b:
            a = util.qt_numbers_bit(32) - in_a
            b = util.qt_numbers_bit(32) - in_b

            c_out = 1

            output = ((a - b) ^ util.qt_numbers_bit(32)) + 1 - c_in
        else:
            output = (in_a - in_b)
            c_out = 0

        return output, c_out

    @staticmethod
    def func_slt(in_a, in_b):
        if in_a < in_b:
            return 1
        return 0

    @staticmethod
    def ula(in_a, in_b, cin, ula_controle):

        op_ula = {
            0: ULA.func_and(in_a, in_b),  # 000
            1: ULA.func_or(in_a, in_b),  # 001
            2: Adder.adder(in_a, in_b, cin),  # 010
            3: ULA.func_nor(in_a, in_b),  # 011
            # 4: ULA.func_nand(in_a, in_b),     # 100
            5: ULA.func_xor(in_a, in_b),  # 101
            6: Sub.sub(in_a, in_b, cin),  # 110
            7: ULA.func_slt(in_a, in_b)  # 111
        }

        return op_ula.get(ula_controle, "Operação não encontrada")

    @staticmethod
    def ula(in_a, in_b, ula_controle):
        zero = 0

        if (ula_controle == 2) or (ula_controle == 6):
            output, overflow = ULA.ula(in_a, in_b, ula_controle)
        else:
            output = ULA.ula(in_a, in_b, ula_controle)
            overflow = 0

        if output == 0:
            zero = 1

        return output, overflow, zero


class Datapath:
    # TODO: generalizar --
    #  alu_result, output_overflow, zero = ULA.ula(srcA, srcB, ula_controle)
    #  -- (ALUControl, SrcA, SrcB, ALUResult, Overflow, Zero)
    @staticmethod
    def datapath(clock, reset, iord, reg_dst, mem_to_reg, ir_write, reg_write, ula_srcA, branch, pc_write, ula_srcB,
                 pc_src, ula_controle, rd):
        zero, out_and_pc, pc_enable = 0
        inputPC, outputPC, outRegInstr, outRegData, outRegA, outRegB, wd3, rd1, rd2 = 0
        srcA, srcB, outSignExt, outShift2, alu_out, alu_result = 0
        inShift2, outShiftJump, jumpADDR = 0
        outMux5 = 0

        out_and_pc = zero & branch
        pc_enable = out_and_pc | pc_write

        outputPC = Flop.flopenr(inputPC, pc_enable, clock, reset, outputPC)
        output_address = Mux.mux(outputPC, alu_out, iord)
        outRegInstr = Flop.flopenr(rd, ir_write, clock, reset, outRegInstr)
        outRegData = Flop.flopr(rd, clock, reset, outRegData)
        outRegDataAux = format(outRegData, '032b')

        outMux5 = Mux.mux(int(outRegDataAux[-20:-16], 2), int(outRegDataAux[-15:-11], 2), reg_dst)
        wd3 = Mux.mux(alu_out, outRegData, mem_to_reg)

        rd1, rd2 = Flop.register_bank(int(outRegDataAux[-25:-21], 2), int(outRegDataAux[-20:-16], 2), outMux5, wd3,
                                      reg_write, clock, reset)

        outRegA = Flop.flopr(rd1, clock, reset, outRegA)
        outRegB = Flop.flopr(rd2, clock, reset, outRegB)

        output_wd = outRegB

        srcA = Mux.mux(outputPC, outRegA, ula_srcA)
        outSignExt = Signal.signal_ext(outRegDataAux[-15:], 32)
        outShift2 = Signal.shift_left(outSignExt, 2, 32)
        srcB = Mux.mux4_v2(outRegB, 4, outSignExt, outShift2, ula_srcB)

        alu_result, output_overflow, zero = ULA.ula(srcA, srcB, ula_controle)

        alu_out = Flop.flopenr(alu_result, clock, reset, alu_out)

        inShift2 = int('000000' + outRegDataAux[-25:], 2)
        outShiftJump = Signal.shift_left(inShift2, 2)

        outPcAux = format(outputPC, '032b')
        outShiftJumpAux = format(outShiftJump, '032b')

        jumpADDR = int(outPcAux[-31:-28] + outShiftJumpAux[-27:], 2)

        inputPC = Mux.mux4_v2(alu_result, alu_out, jumpADDR, 0, pc_src)

        return output_address, output_wd, output_overflow
