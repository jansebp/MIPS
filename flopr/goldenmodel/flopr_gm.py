# -*- coding: utf-8 -*-

import os
import pathlib

from utils import constants, modules, util

pathlib.Path(constants.TV_PATH).mkdir(parents=True, exist_ok=True)
pathlib.Path(constants.TB_PATH).mkdir(parents=True, exist_ok=True)
FILENAME = os.path.splitext(os.path.basename(os.path.realpath(__file__)))[0].split('_')[0]

MAX_BIT_VALUE = util.qt_numbers_bit(constants.N_BITS_INPUT.get(FILENAME))
formatter = '0' + str(MAX_BIT_VALUE.bit_length()) + 'b'

with open(constants.TV_PATH + constants.TV_NAME.get(FILENAME), 'w+') as f:
    clk = 0
    q = 'x'

    for i in range(0, 2):
        if i == 0:
            RESET_VALUE = 0
            for d in range(0, MAX_BIT_VALUE + 1):
                for aux in range(0, 2):
                    for aux2 in range(0, constants.CLOCK_PERIOD):

                        q = modules.Flop.flopr(d, clk, RESET_VALUE, q)

                        if q == 'x':
                            f.write(format(d, formatter) + constants.DELIMITER + str(clk) + constants.DELIMITER
                                    + str(RESET_VALUE) + constants.DELIMITER + str('x' * MAX_BIT_VALUE.bit_length())
                                    + '\n')
                        else:
                            f.write(format(d, formatter) + constants.DELIMITER + str(clk) + constants.DELIMITER
                                    + str(RESET_VALUE) + constants.DELIMITER + format(q, formatter) + '\n')

                        clk = int(not clk)
        else:
            for d in range(0, MAX_BIT_VALUE + 1):
                for aux in range(0, 2):
                    for reset in range(0, constants.RANGES.get('reset')):
                        for aux2 in range(0, constants.CLOCK_PERIOD):

                            q = modules.Flop.flopr(d, clk, reset, q)

                            if q == 'x':
                                f.write(format(d, formatter) + constants.DELIMITER + str(clk) + constants.DELIMITER
                                        + str(reset) + constants.DELIMITER + str('x' * MAX_BIT_VALUE.bit_length())
                                        + '\n')
                            else:
                                f.write(format(d, formatter) + constants.DELIMITER + str(clk) + constants.DELIMITER
                                        + str(reset) + constants.DELIMITER + format(q, formatter) + '\n')

                            clk = int(not clk)
