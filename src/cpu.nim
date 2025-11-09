type Word* = distinct int16
type Byte* = distinct int8

type Instruction* = tuple
    op: string
    arg1: string
    arg2: string
    arg3: string

