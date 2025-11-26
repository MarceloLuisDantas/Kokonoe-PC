import tokenizer
# import ../cpu

type
    Parser* = object
        tokens: seq[Token]
        position: int
        len: int

const INSTRUCTIONS* = [
    "add", "addi", "sub", "subi", "mult", "multi", "div", "divi", "move",
    "or", "ori", "and", "andi", "sll", "srl", "slt", "slti", "li", "syscall",
    "j", "jr", "jal", "beq", "bne", "bgt", "bge", "blt", "ble", "return",
    "lw", "lb", "sw", "sb", "lv", "sv", "lrw", "lrb", "inc", "dec",
    ".text", ".data", "la"
]

const THREE_REGISTERS_INS* = [
    "add", "sub", "mult", "div", "or", "and", "slt"
]

const IMMEDIATE_INS* = [
    "addi", "subi", "multi", "divi", "ori", "andi", "sll", "srl", "slti"
]

const BRANCH_INS* = [
    "beq", "bne", "bgt", "bge", "blt", "ble"
]

const DATA_TYPE* = [
    ".string", ".int8", ".int16"
]

const MEMORIE_ACCESS* = [
    "lw", "lb", "sw", "sb", "lv", "sv", "lrw", "lrb"
]

const JUMP* = [
    "j", "jr", "jal"
]

const INCDEC* = [
    "inc", "dec"
]

const SECTIONS* = [
    ".text", ".data"
]

const LI = "li"
const LA = "la"

const RETURN = "return"
const SYSCALL = "syscall"
const MOVE = "move"

const REGISTERS* = [
    "$zero", "$t0", "$t1", "$t2", "$t3", "$t4", "$t5", "$rt", 
    "$sp", "$fp", "$sc", "$gp", "$ra", "$pc", "$ir", "$bk"
]

proc newParser*(tokens: seq[Token]): Parser =
    result.tokens = tokens
    result.position = 0
    result.len = tokens.len()

proc advance*(self: var Parser, amount: int=1) =
    if (self.position < self.len) :
        self.position += amount

proc get*(self: Parser, index: int): Token =
    return self.tokens[index]

proc peek*(self: Parser): Token =
    return self.tokens[self.position]

# add, sub, mult, div, or, and, slt
proc check_3_registers*(self: var Parser, opcode: string): (seq[string], bool) =
    var instruction: seq[string] = @["INSTRUCTION", opcode]

    var tk: Token = self.peek()
    if (tk.tokenType != REGISTER) or (not (tk.value in REGISTERS)) :
        echo "'", tk.value, "' Não é um registrador valido. Linha: ", tk.line
        return (@[], false)
    instruction.add(tk.value)

    if (self.get(self.position + 1).value != ",") :
        echo "Argumentos devem ser separados por virgula. Linha: ", tk.line
        return (@[], false)

    tk = self.get(self.position + 2)
    if (tk.tokenType != REGISTER) or (not (tk.value in REGISTERS)) :
        echo "'", tk.value, "' Não é um registrador valido. Linha: ", tk.line
        return (@[], false)
    instruction.add(tk.value)
    
    if (self.get(self.position + 3).value != ",") :
        echo "Argumentos devem ser separados por virgula. Linha: ", tk.line
        return (@[], false)
    
    tk = self.get(self.position + 4)
    if (tk.tokenType != REGISTER) or (not (tk.value in REGISTERS)) :
        echo "'", tk.value, "' Não é um registrador valido. Linha: ", tk.line
        return (@[], false)
    instruction.add(tk.value)

    tk = self.get(self.position + 5)
    if (tk.tokenType != NEW_LINE and tk.tokenType != COMMENT) :
        echo "'", opcode, "' recebe apenas 3 parametros. Linha: ", tk.line
        return (@[], false)

    return (instruction, true)

# addi, subi, multi, divi, ori, andi, slti
proc check_imediatos(self: var Parser, opcode: string): (seq[string], bool) = 
    var instruction: seq[string] = @["INSTRUCTION", opcode]

    var tk: Token = self.peek()
    if (tk.tokenType != REGISTER) or (not (tk.value in REGISTERS)) :
        echo "'", tk.value, "' Não é um registrador valido. Linha: ", tk.line
        return (@[], false)
    instruction.add(tk.value)

    if (self.get(self.position + 1).value != ",") :
        echo "Argumentos devem ser separados por virgula. Linha: ", tk.line
        return (@[], false)

    tk = self.get(self.position + 2)
    if (tk.tokenType != REGISTER) or (not (tk.value in REGISTERS)) :
        echo "'", tk.value, "' Não é um registrador valido. Linha: ", tk.line
        return (@[], false)
    instruction.add(tk.value)
    
    if (self.get(self.position + 3).value != ",") :
        echo "Argumentos devem ser separados por virgula. Linha: ", tk.line
        return (@[], false)
    
    tk = self.get(self.position + 4)
    if (tk.tokenType != NUMBER) :
        echo "'", tk.value, "' Não é um valor valido para imediato. Linha: ", tk.line
        return (@[], false)
    instruction.add(tk.value)

    tk = self.get(self.position + 5)
    if (tk.tokenType != NEW_LINE and tk.tokenType != COMMENT) :
        echo "'", opcode, "' recebe apenas 3 parametros. Linha: ", tk.line
        return (@[], false)

    return (instruction, true)

# beq, bne, bgt, bge, blt, ble
proc parse_branch(self: var Parser, opcode: string): (seq[string], bool) =
    var instruction: seq[string] = @["INSTRUCTION", opcode]

    var tk: Token = self.peek()
    if (tk.tokenType != REGISTER) or (not (tk.value in REGISTERS)) :
        echo "'", tk.value, "' Não é um registrador valido. Linha: ", tk.line
        return (@[], false)
    instruction.add(tk.value)

    if (self.get(self.position + 1).value != ",") :
        echo "Argumentos devem ser separados por virgula. Linha: ", tk.line
        return (@[], false)

    tk = self.get(self.position + 2)
    if (tk.tokenType != REGISTER) or (not (tk.value in REGISTERS)) :
        echo "'", tk.value, "' Não é um registrador valido. Linha: ", tk.line
        return (@[], false)
    instruction.add(tk.value)
    
    if (self.get(self.position + 3).value != ",") :
        echo "Argumentos devem ser separados por virgula. Linha: ", tk.line
        return (@[], false)
    
    tk = self.get(self.position + 4)
    if (tk.tokenType != LABEL_REF) :
        echo "'", tk.value, "' Não é um valor valido para referencia de label. Linha: ", tk.line
        return (@[], false)
    instruction.add(tk.value)

    tk = self.get(self.position + 5)
    if (tk.tokenType != NEW_LINE and tk.tokenType != COMMENT) :
        echo "'", opcode, "' recebe apenas 3 parametros. Linha: ", tk.line
        return (@[], false)

    return (instruction, true)

# lw, lb, sw, sb, lv, sv, lrw, lrb
proc parse_memorie_acess(self: var Parser, opcode: string): (seq[string], bool) =
    var instruction: seq[string] = @["INSTRUCTION", opcode]

    var tk: Token = self.peek()
    if (tk.tokenType != REGISTER) or (not (tk.value in REGISTERS)) :
        echo "'", tk.value, "' Não é um registrador valido. Linha: ", tk.line
        return (@[], false)
    instruction.add(tk.value)

    if (self.get(self.position + 1).value != ",") :
        echo "Argumentos devem ser separados por virgula. Linha: ", tk.line
        return (@[], false)

    tk = self.get(self.position + 2)
    if (tk.tokenType != NUMBER) :
        if (tk.tokenType != REGISTER) or (not (tk.value in REGISTERS)) :
            echo "'", tk.value, "' Não é um numero, ou, registrador valido. Linha: ", tk.line
            return (@[], false)
    instruction.add(tk.value)
    
    tk = self.get(self.position + 3)
    if (tk.value != "(") :
        echo "Parenteses esperado na linha: ", tk.line, " coluna: ", tk.column
        return (@[], false)

    tk = self.get(self.position + 4)
    if (tk.tokenType != REGISTER and tk.tokenType != LABEL_REF) :
        echo "Registrador ou Label esperando em linha: ", tk.line, " coluna: ", tk.column
        return (@[], false)

    if (tk.tokenType == REGISTER) and (not (tk.value in REGISTERS)) :
        echo "Registrador invalido em linha: ", tk.line, " coluna: ", tk.column
        return (@[], false)
    instruction.add(tk.value)
    
    tk = self.get(self.position + 5)
    if (tk.value != ")") :
        echo "Fechamento de parenteses esperado na linha: ", tk.line, " coluna: ", tk.column
        return (@[], false)

    tk = self.get(self.position + 6)
    if (tk.tokenType != NEW_LINE and tk.tokenType != COMMENT) :
        echo "'", opcode, "' recebe apenas 3 parametros. Linha: ", tk.line
        return (@[], false)

    return (instruction, true)

# j, jr, jal
proc parse_jump(self: var Parser, jumpType: string): (seq[string], bool) = 
    var instruction: seq[string] = @["INSTRUCTION", jumpType]

    var tk: Token = self.peek()
    if jumpType == "j" :
        if (tk.tokenType != LABEL_REF) :
            echo "'j' espera receber um label. Linha: ", tk.line
            return (@[], false)
    
    if jumpType == "jal" :
        if (tk.tokenType != LABEL_REF) :
            echo "'jal' espera receber um label. Linha: ", tk.line
            return (@[], false)
    
    elif jumpType == "jr" :
        if (tk.tokenType != REGISTER) :
            echo "jr espera um registrador que possui um valor para setar pc. Linha: ", tk.line
            return (@[], false)
        elif (not (tk.value in REGISTERS)) :
            echo "'", tk.value, "' não é um registrador valido. Linha: ", tk.line, " Coluna: ", tk.column
            return (@[], false)
    instruction.add(tk.value)

    tk = self.get(self.position + 1)
    if (tk.tokenType != NEW_LINE and tk.tokenType != COMMENT) :
        echo "'", jumpType, "' recebe apenas 3 parametros. Linha: ", tk.line
        return (@[], false)

    return (instruction, true)

proc parse_inc_dec(self: var Parser, opcode: string) : (seq[string], bool) =
    var instruction: seq[string] = @["INSTRUCTION", opcode]
    var tk: Token = self.peek()
    
    if (tk.tokenType != REGISTER) :
        echo opcode, " espera receber um registrador. Linha: ", tk.line
        return (@[], false)

    elif (not (tk.value in REGISTERS)) :
        echo "'", tk.value, "' não é um registrador valido. Linha: ", tk.line, " Coluna: ", tk.column
        return (@[], false)
    
    instruction.add(tk.value)

    tk = self.get(self.position + 1)
    if (tk.tokenType != NEW_LINE and tk.tokenType != COMMENT) :
        echo "'", opcode, "' recebe apenas 1 parametro. Linha: ", tk.line
        return (@[], false)
    
    return (instruction, true)

proc parse_move(self: var Parser): (seq[string], bool) = 
    var instruction: seq[string] = @["INSTRUCTION", "move"]

    var tk: Token = self.peek()
    if (tk.tokenType != REGISTER) or (not (tk.value in REGISTERS)) :
        echo "'", tk.value, "' Não é um registrador valido. Linha: ", tk.line
        return (@[], false)
    instruction.add(tk.value)

    if (self.get(self.position + 1).value != ",") :
        echo "Argumentos devem ser separados por virgula. Linha: ", tk.line
        return (@[], false)

    tk = self.get(self.position + 2)
    if (tk.tokenType != REGISTER) or (not (tk.value in REGISTERS)) :
        echo "'", tk.value, "' Não é um registrador valido. Linha: ", tk.line
        return (@[], false)
    instruction.add(tk.value)
    
    tk = self.get(self.position + 3)
    if (tk.tokenType != NEW_LINE and tk.tokenType != COMMENT) :
        echo "move recebe apenas 3 argumentos. Linha: ", tk.line
        return (@[], false)
    
    return (instruction, true)

proc parse_li(self: var Parser): (seq[string], bool) = 
    var instruction: seq[string] = @["INSTRUCTION", "li"]
    var tk: Token = self.peek()
    
    if (tk.tokenType != REGISTER) or (not (tk.value in REGISTERS)) :
        echo tk.value, " - registrador invalido. Linha: ", tk.line
        return (@[], false)
    instruction.add(tk.value)

    if (self.get(self.position + 1).value != ",") :
        echo "Argumentos devem ser separados por virgula. Linha: ", tk.line
        return (@[], false)

    tk = self.get(self.position + 2)
    if (tk.tokenType != NUMBER) :
        echo "'", tk.value, "' Não é um numero valido. Linha: ", tk.line
        return (@[], false)
    instruction.add(tk.value)

    tk = self.get(self.position + 3)
    if (tk.tokenType != NEW_LINE and tk.tokenType != COMMENT) :
        echo "'li' recebe apenas 2 parametros. Linha: ", tk.line
        return (@[], false)

    return (instruction, true)

proc parse_la(self: var Parser): (seq[string], bool) = 
    var instruction: seq[string] = @["INSTRUCTION", "la"]
    var tk: Token = self.peek()
    
    if (tk.tokenType != REGISTER) or (not (tk.value in REGISTERS)) :
        echo tk.value, " - registrador invalido. Linha: ", tk.line
        return (@[], false)
    instruction.add(tk.value)

    if (self.get(self.position + 1).value != ",") :
        echo "Argumentos devem ser separados por virgula. Linha: ", tk.line
        return (@[], false)

    tk = self.get(self.position + 2)
    if (tk.tokenType != LABEL_REF) :
        echo "'", tk.value, "' Não é um label valido. Linha: ", tk.line
        return (@[], false)
    instruction.add(tk.value)

    tk = self.get(self.position + 3)
    if (tk.tokenType != NEW_LINE and tk.tokenType != COMMENT) :
        echo "'la' recebe apenas 2 parametros. Linha: ", tk.line
        return (@[], false)

    return (instruction, true)

proc parse_return(self: var Parser): (seq[string], bool) = 
    var instruction: seq[string] = @["INSTRUCTION", "return"]
    var tk: Token = self.peek()
    
    if (tk.tokenType != NEW_LINE and tk.tokenType != COMMENT) :
        echo "return não recebe parametros. Linha: ", tk.line
        return (@[], false)

    return (instruction, true)

proc parse_syscall(self: var Parser): (seq[string], bool) = 
    var instruction: seq[string] = @["INSTRUCTION", "syscall"]
    var tk: Token = self.peek()
    
    if (tk.tokenType != NEW_LINE and tk.tokenType != COMMENT) :
        echo "syscall não recebe parametros. Linha: ", tk.line
        return (@[], false)

    return (instruction, true)

proc parse_instruction*(self: var Parser, token: Token): (seq[string], bool) =
    let upcode: string = token.value
    self.advance()

    if not(upcode in INSTRUCTIONS) :
        echo "'", upcode, "' não é uma instrução valida, linha: ", token.line
        return (@[""], false)

    if (upcode in THREE_REGISTERS_INS) :
        let (ins, ok) = check_3_registers(self, upcode)
        if not ok :
            echo "Erro na linha: ", token.line
        else :
            return (ins, true)

    elif (upcode in IMMEDIATE_INS) :
        let (ins, ok) = check_imediatos(self, upcode)
        if not ok :
            echo "Erro na linha: ", token.line
        else :
            return (ins, true)

    elif (upcode in BRANCH_INS) :
        let (ins, ok) = parse_branch(self, upcode)
        if not ok :
            echo "Erro na linha: ", token.line
        else :
            return (ins, true)

    elif (upcode in MEMORIE_ACCESS) :
        let (ins, ok) = parse_memorie_acess(self, upcode)
        if not ok :
            echo "Erro na linha: ", token.line
        else :
            return (ins, true)
        
    elif (upcode in JUMP) :
        let (ins, ok) = parse_jump(self, upcode)
        if not ok :
            echo "Erro na linha: ", token.line
        else :
            return (ins, true)

    elif (upcode == LI) :
        let (ins, ok) = parse_li(self)
        if not ok :
            echo "Erro na linha: ", token.line
        else :
            return (ins, true)
    
    elif (upcode == LA) :
        let (ins, ok) = parse_la(self)
        if not ok :
            echo "Erro na linha: ", token.line
        else :
            return (ins, true)

    elif (upcode == RETURN) :
        let (ins, ok) = parse_return(self)
        if not ok :
            echo "Erro na linha: ", token.line
        else :
            return (ins, true)

    elif (upcode == MOVE) :
        let (ins, ok) = parse_move(self)
        if not ok :
            echo "Erro na linha: ", token.line
        else :
            return (ins, true)

    elif (upcode in INCDEC) :
        let (ins, ok) = parse_inc_dec(self, upcode)
        if not ok :
            echo "Erro na linha: ", token.line
        else :
            return (ins, true)

    elif (upcode == SYSCALL) :
        let (ins, ok) = parse_syscall(self)
        if not ok :
            echo "Erro na linha: ", token.line
        else :
            return (ins, true)

    return (@[""], false)

proc parse_label_def(self: var Parser, token: Token): (seq[string], bool) =
    var instruction: seq[string] = @["JUMP_LABEL", token.value]
    
    let next: Token = self.get(self.position + 1)
    if (next.value == "\n") :
        return (instruction, true)

    if (next.tokenType == TYPE) :
        instruction[0] = "CONSTANT"
        if (next.value == ".string") :
            instruction.add(next.value)
            var count: int = 2
            var value: Token = self.get(self.position + count)
            while value.tokenType != NEW_LINE :
                if (value.tokenType == STRING) :
                    instruction.add(value.value)
                else :
                    echo "Uso inapropriado de '.string'. Linha: ", token.line 
                    return (@[], false)
                count += 1
                value = self.get(self.position + count)

        if (next.value in [".int8", ".int16"]) :
            instruction.add(next.value)
            var count: int = 2
            var value: Token = self.get(self.position + count)
            while value.tokenType != NEW_LINE :
                if (value.tokenType == NUMBER) :
                    instruction.add(value.value)
                else :
                    echo "Uso inapropriado de '", next.value ,"'. Linha: ", token.line 
                    return (@[], false)
                count += 1
                value = self.get(self.position + count)
            
    else :
        echo "Uso inapropriado de definição de label. Linha: ", token.line 
        return (@[], false)
    
    return (instruction, true)

proc parse_section(self: var Parser, token: Token): (seq[string], bool) =
    var instruction: seq[string] = @[token.value]
    var tk: Token = self.get(self.position + 1)
    
    # echo tk
    if (tk.tokenType != NEW_LINE and tk.tokenType != COMMENT) :
        echo "definição de seções precisam ser seguidas por nova linha. Linha: ", tk.line
        return (@[], false)

    return (instruction, true)

proc parse*(self: var Parser): (seq[seq[string]], bool) =
    var instructions: seq[seq[string]] = @[]

    if self.get(0).value != ".text" :
        echo "seção de texto precisar ser a primeira a ser definida"
        return (@[], false)

    if (self.get(1).tokenType != NEW_LINE and self.get(1).tokenType != COMMENT) :
        echo "definição de seções precisam ser seguidas por nova linha. Linha: 1"
        return (@[], false)

    while (self.position != self.len) :
        let atual: Token = self.peek()
        if (atual.tokenType == INSTRUCTION) :
            let (line, ok) = self.parse_instruction(atual)
            if not ok :
                echo "erro na linha: ", atual.line
                return (@[], false)
            instructions.add(line)

        elif (atual.tokenType == LABEL_DEF) :
            let (line, ok) = self.parse_label_def(atual)
            if not ok :
                echo "erro na linha: ", atual.line
                return (@[], false)
            instructions.add(line)

        elif (atual.value == ".data") :
            let (line, ok) = self.parse_section(atual)
            if not ok :
                echo "erro na linha: ", atual.line
                return (@[], false)
            instructions.add(line)

        self.advance()

    return (instructions, true)
    