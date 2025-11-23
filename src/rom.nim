import strutils
import std/tables

type ROM* = object
    data*: array[65536, string] # 64KB
    len*: int

proc newRom*(): ROM =
    result.data = default(array[65536, string])
    result.len = 0
    
proc add*(self: var ROM, instruction: string) =
    self.data[self.len] = instruction
    self.len += 1

proc get*(self: ROM, index: int16): string =
    return self.data[index]

proc getJumpsTableAndConstantsTablesAndGP(
    program: seq[seq[string]]
): (
    Table[string, int], 
    Table[string, int], 
    int,
    seq[seq[string]]
) =

    var jumps_table: Table[string, int] = initTable[string, int]()
    var constants_table: Table[string, int] = initTable[string, int]()
    var filtered_program: seq[seq[string]] = newSeqOfCap[seq[string]](program.len())

    var gp: int = 0
    var line_number: int = 0
    var index: int = 0

    while index != program.len() :
        var tokens: seq[string] = program[index]
        if (tokens[0] == ".data") :
            gp = line_number * 2
            index += 1
            break
        
        if (tokens[0] == "JUMP_LABEL") :
            jumps_table[tokens[1]] = line_number * 2
        
        else :
            filtered_program.add(tokens)
            line_number += 1

        index += 1

    var constant_line: int = 0
    while index != program.len() :
        var tokens: seq[string] = program[index]
        
        if (tokens[0] != "CONSTANT") :
            return (jumps_table, constants_table, -1, @[])

        constants_table[tokens[1]] = constant_line
        if (tokens[2] == ".string") :
            filtered_program.add(tokens)
            var count: int = 3
            while count != tokens.len() :
                constant_line += tokens[count].len() + 1
                count += 1

        if (tokens[2] == ".int8") :
            filtered_program.add(tokens)
            constant_line += tokens.len() - 3

        if (tokens[2] == ".int16") :
            filtered_program.add(tokens)
            constant_line += (tokens.len() - 3) * 2

        index += 1

    return (jumps_table, constants_table, gp, filtered_program)


proc showData*(self: ROM) =
    var count: int = 0
    while count != self.len :
        if (self.data[count] != " -") :
            echo count, " - ", self.data[count]
        else :
            echo count, " - "
        count += 1

proc loadStringToRom(self: var ROM, value: string) =
    for c in value :
        self.add($(int(c)))
    self.add("\0")

proc loadStringsToRom(self: var ROM, tokens: seq[string]) =
    var count = 3
    while (count != tokens.len()) :
        self.loadStringToRom(tokens[count])
        count += 1

proc loadInt8ToRom(self: var ROM, tokens: seq[string]) =
    var count = 3
    while (count != tokens.len()) :
        self.add(tokens[count])
        count += 1

proc loadInt16ToRom(self: var ROM, tokens: seq[string]) =
    var count = 3
    while (count != tokens.len()) :
        self.add(tokens[count])
        self.add(" -")
        count += 1

# carrega o programa na memoria, e retornar o local a qual começa a area estatica ($gp)
proc loadProgram*(self: var ROM, program: seq[seq[string]]): int =
    const BRANCHS = [
        "beq", "bne", "bgt", "bge", "blt", "ble"
    ]

    const ROM_ACESS = [
        "lrw", "lrb"
    ]

    const JUMPS = [
        "j", "jal"
    ]

    var gp: int
    var jumps_table: Table[string, int]
    var constant_table: Table[string, int]
    var filtered_program: seq[seq[string]]
    (jumps_table, constant_table, gp, filtered_program) = getJumpsTableAndConstantsTablesAndGP(program)

    var line_number: int = 0
    while line_number != filtered_program.len() :
        var tokens: seq[string] = filtered_program[line_number]

        if (tokens[0] == "INSTRUCTION") :
            if (tokens[1] in BRANCHS) :
                tokens[4] = intToStr(jumps_table[tokens[4][1..^1]])
            elif (tokens[1] in JUMPS) :
                tokens[2] = intToStr(jumps_table[tokens[2][1..^1]])
            elif (tokens[1] in ROM_ACESS) :
                if tokens[4][0] == '*' :
                    tokens[4] = intToStr(constant_table[tokens[4][1..^1]])
            elif (tokens[1] == "li") :
                if (tokens[3][0] == '*') :
                    tokens[3] = intToStr(constant_table[tokens[3][1..^1]])

            if tokens[1] in ["syscall", "return"] :
                self.add(tokens[1][0..2])
                self.add(tokens[1][3..^1])
            else :
                self.add(tokens[1])
                self.add(tokens[2..^1].join(" "))

        elif (tokens[0] == "CONSTANT") :
            if (tokens[2] == ".string") :
                self.loadStringsToRom(tokens)
            elif (tokens[2] == ".int8") :
                self.loadInt8ToRom(tokens)
            elif (tokens[2] == ".int16") :
                self.loadInt16ToRom(tokens)

        line_number += 1

    return gp