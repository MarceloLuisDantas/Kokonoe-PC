.text
    j *_main

# Calcula a media dos valores de uma lista de numeros
# o tamanho da lista deve estar em $t1
# o ponteiro para a lista deve estar em $t2
# $t3, $t4 e $t0 precisa estar disponivel
_calc_media:
    li   $t0, 0
    li   $t3, 0
    move $t4, $t1

    loop_c:
        beq  $t1, $zero, *end_c # if (t1 == 0); goto end_c
        lrb  $t3, 0($t2)        # t3 = notas[x]
        add  $t0, $t0, $t3      # t0 += t3
        addi $t2, $t2, 1        # t2 += 1
        subi $t1, $t1, 1        # t1 -= 1
        j    *loop_c            
    end_c:

    div $t0, $t0, $t4
    syscall     

    return

_main:
    li $sc, 1 # print inteiro

    lrb $t1, 0(*num_1) # t1 = 20
    lrb $t2, 0(*num_2) # t2 = 10
    add $t0, $t1, $t2

    syscall

    lrb $t1, 1(*num_1)  # t1 = 10
    lrb $t2, -1(*num_2) # t2 = 20
    add $t0, $t1, $t2

    syscall

    lrb $t1, 0(*num_n)
    move $t0, $t1
    syscall

    li  $t2, *notas_1
    jal *_calc_media

    li $sc, 0 # exit
    syscall
.data
    num_1: .int8 20
    num_2: .int8 10
    num_n: .int8 4
    notas_1: .int8 100 80 20 50
    notas_2: .int8 90 25 34 12