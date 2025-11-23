from assembler/assembler import read_program
import rom
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
            # cpu.rom.showData()
            var result: int
            while true :
                if cpu.getNextInstruction() == 1 :
                    echo "Leitura invalida de seção de data ao buscar instrução"
                    break

                result = cpu.execCurrentInstruction()
                if result == -1 :
                    break
                elif result == -2 :
                    echo "invalid instruciton"

        
