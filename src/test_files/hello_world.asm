.text
    li $t1, *hello_world
    li $t2, 11
    li $sc, 2

    loop:
        beq $t2, $zero, *end    

        lrb $t0, 0($t1)
        syscall

        inc $t1
        dec $t2

        j *loop
    end:

    # Newline
    li $t0, 10
    syscall

    li $sc, 0
    syscall
.data
    hello_world: .string "Hello World"