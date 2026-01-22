.text

    j *_main

# retorna o modulo dos valore passados

_inicializa_tabuleiro:
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
#

_mod:
    lw $t0, 0($zero) # mod
    lw $t1, 2($zero) # num

    loop:
        sub $t1, $t1, $t0 # t1 -= t0 
        blt $t1, $t0, *end # if t1 < t0; return
        j *loop
    end:

    move $rt, $t1
    return

# verifica se a celula passada em ram[1] esta viva
_is_alive:
    # t0 = cell
    lw $t0, 1($zero)

    #t0 = vram[cell]
    lvr $t0, $t0($zero)
    # syscall

    # t0 = xxxxxxxxxxxxxxxx
    # 15 = 0000000000001111
    # ---------------------
    # t0 = 000000000000xxxx
    andi $t0, $t0, 15

    # t0 vai ser 1 (fundo branco/vivo) ou 0(fundo preto/morto)
    add $rt, $rt, $t0
    return

# Retorna quantos vizinhos vivos a celula em ram[0] possui

_vizinhos_vivos:
    addi $sp, $sp, -2
    sw $ra, 0($sp) # push ra

    

  
    return


_main:
    jal *_inicializa_tabuleiro

    # percorre o tabuleiro
    li $t4, 0
    li $t5, 3600

    loop_tabuleiro:
        # t0 = _vizinhos_vivos(t4)
        sw $t4, 0($zero) # ram[0] = t4
        jal *_vizinhos_vivos
        move $t0, $rt

        # printa numero de vizinhos vivos
        li $sc, 1004
        li $t1, 10000
        beq $t0, $t1, *nao_printa
            syscall
        nao_printa:

        inc $t4 # t4 += 1

        # if t4 == 3600; break
        bne $t4, $t5, *loop_tabuleiro

    loop_game:
        
        li $sc, 100
        syscall

        j *loop_game

.data
