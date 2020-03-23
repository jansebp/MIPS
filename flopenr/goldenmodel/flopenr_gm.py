# -*- coding: utf-8 -*-

import pathlib

from utils import constants, modules

pathlib.Path(constants.TV_PATH).mkdir(parents=True, exist_ok=True)
pathlib.Path(constants.TB_PATH).mkdir(parents=True, exist_ok=True)

MAX_BIT_VALUE = constants.MAX_VALUE_BITS_1
formatter = '0' + str(MAX_BIT_VALUE.bit_length()) + 'b'

with open(constants.TV_PATH + constants.FLOPENR_TV_NAME, 'w') as f:
    clk = 0
    q = 'x'

    for i in range(0, 2):
        if i == 0:
            RESET_VALUE = 0
            for d in range(0, MAX_BIT_VALUE + 1):
                for aux in range(0, 2):
                    for enable in range(0, constants.ENABLE_RANGE):
                        for aux2 in range(0, constants.CLOCK_PERIOD):

                            q = modules.Flop.flopenr(d, enable, clk, RESET_VALUE, q)

                            if q == 'x':
                                f.write(format(d, formatter) + constants.DELIMITER + str(enable) + constants.DELIMITER
                                        + str(clk) + constants.DELIMITER + str(RESET_VALUE) + constants.DELIMITER
                                        + str('x' * MAX_BIT_VALUE.bit_length()) + '\n')
                            else:
                                f.write(format(d, formatter) + constants.DELIMITER + str(enable) + constants.DELIMITER
                                        + str(clk) + constants.DELIMITER + str(RESET_VALUE) + constants.DELIMITER
                                        + format(q, formatter) + '\n')

                            clk = int(not clk)
        else:
            for d in range(0, MAX_BIT_VALUE + 1):
                for aux in range(0, 2):
                    for enable in range(0, constants.ENABLE_RANGE):
                        for reset in range(0, constants.RESET_RANGE):
                            for aux2 in range(0, constants.CLOCK_PERIOD):

                                q = modules.Flop.flopenr(d, enable, clk, reset, q)

                                if q == 'x':
                                    f.write(
                                        format(d, formatter) + constants.DELIMITER + str(enable) + constants.DELIMITER
                                        + str(clk) + constants.DELIMITER + str(reset) + constants.DELIMITER
                                        + str('x' * MAX_BIT_VALUE.bit_length()) + '\n')
                                else:
                                    f.write(
                                        format(d, formatter) + constants.DELIMITER + str(enable) + constants.DELIMITER
                                        + str(clk) + constants.DELIMITER + str(reset) + constants.DELIMITER
                                        + format(q, formatter) + '\n')

                                clk = int(not clk)
