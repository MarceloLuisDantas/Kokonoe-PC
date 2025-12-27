.text
    j *_main

_main:
    li $sc, 1001
    li $t0, 0

    loop:

        inc $t0
        syscall
    
    j *loop