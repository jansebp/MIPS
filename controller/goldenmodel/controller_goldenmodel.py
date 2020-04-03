# -*- coding: utf-8 -*-

import os
import pathlib

from utils import constants, modules

pathlib.Path(constants.TV_PATH).mkdir(parents=True, exist_ok=True)
pathlib.Path(constants.TB_PATH).mkdir(parents=True, exist_ok=True)
FILENAME = os.path.splitext(os.path.basename(os.path.realpath(__file__)))[0].split('_')[0]

# MAX_BIT_VALUE_INPUT = util.qt_numbers_bit(constants.N_BITS_INPUT.get(FILENAME))
# MAX_BIT_VALUE_OUTPUT = util.qt_numbers_bit(constants.N_BITS_OUTPUT.get(FILENAME))
# SEL_RANGE = constants.RANGES.get(FILENAME)
# formatter_in = '0' + str(MAX_BIT_VALUE_INPUT.bit_length()) + 'b'
formatter_rd = '032b'

with open(constants.TV_PATH + constants.TV_NAME.get(FILENAME), 'w') as f:
    reset = 1
    iteration = 0

    for rd in (0, 536936453, 2885746689, 2348941314, 3, 134217730):
        for pcSrc in range(0, 3 + 1):
            for pcWrite in range(0, 1):
                for branch in range(0, 1):
                    for aluControl in (0,2):
                        for aluSrcB in range(0, 3 + 1):
                            for aluSrcA in (0, 1):
                                for regWrite in (0, 1):
                                    for memToReg in (0, 1):
                                        for regDest in (0, 1):
                                            for irWrite in (0, 1):
                                                for iord in (0, 1):
                                                    for clock in range(0, constants.RANGES.get('clock')):
                                                        if iteration == 1:
                                                            reset = 0

                                                        rd_aux = format(rd, '032b')
                                                        rd1 = rd_aux[:6]
                                                        rd2 = rd_aux[6:11]
                                                        rd3 = rd_aux[11:16]
                                                        rd4 = rd_aux[16:20]
                                                        rd5 = rd_aux[20:24]
                                                        rd6 = rd_aux[24:28]
                                                        rd7 = rd_aux[28:32]

                                                        addr, wd, overflow = modules.Datapath.datapath(
                                                            clock, reset, iord, regDest, memToReg, irWrite,
                                                            regWrite, aluSrcA, branch, pcWrite, aluSrcB,
                                                            pcSrc, aluControl, rd)

                                                        f.write(
                                                            str(clock) + constants.DELIMITER
                                                            + str(reset) + constants.DELIMITER
                                                            + str(iord) + constants.DELIMITER
                                                            + str(irWrite) + constants.DELIMITER
                                                            + str(regDest) + constants.DELIMITER
                                                            + str(memToReg) + constants.DELIMITER
                                                            + str(regWrite) + constants.DELIMITER
                                                            + str(aluSrcA) + constants.DELIMITER
                                                            + format(aluSrcB, '02b') + constants.DELIMITER
                                                            + format(aluControl, '03b') + constants.DELIMITER
                                                            + str(branch) + constants.DELIMITER
                                                            + str(pcWrite) + constants.DELIMITER
                                                            + format(pcSrc, '02b') + constants.DELIMITER

                                                            + str(rd1) + constants.DELIMITER
                                                            + str(rd2) + constants.DELIMITER
                                                            + str(rd3) + constants.DELIMITER
                                                            + str(rd4) + constants.DELIMITER
                                                            + str(rd5) + constants.DELIMITER
                                                            + str(rd6) + constants.DELIMITER
                                                            + str(rd7) + constants.DELIMITER

                                                            + format(addr, '032b') + constants.DELIMITER
                                                            + format(wd, '032b') + constants.DELIMITER
                                                            + str(overflow) + constants.DELIMITER

                                                            + '\n')

                                                    iteration = iteration + 1
        '''
        for clk in range(0, SEL_RANGE):
            if iteration == 1:
                rst = 0
            if iteration in (4,8,12,14,16,18,20,22,24,28):
                wd = modules.Inv.inverter(wd, MAX_BIT_VALUE_OUTPUT)

            rd1, rd2 = modules.Flop.register_bank(a, b, c, wd, we, clk, rst)

            if iteration == 0:
                rd1 = ''.join(['x'] * 32)
                rd2 = ''.join(['x'] * 32)

                f.write(str(format(a, formatter_in)) + constants.DELIMITER + str(format(b, formatter_in))
                        + constants.DELIMITER + str(format(c, formatter_in)) + constants.DELIMITER
                        + str(format(wd, formatter_out)) + constants.DELIMITER
                        + str(we) + constants.DELIMITER + str(clk) + constants.DELIMITER + str(rst)
                        + constants.DELIMITER + rd1 + constants.DELIMITER + rd2 + '\n')
            else:
                f.write(str(format(a, formatter_in)) + constants.DELIMITER + str(format(b, formatter_in))
                        + constants.DELIMITER + str(format(c, formatter_in)) + constants.DELIMITER
                        + str(format(wd, formatter_out)) + constants.DELIMITER
                        + str(we) + constants.DELIMITER + str(clk) + constants.DELIMITER
                        + str(rst) + constants.DELIMITER + str(format(rd1, formatter_out)) + constants.DELIMITER
                        + str(format(rd2, formatter_out)) + '\n')

            iteration = iteration + 1

        if a < 32:
            a = a + 1
        if b < 31:
            b = b + 1
        if c < 31:
            c = c + 2
        '''
