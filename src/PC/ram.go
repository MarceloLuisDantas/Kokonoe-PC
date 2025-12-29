package pc

type RAM struct {
	ram [65536]uint8 // 64KB
}

func NewRam() *RAM {
	var ram RAM
	return &ram
}

func (ram *RAM) save_byte(value uint8, index uint16) {
	ram.ram[index] = value
}

func (ram *RAM) save_world(value, index uint16) {
	// [11111111]11111111
	ram.ram[index] = uint8(value >> 8)

	// 11111111[11111111]
	ram.ram[index-1] = uint8(value)
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
