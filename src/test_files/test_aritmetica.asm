.text

    addi $t1, $t1, 100 # t1 = 100
    addi $t2, $t2, 100 # t2 = 100
    add  $t0, $t1, $t2 # t0 = 100 + 100 = 200

    # Deve printar 200 na tela
    addi $sc, $zero, 1 # printa t0 na tela
    syscall

    subi $t1, $t1, 50  # t1 = 50
    subi $t2, $t2, 80  # t2 = 100 - 80 = 20
    sub $t0, $t1, $t2  # t0 = 50 - 20 = 30

    # Deve printar 30 na tela
    addi $sc, $zero, 1 # printa t0 na tela
    syscall

    multi $t1, $t1, 3  # t1 = 150
    multi $t2, $t2, 1  # t2 = 20 / 1 = 20
    mult $t0, $t1, $t2 # t0 = 150 * 20 = 3000

    # Deve printar 3000 na tela
    addi $sc, $zero, 1 # printa t0 na tela
    syscall

    divi $t1, $t1, 2  # t1 = 75
    divi $t2, $t2, 10 # t2 = 20 / 10 = 2
    div $t0, $t1, $t2 # t0 = 75 div 2 = 37

    # Deve printar 37 na tela
    addi $sc, $zero, 1 # printa t0 na tela
    syscall

    addi $t1, $t1, 25 # t1 = 100
    divi $t2, $t2, 1  # t2 = 2 / 1 = 1
    div $t0, $t1, $t2 # t0 = 50
    
    # Deve printar 50 na tela
    addi $sc, $zero, 1 # printa t0 na tela
    syscall


    addi $sc, $zero, 0 # termina o programa
    syscall
    
