package cpu

import (
	"slices"
)

var registers = []string{
	"zero", "at", "v0", "v1",
	"a0", "a1", "a2", "a3",
	"t0", "t1", "t2", "t3", "t4", "t5", "t6", "t7", "t8", "t9",
	"s0", "s1", "s2", "s3", "s4", "s5", "s6", "s7",
	"k0", "k1",
	"gp", "sp", "fp",
	"ra",
}

type CPU struct {
	// ZERO int16ister, always returns 0
	ZERO int16

	// Reserved for assembler
	at int16

	// Stores resutls
	v0, v1 int16

	// Stores arguments
	a0, a1, a2, a3 int16

	// Temporare values
	t0, t1, t2, t3, t4, t5, t6, t7, t8, t9 int16

	// Contents saved for use later
	s0, s1, s2, s3, s4, s5, s6, s7 int16

	// Reserved by OS
	k0, k1 int16

	// Global Pointer
	// Stack Pointer
	// Frame Pointer
	gp, sp, fp int16

	// Return Address
	ra int16
}

func NewCPU() *CPU {
	return &CPU{}
}

func IsRegister(reg string) bool {
	return slices.Contains(registers, reg)
}

func (cpu *CPU) Set(reg string, value int16) {
	switch reg {
	case "at":
		cpu.at = value
	case "v0":
		cpu.v0 = value
	case "v1":
		cpu.v1 = value
	case "a0":
		cpu.a0 = value
	case "a1":
		cpu.a1 = value
	case "a2":
		cpu.a2 = value
	case "a3":
		cpu.a3 = value
	case "t0":
		cpu.t0 = value
	case "t1":
		cpu.t1 = value
	case "t2":
		cpu.t2 = value
	case "t3":
		cpu.t3 = value
	case "t4":
		cpu.t4 = value
	case "t5":
		cpu.t5 = value
	case "t6":
		cpu.t6 = value
	case "t7":
		cpu.t7 = value
	case "t8":
		cpu.t8 = value
	case "t9":
		cpu.t9 = value
	case "s0":
		cpu.s0 = value
	case "s1":
		cpu.s1 = value
	case "s2":
		cpu.s2 = value
	case "s3":
		cpu.s3 = value
	case "s4":
		cpu.s4 = value
	case "s5":
		cpu.s5 = value
	case "s6":
		cpu.s6 = value
	case "s7":
		cpu.s7 = value
	case "k0":
		cpu.k0 = value
	case "k1":
		cpu.k1 = value
	case "gp":
		cpu.gp = value
	case "sp":
		cpu.sp = value
	case "fp":
		cpu.fp = value
	case "ra":
		cpu.ra = value
	}
}

func (cpu *CPU) Get(reg string) int16 {
	switch reg {
	case "ZERO":
		return 0
	case "at":
		return cpu.at
	case "v0":
		return cpu.v0
	case "v1":
		return cpu.v1
	case "a0":
		return cpu.a0
	case "a1":
		return cpu.a1
	case "a2":
		return cpu.a2
	case "a3":
		return cpu.a3
	case "t0":
		return cpu.t0
	case "t1":
		return cpu.t1
	case "t2":
		return cpu.t2
	case "t3":
		return cpu.t3
	case "t4":
		return cpu.t4
	case "t5":
		return cpu.t5
	case "t6":
		return cpu.t6
	case "t7":
		return cpu.t7
	case "t8":
		return cpu.t8
	case "t9":
		return cpu.t9
	case "s0":
		return cpu.s0
	case "s1":
		return cpu.s1
	case "s2":
		return cpu.s2
	case "s3":
		return cpu.s3
	case "s4":
		return cpu.s4
	case "s5":
		return cpu.s5
	case "s6":
		return cpu.s6
	case "s7":
		return cpu.s7
	case "k0":
		return cpu.k0
	case "k1":
		return cpu.k1
	case "gp":
		return cpu.gp
	case "sp":
		return cpu.sp
	case "fp":
		return cpu.fp
	case "ra":
		return cpu.ra
	}

	return 0
}
