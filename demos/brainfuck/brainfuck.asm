.text
    j *_main

    # _inc:
    #     lb $t0, 0($t3)
    #     inc $t0
    #     sb $t0, 0($t3)
    #     return

    # _dec:
    #     lb $t0, 0($t3)
    #     dec $t0
    #     sb $t0, 0($t3)
    #     return
        
    # _advance:
    #     li $t0, 2064 # ultimo endereço valido (2048 + 16) 
    #     beq $t3, $t0, *overflow
    #         inc $t3
    #         return
    #     overflow:
    #         li $t3, 16
    #         return

    # _return:
    #     li $t0, 16 # primeiro endereço valido 
    #     beq $t3, $t0, *underflow
    #         dec $t3
    #         return
    #     underflow:
    #         li $t3, 2064
    #         return

    # # avança o PC ate encontrar um ']', e soma 1,
    # # se o valor na celula atual for igual a 0
    # _jump_foward:
    #     li $t2, 0

    #     # if t0 == 0 { loop }
    #     lb $t0, 0($t3)
    #     bne $t0, $zero, *return_f

    #     loop_foward:
            

    #         j *loop_foward

    #     return_f:
    #     return
    
    
    # # ++++++++[>++++[>++>+++>+++>+<<<<-]>++++[>++>+++>+++>+<<<<-]>++++[>++>+++>+++>+<<<<-]>++++[>++>+++>+++>+<<<<-]>++++[>++>+++>+++>+<<<<-]>++++[>++>+++>+++><<<<-]>++++[>++>+++>+++>+<<<<-]>++++[>++>+++>+++>+<<<<-]>++++[>++>+++>+++>+<<<<-]>++++[>++>+++>+++>+<<<<-]>++++
    # # ++++++++[>++++[>++>+++>+++>+<<<<-]>+>+>->>+[<]<-]>>.>---.+++++++..+++.>>.<-.<.+++.------.--------.>>+.>++.\0" 
        
    # # volta o PC ate encontrar um '[', e soma 1,
    # # se o valor na celula atual não for 0
    # _jump_back:
    #     li $t2, 0

    #     # if t0 == 0 { loop }
    #     lb $t0, 0($t3)
    #     beq $t0, $zero, *return_b

    #     loop_back:
          
    #         j *loop_back

    #     return_b:
    #     return

    # _print:       
    #     lb $t0, 0($t3)
    #     li $sc, 1003
    #     syscall
    #     return

    # _main:
    #     li $t3, 16 # t3 = pivot
    #     la $t5, *program # t5 = pc

    #     loop:
    #         lrb $t4, 0($t5)

    #         # if t4 == \0 { break }
    #         beq $t4, $zero, *end
    #         inc $t5

    #         start_logic:
    #             # memorie[pivot] += 1
    #             li $t0, 43 # 43 = '+' ASCII
    #             bne $t4, $t0, *else_inc
    #                 jal *_inc
    #                 j *end_logic
    #             else_inc:

    #             # memorie[pivot] -= 1
    #             li $t0, 45 # 43 = '-' ASCII
    #             bne $t4, $t0, *else_dec
    #                 jal *_dec
    #                 j *end_logic
    #             else_dec:

    #             # pivot -= 1
    #             li $t0, 60 # 60 = '<' ASCII
    #             bne $t4, $t0, *else_return
    #                 jal *_return
    #                 j *end_logic
    #             else_return:

    #             # pivot += 1
    #             li $t0, 62 # 60 = '>' ASCII
    #             bne $t4, $t0, *else_advance
    #                 jal *_advance
    #                 j *end_logic
    #             else_advance:

    #             # pc = proximo ']' + 1
    #             li $t0, 91 # 46 = '[' ASCII
    #             bne $t4, $t0, *else_jump_f
    #                 jal *_jump_foward
    #                 j *end_logic
    #             else_jump_f:

    #             # pc = ultimo '[' + 1
    #             li $t0, 93 # 46 = ']' ASCII
    #             bne $t4, $t0, *else_jump_b
    #                 jal *_jump_back
    #                 j *end_logic
    #             else_jump_b:

    #             # print(memorie[pivot])
    #             li $t0, 46 # 46 = '.' ASCII
    #             bne $t4, $t0, *else_print
    #                 jal *_print
    #                 j *end_logic
    #             else_print:


    #         end_logic:

    #         # # render frame
    #         # li $sc, 100
    #         # syscall

    #         j *loop
    #     end:

    #     # exit
    #     li $sc, 0
    #     syscall


    # _show_value(number, index)
    #                 -2,     0
    _show_value:
        lw $t0, 0($sp)  # endereço a escrever o numero
        lw $t2, -1($sp) # t2 = number
        li $t3, 10      # mod

        # while (t0 != 0)
        loop_show_numbers:
            move $t1, $t2 # t1 = number

            loop_calc_mod_10:
                # if t1 < 10 { break }
                blt $t1, $t3, *end_loop_calc_mod_10
                subi $t1, $t1, 10
                j *loop_calc_mod_10
            end_loop_calc_mod_10:

            divui $t2, $t2, 10  # number /= 10

            # Monta o valor para VRAM
            ori $t1, $t1, 48    # t1 or 00110000 = 0011xxxx | valor em ASCII
            sll $t1, $t1, 8     # t1 = 0011xxxx00000000
            ori $t1, $t1, 16    # t1 or 00010000 = 0011xxxx00010000
            
            svr $t1, 0($t0)
            dec $t0

            # if num == 0 { break }
            beq $t2, $zero, *end_loop_show_numbers

            j *loop_calc_mod_10
        end_loop_show_numbers:

        return

    # _draw_square() 
    _draw_squares:
        li $t0, 901 # endereço inicial na vram
        li $t1, 1   # [00000000][0000][0001] - sem letra, fundo branco
        li $t2, 6   # total de quadrados

        loop_draw_squares:
            svr $t1, 0($t0)
            svr $t1, 1($t0)
            svr $t1, 2($t0)
            svr $t1, 3($t0)
            svr $t1, 4($t0)
            svr $t1, 60($t0)
            svr $t1, 64($t0)
            svr $t1, 120($t0)
            svr $t1, 124($t0)
            svr $t1, 180($t0)
            svr $t1, 184($t0)
            svr $t1, 240($t0)
            svr $t1, 241($t0)
            svr $t1, 242($t0)
            svr $t1, 243($t0)
            svr $t1, 244($t0)

            beq $t2, $zero, *end_loop_draw_squares
            dec $t2
            addi $t0, $t0, 6
            j *loop_draw_squares
        end_loop_draw_squares:
        
        return

    _draw_values:
        li $t0, 1202 # endereço inicial na vram
        li $t1, 16   # endereço da primeira celula na ram
        li $t2, 6    # total de quadrados

        # push ra
        addi $sp, $sp, -2 # adiciona 1 valor a pilha
        sw $ra, 0($sp)

        loop_draw_values:
            addi $sp, $sp, -6 # adiciona 2 valores na stack
            sw $t0, 0($sp)    # push t0
            sw $t1, -2($sp)   # push t1
            sw $t2, -4($sp)   # push t2

            addi $sp, $sp, -4  # adiciona 2 valores na stack
            sw $t0, 0($sp)     # endereço inicial na vram
            lb $t0, $t1($zero) # load num
            sw $t0, -2($sp)    # push num

            jal *_show_value
            addi $sp, $sp, 4   # pop values

            lw $t0, 0($sp)  # pop t0
            lw $t1, -2($sp) # pop t1
            lw $t2, -4($sp) # pop t2
            addi $sp, $sp, 6 

            inc $t1
            dec $t2
            beq $t2, $zero, *end_loop_draw_values

            j *loop_draw_values
        end_loop_draw_values:


        # pop ra        
        lw $ra, 0($sp)
        addi $sp, $sp, 2

        return

    _main:

        li $t0, 123
        sb $t0, 16($zero)
        sb $t0, 17($zero)
        sb $t0, 18($zero)
        sb $t0, 19($zero)
        sb $t0, 20($zero)
        sb $t0, 21($zero)

        game_loop:
            
            start_drawing:
                jal *_draw_squares
                jal *_draw_values

                li $sc, 100
                syscall
            end_drawing:

            j *game_loop



.data
    # Printa '!' na tela
    # program: .string "+++++++++++++++++++++++++++++++++.\0"
    # program: .string "++++++++++++++++++++>+++++++++++++<[->+<]>.\0"
    
    # printa "HELLO WORLD" na tela
    #                 ++++++++[>++++[>++>+++>+++>+<<<<-]>++++[>++>+++>+++>+<<<<-]>++++[>++>+++>+++>+<<<<-]>++++[>++>+++>+++>+<<<<-]>++++[>++>+++>+++>+<<<<-]>++++[>++>+++>+++><<<<-]>++++[>++>+++>+++>+<<<<-]>++++[>++>+++>+++>+<<<<-]>++++[>++>+++>+++>+<<<<-]>++++[>++>+++>+++>+<<<<-]>++++
    program: .string "++++++++[>++++[>++>+++>+++>+<<<<-]>+>+>->>+[<]<-]>>.>---.+++++++..+++.>>.<-.<.+++.------.--------.>>+.>++.\0" 