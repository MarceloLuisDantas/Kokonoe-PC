.text
    # REGISTRADORES EM MEMORIA
    # 0x0000 [ KEY UP ]
    # 0x0001 [ KEY DOWN ]
    # 0x0002 [ KEY LEFT ]
    # 0x0003 [ KEY RIGHT ]
    # 0x0004 [ KEY SPACE ]
    # 0x0005 [ KEY ENTER ]
    # 0x0006 [ KEY BACKSPACE ]
    # 0x0007 [ KEY W ]
    # 0x0008 [ KEY A ]
    # 0x0009 [ KEY S ]
    # 0x000A [ KEY D ]
    # 0x000B [ KEY Q ]
    # 0x000C [ KEY E ]
    # 0x000D [ KEY I ]
    # 0x000E [ KEY O ]
    # 0x000F [ KEY P ]

    j *_main

    _print:
        move $t1, $t0
        loop_print:
            lrb $t0, 0($t1) # string[i]
            inc $t1 # i++
            beq $t0, $zero, *end_print # if t0 == \0; break
            li $sc, 5 # print char
            syscall
            j *loop_print
        end_print:

        return

    _main:
        game_loop:
            lb $t0, 0($zero) # key up
            beq $t0, $zero, *else_up
                la $t0, *key_up
                jal *_print
            else_up:

            lb $t0, 1($zero) # key down
            beq $t0, $zero, *else_down
                la $t0, *key_down
                jal *_print
            else_down:

            lb $t0, 2($zero) # key left
            beq $t0, $zero, *else_left
                la $t0, *key_left
                jal *_print
            else_left:

            lb $t0, 3($zero) # key right
            beq $t0, $zero, *else_right
                la $t0, *key_right
                jal *_print
            else_right:

            # render frame
            li $sc, 100
            syscall
            j *game_loop


.data
    key_up:    .string "key up\n\0"
    key_down:  .string "key down\n\0"
    key_left:  .string "key left\n\0"
    key_right: .string "key right\n\0"