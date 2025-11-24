.text
    # Carrega em t1 o ponteiro para a string hello_world
    li $t1, *hello_world
    li $t2, 11 # tamanho da string

    # Syscall 2 = printChar
    li $sc, 2
    loop:
        # if (t2 == 0): goto end
        beq $t2, $zero, *end    

        # carrega um character da string em $t0 em ASCII
        lrb $t0, 0($t1) 
        syscall # Chama a printChar

        inc $t1 # Incrementa t1, avançando em 1 o ponteiro
        dec $t2 # Decrementa t2, 

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
    hello_world: .string "Hello World"