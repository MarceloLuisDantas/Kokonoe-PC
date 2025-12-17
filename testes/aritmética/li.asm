.text
    
    li $t0, 32767 # MAX int16
    li $sc, 1001 # Println int16
    syscall # 32767

    li $t0, -32768 # MIN int16
    syscall # -32768

    li $t0, 65535 # MAX uint16
    syscall # -1
    
    li $sc, 1002 # Println uint16
    syscall # 65535
    
    li $sc, 0 # exit
    syscall

