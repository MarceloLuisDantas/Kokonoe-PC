.text
    j *_main

_print_text:
    li $sc, 2
    la $t1, *text
    while_pt:
        lrb $t0, 0($t1)
        beq $t0, $zero, *end_pt
        syscall
        inc $t1
        j *while_pt
    end_pt:

    return

_main:
    jal *_print_text

    rand $t0
    li $sc, 1
    syscall

    li $t0, 10
    li $sc, 2
    syscall

    li $sc, 0
    syscall

.data
    text: .string "numero: \0"