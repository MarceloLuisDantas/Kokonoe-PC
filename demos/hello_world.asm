.text
    # Carrega em t1 o ponteiro para a string hello_world
    la $t1, *hello_world

    # Syscall 2 = printChar
    li $sc, 2
    loop:
        # carrega um character da string em $t0 em ASCII
        lrb $t0, 0($t1) 

        # if (t0 == \0): goto end
        beq $t0, $zero, *end    

        syscall # Chama a printChar

        inc $t1 # Incrementa t1, avançando em 1 o ponteiro

        # repete ate que o tamanho sejá 0
        j *loop # goto loop
    end:

    # Newline
    li $t0, 10
    syscall

    # syscall 0 = exit
    li $sc, 0
    syscall

.data
    # Definição de uma string na rom
    hello_world: .string "Hello World\0"