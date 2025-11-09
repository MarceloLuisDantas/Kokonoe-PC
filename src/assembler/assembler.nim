# Este modulo é responsavel por carregar programas e processar eles para garantir
# a sintaxe correta de cada instrução, remover coisas desnecessarias como comentarios
# e linhas em brancos, e, fazer a troca dos labels de jumps pelo endereço.

import sintaxes
import strutils
import strformat
import sequtils
import tables
import sugar
# import cpu
import os

# Removes all empty lines
proc remove_empty_lines(lines: var seq[string]) =
    lines.keepIf(x => not isEmptyOrWhitespace(x))

# Removes all comments
proc remove_comments(lines: var seq[string]) =
    for i in 0..(lines.len() - 1) :
        if ('#' in lines[i]) :
            lines[i] = lines[i].split("#")[0]

# Remove extra spaces
proc remove_spaces(lines: var seq[string]) = 
    for i in 0..(lines.len() - 1) :
        var tokens: seq[string] = lines[i].split(" ")
        tokens.keepIf(x => (x != ""))
        lines[i] = tokens.join(" ")

proc is_jump_label(line: string): bool =
    if (not (':' in line)) :
        return false

    # echo line.split(':')
    if (line.split(':')[1] != "") :
        return false
    
    if (' ' in line.split(':')[0]) :
        return false
    # echo line

    return true

# List jump labels
proc get_jump_lines(lines: seq[string]): (Table[string, int], bool) =
    var labels: Table[string, int] = initTable[string, int]()
    var label: string
    for i in 0..(lines.len() - 1) :
        if (is_jump_label(lines[i])) :
            label = lines[i][0..^2]
            if (labels.hasKey(label)) :
                echo fmt"Label {label} duplicado."
                return (labels, false)
            labels[label] = i
    return (labels, true) 

# Extrai apenas a seção .text do codigo
func get_text_region(lines: seq[string]): seq[string] =
    var text: seq[string]
    var in_text_section: bool = false
    for line in lines :
        if (in_text_section) :
            if (line == ".data") :
                return text
            text.add(line)
        else :
            if (line == ".text") :
                in_text_section = true
    return text

# Extrai apenas a seção .text do codigo
func get_data_region(lines: seq[string]): seq[string] =
    var data: seq[string]
    var in_data_section: bool = false
    for line in lines :
        if (in_data_section) :
            if (line == ".text") :
                return data
            data.add(line)
        else :
            if (line == ".data") :
                in_data_section = true
    return data

# Detecta instruções não existentes da seção de texto
proc illigal_instruction(lines: seq[string]): seq[string] =
    var errors: seq[string]
    var tokens: seq[string]

    for i in 0..(lines.len() - 1) :
        if (not (isEmptyOrWhitespace(lines[i]))) :
            if (not (':' in lines[i])) :
                tokens = lines[i].split(" ")
                if (not (tokens[0] in INSTRUCTIONS)) :
                    errors.add(fmt"Erro na linha: {i}. Instrução: {tokens[0]} não é valida.")
    return errors
            
# Verifica a sitnaxe
proc check_sintaxe(lines: seq[string]) =
    var tokens: seq[string]
    for i in 0..(lines.len() - 1) :
        tokens = lines[i].split(" ")
        if (not (isEmptyOrWhitespace(lines[i]))) :
            # echo tokens
            if (not (sintaxes.check_sintaxe(tokens))) :
                # echo "Erro na linha: ", i, ": ", lines[i]
                echo ""

# Carrega o programa e sanetiza 
proc load_program*(file_path: string): bool =
    if not fileExists(file_path) :
        echo "file: ", file_path, "not found"
        return false

    var raw_file: string = readFile(file_path)
    var lines: seq[string] = raw_file.split("\n")

    remove_comments(lines)
    remove_spaces(lines)

    if (lines[0] != ".text") :
        echo "A sessão .text precisa estar no começo do arquivo"
        return false

    let illigal: seq[string] = illigal_instruction(lines)
    if (illigal.len() != 0) :
        for i in illigal :
            echo i
        return
    
    # var (labels, ok) = get_jump_lines(lines)
    # if (not ok) :
    #     return false

    check_sintaxe(lines)

    remove_empty_lines(lines)

    # for i in labels.keys :
    #     echo "Label: ", i, " is in line ", labels[i]


    # for line in lines :
    #     echo line

    return true