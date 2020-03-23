# -*- coding: utf-8 -*-

import pathlib

from utils import constants, modules

pathlib.Path(constants.TV_PATH).mkdir(parents=True, exist_ok=True)
pathlib.Path(constants.TB_PATH).mkdir(parents=True, exist_ok=True)

MAX_BIT_VALUE = constants.MAX_VALUE_BITS_1
formatter = '0' + str(MAX_BIT_VALUE.bit_length()) + 'b'

with open(constants.TV_PATH + constants.TRISTATE_TV_NAME, 'w') as f:
    for a in range(0, MAX_BIT_VALUE + 1):
        for en in range(0, constants.ENABLE_RANGE):
            out = modules.Tristate.tristate(a, en)
            if type(out) == str:
                f.write(format(a, formatter) + constants.DELIMITER + str(en) + constants.DELIMITER + (
                            out * MAX_BIT_VALUE.bit_length()) + '\n')
            else:
                f.write(format(a, formatter) + constants.DELIMITER + str(en) + constants.DELIMITER +
                        format(out, formatter) + '\n')
