.text
    j *_main

# Desempilhar 16 valores da stack e printa eles
_printa:
    li $sc, 1 # Printa int8
    li $t1, 16
    while_printa:
        beq $t1, $zero, *end_printa

        lb $t0, 1($sp)
        syscall
        inc $sp

        dec $t1
        j *while_printa
    end_printa:

    li $t0, 10 # new line
    li $sc, 5  # print ascii
    syscall

    return

# Calcula o resto da divisão de t0 por 2 e salva na stack
_resto_por_2:
    # t0 = xxxxxxxxxxxxxxxx
    #  1 = 0000000000000001
    # ---------------------
    # t0 = 000000000000000x
    andi $t2, $t0, 1

    dec $sp
    sb $t2, 1($sp)

    return    

_main:
    lrw $t0, 0(*num)

    # while (t1 != 0) do
    li $t1, 16
    while:
        beq $t1, $zero, *end
        jal *_resto_por_2
        srl $t0, $t0, 1
        dec $t1
        j *while
    end:

    jal *_printa

    # Exit
    li $sc, 0
    syscall

.data
    num: .int16 24892