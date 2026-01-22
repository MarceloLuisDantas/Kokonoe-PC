.text
    j *_main

_mod:
    lw $t0, 0($zero) # mod
    lw $t1, 2($zero) # num

    loop:
        sub $t1, $t1, $t0 # t1 -= t0 
        blt $t1, $t0, *end # if t1 < t0; return
        j *loop
    end:

    move $rt, $t1
    return

_main:
    # print int16
    li $sc, 1003

    lrw $t0, 0(*mod)
    sw $t0, 0($zero)

    # 535 mod 3
    lrw $t0, 0(*num1)
    sw $t0, 2($zero)
    jal *_mod
    move $t0, $rt
    syscall # print 1

    # 257 mod 3
    lrw $t0, 0(*num2)
    sw $t0, 2($zero)
    jal *_mod
    move $t0, $rt
    syscall # print 2

    # 600 mod 3
    lrw $t0, 0(*num3)
    sw $t0, 2($zero)
    jal *_mod
    move $t0, $rt
    syscall # print 0

    li $sc, 0
    syscall

.data
    num1: .int16 535
    num2: .int16 257
    num3: .int16 600
    mod: .int16 3