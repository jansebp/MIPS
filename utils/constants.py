##################################################
# Constantes para o MIPS 32 Bits
##################################################

DELIMITER = '_'             # delimitador para os arquivos .TV

# Paths para os arquivos de TV (test vector) e de Testbench - Quartus / ModelSIM
TV_PATH = '..\\simulation\\modelsim\\'
TB_PATH = '..\\testbench\\'

# Nomes para os arquivos de test vector (.TV)
TV_NAME = {
    'inv': 'inv.tv',
    'tristate': 'tristate.tv',
    'mux': 'mux.tv',
    'mux4': 'mux4.tv',
    'flopr': 'flopr.tv',
    'flopenr': 'flopenr.tv',
    'decoder': 'decoder.tv',
    'adder': 'adder.tv',
    'sub': 'sub.tv',
    'ula': 'ula.tv',
    'uladec': 'uladec.tv'
}

RANGES = {
    'mux': 2,       # Range de valores para o input 'sel' do MUX
    'mux4': 4,      # Range de valores para o input 'sel' do MUX4
    'adder': 2,     # Range de valores para o input 'cin' do ADDER
    'sub': 2,       # Range de valores para o input 'cin' do SUB
    'enable': 2,    # Range de valores para o Enable
    'reset': 2      # Range de valores para o Reset
}

CLOCK_PERIOD = 2                # Tempo de execucao para o CLK sair de HIGH e voltar para HIGH

MAX_VALUE_BITS = {
    1: 1,                       # Constante para execucao com inputs de 1 bit
    2: 3,                       # Constante para execucao com inputs de 2 bits
    3: 7,                       # Constante para execucao com inputs de 3 bits
    4: 15,                      # Constante para execucao com inputs de 4 bits
    5: 31,                      # Constante para execucao com inputs de 5 bits
    32: 4294967295              # Constante para execucao com inputs de 32 bits
}
