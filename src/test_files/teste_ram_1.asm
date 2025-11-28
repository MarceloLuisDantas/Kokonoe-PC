.text
    j *_main


_calcula_media:

_main:
    # Coloca 4 espaços para 2 int16 na stack
    addi $sp, $sp, 8 
    lrw  $t0, 0(*notas) # 120
    sw   $t0, -8($sp)
    lrw  $t0, 2(*notas) # 121
    sw   $t0, -6($sp)
    lrw  $t0, 4(*notas) # 122
    sw   $t0, -4($sp)
    lrw  $t0, 4(*notas) # 123
    sw   $t0, -2($sp)


.data
    t_notas: .int8  4
    notas:   .int16 120 121 122 123