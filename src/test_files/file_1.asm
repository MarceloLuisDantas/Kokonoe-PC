jump main

subtrair:                       ; Procedimento para subtrair a1 e a2
    sub         $v1 $a1 $a2     ; Subtraindo a1 e a2 e armazenando em v1
    jr                          ; retornando para _main

printar:
    ssc         1               ; seta syscall para 1 (printInt)
    syscall                     ; chama a syscall para printar na tela o valor de $a1
    jr                          ; retornando para _main

main:
    li          $a1 100         ; salvando 100 em a1
    li          $a2 20          ; salvando 20 am a2
    jal         subtrair        ; pulanod para subtrair
    move        $a1 $v1         ; movendo o resultado de subtrair para a1
    jal         printar         ; indo para printar
    

    
