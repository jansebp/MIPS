# -*- coding: utf-8 -*-

import os
import pathlib

from utils import constants, modules, util

pathlib.Path(constants.TV_PATH).mkdir(parents=True, exist_ok=True)
pathlib.Path(constants.TB_PATH).mkdir(parents=True, exist_ok=True)
FILENAME = os.path.splitext(os.path.basename(os.path.realpath(__file__)))[0].split('_')[0]

MAX_BIT_VALUE = util.qt_numbers_bit(constants.N_BITS_INPUT.get(FILENAME))
SEL_RANGE = constants.RANGES.get(FILENAME)
formatter = '0' + str(MAX_BIT_VALUE.bit_length()) + 'b'
formatter_sel = '0' + str(constants.RANGES.get(FILENAME).bit_length()) + 'b'

with open(constants.TV_PATH + constants.TV_NAME.get(FILENAME), 'w') as f:
    for a in range(0, MAX_BIT_VALUE + 1):
        for b in range(0, MAX_BIT_VALUE + 1):
            for c in range(0, MAX_BIT_VALUE + 1):
                for d in range(0, MAX_BIT_VALUE + 1):
                    for e in range(0, MAX_BIT_VALUE + 1):
                        for g in range(0, MAX_BIT_VALUE + 1):
                            for h in range(0, MAX_BIT_VALUE + 1):
                                for i in range(0, MAX_BIT_VALUE + 1):
                                    for s in range(0, SEL_RANGE + 1):
                                        f.write(format(s, formatter_sel) + constants.DELIMITER, format(a, formatter)
                                                + constants.DELIMITER + format(b, formatter) + constants.DELIMITER
                                                + format(c, formatter) + constants.DELIMITER + format(d, formatter)
                                                + constants.DELIMITER + format(e, formatter) + constants.DELIMITER
                                                + format(g, formatter) + constants.DELIMITER + format(h, formatter)
                                                + constants.DELIMITER + format(i, formatter) + constants.DELIMITER
                                                + format(modules.Mux.mux8(a, b, c, d, e, g, h, i, s), formatter) + '\n')
