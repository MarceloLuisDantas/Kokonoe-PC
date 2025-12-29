.text
    j *_main

_print_ln:
    li $t0, 10
    li $sc, 5
    syscall

    return

# Printa a string com endereço salvo em t0
_print_string:
    li $sc, 5 # print ascii

    # t1 = t0
    move $t2, $t0
    
    # while t0 != '\0' {
    while_str:
        lrb $t0, 0($t2)
        syscall
        inc $t2        
    bne $t0, $zero, *while_str
    
    return

# Printa os 4 valores da lista salva em $t0
_print_notas:
    # push ra
    addi $sp, $sp, -2
    sw $ra, 2($sp)

    move $t1, $t0

    li $t3, 4
    # While t3 != 0
    while_notas:
        la $t0, *s_notas
        jal *_print_string

        lrw $t0, 0($t1)
        li $sc, 3
        syscall
        
        addi $t1, $t1, 2 # t1++
        dec $t3          # t3--
        
        jal *_print_ln
    bne $t3, $zero, *while_notas

    # pop ra
    lw $ra, 2($sp)
    addi $sp, $sp, 2

    return


# Soma os 4 valores da lista salva em t0, e calcula a media
_calc_media:
    move $t1, $t0

    li $t2, 4
    while_media:
        lrw $t0, 0($t1)
        add $rt, $rt, $t0
        addi $t1, $t1, 2
        dec $t2
    bne $t2, $zero, *while_media

    divi $rt, $rt, 4
    return

# Printa as notas e a media da lista salva em t0
_calc_and_print:
    addi $sp, $sp, -4
    sw $ra, 4($sp) # push ra
    sw $t0, 2($sp) # push t0

    lw $t0, 2($sp)
    jal *_print_notas

    la $t0, *s_media
    jal *_print_string

    # pop t0
    lw $t0, 2($sp)
    addi $sp, $sp, 2

    jal *_calc_media

    move $t0, $rt
    li $sc, 3
    syscall
    jal *_print_ln

    # pop ra
    lw $ra, 2($sp)
    addi $sp, $sp, 2
    return

_main:
    la $t0, *notas_1
    jal *_calc_and_print

    jal *_print_ln

    la $t0, *notas_2
    jal *_calc_and_print
    
    # exit
    li $sc, 0
    syscall

.data
    s_notas:    .string     " nota: \0"
    s_media:    .string     "media: \0"
    notas_1:    .int16      104 223 32 91
    notas_2:    .int16      231 112 45 63