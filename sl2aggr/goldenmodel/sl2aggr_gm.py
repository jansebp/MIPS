# -*- coding: utf-8 -*-

import os
import pathlib

from utils import constants, modules, util

pathlib.Path(constants.TV_PATH).mkdir(parents=True, exist_ok=True)
pathlib.Path(constants.TB_PATH).mkdir(parents=True, exist_ok=True)
FILENAME = os.path.splitext(os.path.basename(os.path.realpath(__file__)))[0].split('_')[0]

MAX_BIT_VALUE_INPUT_ADDR = util.qt_numbers_bit(constants.N_BITS_INPUT.get(FILENAME))
MAX_BIT_VALUE_INPUT_REG = util.qt_numbers_bit(constants.N_BITS_INPUT.get(FILENAME + '_reg'))

formatter_addr = '0' + str(MAX_BIT_VALUE_INPUT_ADDR.bit_length()) + 'b'
formatter_reg = '0' + str(MAX_BIT_VALUE_INPUT_REG.bit_length()) + 'b'
'''
with open(constants.TV_PATH + constants.TV_NAME.get(FILENAME), 'w') as f:
    for a in range(0, MAX_BIT_VALUE_INPUT_ADDR + 1):
        for r in range(0, MAX_BIT_VALUE_INPUT_REG + 1):
            f.write(format(a, formatter_addr) + constants.DELIMITER + format(r, formatter_reg) + constants.DELIMITER
                    + modules.Signal.shift_left_aggr(a, r, constants.RANGES.get(FILENAME),
                                                     constants.N_BITS_INPUT.get(FILENAME + '_reg'),
                                                     constants.N_BITS_OUTPUT.get(FILENAME)) + '\n')
'''

with open(constants.TV_PATH + constants.TV_NAME.get(FILENAME), 'w') as f:
    a = 0
    r = 7
    f.write(format(a, formatter_addr) + constants.DELIMITER + format(r, formatter_reg) + constants.DELIMITER
                + modules.Signal.shift_left_aggr(a, r, constants.RANGES.get(FILENAME),
                                                 constants.N_BITS_OUTPUT.get(FILENAME)) + '\n')
    a = 67108863
    r = 2379650559
    f.write(format(a, formatter_addr) + constants.DELIMITER + format(r, formatter_reg) + constants.DELIMITER
            + modules.Signal.shift_left_aggr(a, r, constants.RANGES.get(FILENAME),
                                             constants.N_BITS_OUTPUT.get(FILENAME)) + '\n')

    a = 27100645
    r = 2379650559
    f.write(format(a, formatter_addr) + constants.DELIMITER + format(r, formatter_reg) + constants.DELIMITER
            + modules.Signal.shift_left_aggr(a, r, constants.RANGES.get(FILENAME),
                                             constants.N_BITS_OUTPUT.get(FILENAME)) + '\n')

    a = 270645
    r = 2379650559
    f.write(format(a, formatter_addr) + constants.DELIMITER + format(r, formatter_reg) + constants.DELIMITER
            + modules.Signal.shift_left_aggr(a, r, constants.RANGES.get(FILENAME),
                                             constants.N_BITS_OUTPUT.get(FILENAME)) + '\n')

    a = 0
    r = 4294967295
    f.write(format(a, formatter_addr) + constants.DELIMITER + format(r, formatter_reg) + constants.DELIMITER
            + modules.Signal.shift_left_aggr(a, r, constants.RANGES.get(FILENAME),
                                             constants.N_BITS_OUTPUT.get(FILENAME)) + '\n')

    a = 67108863
    r = 0
    f.write(format(a, formatter_addr) + constants.DELIMITER + format(r, formatter_reg) + constants.DELIMITER
            + modules.Signal.shift_left_aggr(a, r, constants.RANGES.get(FILENAME),
                                             constants.N_BITS_OUTPUT.get(FILENAME)) + '\n')