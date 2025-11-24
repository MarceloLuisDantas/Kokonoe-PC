# Arquitetura

 
 00000 |  000 |  000 |  000 |   00 | 
opcode | dest | src1 | src2 | null |

 00000 |  000 | 00000000 |
opcode | dest |    value |



## Instruções Reais



00000 nop
00001 add
00010 addi
00011 sub
00100 subi
00101 mult
00110 multi
00111 div
01000 divi
01001 or
01010 and
01011 
01100 
01101 syscall
01110 lw
01111 lb
10000 sw
10001 sb
10010 lv
10011 sv
10100 lrw
10101 lrb
10110 beq
10111 bne
11000 return
11001 j
11010 jr
11011 jal
11100 sll
11101 srl
11110 slt
11111 slti

Pseudo Instruções

inc \$t -> addi \$t, \$t, 1
dec \$t -> subi \$t, \$t, 1

slti $t0, $t1, value -> addi $t2, $zero, value
                     -> stl  $t0, $t1, $t2

ori $t0, $t1, value -> addi $t2, $zero, value
                    -> or   $t0, $t1, $t2

andi $t0, $t1, value -> addi $t2, $zero, value
                     -> and  $t0, $t1, $t2                

move dest, src -> add dest, src, $zero

li dest, value -> addi dest, $zero, value

branch on less than (t1 < t2; goto *jump)
blt $t1, $t2, *jump -> slt $t3, $t1, $t2
                       ben $at, $zero, *jump

branch on less than or equal (t1 <= t2; goto *jump)
ble $t1, $t2, *jump -> slt $t3, $t2, $t1
                       beq $at, $zero, *jump

branch on greater than (t1 > t2; goto *jump)
bgt $t1, $t2, *jump -> slt $t3, $t2, $t1
                       bne $at, $zero, *jump

branch on greater than or equal (t1 >= t2; goto *jump)
bge $t1, $t2, *jump -> slt $t3, $t1, $t2
                       beq $at, $zero, *jump                 


## Registradores

0000 \$zero 
0001 \$t0
0010 \$t1
0011 \$t2
0100 \$t3
0101 \$t4
0110 \$rt
0111 \$sp
1000 \$fp
1001 \$sc


