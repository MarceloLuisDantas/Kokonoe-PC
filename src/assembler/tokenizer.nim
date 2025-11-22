# Este modulo é responsavel por carregar programas e processar eles para garantir
# a sintaxe correta de cada instrução, remover coisas desnecessarias como comentarios
# e linhas em brancos, e, fazer a troca dos labels de jumps pelo endereço.

import strutils
# import sintaxes

type 
    TokenType* = enum 
        INSTRUCTION,   # instrução
        ARGUMENT,      # argumento para instrução
        LABEL_DEF,     # definição de label
        LABEL_REF,     # uso de labels
        TYPE,          # .string, .word...
        SECTION,       # .text e .data
        OPEN_PARENTH   # (
        CLOSE_PARENTH  # )
        REGISTER,
        COMMENT,
        STRING,
        NUMBER,
        NEW_LINE,
        VIRGULA

    Token* = ref object 
        tokenType*: TokenType
        value*: string
        line*: int
        column*: int

    Tokenizer* = object
        source*: string  
        position*: int   
        line*: int   
        column*: int 
        tokens*: seq[Token]  

var labels: seq[string]

proc `$`*(token: Token): string =
  result = "Token(" & $token.tokenType & ", '" & token.value & "', line=" & $token.line & ")"

proc newTokenzier*(file: string): Tokenizer =
    result.source = file
    result.position = 0
    result.line = 1
    result.column = 1
    result.tokens = @[]

proc advance(self: var Tokenizer, total: int=1) =
    self.position += total
    self.column += total

proc addToken(self: var Tokenizer, token_t: TokenType, value: string) =
    let t: Token = Token(
        tokenType: token_t,
        value: value,
        line: self.line,
        column: self.column
    )

    self.tokens.add(t)

proc currentChar(self: Tokenizer): char = 
    if self.position < self.source.len:
        return self.source[self.position]
    else:
        return '\0' # Fim do arquivo

proc peekNextChar(self: Tokenizer, offset: int=1): char =
    let next: int = self.position + offset
    if next < self.source.len:
        return self.source[next]
    else:
        return '\0'

proc handleWhiteSpace(self: var Tokenizer) = 
    case self.currentChar
        of '\n':
            self.addToken(NEW_LINE, "\n")
            self.advance()
            self.line += 1
            self.column = 1
        else:
            self.advance()

# proc handleComment(self: var Tokenizer) =
#   while self.currentChar != '\n' and self.currentChar != '\0':
#     self.advance()

# TODO - Adicionar suporte a Escape
proc handleString(self: var Tokenizer): bool =
    self.advance()
    var str: string = ""
    while (self.currentChar != '"') :
        let ch: char = self.currentChar()
        if (ch == '\n') :
            echo "Erro ao ler string na linha: ", self.line
            return false
        str.add(ch)
        self.advance()
    self.advance()
    self.addToken(STRING, str)
    return true

proc handleDirective(self: var Tokenizer) =
    let start = self.position  
    self.advance() 
        
    while self.currentChar.isAlphaNumeric() or self.currentChar == '_':
        self.advance() 
        
    let directive: string = self.source.substr(start, self.position - 1)
    var t = TYPE
    if (directive == ".text" or directive == ".data") :
        t = SECTION

    self.addToken(t, directive)  

proc setLastTokenType(self: var Tokenizer, newType: TokenType) =
    self.tokens[^1].tokenType = newType

proc handleLabelDef(self: var Tokenizer) =
    self.setLastTokenType(LABEL_DEF)
    labels.add(self.tokens[^1].value)
    self.advance()

proc handleIdentifier(self: var Tokenizer) =
    let start: int = self.position

    while self.currentChar.isAlphaNumeric() or self.currentChar == '_':
        self.advance()

    let identifier: string = self.source.substr(start, self.position - 1)
    self.addToken(INSTRUCTION, identifier)

proc isHex(c: char): bool =
    if not (('0' <= c and c <= '9') or
            ('a' <= c and c <= 'f') or
            ('A' <= c and c <= 'F')):
        return false
    return true

proc handleNumber(self: var Tokenizer) =
    let start: int = self.position

    # Handle negativo
    if self.currentChar == '-':
        self.advance()

    # Handle hexadecimal
    if self.currentChar == '0' and self.peekNextChar().toLowerAscii() == 'x':
        self.advance(2)  # Pula '0x'
        while self.currentChar().isHex():
            self.advance()
    # Decimal
    else:
        while self.currentChar.isDigit():
            self.advance()

    let number: string = self.source.substr(start, self.position - 1)
    self.addToken(NUMBER, number)

proc handleRegister(self: var Tokenizer) =
    let start: int = self.position
    self.advance() 

    while self.currentChar().isAlphaNumeric() :
        self.advance()

    let register: string = self.source.substr(start, self.position - 1)
    self.addToken(REGISTER, register)

proc handleComment(self: var Tokenizer) =
    let start: int = self.position
    self.advance()

    while self.currentChar() != '\n' :
        self.advance()

    let comentario: string = self.source.substr(start, self.position - 1)
    self.addToken(COMMENT, comentario)

proc handleLabelRef(self: var Tokenizer) =
    let start: int = self.position
    self.advance()

    while self.currentChar.isAlphaNumeric() or self.currentChar == '_':
        self.advance()

    let identifier: string = self.source.substr(start, self.position - 1)
    self.addToken(LABEL_REF, identifier)        

proc tokenize*(self: var Tokenizer): (seq[Token], bool) =
    while self.position < self.source.len:
        case self.currentChar
            of ' ', '\n':
                self.handleWhitespace()
            of '"':
                if (not self.handleString()) :
                    return (newSeq[Token](), false)
            of ',':
                self.addToken(VIRGULA, ",")
                self.advance()
            of '.':
                self.handleDirective()
            of ':':
                self.handleLabelDef()
            of '*':
                self.handleLabelRef()
            of 'a'..'z', 'A'..'Z', '_':
                self.handleIdentifier()
            of '0'..'9', '-':
                self.handleNumber()
            of '$' :
                self.handleRegister()
            of '#' :
                self.handleComment()
            of '(' :
                self.addToken(OPEN_PARENTH, "(")
                self.advance()
            of ')' :
                self.addToken(CLOSE_PARENTH, ")")
                self.advance()
            else:
                echo " - '", "'", self.currentChar
                echo "Character invalido na linha ", self.line
                return (newSeq[Token](), false)
    
    return (self.tokens, true)
