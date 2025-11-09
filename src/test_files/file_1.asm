.text
    j main

    fatorial:
        pop     $t0
        move    $rt $t0
        li      $t1 1      

_loop_1:
        bgt     $t0 $t1 exit	    # if x > 1 then goto target
            mult    $rt $rt $t0     #   rt *= x 
            subi    $t0 $t0 1       #   $t0 = $t0 -1
            j       _loop_1
_exit:
        return
            

    print:
        pop $t0
        li $sc 1 # Syscall para pritnar numero
        syscall
        return

    main:
        li $t0 5
        push $t0
        
        jal fatorial  # Fatorial de 5
        push $rt

        jal print
        
        # exit
        li $sc 0
        syscall 

        
.data
    nome:  .string "Marceline"
    hello: .string "Hello World"
    nomes: .string "Reimu Hakurei" "Marisa Kirisame" "Alice"

    idade: .int8   23
    notas: .int16  123 123 123
    