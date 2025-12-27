.text
    li $sc, 1001
    
    # Teste simples
    li $t0, 100
    li $t1, 200
    sub $t0, $t0, $t1
    syscall # -100

    # Teste Overflow int16
    li $t0, 32767
    syscall # 32767

    subi $t0, $t0, -1
    syscall # -32768

    li $sc, 1002
    syscall # 32768

    # Teste Underflow int16
    li $sc, 1001
    li $t0, -32768
    syscall # -32768
    subi $t0, $t0, 1
    syscall # 32767

    li $sc, 100

    li $sc, 0
    syscall