.text

    li $sc, 1001

    lrb $t0, 0(*int8_com_sinal)
    syscall # -120

    li $sc, 1002
    lrb $t0, 0(*int8_sem_sinal)
    syscall # 255

    lrw $t0, 0(*int16_com_sinal)
    li $sc, 1003 
    syscall # -12978

    lrw $t0, 0(*int16_sem_sinal)
    li $sc, 1004
    syscall # 52558

    li $sc, 1001
    lrb $t0, 0(*int16_com_sinal)
    syscall # -51
    lrb $t0, 1(*int16_com_sinal)
    syscall # 78


    li $sc, 1002
    li $t1, 0
    lrb $t2, 0(*len) # t2 = 8
    loop:
        
        lrb $t0, $t1(*lista)
        syscall
        inc $t1

    bne $t1, $t2, *loop
    
        

    li $sc, 0
    syscall


.data
    
    int8_com_sinal: .int8 -120
    int8_sem_sinal: .uint8 255

    # Mesmo binario 1100110101001110
    int16_com_sinal: .int16 -12978
    int16_sem_sinal: .uint16 52558
    
    # [11001101]01001110 = -51
    primeira_metade: .int8 -51
    
    # 11001101[01001110] = 78
    segunda_metade: .int8 78

    len: .uint8 8
    lista: .uint8 0 1 2 3 4 5 6 7















