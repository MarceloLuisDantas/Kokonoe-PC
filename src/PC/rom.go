package pc

import "fmt"

type ROM struct {
	rom [65536]string // 64KB
}

func NewRom(file []string) (*ROM, error) {
	if len(file) > 65536 {
		fmt.Print("ROM maior que 64KB")
		return nil, fmt.Errorf("ROM muito grande")
	}

	var rom ROM
	copy(rom.rom[:], file)
	return &rom, nil
}
