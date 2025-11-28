.text
    j *_main

_print_lyric:
    li $sc, 2
    while_pl1:
        lrb $t0, 0($t2)
        beq $t0, $zero, *end_pl1
        syscall
        inc $t2
        j *while_pl1
    end_pl1:
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
            la $t2, *lyric_1
            j *p1
        singular1:
            la $t2, *lyric_6
        p1: 
        jal *_print_lyric
        
        move $t0, $t5
        li $sc, 1
        syscall  

        beq $t5, $t4, *singular2
            la $t2, *lyric_2
            j *p2
        singular2:
            la $t2, *lyric_7
        p2:
        jal *_print_lyric

        la $t2, *lyric_3
        jal *_print_lyric

        dec $t5

        move $t0, $t5
        li $sc, 1
        syscall  

        ble $t5, $t4, *singular3
            la $t2, *lyric_1
            j *p3
        singular3:
            la $t2, *lyric_6
        p3:
        jal *_print_lyric

        li $t0, 10
        syscall

        j *loop_99
    end_99:

    la $t2, *lyric_4
    jal *_print_lyric

    la $t2, *lyric_5
    jal *_print_lyric

    # Exit
    li $sc, 0
    syscall

.data
    lyric_1: .string " bottles of beer on the wall. \n\0" 
    lyric_2: .string " bottles of beer. \n\0"
    lyric_3: .string "Take one down & pass it around, now there's. \n\0"
    lyric_4: .string "No more bottles of beer on the wall, no more bottles of beer. \n\0"
    lyric_5: .string "Go to the store and buy some more, 99 bottles of beer on the wall... \n\0"
    lyric_6: .string " bottle of beer on the wall. \n\0" 
    lyric_7: .string " bottle of beer. \n\0"