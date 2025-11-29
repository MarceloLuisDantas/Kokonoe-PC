.text
    j *_main


_calcula_media:
    lw $t1, -2($sp)
    subi $sp, $sp, 2
    while_cm: 
        beq $t1, $zero, *end_cm
            lw $t0, -2($sp)
            subi $sp, $sp, 2
            add $rt, $rt, $t0
            dec $t1
        j *while_cm
    end_cm:

    lrb $t0, 0(*t_notas)
    div $rt, $rt, $t0
    return

_load_notas:
    la $t1, *notas
    lrb $t2, 0(*t_notas)
    while_load_notas:
        beq $t2, $zero, *end_load_notas
            lrw $t0, 0($t1)
            addi $t1, $t1, 2
            addi $sp, $sp, 2
            sw $t0, -2($sp)
            dec $t2
        j *while_load_notas
    end_load_notas:
    return

_main:
    jal *_load_notas

    lrb  $t0, 0(*t_notas)
    addi $sp, $sp, 2
    sw   $t0, -2($sp)

    jal *_calcula_media

    move $t0, $rt
    li $sc, 1
    syscall

    li $t0, 10
    li $sc, 2
    syscall

    li $sc, 0
    syscall

.data
    t_notas: .int8  4
    notas:   .int16 120 121 122 123