package assembler

import (
	"fmt"
	"os"
	"strconv"
	"strings"
)

func check(err error) {
	if err != nil {
		panic(err)
	}
}

func load_file(file_name string) string {
	data, err := os.ReadFile(file_name)
	check(err)
	return string(data)
}

func replaceLabelsRef(ins []Instruction, parser *Parser) error {
	for i, value := range ins {
		var label = ""
		op := value[0]
		if op == "j" || op == "jal" {
			label = value[1]
		} else if op == "la" {
			label = value[2]
		} else if op[0] == 'b' {
			label = value[3]
		} else if op == "lrw" || op == "lrb" {
			if value[3][0] != '$' {
				label = value[3]
			}
		}

		if label != "" {
			if op == "j" || op == "jal" || op[0] == 'b' {
				line, exists := parser.JumpLabels[label]
				if !exists {
					return fmt.Errorf("Label \"%s\" não encontrando", label)
				}

				if op == "j" || op == "jal" {
					ins[i][1] = strconv.Itoa(line)
				} else {
					ins[i][3] = strconv.Itoa(line)
				}
			} else {
				line, exists := parser.RomLabels[label]
				if !exists {
					return fmt.Errorf("Label \"%s\" não encontrando", label)
				}

				if op == "la" {
					ins[i][2] = strconv.Itoa(line)
				} else {
					ins[i][3] = strconv.Itoa(line)
				}
			}
			label = ""
		}
	}
	return nil
}

func exportFile(instructions []Instruction, file_name string) error {
	file, err := os.Create(file_name)
	if err != nil {
		return err
	}
	defer file.Close()

	for _, ins := range instructions {
		switch ins[0] {
		case "STR":
			value := ins[1]
			// println(value[len(value)-1])
			for _, char := range value {
				fmt.Fprintf(file, fmt.Sprintf("%d\n", char))
			}
		case "INT8", "UINT8":
			values := ins[1:]
			for _, v := range values {
				numi64, _ := strconv.ParseInt(v, 10, 64)
				fmt.Fprintf(file, fmt.Sprintf("%d\n", uint8(numi64)))
			}

		case "INT16", "UINT16":
			values := ins[1:]
			for _, v := range values {
				numi64, _ := strconv.ParseInt(v, 10, 64)
				numui16 := uint16(numi64)
				lsb := uint8(numui16)
				msb := uint8(numui16 >> 8)
				fmt.Fprintf(file, fmt.Sprintf("%d\n", msb))
				fmt.Fprintf(file, fmt.Sprintf("%d\n", lsb))
			}
		case "syscall", "return", "rand":
			fmt.Fprintln(file, ins[0][0:3])
			fmt.Fprintln(file, ins[0][3:])

		default:
			fmt.Fprintf(file, fmt.Sprintf("%s\n", ins[0]))

			values := ins[1:]
			for _, v := range values {
				fmt.Fprintf(file, fmt.Sprintf("%s ", v))
			}
			fmt.Fprintf(file, "\n")
		}
	}

	return nil
}

func Assembler() {
	if len(os.Args) < 2 {
		fmt.Println("Arquivo não dado")
		os.Exit(0)
	}

	file_name := os.Args[1]
	data := load_file(file_name)

	tk := newTokenizer(data)
	err := tk.Tokenize()
	if err != nil {
		return
	}
	println("Tokenizer: OK")

	parser := newParser(tk.tokens)
	instructions := parser.Parse()
	if instructions == nil {
		println("Erro ao realisar parser")
	}
	println("Parser: OK")

	err = replaceLabelsRef(instructions, parser)
	if err != nil {
		fmt.Println(err)
	}
	fmt.Println("Assembler: OK")

	final_name := strings.Split(file_name, ".")[0]
	final_name += ".krom"
	err = exportFile(instructions, final_name)
	if err != nil {
		println(err)
	} else {
		fmt.Printf("ROM exportada em \"%s\"\n", final_name)
	}
}
