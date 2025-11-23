from assembler/assembler import read_program
import cpu
import std/os

when isMainModule:
    let args: seq[string] = commandLineParams()
    if (args.len() != 1) :
        echo "No Source File"
    else :
        var program: seq[seq[string]]
        var ok: bool
        (program, ok) = read_program(args[0])
        if not ok :
            echo "ERROR"

        else :
            var cpu: CPU = newCpu(program)

            while true :
                cpu.getNextInstruction()
                if cpu.execCurrentInstruction() == -1 :
                    break

        
