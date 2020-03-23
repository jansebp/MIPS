# -*- coding: utf-8 -*-

import pathlib

from utils import constants, modules

pathlib.Path(constants.TV_PATH).mkdir(parents=True, exist_ok=True)
pathlib.Path(constants.TB_PATH).mkdir(parents=True, exist_ok=True)

MAX_BIT_VALUE = constants.MAX_VALUE_BITS_1
formatter = '0' + str(MAX_BIT_VALUE.bit_length()) + 'b'

with open(constants.TV_PATH + constants.MUX_TV_NAME, 'w') as f:
    for a in range(0, MAX_BIT_VALUE + 1):
        for b in range(0, MAX_BIT_VALUE + 1):
            for s in range(0, constants.MUX_SELECTION_RANGE):
                f.write(format(a, formatter) + constants.DELIMITER + format(b, formatter) + constants.DELIMITER + str(
                    s) + constants.DELIMITER + format(modules.Mux.mux(a, b, s), formatter) + '\n')
