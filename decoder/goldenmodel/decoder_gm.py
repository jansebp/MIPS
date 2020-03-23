# -*- coding: utf-8 -*-

import pathlib

from utils import constants, modules

pathlib.Path(constants.TV_PATH).mkdir(parents=True, exist_ok=True)
pathlib.Path(constants.TB_PATH).mkdir(parents=True, exist_ok=True)

MAX_BIT_VALUE = constants.MAX_VALUE_BITS_5
MAX_BIT_VALUE_OUTPUT = constants.MAX_VALUE_BITS_32
formatter = '0' + str(MAX_BIT_VALUE.bit_length()) + 'b'

with open(constants.TV_PATH + constants.DECODER_TV_NAME, 'w') as f:
    for i in range(0, MAX_BIT_VALUE + 1):
        output = modules.Decoder.decoder(i, MAX_BIT_VALUE_OUTPUT.bit_length())

        f.write(format(i, formatter) + constants.DELIMITER + output + '\n')
