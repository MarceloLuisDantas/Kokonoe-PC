package pc

import "fmt"

type COLOR uint8

const (
	PRETO    COLOR = 0 // 0000
	BRANCO   COLOR = 1 // 0001
	AZUL     COLOR = 2 // 0010
	VERMELHO COLOR = 3 // 0011
	VERDE    COLOR = 4 // 0100
	CINZA    COLOR = 5 // 0101
	MARROM   COLOR = 6 // 0110
	AMARELO  COLOR = 7 // 0111
)

// [00000000] - ASCII
// [0000] - CHARACTER COLOR
// [0000] - BACKGROUND COLOR
type Character uint16

type VRAM struct {
	vram [60][60]Character
}

func NewVram() *VRAM {
	var vram VRAM
	return &vram
}

func (vram *VRAM) SetChar(x, y int, char uint8) error {
	if (x < 0 || x >= 60) || (y < 0 || y >= 60) {
		return fmt.Errorf("out of bounds VRAM write char")
	}

	cell := vram.vram[y][x]
	cell &= 0b0000000011111111     // zera o character
	cell |= (Character(char)) << 8 //
	vram.vram[y][x] = cell
	return nil
}

func (vram *VRAM) SetCharColor(x, y int, color COLOR) error {
	if (x < 0 || x >= 60) || (y < 0 || y >= 60) {
		return fmt.Errorf("out of bounds VRAM write color")
	}

	cell := vram.vram[y][x]
	cell &= 0b1111111100001111      // zera o valor da cor
	cell |= (Character(color)) << 4 // color = 00000000xxxx0000
	vram.vram[y][x] = cell
	return nil
}

func (vram *VRAM) SetCharBackColor(x, y int, color COLOR) error {
	if (x < 0 || x >= 60) || (y < 0 || y >= 60) {
		return fmt.Errorf("out of bounds VRAM write back color")
	}

	cell := vram.vram[y][x]
	cell &= 0b1111111111110000 // zera o valor da cor de fundo
	cell |= (Character(color)) // color = 000000000000xxxx
	vram.vram[y][x] = cell
	return nil
}

func (vram *VRAM) GetChar(x, y int) (error, byte) {
	if (x < 0 || x >= 60) || (y < 0 || y >= 60) {
		return fmt.Errorf("out of bounds VRAM reading char"), ' '
	}

	cell := vram.vram[y][x]
	cell >>= 8 // cell = 0b00000000xxxxxxxx
	return nil, byte(cell)
}

func (vram *VRAM) GetCharColor(x, y int) (error, COLOR) {
	if (x < 0 || x >= 60) || (y < 0 || y >= 60) {
		return fmt.Errorf("out of bounds VRAM reading color"), 0
	}

	cell := vram.vram[y][x]    // cell = xxxxxxxx[xxxx]xxxx
	cell >>= 4                 // cell = 0000xxxxxxxx[xxxx]
	cell &= 0b0000000000001111 // cell = 000000000000xxxx
	return nil, COLOR(cell)
}

func (vram *VRAM) GetCharBackColor(x, y int) (error, COLOR) {
	if (x < 0 || x >= 60) || (y < 0 || y >= 60) {
		return fmt.Errorf("out of bounds VRAM reading back color"), 0
	}
	cell := vram.vram[y][x]    // cell = xxxxxxxxxxxx[xxxx]
	cell &= 0b0000000000001111 // cell = 000000000000xxxx
	return nil, COLOR(cell)
}
