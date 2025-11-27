.text
    j *_main

_print_notas:    
    la $t3, *notas
    lrb $t4, 0(*quantas)

    loop_pn:
        beq $t4, $zero, *end_pn        
        la $t1, *s_notas
        li $sc, 2
        loop_ps:
            lrb $t0, 0($t1)
            beq $t0, $zero, *end_ps
            syscall
            inc $t1
            dec $t2
            j *loop_ps
        end_ps:

        lrw $t0, 0($t3)
        li $sc, 1
        syscall

        li $t0, 10
        li $sc, 2
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

    li $sc, 2
    loop_pm:
        lrb $t0, 0($t1)
        beq $t0, $zero, *end_pm
        syscall
        inc $t1
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
    s_notas:    .string     " nota: \0"
    s_media:    .string     "media: \0"
    quantas:    .int8       4
    notas:      .int16      104 223 32 91