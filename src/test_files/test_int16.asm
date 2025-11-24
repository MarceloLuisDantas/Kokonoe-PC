.text
    li $sc, 1 # print numeros

    lrw $t0, 0(*max_int16)
    syscall

    lrw $t0, 0(*min_int16)
    syscall

    li $sc, 0
    syscall

.data
    max_int16: .int16  32767
    min_int16: .int16 -32768