.text

    li   $t1, 100 # t1 = 100
    li   $t2, 100 # t2 = 100
    add  $t0, $t1, $t2 # t0 = 100 + 100 = 200

    # Deve printar 200 na tela
    li $sc, 1 # printa t0 na tela
    syscall

    li  $t1, 50  # t1 = 50
    li  $t2, 20  # t2 = 20
    sub $t0, $t1, $t2  # t0 = 50 - 20 = 30

    # Deve printar 30 na tela
    syscall

    li   $t1, 150  # t1 = 150
    li   $t2, 20   # t2 = 20
    mult $t0, $t1, $t2 # t0 = 150 * 20 = 3000

    # Deve printar 3000 na tela
    syscall 

    li  $t1, 75 # t1 = 75
    li  $t2, 2  # t2 = 2
    div $t0, $t1, $t2 # t0 = 75 div 2 = 37

    # Deve printar 37 na tela
    syscall

    li  $t1, 100      # t1 = 100
    li  $t2, 2        # t2 = 2
    div $t0, $t1, $t2 # t0 = 50
    
    # Deve printar 50 na tela
    syscall

    li $sc, 0 # termina o programa
    syscall
    
