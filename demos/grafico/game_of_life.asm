.text
    j *_main


_mod:
    lw $t0, 0($sp)
    lw $t1, 2($sp)
    return

# Inicializa o tabuleiro
_start:
    addi $sp, $sp, -2
    sw $ra, 0($sp)

    # Tamanho do tabuleiro 60x60
    li $t0, 3600

    # Chanche de nascer +-20% de -32.768 ... 32.767 (16b)
    li $t1, 19659

    # 1 = [00000000][0000][0001] 
    # ASCII 0 - Branco - Fundo Preto
    li $t2, 1

    # $t0 = vram[i]
    li $t3, 0
    loop_y:

        # if t4 >= 30% {
        #   svr $t2, $t3($zero);
        # }
        rand $t4
        ble $t4, $t1, *dead
            svr $t2, $t3($zero)
        dead:

        inc $t3
    bne $t3, $t0, *loop_y

    lw $ra, 0($sp)
    addi $sp, $sp, -2
    return


# _is_alive(addr) -> bool
_is_alive:
    lw $t0, 0($sp) # pop addr
    # syscall
    
    #t0 = vram[addr]
    lvr $t0, $t0($zero)
    # syscall

    # t0 = xxxxxxxxxxxxxxxx
    # 15 = 0000000000001111
    # ---------------------
    # t0 = 000000000000xxxx
    andi $t0, $t0, 15

    # t0 vai ser 1 (fundo branco/vivo) ou 0(fundo preto/morto)
    move $rt, $t0
    return

# Calcula vizinhos vivos para celula superior esquerdo
_cell_se:
    
    return

# Calcula vizinhos vivos para celula superior direito
_cell_sd:
    return

# Calcula visinhos vivos para celula inferior esquerdo
_cell_ie:
    return

# Calcula visinhos vivos para celula inferior direito
_cell_id:
    return

# _get_number_of_alive_neighbors(y, x) -> int
_get_number_of_alive_neighbors:
    lw $t0, 0($sp) # pop y
    lw $t1, 2($sp) # pop x
    addi $sp, $sp, 4

    multi $t0, $t0, 60 # y *= 60
    add $t0, $t0, $t1  # y += x

    # Celula é a do canto superior esquerdo
    li $t1, 0
    beq $t0, $zero, *_cell_se

    # Celula é a do canto superior direito
    li $t1, 59
    beq $t0, $zero, *_cell_sd

    # Celula é a do canto inferior esquerdo
    li $t1, 3540
    beq $t0, $zero, *_cell_ie

    # Celula é a do canto inferior direito
    li $t1, 3599
    beq $t0, $zero, *_cell_id 





_next_gen:
    return


_update_board:
    return


_main:
    jal *_start

    game_loop:



        # Render
        li $sc, 100
        syscall

        j *game_loop


    # Exit
    li $sc, 0
    syscall

