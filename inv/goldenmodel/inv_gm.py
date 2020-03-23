# -*- coding: utf-8 -*-

import pathlib

from utils import constants, modules

pathlib.Path(constants.TV_PATH).mkdir(parents=True, exist_ok=True)
pathlib.Path(constants.TB_PATH).mkdir(parents=True, exist_ok=True)

MAX_BIT_VALUE = constants.MAX_VALUE_BITS_1
formatter = '0' + str(MAX_BIT_VALUE.bit_length()) + 'b'

with open(constants.TV_PATH + constants.INV_TV_NAME, 'w') as f:
    for i in range(0, MAX_BIT_VALUE + 1):
        f.write(format(i, formatter) + constants.DELIMITER + format(modules.Inv.inverter(i, MAX_BIT_VALUE),
                                                                    formatter) + '\n')
