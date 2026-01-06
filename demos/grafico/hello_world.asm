.text

    la $t1, *hello
    li $t2, 0 # y position on vram
    # li $t3, 0 # x position on vram
    loop:
        lrb $t0, 0($t1) 
        inc $t1

        # if t0 == \0; goto end
        beq $t0, $zero, *end  

        sll $t0, $t0, 8 # t0 = [xxxxxxxx]00000000 character
        
        # t0 = [xxxxxxxx]00000000
        # 16 =          [0001]0000 character color white
        # ------------------------
        # t0 = [xxxxxxxx][0001]0000
        ori $t0, $t0, 16 

        svr $t0, 0($t2) # vram[t2] = $t0
        inc $t2
        
        j *loop
    end:

    li $sc, 100 # render frame

    # Loop infinito
    loop_2:
        syscall
        j *loop_2

    li $sc, 0
    syscall

.data
    hello: .string "Hello World\0"