.text
    j *_main

_print_lyric:
    li $sc, 2
    while_pl1:
        beq $t1, $zero, *end_pl1
        lrb $t0, 0($t2)
        syscall
        inc $t2
        dec $t1
        j *while_pl1
    end_pl1:
    li $t0, 10
    syscall
    return

_main:
    li $t5, 99

    loop_99:
        beq $t5, $zero, *end_99

        move $t0, $t5
        li $sc, 1
        syscall

        li $t4, 1
        ble $t5, $t4, *singular1
            lrb $t1, 0(*len_ly1)
            la $t2, *lyric_1
            j *p1
        singular1:
            lrb $t1, 0(*len_ly6)
            la $t2, *lyric_6
        p1:
        jal *_print_lyric
        
        move $t0, $t5
        li $sc, 1
        syscall  

        beq $t5, $t4, *singular2
            lrb $t1, 0(*len_ly2)
            la $t2, *lyric_2
            j *p2
        singular2:
            lrb $t1, 0(*len_ly7)
            la $t2, *lyric_7
        p2:
        jal *_print_lyric

        lrb $t1, 0(*len_ly3)
        la $t2, *lyric_3
        jal *_print_lyric

        dec $t5

        move $t0, $t5
        li $sc, 1
        syscall  

        ble $t5, $t4, *singular3
            lrb $t1, 0(*len_ly1)
            la $t2, *lyric_1
            j *p3
        singular3:
            lrb $t1, 0(*len_ly6)
            la $t2, *lyric_6
        p3:
        jal *_print_lyric

        li $t0, 10
        syscall

        j *loop_99
    end_99:

    lrb $t1, 0(*len_ly4)
    la $t2, *lyric_4
    jal *_print_lyric

    lrb $t1, 0(*len_ly5)
    la $t2, *lyric_5
    jal *_print_lyric

    # Exit
    li $sc, 0
    syscall

.data

    len_ly1: .int8 29
    lyric_1: .string " bottles of beer on the wall." 

    len_ly2: .int8 17
    lyric_2: .string " bottles of beer."

    len_ly3: .int8 44
    lyric_3: .string "Take one down & pass it around, now there's."

    len_ly4: .int8 61
    lyric_4: .string "No more bottles of beer on the wall, no more bottles of beer."

    len_ly5: .int8 68
    lyric_5: .string "Go to the store and buy some more, 99 bottles of beer on the wall..."

    len_ly6: .int8 28
    lyric_6: .string " bottle of beer on the wall." 

    len_ly7: .int8 16
    lyric_7: .string " bottle of beer."