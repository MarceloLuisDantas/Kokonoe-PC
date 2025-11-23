.text
    j *_main


# Printa uma string na tela
# len da string deve estar em $t0
# ponto para começo da string em $t1
# $t2 precisa, estar diponivel
_print_string:
    # Syscall para printar um char na tela
    li $sc, 2 

    li $t2, 0
    loop_p:
        # if len == 0, goto end_p
        beq     $t0, $zero, *end_p 

        lrb     $t2, 0($t1) # t2 = nome[x]
        addi    $t1, $t1, 1 # t1 += 1
        subi    $t0, $t0, 1 # len -= 1
    
        move $t3, $t0
        move $t0, $t2
        syscall # Print o char em $t0
        move $t0, $t3

        j *loop_p
    end_p:
        li $t0, 10 # new line
        syscall    # print new line
        return

_main:
    lrb $t0, 0(*len) # t0 = 9
    li  $t1, *nome   # t1 = endereço de nome
    jal *_print_string

.data
    len:  .int8   9
    nome: .string "Marceline"
