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
