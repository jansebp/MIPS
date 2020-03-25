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

with open(constants.TV_PATH + constants.TV_NAME.get(FILENAME), 'w') as f:
    for a in range(0, MAX_BIT_VALUE + 1):
        for b in range(0, MAX_BIT_VALUE + 1):
            for c in range(0, MAX_BIT_VALUE + 1):
                for d in range(0, MAX_BIT_VALUE + 1):
                    for s in range(0, SEL_RANGE):
                        selection = str(format(s, '02b'))
                        s1 = int(selection[0:1])
                        s2 = int(selection[1:2])

                        f.write(format(a, formatter) + constants.DELIMITER + format(b, formatter) + constants.DELIMITER
                                + format(c, formatter) + constants.DELIMITER + format(d, formatter)
                                + constants.DELIMITER + str(s1) + constants.DELIMITER + str(s2) + constants.DELIMITER
                                + format(modules.Mux.mux4(a, b, c, d, s1, s2), formatter) + '\n')
