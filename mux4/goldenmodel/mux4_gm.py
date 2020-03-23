# -*- coding: utf-8 -*-

import pathlib

from utils import constants, modules

pathlib.Path(constants.TV_PATH).mkdir(parents=True, exist_ok=True)
pathlib.Path(constants.TB_PATH).mkdir(parents=True, exist_ok=True)

MAX_BIT_VALUE = constants.MAX_VALUE_BITS_1
SEL_RANGE = constants.MUX4_SELECTION_RANGE
formatter = '0' + str(MAX_BIT_VALUE.bit_length()) + 'b'

with open(constants.TV_PATH + constants.MUX4_TV_NAME, 'w') as f:
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
