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
        for b in range(0, MAX_BIT_VALUE + 1):
            for s in range(0, constants.RANGES.get(FILENAME)):
                f.write(str(s) + constants.DELIMITER + format(a, formatter) + constants.DELIMITER
                        + format(b, formatter) + constants.DELIMITER + format(modules.Mux.mux(a, b, s), formatter)
                        + '\n')
