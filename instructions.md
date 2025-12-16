# Instruções Aritmeticas
## add - (Addition) `add $r1 $r2 $r3` => `r1 = r2 + r3`
Soma os valores de r2 e r3, e salva o resultado em r1

## addu - (Addition) `add $r1 $r2 $r3` => `r1 = r2 + r3`
Soma os valores de r2 e r3, e salva o resultado em r1, interpreta os valores como unsigned

## addi - (Addition Immediate) `addi $r1 $r2 x` => `r1 = r2 + x`
Soma os valores de r2 e x, e salva o resultado em r1

## addiu - (Addition Immediate) `addi $r1 $r2 x` => `r1 = r2 + x`
Soma os valores de r2 e x, e salva o resultado em r1, interpreta os valores como unsigned

## sub - (Subtraction) `sub $r1 $r2 $r3` => `r1 = r2 - r3`
Subtrai r3 de r2, e salva o resultado em r1

## subu - (Subtraction) `sub $r1 $r2 $r3` => `r1 = r2 - r3`
Subtrai r3 de r2, e salva o resultado em r1, interpreta os valores como unsigned

## subi - (Subtraction Immediate) `subi $r1 $r2 x` => `r1 = r2 - x`
Subtrai  de r2, e salva o resultado em r1

## subiu - (Subtraction Immediate) `subi $r1 $r2 x` => `r1 = r2 - x`
Subtrai  de r2, e salva o resultado em r1, interpreta os valores como unsigned

## mult - (Multplication) `mult $r1 $r2 $r3` => `r1 = r2 * r3`
Multiplica r2 por r3 e salva o resultado em r1

## multi - (Multplication Immediate) `multi $r1 $r2 x` => `r1 = r2 * x`
Multiplica r2 por x e salva o resultado em r1

## div - (Division) `div $r1 $r2 $r3` => `r1 = r2 / r3`
Divide r2 por r3 e salva o resultado em r1

## divi - (Division Immediate) `div $r1 $r2 x` => `r1 = r2 / x`
Divide r2 por x e salva o resultado em r1

## move - (Move) `move $r1 $r2` => `r1 = r2`
Copia o valor de r2 para r1

## li - (Load Immediate) `li $r1 x` => `r1 = x`
Copia o valor de r2 para r1

## la - (Load Address) `la $r1 *value` => `r1 = &x`
Salva o endereço de memoria de um valor em r1

## inc - (Incrementa) `inc $r1` => `r1++`

## dec - (Decrementa) `dec $r1` => `r1--`

## rand - (Random number) `rand $r1` => `r1 = rand()`

# Instruções Logicas
## or - (Or) `or $r1 $r2 $r3` => `r1 = r2 or r3`
Aplica OR entre r2 e r3 e salva o resultado em r1

## ori - (Or Immediate) `ori $r1 $r2 x` => `r1 = r2 or x`
Aplica OR entre r2 e x e salva o resultado em r1

## and - (And) `and $r1 $r2 $r3` => `r1 = r2 and r3`
Aplica AND entre r2 e r3 e salva o resultado em r1

## andi - (And Immediate) `andi $r1 $r2 x` => `r1 = r2 and x`
Aplica AND entre r2 e x e salva o resultado em r1

## sll - (Shift Left Logical) `sll $r1 $r2 x` => `r1 = r2 << x`
Faz shift left de r2, x vezes, e salva o resultado em r1

## srl - (Shift Right Logical) `srl $r1 $r2 x` => `r1 = r2 >> x`
Faz shift right de r2, x vezes, e salva o resultado em r1

## slt - (Set Less Than) `slt $r1 $r2 $r3` => `if (r2 < r3): r1 = 1; else: r1 = 0`
Verifica se r2 é menor que r3, e salva o resultado em r1

## slti - (Set Less Than Immediate) `slt $r1 $r2 x` => `if (r2 < x): r1 = 1; else: r1 = 0`
Verifica se r2 é menor que x, e salva o resultado em r1

# Instruções de Branch
## j - (Jump To) `j address` => `goto address`
Seta o PC para o endereço especificado

## jr - (Jump Register) `jr $r1` => `goto r1`
Seta o PC para o endereço contido em r1

## jal - (Jump and Link) `jal address` => `$ra = PC+1; goto address`
Salva o endereço da proxima instrução no registrador `$ra` e realiza um jump ao endereço dado.

## beq - (Branch on Equal) `beq $r1 $r2 address` => `if(r1 == r2) goto address`
Pula para o endereço especificado caso r1 for igual a r2, caso contrario, segue para a proxima instrução

## bne - (Branch not Equal) `bne $r1 $r2 address` => `if(r1 != r2) goto address`
Pula para o endereço especificado caso r1 for diferente de r2, caso contrario, segue para a proxima instrução

## bgt - (Branch on Greater Than) `bgt $r1 $r2 address` => `if(r1 > r2) goto address`
Pula para o endereço especificado caso r1 for maior que r2, caso contrario, segue para a proxima instrução

## bge - (Branch on Greater Than or Equal) `bge $r1 $r2 address` => `if(r1 >= r2) goto address`
Pula para o endereço especificado caso r1 for maior ou igual a r2, caso contrario, segue para a proxima instrução

## blt - (Branch on Less Than) `blt $r1 $r2 address` => `if(r1 < r2) goto address`
Pula para o endereço especificado caso r1 for menor que r2, caso contrario, segue para a proxima instrução

## ble - (Branch on Less Than or Equal) `ble $r1 $r2 address` => `if(r1 <= r2) goto address`
Pula para o endereço especificado caso r1 for menor ou igual a r2, caso contrario, segue para a proxima instrução

## return - (Return) `return` => `pc = ra`
Seta o PC para o endereço salvo em $ra salvo por `jal`
 
# Instruções de Data Transfer
## lw - (Load World) `lw $r1 [offset][address/register]` => `r1 = *address`
Carrega uma world (2 bytes) da RAM e salva em r1
### lw $t0, 0($sp)
### lw $t0, $t1($sp)

## lb - (Load Byte) `lb $r1 [offset][address/register]` => `r1 = *address`
Carrega 1 byte da RAM e salva em r1
### lb $t0, 0($sp)
### lb $t0, $t1($sp)

## sw - (Save World) `sw $r1 [offset][address/register]` => `*address = r1`
Salva o valor de r1 na memoria, escreve 2 bytes
### sw $t0, 0($sp)
### sw $t0, $t1($sp)

## sb - (Save Byte) `sb $r1 [offset][address/register]` => `*address = r1`
Salva o valor de r1 na memoria, escreve 1 byte
### sb $t0, 0($sp)
### sb $t0, $t1($sp)

## lv - (Load from VRAM) `lv $r1 [offset][vram_address/register]` => `r1 = *vram_address`
Carregar um pixel da VRAM para r1
### lv $t0, 0($sp)
### lv $t0, $t1($sp)

## sv - (Save to VRAM) `sv $r1 [offset][vram_address/register]` => `*vram_address = r1`
Salva o pixel em r1 no endereço na VRAM

## lrw - (Load from ROM) `lr $r1 [offset][rom_address/register]` => `r1 = *rom_address`
Carrega uma word completa da ROM e salva em r1

## lrb - (Load from ROM) `lr $r1 [offset][rom_address/register]` => `r1 = *rom_address`
Carrega 1 byte da ROM e salva em r1