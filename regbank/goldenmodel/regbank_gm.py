# -*- coding: utf-8 -*-

import os
import pathlib

from utils import constants, modules, util

pathlib.Path(constants.TV_PATH).mkdir(parents=True, exist_ok=True)
pathlib.Path(constants.TB_PATH).mkdir(parents=True, exist_ok=True)
FILENAME = os.path.splitext(os.path.basename(os.path.realpath(__file__)))[0].split('_')[0]

MAX_BIT_VALUE_INPUT = util.qt_numbers_bit(constants.N_BITS_INPUT.get(FILENAME))
MAX_BIT_VALUE_OUTPUT = util.qt_numbers_bit(constants.N_BITS_OUTPUT.get(FILENAME))
SEL_RANGE = constants.RANGES.get(FILENAME)
formatter_in = '0' + str(MAX_BIT_VALUE_INPUT.bit_length()) + 'b'
formatter_out = '0' + str(MAX_BIT_VALUE_OUTPUT.bit_length()) + 'b'

with open(constants.TV_PATH + constants.TV_NAME.get(FILENAME), 'w') as f:
    a, b, c, wd, we, rst = 1, 17, 0, 0, 1, 1
    iteration = 0
    for i in range(0, 16):
        for clk in range(0, SEL_RANGE):
            if iteration == 1:
                rst = 0
            if iteration in (4,8,12,14,16,18,20,22,24,28):
                wd = modules.Inv.inverter(wd, MAX_BIT_VALUE_OUTPUT)

            rd1, rd2 = modules.Flop.register_bank(a, b, c, wd, we, clk, rst)

            if iteration == 0:
                rd1 = ''.join(['x'] * 32)
                rd2 = ''.join(['x'] * 32)

                f.write(str(format(a, formatter_in)) + constants.DELIMITER + str(format(b, formatter_in))
                        + constants.DELIMITER + str(format(c, formatter_in)) + constants.DELIMITER
                        + str(format(wd, formatter_out)) + constants.DELIMITER
                        + str(we) + constants.DELIMITER + str(clk) + constants.DELIMITER + str(rst)
                        + constants.DELIMITER + rd1 + constants.DELIMITER + rd2 + '\n')
            else:
                f.write(str(format(a, formatter_in)) + constants.DELIMITER + str(format(b, formatter_in))
                        + constants.DELIMITER + str(format(c, formatter_in)) + constants.DELIMITER
                        + str(format(wd, formatter_out)) + constants.DELIMITER
                        + str(we) + constants.DELIMITER + str(clk) + constants.DELIMITER
                        + str(rst) + constants.DELIMITER + str(format(rd1, formatter_out)) + constants.DELIMITER
                        + str(format(rd2, formatter_out)) + '\n')

            iteration = iteration + 1

        if a < 32:
            a = a + 1
        if b < 31:
            b = b + 1
        if c < 31:
            c = c + 2
