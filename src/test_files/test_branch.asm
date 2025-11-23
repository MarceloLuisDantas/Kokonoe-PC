.text

    j *_main

# Calcula a soma de todos os numeros entre 0 e $t1 e salva em $t0
_somatorio:
    # Garantir que t0 = 0
    li $t0, 0 
    loop_s:
        add  $t0, $t0, $t1          # t0 += t1
        subi $t1, $t1, 1            # t1 -= 1
        beq  $t1, $zero, *end_s     # if (t1 == 0), goto end_s
        j    *loop_s
    end_s:
        return

# Finaliza o programa
_exit:
    li $sc, 0
    syscall


# Printa o valor armazenado em t0
_print: 
    li $sc, 1
    syscall
    return


_main:

    li  $t1, 100
    jal *_somatorio
    jal *_print

    j *_exit
