# Este modulo é responsavel por carregar programas e processar eles para garantir
# a sintaxe correta de cada instrução, remover coisas desnecessarias como comentarios
# e linhas em brancos, e, fazer a troca dos labels de jumps pelo endereço.

import sintaxes
import strutils
import strformat
import sequtils
import tables
import sugar
import os

type 
    type_of_instruction = enum 
        NO_ARGS, 
        ONE_ARG, 
        MULT_ARGS, 
        JUMP_LABEL, 
        ROM_LABEL
 
    TokenType = enum 
        INSTRUCTION,  # instrução
        ARGUMENT,     # argumento para instrução
        LABEL_DEF,    # definição de label
        LABEL_REF,    # uso de labels
        TYPE,         # .string, .word...
        STRING,
        NUMBER,
        NEW_LINE,
        COMMA

    Token* = ref object 
        tokenType*: TokenType
        value: string
        line: int
        column: int

    AssemblyTokenizer* = object
        source: string  
        position: int   
        line: int   
        column: int 
        tokens: seq[Token]  

proc newAssemblyTokenzier*(file: string): AssemblyTokenizer =
    result.source = file
    result.position = 0
    result.line = 1
    result.column = 1
    result.tokens = @[]

proc advance(self: var AssemblyTokenizer) =
    self.position += 1
    self.column += 1

proc addToken(self: var AssemblyTokenizer, token_t: TokenType, value: string) =
    let t: Token = Token(
        tokenType: token_t,
        value: value,
        line: self.line,
        column: self.column
    )

    self.tokens.add(t)

proc currentChar(self: AssemblyTokenizer): char = 
    if self.position < self.source.len:
        return self.source[self.position]
    else:
        return '\0' # Fim do arquivo

# proc handleWhiteSpace(self: AssemblyTokenizer) = 


proc tokenize*(self: var AssemblyTokenizer): seq[string] =
    while self.position < self.source.len:
        
        case self.currentChar
            of ' ', '\t', '\n', '\r':
                self.handleWhitespace()
            of ';':
                self.handleComment()
            of '"':
                self.handleString()
            of ':':
                self.handleLabelDef()
            of ',':
                self.addToken(tkComma, ",")
                self.advance()
            of '.':
                self.handleDirective()
            of 'a'..'z', 'A'..'Z', '_':
                self.handleIdentifier()
            of '0'..'9', '-':
                self.handleNumber()
            else:
                self.advance()  # Ignora caracteres inválidos
    return

# Removes all comments
proc remove_comments(lines: var seq[string]) =
    for i in 0..(lines.len() - 1) :
        if ('#' in lines[i]) :
            lines[i] = lines[i].split("#")[0]


# Carrega o programa e sanetiza 
proc load_program*(file_path: string): bool =
    if not fileExists(file_path) :
        echo "file: ", file_path, "not found"
        return false

    var raw_file: string = readFile(file_path)

    var at: AssemblyTokenizer = newAssemblyTokenzier(raw_file)

    

    return true