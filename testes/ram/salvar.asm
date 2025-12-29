.text
    j *_main


_main:
    li $t0, 100
    sw $t0, 0($zero)
    lw $t1, 0($zero)
    addi $t1, $t1, 100
    move $t0, $t1
    li $sc, 3
    syscall

    li $sc, 0
    syscall

