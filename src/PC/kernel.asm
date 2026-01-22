.text
# Kernel 
#   Syscalls
#       0 - module
#       1 - exit
#       2 - print int16
#       3 - print uint16
#       4 - print int8
#       5 - print uint8
#       6 - print char
#       7 - print string
#       8 - println int16
#       9 - println uint16
#      10 - println int8
#      11 - println uint8
#      12 - println char
#      13 - println string

    j *_main

# __KOKONOE_MOD(number, mod)
#               sp+2,   sp
__KOKONOE_MOD:
    lw $t0, 0($sp)   # t0 = mod
    lw $t1, 2($sp)   # t1 = number

    __KOKONOE_LOOP_MOD:
        # if t1 < t0; { break }
        blt $t1, $t0, *__KOKONOE_END_LOOP_MOD

        sub $t1, $t1, $t0 # t1 -= t0 
        j *__KOKONOE_LOOP_MOD
    __KOKONOE_END_LOOP_MOD:

    move $rt, $t1
    return

# VRAM [00000000][0000][0000]
# [00000000] - ASCII
# [0000] - CHARACTER COLOR
# [0000] - BACKGROUND COLOR
# __KOKONOE_PRINT_U16(number, column_vram, line_vram)
#                    sp+4    sp+2         sp
__KOKONOE_PRINT_U16:
    # Calcula onde na VRAM deve começar a escrever
    lw $t1, 0($sp)      # t1 = line_vram
    addi $sp, $sp, 2    # pop line_vram
    multi $t1, $t1, 60  # t1 = line * 60

    lw $t2, 0($sp)      # t2 = column_vram
    addi $sp, $sp, 2    # pop column_vram
    add $t2, $t1, $t2   # t2 = line * 60 + column | Index incial na VRAM

    lw $t0, 0($sp)      # t0 = number
    addi $sp, $sp, 2    # pop number

    li $t1, 0
    # t0 = numero a ser printado
    # t1 = 0
    # t2 = index na VRAM 

    # push ra
    addi $sp, $sp, -2
    sw $ra, 0($sp)

    # push 0 (zero indica que todos os valores foram desempilhados no momento de printar)
    addi $sp, $sp, -2
    sw $zero, 0($sp)

    # while (t0 != 0)
    __KOKONOE_WHILE_STACK_NUMBERS_U16:
        # __KOKONOE_MOD(number, mod)
        #               sp+2,   sp    
        addi $sp, $sp, -4   # cria 2 epaços na stack
        li $t1, 10
        sw $t1, 0($sp)      # push 10 (modulo)
        sw $t0, 2($sp)      # push number    
        jal *__KOKONOE_MOD
        lw $t0, 2($sp)
        addi $sp, $sp, 4    # pop values

        move $t1, $rt       # t1 = number % 10
        divi $t0, $t0, 10   # number /= 10

        # Monta o valor para VRAM
        ori $t1, $t1, 48    # t1 or 00110000 = 0011xxxx | valor em ASCII
        sll $t1, $t1, 8     # t1 = 0011xxxx00000000
        ori $t1, $t1, 16    # t1 or 00010000 = 0011xxxx00010000
        # 16 = [0001][0000]
        # [0001] - fonte branca
        # [0000] - fundo preto
        
        # push num
        addi $sp, $sp, -2 
        sw $t1, 0($sp)

        # if t0 <= 0 { break }
        ble $t0, $zero, *__KOKONOE_END_WHILE_STACK_NUMBERS_U16

        j *__KOKONOE_WHILE_STACK_NUMBERS_U16
    __KOKONOE_END_WHILE_STACK_NUMBERS_U16:

    __KOKONOE_UNSTACK_PRINT_NUMBERS:
        # pop
        lw $t0, 0($sp)
        addi $sp, $sp, 2
        beq $t0, $zero, *__KOKONOE_END_UNSTACK_PRINT_NUMBERS

        svr $t0, 0($t2)
        inc $t2

        j *__KOKONOE_UNSTACK_PRINT_NUMBERS
    __KOKONOE_END_UNSTACK_PRINT_NUMBERS:

    lw $ra, 0($sp)
    addi $sp, $sp, 2

    return

_main:
    addi $sp, $sp, -6 # Adiciona 3 espaços na stack       
    
    li $t0, 0
    sw $t0, 0($sp) # line_vram
    sw $t0, 2($sp) # column_vram

    li $t0, 23456
    sw $t0, 4($sp) # number
      
    # print_16(number, column_vram, line_vram)
    #          sp+4    sp+2         sp
    jal *__KOKONOE_PRINT_U16

    li $sc, 100 # render frame
    loop:
        syscall
        j *loop

     