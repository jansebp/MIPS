# -*- coding: utf-8 -*-

import os
import pathlib

from utils import constants, modules

pathlib.Path(constants.TV_PATH).mkdir(parents=True, exist_ok=True)
pathlib.Path(constants.TB_PATH).mkdir(parents=True, exist_ok=True)
FILENAME = os.path.splitext(os.path.basename(os.path.realpath(__file__)))[0].split('_')[0]

N_BITS = 1
N_BITS_OP = 3
MAX_BIT_VALUE = constants.MAX_VALUE_BITS.get(N_BITS)
MAX_BIT_OP_VALUE = constants.MAX_VALUE_BITS.get(N_BITS_OP)
formatter = '0' + str(MAX_BIT_VALUE.bit_length()) + 'b'
formatter_op = '0' + str(MAX_BIT_OP_VALUE.bit_length()) + 'b'

with open(constants.TV_PATH + constants.TV_NAME.get(FILENAME), 'w') as f:
    for op in range(0, constants.RANGES.get(FILENAME + '_op')):
        for a in range(0, MAX_BIT_VALUE + 1):
            for b in range(0, MAX_BIT_VALUE + 1):
                for cin in range(0, constants.RANGES.get(FILENAME)):
                    output = None
                    if (op == 2) or (op == 6):
                        out, c_out = modules.ULA.ula(a, b, cin, op)

                        f.write(
                            format(op, formatter_op) + constants.DELIMITER + format(a, formatter) + constants.DELIMITER
                            + format(b, formatter) + constants.DELIMITER + str(cin) + constants.DELIMITER
                            + format(out, formatter) + constants.DELIMITER + format(c_out, formatter) + '\n')
                    else:
                        out = modules.ULA.ula(a, b, cin, op)
                        c_out = 'x'

                        f.write(
                            format(op, formatter_op) + constants.DELIMITER + format(a, formatter) + constants.DELIMITER
                            + format(b, formatter) + constants.DELIMITER + str(cin) + constants.DELIMITER
                            + format(out, formatter) + constants.DELIMITER + c_out * MAX_BIT_VALUE.bit_length() + '\n')
