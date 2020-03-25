# -*- coding: utf-8 -*-

import os
import pathlib

from utils import constants, modules, util

pathlib.Path(constants.TV_PATH).mkdir(parents=True, exist_ok=True)
pathlib.Path(constants.TB_PATH).mkdir(parents=True, exist_ok=True)
FILENAME = os.path.splitext(os.path.basename(os.path.realpath(__file__)))[0].split('_')[0]

MAX_BIT_VALUE = util.qt_numbers_bit(constants.N_BITS_INPUT.get(FILENAME))
formatter = '0' + str(MAX_BIT_VALUE.bit_length()) + 'b'

with open(constants.TV_PATH + constants.TV_NAME.get(FILENAME), 'w') as f:
    for a in range(0, MAX_BIT_VALUE + 1):
        for en in range(0, constants.RANGES.get('enable')):
            out = modules.Tristate.tristate(a, en)
            if type(out) == str:
                f.write(format(a, formatter) + constants.DELIMITER + str(en) + constants.DELIMITER + (
                        out * MAX_BIT_VALUE.bit_length()) + '\n')
            else:
                f.write(format(a, formatter) + constants.DELIMITER + str(en) + constants.DELIMITER +
                        format(out, formatter) + '\n')
