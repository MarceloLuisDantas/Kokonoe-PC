.text
    j *_main

_printa:
    li $t1, -1
    li $sc, 1

    loop_p:
        lb $t0, -1($sp)
        beq $t0, $t1, *end_p
        syscall
        dec $sp
        j *loop_p
    end_p:

    li $t0, 10
    li $sc, 2
    syscall

    return

_multiplo_de_2:
    li $t1, 2
    while_m2:
        # if t0 < 2; goto end_m2
        blt $t0, $t1, *end_m2
            subi $t0, $t0, 2
        j *while_m2
    end_m2:    

    inc $sp
    sb $t0, -1($sp)
    
    return

_main:
    lrw $t5, 0(*num)

    # 16 bits
    li $t3, 16

    addi $sp, $sp, 1
    li $t0, -1
    sb $t0, -1($sp)
    
    while_bits:
        # if t3 == zero, goto end_bits
        beq $t3, $zero, *end_bits
            move $t0, $t5
            jal *_multiplo_de_2
            dec $t3
            srl $t5, $t5, 1            
        j *while_bits
    end_bits:

    jal *_printa

    # Exit
    li $sc, 0
    syscall

.data
     num: .int16 534