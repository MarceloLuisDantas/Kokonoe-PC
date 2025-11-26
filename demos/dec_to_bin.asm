.text
    j *_main

_print:
    lrb $t0, 0($t0)
    li $sc, 2 # print char
    syscall
    return    

_multiplo_de_2:
    li $t1, 0

    # while (num >= 2)
    loop_m2:     
        # if (num == 0); goto is_m2
        beq $t0, $t1, *is_m2
        inc $t1 # t1 = 1

        # if (num == 1); goto no_m2
        beq $t0, $t1, *no_m2
        dec $t1 # t1 = 0

        # t0 -= 2
        subi $t0, $t0, 2
    j *loop_m2

    is_m2:
        la $t0, *zero
        j *_print

    no_m2:
        la $t0, *um
        j *_print

_main:
    lrw $t5, 0(*num)

    # 16 bits
    li $t3, 16

    # while ($t3 != 0)
    loop_bin:
        li $t4, 1

        # if (bits < 16); goto end_bin
        beq $t3, $zero, *end_bin
        dec $t3

        move $t0, $t5
        jal *_multiplo_de_2
        srl $t5, $t5, 1

        j *loop_bin
    end_bin:

    # New line
    li $t0, 10
    li $sc, 2
    syscall

    # Exit
    li $sc, 0
    syscall

.data
     num: .int16 32767

      um: .string "1"
    zero: .string "0"