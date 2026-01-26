package pc

// REGISTRADORES EM MEMORIA
// 0x0000 [ KEY UP ]
// 0x0001 [ KEY DOWN ]
// 0x0002 [ KEY LEFT ]
// 0x0003 [ KEY RIGHT ]
// 0x0004 [ KEY SPACE ]
// 0x0005 [ KEY ENTER ]
// 0x0006 [ KEY BACKSPACE ]
// 0x0007 [ KEY W ]
// 0x0008 [ KEY A ]
// 0x0009 [ KEY S ]
// 0x000A [ KEY D ]
// 0x000B [ KEY Q ]
// 0x000C [ KEY E ]
// 0x000D [ KEY I ]
// 0x000E [ KEY O ]
// 0x000F [ KEY P ]

type RAM struct {
	ram [65536]uint8 // 64KB
}

func NewRam() *RAM {
	var ram RAM
	return &ram
}

func (ram *RAM) save_byte(value uint8, index uint16) {
	// Primeiros 16 endereços não podem ser escritos
	if index >= 16 {
		ram.ram[index] = value
	} else {
		println("Endereço \"", index, "\" é endereço apenas de leitar de input.")
		panic("Tentativa de escrever endereço byte na memoria protegida")
	}
}

func (ram *RAM) save_world(value, index uint16) {
	// Primeiros 16 endereços não podem ser escritos
	if index >= 16 {
		// [11111111]11111111
		ram.ram[index] = uint8(value >> 8)

		// 11111111[11111111]
		ram.ram[index-1] = uint8(value)
	} else {
		println("Endereço \"", index, "\" é endereço apenas de leitar de input.")
		panic("Tentativa de escrever endereço word na memoria protegida")
	}
}

func (ram *RAM) load_byte(index uint16) uint8 {
	return ram.ram[index]
}

func (ram *RAM) load_world(index uint16) uint16 {
	half_1 := ram.ram[index]
	half_2 := ram.ram[index-1]

	var full_value uint16 = uint16(half_1) << 8
	full_value = full_value | uint16(half_2)
	return full_value
}

func (ram *RAM) show_ram() {
	for i, v := range ram.ram {
		println(i, ": ", v)
	}
}
