package cpu

/*

	ADD  - ADD $r1 $r2 $r3 -> $r1 = $r2 + $r3
	SUB	 - SUB $r1 $r2 $r3 -> $r1 = $r2 - $r3
	MUT	 - MUT $r1 $r2 $r3 -> $r1 = $r2 * $r3
	DIV	 - DIV $r1 $r2 $r3 -> $r1 = $r2 / $r3

	ADDI - ADD $r1 $r2 value -> $r1 = $r2 + value
	SUBI - SUB $r1 $r2 value -> $r1 = $r2 - value
	MUTI - MUT $r1 $r2 value -> $r1 = $r2 * value
	DIVI - DIV $r1 $r2 value -> $r1 = $r2 / value

	SLL  - SLL $r1 $r2 value -> $r1 = $r2 << value
	SRL  - SRL $r1 $r2 value -> $r1 = $r2 >> value

	AND  - AND  $r1 $r2 $r3 -> $r1 = $r2 & $r3
	OR 	 - OR   $r1 $r2 $r3 -> $r1 = $r2 | $r3

	ANDI - ANDI $r1 $r2 $r3 -> $r1 = $r2 & value
	ORI  - ORI  $r1 $r2 $r3 -> $r1 = $r2 | value

	BEQ  - BEQ $r1 $r2 value -> if($r1 == $r2) go to PC+value
	BNE  - BNE $r1 $r2 value -> if($r1 != $r2) go to PC+value
	BGT  - BGT $r1 $r2 value -> if($r1 >  $r2) go to PC+value
	BGE  - BGE $r1 $r2 value -> if($r1 >= $r2) go to PC+value
	BLT  - BLT $r1 $r2 value -> if($r1 <  $r2) go to PC+value
	BLE  - BLE $r1 $r2 value -> if($r1 <= $r2) go to PC+value

	SLT  - SLT $r1 $r2 $r3   -> if($r2 < $r3) $r1 = 1; else $r1 = 0
	SLTI - SLT $r1 $r2 value -> if($r2 < value) $r1 = 1; else $r1 = 0

	J	 - J address   -> go to address
	JR	 - JR $r1      -> go to address in $r1
	JAL	 - JAL address -> $r1 = PC; go to address

*/

// ADD - ADD $r1 $r2 $r3 -> $r1 = $r2 + $r3
func (cpu *CPU) ADD(r1, r2, r3 string) {
	cpu.Set(r1, cpu.Get(r2)+cpu.Get(r3))
}

// SUB - SUB $r1 $r2 $r3 -> $r1 = $r2 - $r3
func (cpu *CPU) SUB(r1, r2, r3 string) {
	cpu.Set(r1, cpu.Get(r2)-cpu.Get(r3))
}

// MUT - MUT $r1 $r2 $r3 -> $r1 = $r2 * $r3
func (cpu *CPU) MUT(r1, r2, r3 string) {
	cpu.Set(r1, cpu.Get(r2)*cpu.Get(r3))
}

// DIV - DIV $r1 $r2 $r3 -> $r1 = $r2 / $r3
func (cpu *CPU) DIV(r1, r2, r3 string) {
	cpu.Set(r1, cpu.Get(r2)/cpu.Get(r3))
}

// ADD - ADD $r1 $r2 $r3 -> $r1 = $r2 + $r3
func (cpu *CPU) ADDI(r1, r2 string, value int16) {
	cpu.Set(r1, cpu.Get(r2)+value)
}

// SUB - SUB $r1 $r2 $r3 -> $r1 = $r2 - $r3
func (cpu *CPU) SUBI(r1, r2 string, value int16) {
	cpu.Set(r1, cpu.Get(r2)-value)
}

// MUT - MUT $r1 $r2 $r3 -> $r1 = $r2 * $r3
func (cpu *CPU) MUTI(r1, r2 string, value int16) {
	cpu.Set(r1, cpu.Get(r2)*value)
}

// DIV - DIV $r1 $r2 $r3 -> $r1 = $r2 / $r3
func (cpu *CPU) DIVI(r1, r2 string, value int16) {
	cpu.Set(r1, cpu.Get(r2)/value)
}

// SLL - SLL $r1 $r2 value -> $r1 = $r2 << value
func (cpu *CPU) SLL(r1, r2 string, value int16) {
	cpu.Set(r1, cpu.Get(r2)<<value)
}

// SRL - SRL $r1 $r2 value -> $r1 = $r2 >> value
func (cpu *CPU) SRL(r1, r2 string, value int16) {
	cpu.Set(r1, cpu.Get(r2)>>value)
}

// AND - AND  $r1 $r2 $r3 -> $r1 = $r2 & $r3
func (cpu *CPU) AND(r1, r2, r3 string) {
	cpu.Set(r1, cpu.Get(r2)&cpu.Get(r3))
}

// OR - OR   $r1 $r2 $r3 -> $r1 = $r2 | $r3
func (cpu *CPU) OR(r1, r2, r3 string) {
	cpu.Set(r1, cpu.Get(r2)|cpu.Get(r3))
}

// ANDI - ANDI $r1 $r2 $r3 -> $r1 = $r2 & value
func (cpu *CPU) ANDI(r1, r2 string, value int16) {
	cpu.Set(r1, cpu.Get(r2)&value)
}

// ORI - ORI  $r1 $r2 $r3 -> $r1 = $r2 | value
func (cpu *CPU) ORI(r1, r2 string, value int16) {
	cpu.Set(r1, cpu.Get(r2)|value)
}
