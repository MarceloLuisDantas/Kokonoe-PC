.text 
    li $sc, 1001

    li $t0, 100
    li $t1, 2
    mult $t0, $t0, $t1
    syscall # 200

    li $t1, -2
    mult $t0, $t0, $t1
    syscall # -400

    li $t0, 32767
    multi $t0, $t0, 2
    syscall # -2

    li $sc, 1002
    syscall # 65534

    li $sc, 1001
    li $t0, 10000
    multi $t0, $t0, 0
    syscall # 0

    li $sc, 1002
    syscall # 0


    li $sc, 0
    syscall


