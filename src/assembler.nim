# Este modulo é responsavel por carregar programas e processar eles para garantir
# a sintaxe correta de cada instrução, remover coisas desnecessarias como comentarios
# e linhas em brancos, e, fazer a troca dos labels de jumps pelo endereço.

import strutils
import sequtils
import sugar
import os

# Removes all empty lines
proc remove_empty_lines(lines: var seq[string]) =
    var count: int = lines.len() - 1
    for i in 0..(count) :
        if (lines[count - i].strip().len == 0) :
            lines.del(count - i)

# Removes all comments
proc remove_comments(lines: var seq[string]) =
    for i in 0..(lines.len() - 1) :
        lines[i] = lines[i].split(";")[0]

# Remove extra spaces
proc remove_spaces(lines: var seq[string]) = 
    for i in 0..(lines.len() - 1) :
        var tokens: seq[string] = lines[i].split(" ")
        tokens.keepIf(x => x != "")
        lines[i] = tokens.join(" ")

# Loads a program and sanetize it
proc load_program*(file_path: string): bool =
    if not fileExists(file_path) :
        echo "file: ", file_path, "not found"
        return false

    var raw_file: string = readFile(file_path)
    var lines: seq[string] = raw_file.split("\n")

    remove_empty_lines(lines)
    remove_comments(lines)
    remove_spaces(lines)

    for line in lines :
        echo line

    return true