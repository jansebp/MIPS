# -*- coding: utf-8 -*-

import os
import pathlib

from utils import constants, modules, util

pathlib.Path(constants.TV_PATH).mkdir(parents=True, exist_ok=True)
pathlib.Path(constants.TB_PATH).mkdir(parents=True, exist_ok=True)
FILENAME = os.path.splitext(os.path.basename(os.path.realpath(__file__)))[0].split('_')[0]

MAX_BIT_VALUE = util.qt_numbers_bit(constants.N_BITS_INPUT.get(FILENAME))
formatter = '0' + str(MAX_BIT_VALUE.bit_length()) + 'b'
formatter_op = '0' + str((constants.RANGES.get(FILENAME + '_op')).bit_length()) + 'b'


def write_file(file, n_bits, formatter_input, formatter_op, operation, add_sub, in_a, in_b, c_in, out, overflow, zero):
    if n_bits == 1:
        file.write(
            format(operation, formatter_op) + constants.DELIMITER + format(in_a, formatter_input)
            + constants.DELIMITER + format(in_b, formatter_input) + constants.DELIMITER + str(c_in)
            + constants.DELIMITER + format(add_sub, formatter_input) + constants.DELIMITER
            + format(out, formatter_input)
            + '\n'
        )
        file.flush()
    elif n_bits == 32:
        file.write(
            format(operation, formatter_op) + constants.DELIMITER + format(in_a, formatter_input)
            + constants.DELIMITER + format(in_b, formatter_input) + constants.DELIMITER
            + str(add_sub) + constants.DELIMITER + format(out, formatter_input) + constants.DELIMITER
            + str(overflow) + constants.DELIMITER + str(zero)
            + '\n'
        )
        file.flush()


with open(constants.TV_PATH + constants.TV_NAME.get(FILENAME), 'w') as f:
    for op in range(0, constants.RANGES.get(FILENAME + '_op') + 1):
        if op != 4:
            #for a in range(0, MAX_BIT_VALUE + 1):
            for a in (0, MAX_BIT_VALUE >> 1, MAX_BIT_VALUE):
                #for b in range(0, MAX_BIT_VALUE + 1):
                for b in (0, 1, MAX_BIT_VALUE):
                    for cin in range(0, constants.RANGES.get(FILENAME)):
                        for addsub in range(0, constants.RANGES.get(FILENAME)):
                            if (op == 2) or (op == 6):
                                bAux = b ^ addsub
                                out, c_out = modules.ULA.ula(a, bAux, cin, op)
                                zero = 1 if out == 0 else 0

                                overflow = 0
                                if ((a > 0) and (b > 0) and (a + b < 0)) or ((a < 0) and (b < 0) and (a + b > 0)):
                                    overflow = 1

                                write_file(f, constants.N_BITS_INPUT.get(FILENAME), formatter, formatter_op, op, addsub,
                                           a, b, cin, out, overflow, zero)
                            else:
                                if cin == 0:
                                    out = modules.ULA.ula(a, b, cin, op)
                                    zero = 1 if out == 0 else 0
                                    c_out = 0

                                    overflow = 0
                                    if ((a > 0) and (b > 0) and (a + b < 0)) or ((a < 0) and (b < 0) and (a + b > 0)):
                                        overflow = 1

                                    write_file(f, constants.N_BITS_INPUT.get(FILENAME), formatter, formatter_op, op,
                                               addsub, a, b, cin, out, overflow, zero)
