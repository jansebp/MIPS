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
        s1 = selection[:2]
        s2 = selection[2:]
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
    def ula(in_a, in_b, cin, operation):

        op_ula = {
            0: ULA.func_and(in_a, in_b),
            1: ULA.func_or(in_a, in_b),
            2: ULA.func_sum(in_a, in_b, cin),
            3: ULA.func_nor(in_a, in_b),
            # 4: ULA.func_nand(in_a, in_b),
            5: ULA.func_xor(in_a, in_b),
            6: ULA.func_sub(in_a, in_b, cin),
            7: ULA.func_slt(in_a, in_b)
        }

        return op_ula.get(operation, "Operacao nao encontrada")
