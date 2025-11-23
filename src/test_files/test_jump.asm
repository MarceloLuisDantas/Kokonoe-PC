.text

    j *_main

# Finaliza o programa
_exit:
    li $sc, 0
    syscall

# Printa na tela o valor armazenado em $t0
_print:
    li $sc, 1
    syscall
    return

_soma_1:
    addi $t0, $t0, 1
    return

_main:
    li  $t0, 0

    # Soma 1 a $t0 e printa
    loop:
        jal *_soma_1
        jal *_print
        j   *loop


