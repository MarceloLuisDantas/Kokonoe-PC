.text 
    li $sc, 1001

    li $t0, 100
    li $t1, 2
    div $t0, $t0, $t1
    syscall # 100

    li $t1, -2
    mult $t0, $t0, $t1
    syscall # -50

    li $t0, 65534
    divi $t0, $t0, 2
    syscall # 16383

    li $sc, 1002
    syscall # 65534

    li $sc, 0
    syscall


