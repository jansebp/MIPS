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
    'ula': 2,       # Range de valores para o input 'cin' da ULA
    'ula_op': 8,    # Range de valores de OP para a ULA
    'enable': 2,    # Range de valores para o Enable
    'reset': 2      # Range de valores para o Reset
}

CLOCK_PERIOD = 2                # Tempo de execucao para o CLK sair de HIGH e voltar para HIGH

# Quantidade de bits do input de cada módulo
N_BITS_INPUT = {
    'adder': 1,
    'decoder': 5,
    'flopenr': 1,
    'flopr': 1,
    'inv': 1,
    'mux': 1,
    'mux4': 1,
    'sub': 1,
    'tristate': 1,
    'ula': 32
}

# Quantidade de bits do output de cada módulo
N_BITS_OUTPUT = {
    'adder': 1,
    'decoder': 32,
    'flopenr': 1,
    'flopr': 1,
    'inv': 1,
    'mux': 1,
    'mux4': 1,
    'sub': 1,
    'tristate': 1,
    'ula': 32
}