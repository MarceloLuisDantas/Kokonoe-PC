from assembler import load_program

import std/os

when isMainModule:
    let args: seq[string] = commandLineParams()
    if (args.len() != 1) :
        echo "No Source File"
    else :
        var loaded: bool = load_program(args[0])
