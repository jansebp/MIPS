from utils import constants, util

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
            #4: ULA.func_nand(in_a, in_b),
            5: ULA.func_xor(in_a, in_b),
            6: ULA.func_sub(in_a, in_b, cin),
            7: ULA.func_slt(in_a, in_b)
        }

        return op_ula.get(operation, "Operacao nao encontrada")