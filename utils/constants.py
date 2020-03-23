##################################################
# Constantes para o MIPS 32 Bits
##################################################

DELIMITER = '_'             # delimitador para os arquivos .TV

# Paths para os arquivos de TV (test vector) e de Testbench - Quartus / ModelSIM
TV_PATH = '..\\simulation\\modelsim\\'
TB_PATH = '..\\testbench\\'

# Nomes para os arquivos de test vector (.TV)
INV_TV_NAME = 'inv.tv'
TRISTATE_TV_NAME = 'tristate.tv'
MUX_TV_NAME = 'mux.tv'
MUX4_TV_NAME = 'mux4.tv'
FLOPR_TV_NAME = 'flopr.tv'
FLOPENR_TV_NAME = 'flopenr.tv'
DECODER_TV_NAME = 'decoder.tv'

MUX_SELECTION_RANGE = 2         # Range de valores para o input 'sel' do MUX
MUX4_SELECTION_RANGE = 4        # Range de valores para o input 'sel' do MUX4

ENABLE_RANGE = 2                # Range de valores para o Enable
RESET_RANGE = 2                 # Range de valores para o Reset
CLOCK_PERIOD = 2                # Tempo de execucao para o CLK sair de HIGH e voltar para HIGH

MAX_VALUE_BITS_1 = 1            # Constante para execucao com inputs de 1 bit
MAX_VALUE_BITS_2 = 3            # Constante para execucao com inputs de 2 bits
MAX_VALUE_BITS_3 = 7            # Constante para execucao com inputs de 3 bits
MAX_VALUE_BITS_4 = 15           # Constante para execucao com inputs de 4 bits
MAX_VALUE_BITS_5 = 31           # Constante para execucao com inputs de 5 bits
MAX_VALUE_BITS_32 = 4294967295  # Constante para execucao com inputs de 32 bits
