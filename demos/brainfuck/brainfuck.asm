.text
    j *_main

    _inc:
        lb $t0, 0($t3)
        inc $t0
        sb $t0, 0($t3)
        return

    _dec:
        lb $t0, 0($t3)
        dec $t0
        sb $t0, 0($t3)
        return
        
    _advance:
        li $t0, 2064 # ultimo endereço valido (2048 + 16) 
        beq $t3, $t0, *overflow
            inc $t3
            return
        overflow:
            li $t3, 16
            return

    _return:
        li $t0, 16 # primeiro endereço valido 
        beq $t3, $t0, *underflow
            dec $t3
            return
        underflow:
            li $t3, 2064
            return

    # avança o PC ate encontrar um ']', e soma 1,
    # se o valor na celula atual for igual a 0
    _jump_foward:
        li $t2, 0

        # if t0 == 0 { loop }
        lb $t0, 0($t3)
        bne $t0, $zero, *return_f

        loop_foward:
            

            j *loop_foward

        return_f:
        return
    
    
    # ++++++++[>++++[>++>+++>+++>+<<<<-]>++++[>++>+++>+++>+<<<<-]>++++[>++>+++>+++>+<<<<-]>++++[>++>+++>+++>+<<<<-]>++++[>++>+++>+++>+<<<<-]>++++[>++>+++>+++><<<<-]>++++[>++>+++>+++>+<<<<-]>++++[>++>+++>+++>+<<<<-]>++++[>++>+++>+++>+<<<<-]>++++[>++>+++>+++>+<<<<-]>++++
    # ++++++++[>++++[>++>+++>+++>+<<<<-]>+>+>->>+[<]<-]>>.>---.+++++++..+++.>>.<-.<.+++.------.--------.>>+.>++.\0" 
        
    # volta o PC ate encontrar um '[', e soma 1,
    # se o valor na celula atual não for 0
    _jump_back:
        li $t2, 0

        # if t0 == 0 { loop }
        lb $t0, 0($t3)
        beq $t0, $zero, *return_b

        loop_back:
          
            j *loop_back

        return_b:
        return

    _print:       
        lb $t0, 0($t3)
        li $sc, 1003
        syscall
        return

    _main:
        li $t3, 16 # t3 = pivot
        la $t5, *program # t5 = pc

        loop:
            lrb $t4, 0($t5)

            # if t4 == \0 { break }
            beq $t4, $zero, *end
            inc $t5

            start_logic:
                # memorie[pivot] += 1
                li $t0, 43 # 43 = '+' ASCII
                bne $t4, $t0, *else_inc
                    jal *_inc
                    j *end_logic
                else_inc:

                # memorie[pivot] -= 1
                li $t0, 45 # 43 = '-' ASCII
                bne $t4, $t0, *else_dec
                    jal *_dec
                    j *end_logic
                else_dec:

                # pivot -= 1
                li $t0, 60 # 60 = '<' ASCII
                bne $t4, $t0, *else_return
                    jal *_return
                    j *end_logic
                else_return:

                # pivot += 1
                li $t0, 62 # 60 = '>' ASCII
                bne $t4, $t0, *else_advance
                    jal *_advance
                    j *end_logic
                else_advance:

                # pc = proximo ']' + 1
                li $t0, 91 # 46 = '[' ASCII
                bne $t4, $t0, *else_jump_f
                    jal *_jump_foward
                    j *end_logic
                else_jump_f:

                # pc = ultimo '[' + 1
                li $t0, 93 # 46 = ']' ASCII
                bne $t4, $t0, *else_jump_b
                    jal *_jump_back
                    j *end_logic
                else_jump_b:

                # print(memorie[pivot])
                li $t0, 46 # 46 = '.' ASCII
                bne $t4, $t0, *else_print
                    jal *_print
                    j *end_logic
                else_print:


            end_logic:

            # # render frame
            # li $sc, 100
            # syscall

            j *loop
        end:

        # exit
        li $sc, 0
        syscall

.data
    # Printa '!' na tela
    # program: .string "+++++++++++++++++++++++++++++++++.\0"
    # program: .string "++++++++++++++++++++>+++++++++++++<[->+<]>.\0"
    
    # printa "HELLO WORLD" na tela
    #                 ++++++++[>++++[>++>+++>+++>+<<<<-]>++++[>++>+++>+++>+<<<<-]>++++[>++>+++>+++>+<<<<-]>++++[>++>+++>+++>+<<<<-]>++++[>++>+++>+++>+<<<<-]>++++[>++>+++>+++><<<<-]>++++[>++>+++>+++>+<<<<-]>++++[>++>+++>+++>+<<<<-]>++++[>++>+++>+++>+<<<<-]>++++[>++>+++>+++>+<<<<-]>++++
    program: .string "++++++++[>++++[>++>+++>+++>+<<<<-]>+>+>->>+[<]<-]>>.>---.+++++++..+++.>>.<-.<.+++.------.--------.>>+.>++.\0" 