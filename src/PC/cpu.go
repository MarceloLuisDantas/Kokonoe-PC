package pc

import (
	"fmt"
	"math/rand"
	"os"
	"strconv"
)

type CPU struct {
	zero int16
	t0   int16
	t1   int16
	t2   int16
	t3   int16
	t4   int16
	t5   int16
	rt   int16
	sp   int16
	fp   int16
	sc   int16
	ra   uint16
	pc   uint16
	gp   uint16
	ir   string
	rom  *ROM
	// ram  RAM
}

func NewCPU(file []string) (*CPU, error) {
	var cpu CPU

	gp, err := strconv.ParseInt(file[0], 10, 16)
	if err != nil {
		return nil, err
	}
	cpu.gp = uint16(gp)

	rom, err := NewRom(file[1:])
	if err != nil {
		return nil, err
	}

	cpu.rom = rom
	return &cpu, nil
}

func (cpu *CPU) SetRegister(dest string, value int16) {
	switch dest {
	case "$t0":
		cpu.t0 = value
	case "$t1":
		cpu.t1 = value
	case "$t2":
		cpu.t2 = value
	case "$t3":
		cpu.t3 = value
	case "$t4":
		cpu.t4 = value
	case "$t5":
		cpu.t5 = value
	case "$pc":
		cpu.pc = uint16(value)
	case "$zero":
		cpu.zero = 0
	case "$sp":
		cpu.sp = value
	case "$fp":
		cpu.fp = value
	case "$sc":
		cpu.sc = value
	case "$ra":
		cpu.ra = uint16(value)
	case "$gp":
		cpu.gp = uint16(value)
	case "$rt":
		cpu.rt = value
	}
}

func (cpu *CPU) GetRegister(dest string) int16 {
	switch dest {
	case "$t0":
		return cpu.t0
	case "$t1":
		return cpu.t1
	case "$t2":
		return cpu.t2
	case "$t3":
		return cpu.t3
	case "$t4":
		return cpu.t4
	case "$t5":
		return cpu.t5
	case "$pc":
		return int16(cpu.pc)
	case "$zero":
		return 0
	case "$sp":
		return cpu.sp
	case "$fp":
		return cpu.fp
	case "$sc":
		return cpu.sc
	case "$ra":
		return int16(cpu.ra)
	case "$gp":
		return int16(cpu.gp)
	case "$rt":
		return cpu.rt
	}
	panic("registrador inválido")
}

func (cpu *CPU) Add(dest, src1, src2 string) {
	v1 := cpu.GetRegister(src1)
	v2 := cpu.GetRegister(src2)
	cpu.SetRegister(dest, v1+v2)
}

func (cpu *CPU) Sub(dest, src1, src2 string) {
	v1 := cpu.GetRegister(src1)
	v2 := cpu.GetRegister(src2)
	cpu.SetRegister(dest, v1-v2)
}

func (cpu *CPU) Mult(dest, src1, src2 string) {
	v1 := cpu.GetRegister(src1)
	v2 := cpu.GetRegister(src2)
	cpu.SetRegister(dest, v1*v2)
}

func (cpu *CPU) Div(dest, src1, src2 string) {
	v1 := cpu.GetRegister(src1)
	v2 := cpu.GetRegister(src2)
	cpu.SetRegister(dest, v1/v2)
}

func (cpu *CPU) Addi(dest, src string, value int16) {
	v := cpu.GetRegister(src)
	cpu.SetRegister(dest, v+value)
}

func (cpu *CPU) Subi(dest, src string, value int16) {
	v := cpu.GetRegister(src)
	cpu.SetRegister(dest, v-value)
}

func (cpu *CPU) Multi(dest, src string, value int16) {
	v := cpu.GetRegister(src)
	cpu.SetRegister(dest, v*value)
}

func (cpu *CPU) Divi(dest, src string, value int16) {
	v := cpu.GetRegister(src)
	cpu.SetRegister(dest, v/value)
}

func (cpu *CPU) Addu(dest, src1, src2 string) {
	v1 := uint16(cpu.GetRegister(src1))
	v2 := uint16(cpu.GetRegister(src2))
	cpu.SetRegister(dest, int16(v1+v2))
}

func (cpu *CPU) Addui(dest, src string, value int16) {
	v := uint16(cpu.GetRegister(src))
	result := v + uint16(value)
	cpu.SetRegister(dest, int16(result))
}

func (cpu *CPU) Subu(dest, src1, src2 string) {
	v1 := uint16(cpu.GetRegister(src1))
	v2 := uint16(cpu.GetRegister(src2))
	cpu.SetRegister(dest, int16(v1-v2))
}

func (cpu *CPU) Subui(dest, src string, value int16) {
	v := uint16(cpu.GetRegister(src))
	result := v - uint16(value)
	cpu.SetRegister(dest, int16(result))
}

func (cpu *CPU) And(dest, src1, src2 string) {
	v1 := cpu.GetRegister(src1)
	v2 := cpu.GetRegister(src2)
	cpu.SetRegister(dest, v1&v2)
}

func (cpu *CPU) Andi(dest, src string, value int16) {
	v := cpu.GetRegister(src)
	cpu.SetRegister(dest, v&value)
}

func (cpu *CPU) Or(dest, src1, src2 string) {
	v1 := cpu.GetRegister(src1)
	v2 := cpu.GetRegister(src2)
	cpu.SetRegister(dest, v1|v2)
}

func (cpu *CPU) Ori(dest, src string, value int16) {
	v := cpu.GetRegister(src)
	cpu.SetRegister(dest, v|value)
}

func (cpu *CPU) Slt(dest, src1, src2 string) {
	if cpu.GetRegister(src1) < cpu.GetRegister(src2) {
		cpu.SetRegister(dest, 1)
	} else {
		cpu.SetRegister(dest, 0)
	}
}

func (cpu *CPU) Slti(dest, src string, value int16) {
	if cpu.GetRegister(src) < value {
		cpu.SetRegister(dest, 1)
	} else {
		cpu.SetRegister(dest, 0)
	}
}

func (cpu *CPU) Move(dest, src string) {
	cpu.SetRegister(dest, cpu.GetRegister(src))
}

func (cpu *CPU) Li(dest string, value int16) {
	cpu.SetRegister(dest, value)
}

func (cpu *CPU) La(dest string, value int16) {
	cpu.SetRegister(dest, value)
}

func (cpu *CPU) Jump(point uint16) {
	cpu.pc = point
}

func (cpu *CPU) Jr(src string) {
	cpu.pc = uint16(cpu.GetRegister(src))
}

func (cpu *CPU) Jal(point uint16) {
	cpu.ra = cpu.pc
	cpu.pc = point
}

func (cpu *CPU) Ret() {
	cpu.pc = cpu.ra
}

func (cpu *CPU) Beq(src1, src2 string, point uint16) {
	if cpu.GetRegister(src1) == cpu.GetRegister(src2) {
		cpu.pc = point
	}
}

func (cpu *CPU) Bne(src1, src2 string, point uint16) {
	if cpu.GetRegister(src1) != cpu.GetRegister(src2) {
		cpu.pc = point
	}
}

func (cpu *CPU) Bgt(src1, src2 string, point uint16) {
	if cpu.GetRegister(src1) > cpu.GetRegister(src2) {
		cpu.pc = point
	}
}

func (cpu *CPU) Bge(src1, src2 string, point uint16) {
	if cpu.GetRegister(src1) >= cpu.GetRegister(src2) {
		cpu.pc = point
	}
}

func (cpu *CPU) Blt(src1, src2 string, point uint16) {
	if cpu.GetRegister(src1) < cpu.GetRegister(src2) {
		cpu.pc = point
	}
}

func (cpu *CPU) Ble(src1, src2 string, point uint16) {
	if cpu.GetRegister(src1) <= cpu.GetRegister(src2) {
		cpu.pc = point
	}
}

func (cpu *CPU) Inc(dest string) {
	cpu.SetRegister(dest, cpu.GetRegister(dest)+1)
}

func (cpu *CPU) Dec(dest string) {
	cpu.SetRegister(dest, cpu.GetRegister(dest)-1)
}

func (cpu *CPU) Rand(dest string) {
	cpu.SetRegister(dest, int16(rand.Intn(65536)-32768))
}

func (cpu *CPU) Lrb(dest string, offset, point uint16) {
	addr := cpu.gp + point + offset
	v, err := strconv.Atoi(cpu.rom.rom[addr])
	if err != nil {
		panic(err)
	}

	cpu.SetRegister(dest, int16(v))
}

func (cpu *CPU) Lrw(dest string, offset, point uint16) {
	addr := cpu.gp + point + offset

	h1, err := strconv.Atoi(cpu.rom.rom[addr])
	if err != nil {
		panic(err)
	}

	h2, err := strconv.Atoi(cpu.rom.rom[addr+1])
	if err != nil {
		panic(err)
	}

	value := int16(h1) | int16(h2)
	cpu.SetRegister(dest, value)
}

func (cpu *CPU) Sll(dest, src string, value uint16) {
	v := int16(cpu.GetRegister(src))
	cpu.SetRegister(dest, int16(v<<value))
}

func (cpu *CPU) Srl(dest, src string, value uint16) {
	v := int16(cpu.GetRegister(src))
	cpu.SetRegister(dest, int16(v>>value))
}

// 0 - exit
// 1 - print t0 como int16
// 2 - print t0 como uint16
// 3 - print t0 como int8
// 4 - print t0 como utin16
// 5 - print t0 como char utf8
func (cpu *CPU) Syscall() {
	value := cpu.t0
	switch cpu.sc {
	case 0:
		os.Exit(0)
	case 1:
		print(value)
	case 2:
		print(uint16(value))
	case 3:
		print(int8(value))
	case 4:
		print(uint8(value))
	case 5:
		fmt.Printf("%c", int8(value))
	}
}

func (cpu *CPU) ExecCurrentInstruction(tokens []string) int {
	switch tokens[0] {

	case "add":
		cpu.Add(tokens[1], tokens[2], tokens[3])

	case "sub":
		cpu.Sub(tokens[1], tokens[2], tokens[3])

	case "mult":
		cpu.Mult(tokens[1], tokens[2], tokens[3])

	case "div":
		cpu.Div(tokens[1], tokens[2], tokens[3])

	case "addi":
		v, _ := strconv.Atoi(tokens[3])
		cpu.Addi(tokens[1], tokens[2], int16(v))

	case "subi":
		v, _ := strconv.Atoi(tokens[3])
		cpu.Subi(tokens[1], tokens[2], int16(v))

	case "multi":
		v, _ := strconv.Atoi(tokens[3])
		cpu.Multi(tokens[1], tokens[2], int16(v))

	case "divi":
		v, _ := strconv.Atoi(tokens[3])
		cpu.Divi(tokens[1], tokens[2], int16(v))

	case "addu":
		cpu.Addu(tokens[1], tokens[2], tokens[3])

	case "addiu":
		v, _ := strconv.Atoi(tokens[3])
		cpu.Addui(tokens[1], tokens[2], int16(v))

	case "subu":
		cpu.Subu(tokens[1], tokens[2], tokens[3])

	case "subiu":
		v, _ := strconv.Atoi(tokens[3])
		cpu.Subui(tokens[1], tokens[2], int16(v))

	case "move":
		cpu.Move(tokens[1], tokens[2])

	case "li":
		v, _ := strconv.Atoi(tokens[2])
		cpu.Li(tokens[1], int16(v))

	case "la":
		v, _ := strconv.Atoi(tokens[2])
		cpu.La(tokens[1], int16(v))

	case "j":
		v, _ := strconv.Atoi(tokens[1])
		cpu.Jump(uint16(v))

	case "jal":
		v, _ := strconv.Atoi(tokens[1])
		cpu.Jal(uint16(v))

	case "jr":
		cpu.Jr(tokens[1])

	case "return":
		cpu.Ret()

	case "beq":
		v, _ := strconv.Atoi(tokens[3])
		cpu.Beq(tokens[1], tokens[2], uint16(v))

	case "bne":
		v, _ := strconv.Atoi(tokens[3])
		cpu.Bne(tokens[1], tokens[2], uint16(v))

	case "bgt":
		v, _ := strconv.Atoi(tokens[3])
		cpu.Bgt(tokens[1], tokens[2], uint16(v))

	case "bge":
		v, _ := strconv.Atoi(tokens[3])
		cpu.Bge(tokens[1], tokens[2], uint16(v))

	case "blt":
		v, _ := strconv.Atoi(tokens[3])
		cpu.Blt(tokens[1], tokens[2], uint16(v))

	case "ble":
		v, _ := strconv.Atoi(tokens[3])
		cpu.Ble(tokens[1], tokens[2], uint16(v))

	case "slt":
		cpu.Slt(tokens[1], tokens[2], tokens[3])

	case "slti":
		v, _ := strconv.Atoi(tokens[3])
		cpu.Slti(tokens[1], tokens[2], int16(v))

	case "and":
		cpu.And(tokens[1], tokens[2], tokens[3])

	case "andi":
		v, _ := strconv.Atoi(tokens[3])
		cpu.Andi(tokens[1], tokens[2], int16(v))

	case "or":
		cpu.Or(tokens[1], tokens[2], tokens[3])

	case "ori":
		v, _ := strconv.Atoi(tokens[3])
		cpu.Ori(tokens[1], tokens[2], int16(v))

	case "sll":
		v, _ := strconv.Atoi(tokens[3])
		cpu.Sll(tokens[1], tokens[2], uint16(v))

	case "srl":
		v, _ := strconv.Atoi(tokens[3])
		cpu.Srl(tokens[1], tokens[2], uint16(v))

	case "inc":
		cpu.Inc(tokens[1])

	case "dec":
		cpu.Dec(tokens[1])

	case "rand":
		cpu.Rand(tokens[1])

	case "lrb":
		var offset uint16
		if tokens[2][0] == '$' {
			offset = uint16(cpu.GetRegister(tokens[2]))
		} else {
			v, _ := strconv.Atoi(tokens[2])
			offset = uint16(v)
		}

		if tokens[3][0] == '$' {
			cpu.Lrb(tokens[1], uint16(offset), uint16(cpu.GetRegister(tokens[3])))
		} else {
			point, _ := strconv.Atoi(tokens[3])
			cpu.Lrb(tokens[1], uint16(offset), uint16(point))
		}

	case "lrw":
		offset, _ := strconv.Atoi(tokens[2])

		if tokens[3][0] == '$' {
			cpu.Lrw(tokens[1], uint16(offset), uint16(cpu.GetRegister(tokens[3])))
		} else {
			point, _ := strconv.Atoi(tokens[3])
			cpu.Lrw(tokens[1], uint16(offset), uint16(point))
		}

	case "syscall":
		cpu.Syscall()

	default:
		return -2
	}

	return 0
}
