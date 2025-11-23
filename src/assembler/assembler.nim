import tokenizer
import parser
import os

proc read_program*(file_path: string): (seq[seq[string]], bool) =
    if not fileExists(file_path) :
        echo "file: ", file_path, "not found"
        return (@[], false)

    var raw_file: string = readFile(file_path)

    var tokenizer: Tokenizer = newTokenzier(raw_file)
    let (tokens, ok1) = tokenizer.tokenize()
    if (not ok1) :
        return (@[], false)

    var parser: Parser = newParser(tokens)
    let (instructions, correct) = parser.parse()
    if not correct :
        return (@[], false)

    # for instruction in instructions :
    #     echo instruction

    return (instructions, true)