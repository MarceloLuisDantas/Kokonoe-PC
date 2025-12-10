.text
    j *_main

# Carrega uma linha para a stack
_load_line:


# Carrega a tabela para a stack
_load_tabel:


# Retorna uma celula especifica da tabela
_get_cell:


# Seta uma celula especifica da tabela
_set_cell:


# Retornar os 8(max) vizinhos de uma celula especifica
_get_vizinhos:


# Descide se uma celula vai nascer ou morrer
_born_or_die:


# Gera a proxima geração
_next_gen:



# Pega as novas geração, e seta na tabela
_update_table:


_main:
    jal *_load_tabel

.data
    alive: .string "#"