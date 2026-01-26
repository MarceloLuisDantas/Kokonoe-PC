.text
    j *_main

_clear_scream:
    li $t2, 3600 # pixels na tela 

    # 0 = [00000000][0000][0000] tudo preto
    li $t1, 0

    loop_cleaning:
        beq $t0, $t2, *cleaning_end
        svr $t1, 0($t0)
        inc $t0
        j *loop_cleaning
    cleaning_end:

    return


_draw_player:
    lb $t0, 17($zero)  # t1 = player y
    # player y *= 60 | valor na vram conrespondente a linha
    multi $t0, $t0, 60 
    
    lb $t1, 16($zero)  # t0 = player x
    # t0 = linha + coluna | valor na vram a [y][x] 
    add $t0, $t0, $t1 

    # 17 = [00000000][0001][0001] sem character, fonte branca, fundo branco
    li $t1, 17 

    svr $t1, 0($t0) # draw player

    return

_move_up:
    lb $t0, 17($zero) # player y
    
    # if $t0 > 0 { player.y -= 1 }
    ble $t0, $zero, *end_move_up
        dec $t0           # player y -= 1
        sb $t0, 17($zero) # salve player y
    end_move_up:

    return

_move_down:
    lb $t0, 17($zero) # player y

    # if $t0 <= 59 { player.y += 1 }
    li $t1, 59
    bge $t0, $t1, *end_move_down
        inc $t0           # player y += 1
        sb $t0, 17($zero) # salve player y
    end_move_down:

    return

_move_left:
    lb $t0, 16($zero) # player x
    
    # if player.x > 0 { player.x -= 1 }
    ble $t0, $zero, *end_move_down
        dec $t0           # player x -= 1
        sb $t0, 16($zero) # salve player x
    end_move_left:

    return

_move_right:
    lb $t0, 16($zero) # player x

    # if player.x < 59 { player.x += 1 }
    li $t1, 59
    bge $t0, $t1, *end_move_right
        inc $t0           # player x += 1
        sb $t0, 16($zero) # salve player x
    end_move_right:

    return

_main:
    # ram[16] = player x
    li $t0, 5 # player x
    sb $t0, 16($zero) 

    # ram[17] = player y
    li $t0, 5 # player y
    sb $t0, 17($zero) 
    

    game_loop:
        _start_logic:
            lb $t0, 0($zero) # key up
            beq $t0, $zero, *else_up
                jal *_move_up
                j *end_move
            else_up:

            lb $t0, 1($zero) # key down
            beq $t0, $zero, *else_down
                jal *_move_down
                j *end_move
            else_down:

            lb $t0, 2($zero) # key left
            beq $t0, $zero, *else_left
                jal *_move_left
                j *end_move
            else_left:

            lb $t0, 3($zero) # key right
            beq $t0, $zero, *else_right
                jal *_move_right
                j *end_move
            else_right:

            end_move:
        _end_logic:

        _start_drawing:
            jal *_clear_scream
            jal *_draw_player

            # render frame
            li $sc, 100
            syscall
        _end_drawing:

        j *game_loop
    


.data
