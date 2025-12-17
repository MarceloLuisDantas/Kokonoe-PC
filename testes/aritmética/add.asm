.text
    li $sc, 1001
    
    # Teste simples
    li $t0, 100
    li $t1, 200
    add $t0, $t0, $t1
    syscall # 300

    # Teste Overflow int16
    li $t0, 32767
    syscall # 32767

    li $t1, 1
    add $t0, $t0, $t1
    syscall # -32768

    li $sc, 1002
    syscall # 32768








    li $sc, 0
    syscall