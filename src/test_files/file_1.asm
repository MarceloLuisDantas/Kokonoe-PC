.text
    j *main

    fatorial:
        move    $rt, $t0
        li      $t1, 1      

_loop_1:
        bgt     $t0, $t1, *_exit   # if x > 1 then goto target
        mult    $rt, $rt, $t0     #   rt *= x 
        subi    $t0, $t0, 1       #   $t0 = $t0 -1
        j       *_loop_1
_exit:         
        return
            

    print:
        lw $t0, 0($sp)
    
        li $sc, 1 # Syscall para pritnar numero
        li $sc, 1 # Syscall para pritnar numero
        syscall
        return

    main:
        li $t0, 5
        
        jal *fatorial  # Fatorial de 5

        jal *print
        
        # exit
        li $sc, 0
        syscall 

_3_registradores:
    add     $rt, $rt, $t0
    sub     $rt, $rt, $t0
    mult    $rt, $rt, $t0
    div     $rt, $rt, $t0
    or      $rt, $rt, $t0
    and     $rt, $rt, $t0
    slt     $rt, $rt, $t0
        
_imediatos:
    addi    $rt, $rt, 3001
    subi    $rt, $rt, 3000
    multi   $rt, $rt, 3000
    divi    $rt, $rt, 3000
    ori     $rt, $rt, 3000
    andi    $rt, $rt, 3000
    slti    $rt, $rt, 3000

_branch:
    beq $rt, $rt, *_imediatos
    bne $rt, $rt, *_imediatos
    bgt $rt, $rt, *_imediatos
    bge $rt, $rt, *_imediatos
    blt $rt, $rt, *_imediatos
    ble $rt, $rt, *_imediatos

print:
    li $sc, 1 # print
    syscall
    return

soma_valores:
    addi $sp, $sp, 2 # $sp = 14
    sw $fp, 0($sp)   # salva fp na pilha
    move $fp, $sp    # fp = sp

    li $rt, 0

    lw $t0, -4($sp)
    lw $t1, -6($sp)
    add $rt, $t0, $t1 # rt = t0 + t1

    lw $t0, -8($sp)
    add $rt, $rt, $t0
    
    lw $fp, 0($sp)

    return

game:
    # $sp = 0
    # $fp = 0

    li $t0, 100      # player_x
    addi $sp, $sp, 2 # $sp = 2
    sw $t0, 0($sp)   # push player_x na stack
    
    li $t0, 50       # player_x 
    addi $sp, $sp, 2 # $sp = 4 
    sw $t0, 0($sp)   # push player_y na stack
    
    li $t0, 10       # player_hp - 8 bits
    addi $sp, $sp, 2 # $sp = 6
    sb $t0, 0($sp)   # salva player_hp na stack
    # $sp = 6

    lrw $t0, 0(*notas) # $t0 = 124
    lrw $t1, 2(*notas) # $t1 = 125
    lrw $t2, 4(*notas) # $t2 = 125

    addi $sp, $sp, 6 # $sp = 12
    sw $t0, -4($sp)
    sw $t1, -2($sp)
    sw $t2,  0($sp)

    jal *soma_valores

    li $sc, 1       # system call #1 - print int
    move $t0, $rt   # t0 = rt
    syscall         # execute


.data
    nome:  .string "Marceline"
    hello: .string "Hello World"
    nomes: .string "Reimu Hakurei" "Marisa Kirisame" "Alice"

    idade:  .int8   23
    num_n:  .int8   3
    status: .int8   24 16 34   
    notas:  .int16  124 125 126

    player_sprite: .string "A"  
    