# -*- coding: utf-8 -*-

import os
import pathlib

from utils import constants, modules, util


pathlib.Path(constants.TV_PATH).mkdir(parents=True, exist_ok=True)
pathlib.Path(constants.TB_PATH).mkdir(parents=True, exist_ok=True)
FILENAME = os.path.splitext(os.path.basename(os.path.realpath(__file__)))[0].split('_')[0]

MAX_BIT_VALUE = util.qt_numbers_bit(constants.N_BITS_INPUT.get(FILENAME))
formatter = '0' + str(MAX_BIT_VALUE.bit_length()) + 'b'
formatter_op = '0' + str((constants.RANGES.get(FILENAME + '_op') - 1).bit_length()) + 'b'

with open(constants.TV_PATH + constants.TV_NAME.get(FILENAME), 'w') as f:
    for op in range(0, constants.RANGES.get(FILENAME + '_op')):
        if op != 4:
            for a in range(0, MAX_BIT_VALUE + 1):
                for b in range(0, MAX_BIT_VALUE + 1):
                    for cin in range(0, constants.RANGES.get(FILENAME)):
                        if (op == 2) or (op == 6):
                            out, c_out = modules.ULA.ula(a, b, cin, op)
                            zero = 1 if out == 0 else 0

                            f.write(
                                format(op, formatter_op) + constants.DELIMITER + format(a, formatter)
                                + constants.DELIMITER + format(b, formatter) + constants.DELIMITER + str(cin)
                                + constants.DELIMITER + format(out, formatter) + constants.DELIMITER
                                + str(zero) + constants.DELIMITER + str(c_out) + '\n')
                        else:
                            out = modules.ULA.ula(a, b, cin, op)
                            zero = 1 if out == 0 else 0
                            c_out = 'x'
                            cin = 'x'

                            f.write(
                                format(op, formatter_op) + constants.DELIMITER + format(a, formatter)
                                + constants.DELIMITER + format(b, formatter) + constants.DELIMITER + str(cin)
                                + constants.DELIMITER + format(out, formatter) + constants.DELIMITER
                                + str(zero) + constants.DELIMITER + str(c_out) + '\n')