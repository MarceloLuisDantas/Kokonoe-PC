.text
    j *_main

_print_notas:    
    la $t3, *notas
    lrb $t4, 0(*quantas)

    loop_pn:
        beq $t4, $zero, *end_pn        
        la $t1, *s_notas
        lrb $t2, 0(*len_s)
        loop_ps:
            beq $t2, $zero, *end_ps
            lrb $t0, 0($t1)
            li $sc, 2
            syscall
            inc $t1
            dec $t2
            j *loop_ps
        end_ps:

        lrw $t0, 0($t3)
        li $sc, 1
        syscall

        addi $t3, $t3, 2
        dec $t4

        j *loop_pn
    end_pn:
    
    return

_calc_media:
    la $t3, *notas
    lrb $t4, 0(*quantas)
    move $t5, $t4

    loop_cm:
        beq $t4, $zero, *end_cm

        lrw $t0, 0($t3)
        add $rt, $rt, $t0
        addi $t3, $t3, 2
        dec $t4
        
        j *loop_cm
    end_cm:

    div $rt, $rt, $t5
    return

_print_media:    
    la $t1, *s_media
    lrb $t2, 0(*len_s)

    li $sc, 2
    loop_pm:
        beq $t2, $zero, *end_pm
        lrb $t0, 0($t1)
        syscall
        inc $t1
        dec $t2
        j *loop_pm
    end_pm:

    move $t0, $t5
    li $sc, 1
    syscall
    return

_main:
    li $sc, 1

    jal *_print_notas
    jal *_calc_media
    move $t5, $rt
    jal *_print_media
    
    # printa new line
    li $t0, 10
    li $sc, 2
    syscall

    li $sc, 0
    syscall

.data
    len_s:      .int8       0
    s_notas:    .string     " nota: "
    len_s:      .int8       0
    s_media:    .string     "media: "
    len_s:      .int8       0
    len_s:      .int8       7
    quantas:    .int8       4
    notas:      .int16      104 223 32 91