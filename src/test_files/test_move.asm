.text

    addi $t1, $t1, 100 # t1 = 100
    addi $t2, $t1, 100 # t2 = 200
    move $t0, $t2      # t0 = 200

    # Deve printar 200 na tela
    addi $sc, $zero, 1 # printa t0 na tela
    syscall

    move $t0, $t0
    
    # Deve printar 200 na tela
    addi $sc, $zero, 1 # printa t0 na tela
    syscall

    move $t0, $zero
    
    # Deve printar 0 na tela
    addi $sc, $zero, 1 # printa t0 na tela
    syscall

    addi $sc, $zero, 0 # termina o programa
    syscall
    
