import strutils
import rom
import ram

type REGS = string

type CPU* = object
    zero*:  int16
    t0*:    int16
    t1*:    int16
    t2*:    int16
    t3*:    int16
    t4*:    int16
    t5*:    int16
    rt*:    int16
    gp*:    int16
    sp*:    int16
    fp*:    int16
    sc*:    int16
    ra*:    int16
    pc*:    int16
    ir*:    string
    rom*:   ROM
    ram*:   RAM

proc newCPU*(program: seq[seq[string]]): CPU =
    result.ram = newRam()
    result.rom = newRom()
    var gp: int = result.rom.loadProgram(program)
    result.gp = int16(gp)
    result.pc = 0
    return result

proc setRegister(self: var CPU, dest: REGS, value: int16) = 
    case dest
    of "$t0":
        self.t0 = value 
    of "$t1":
        self.t1 = value 
    of "$t2":
        self.t2 = value 
    of "$t3":
        self.t3 = value 
    of "$t4":
        self.t4 = value 
    of "$t5":
        self.t5 = value 
    of "$pc":
        self.pc = value 
    of "$zero":
        self.zero = 0
    of "$sp":
        self.sp = value 
    of "$fp":
        self.fp = value
    of "$sc":
        self.sc = value
    of "$ra":
        self.ra = value
    of "$rt":
        self.rt = value

proc getRegister(self: var CPU, dest: REGS): int16 = 
    case dest
    of "$t0":
        return self.t0
    of "$t1":
        return self.t1 
    of "$t2":
        return self.t2 
    of "$t3":
        return self.t3 
    of "$t4":
        return self.t4 
    of "$t5":
        return self.t5 
    of "$pc":
        return self.pc 
    of "$zero":
        return 0
    of "$sp":
        return self.sp 
    of "$fp":
        return self.fp 
    of "$sc":
        return self.sc 
    of "$ra":
        return self.ra
    of "$rt":
        return self.rt

proc add(self: var CPU, dest: REGS, src1: REGS, src2: REGS) =
    let v1: int16 = self.getRegister(src1)
    let v2: int16 = self.getRegister(src2)
    self.setRegister(dest, v1 + v2)

proc sub(self: var CPU, dest: REGS, src1: REGS, src2: REGS) =
    let v1: int16 = self.getRegister(src1)
    let v2: int16 = self.getRegister(src2)
    self.setRegister(dest, v1 - v2)

proc mult(self: var CPU, dest: REGS, src1: REGS, src2: REGS) =
    let v1: int16 = self.getRegister(src1)
    let v2: int16 = self.getRegister(src2)
    self.setRegister(dest, v1 * v2)

proc kdiv(self: var CPU, dest: REGS, src1: REGS, src2: REGS) =
    let v1: int16 = self.getRegister(src1)
    let v2: int16 = self.getRegister(src2)
    # echo v1
    # echo v2
    self.setRegister(dest, v1 div v2)

proc kand(self: var CPU, dest: REGS, src1: REGS, src2: REGS) =
    let v1: int16 = self.getRegister(src1)
    let v2: int16 = self.getRegister(src2)
    self.setRegister(dest, v1 and v2)

proc kor(self: var CPU, dest: REGS, src1: REGS, src2: REGS) =
    let v1: int16 = self.getRegister(src1)
    let v2: int16 = self.getRegister(src2)
    self.setRegister(dest, v1 or v2)

proc addi(self: var CPU, dest: REGS, src1: REGS, value: int16) =
    let v1: int16 = self.getRegister(src1)
    self.setRegister(dest, v1 + value)

proc subi(self: var CPU, dest: REGS, src1: REGS, value: int16) =
    let v1: int16 = self.getRegister(src1)
    self.setRegister(dest, v1 - value)

proc multi(self: var CPU, dest: REGS, src1: REGS, value: int16) =
    let v1: int16 = self.getRegister(src1)
    self.setRegister(dest, v1 * value)

proc divi(self: var CPU, dest: REGS, src1: REGS, value: int16) =
    let v1: int16 = self.getRegister(src1)
    self.setRegister(dest, v1 div value)

proc andi(self: var CPU, dest: REGS, src1: REGS, value: int16) =
    let v1: int16 = self.getRegister(src1)
    self.setRegister(dest, v1 and value)

proc ori(self: var CPU, dest: REGS, src1: REGS, value: int16) =
    let v1: int16 = self.getRegister(src1)
    self.setRegister(dest, v1 or value)

proc sll(self: var CPU, dest: REGS, src1: REGS, value: int16) =
    let v1: int16 = self.getRegister(src1)
    self.setRegister(dest, v1 shl value)

proc srl(self: var CPU, dest: REGS, src1: REGS, value: int16) =
    let v1: int16 = self.getRegister(src1)
    self.setRegister(dest, v1 shr value)

proc move(self: var CPU, dest: REGS, src: REGS) =
    let v1: int16 = self.getRegister(src)
    self.setRegister(dest, v1)

proc li(self: var CPU, dest: REGS, value: int16) =
    self.setRegister(dest, value)

proc la(self: var CPU, dest: REGS, value: int16) =
    self.setRegister(dest, value)

proc lrw(self: var CPU, dest: REGS, offset: int16, point: int16) =
    let half_1: int16 = int16(parseInt(self.rom.get(self.gp + point + offset)))
    let half_2: int16 = int16(parseInt(self.rom.get(self.gp + point + offset + 1)))
    let value: int16 = half_1 or half_2
    self.setRegister(dest, value)

proc lrb(self: var CPU, dest: REGS, offset: int16, point: int16) =
    let y = self.rom.get(self.gp + point + offset)
    let x = int16(parseInt(y))
    let value: int16 = x
    self.setRegister(dest, value)

proc lw(self: var CPU, dest: REGS, offset: int16, point: int16) =
    let half_1: int8 = (self.ram.get(point + offset))
    let half_2: int8 = (self.ram.get(point + offset + 1))
    var value: int16 = half_1
    value = value shl 8
    value = value or half2
    self.setRegister(dest, value)

proc lb(self: var CPU, dest: REGS, offset: int16, point: int16) =
    let value: int8 = self.ram.get(point + offset)
    self.setRegister(dest, value)

proc sw(self: var CPU, src: REGS, offset: int16, point: int16) =
    let value: int16 = self.getRegister(src)
    let half_1: int8 = cast[int8](value and 0x00FF)
    self.ram.set(half_1, offset + point)

    let half_2: int8 = cast[int8](value and 0xFF00)
    self.ram.set(half_2, offset + point + 1)

proc sb(self: var CPU, src: REGS, offset: int16, point: int16) =
    let x = self.getRegister(src)
    let value: int8 = cast[int8](x and 0x00FF)
    self.ram.set(value, offset + point)

proc syscall(self: var CPU): int =
    # exit
    if self.sc == 0 :
        return -1

    # printInt t0 
    elif self.sc == 1 :
        stdout.write(self.t0)

    # printChar t0
    elif self.sc == 2 :
        stdout.write(char(self.t0))
        # echo char(self.t0)
        # echo self.t0
    
    return 1

proc jump(self: var CPU, point: int16) = 
    self.pc = point

proc jr(self: var CPU, src: REGS) = 
    self.pc = self.getRegister(src)

proc jal(self: var CPU, point: int16) = 
    self.ra = self.pc
    self.pc = point

proc ret(self: var CPU) =
    self.pc = self.ra 

proc beq(self: var CPU, src1: REGS, src2: REGS, point: int16) =
    let v1: int16 = self.getRegister(src1)
    let v2: int16 = self.getRegister(src2)
    if v1 == v2 :
        self.pc = point

proc bne(self: var CPU, src1: REGS, src2: REGS, point: int16) =
    let v1: int16 = self.getRegister(src1)
    let v2: int16 = self.getRegister(src2)
    if v1 != v2 :
        self.pc = point

proc bgt(self: var CPU, src1: REGS, src2: REGS, point: int16) =
    let v1: int16 = self.getRegister(src1)
    let v2: int16 = self.getRegister(src2)
    if v1 > v2 :
        self.pc = point

proc bge(self: var CPU, src1: REGS, src2: REGS, point: int16) =
    let v1: int16 = self.getRegister(src1)
    let v2: int16 = self.getRegister(src2)
    if v1 >= v2 :
        self.pc = point

proc blt(self: var CPU, src1: REGS, src2: REGS, point: int16) =
    let v1: int16 = self.getRegister(src1)
    let v2: int16 = self.getRegister(src2)
    if v1 < v2 :
        self.pc = point

proc ble(self: var CPU, src1: REGS, src2: REGS, point: int16) =
    let v1: int16 = self.getRegister(src1)
    let v2: int16 = self.getRegister(src2)
    if v1 <= v2 :
        self.pc = point

proc slt(self: var CPU, dest: REGS, src1: REGS, src2: REGS) =
    let v1: int16 = self.getRegister(src1)
    let v2: int16 = self.getRegister(src2)
    if (v1 < v2) :
        self.setRegister(dest, 1)
    else :
        self.setRegister(dest, 0)

proc slti(self: var CPU, dest: REGS, src1: REGS, value: int16) =
    let v1: int16 = self.getRegister(src1)
    if (v1 < value) :
        self.setRegister(dest, 1)
    else :
        self.setRegister(dest, 0)

proc kinc(self: var CPU, dest: REGS) =
    self.setRegister(dest, self.getRegister(dest) + 1)

proc kdec(self: var CPU, dest: REGS) =
    self.setRegister(dest, self.getRegister(dest) - 1)

proc getNextInstruction*(self: var CPU): int =
    if (self.pc == self.gp) :
        return 1

    let first_half: string = self.rom.get(self.pc)
    let second_half: string = self.rom.get(self.pc + 1)
    if (first_half in ["sys", "ret"]) :
        self.ir = [first_half, second_half].join("")
    else :
        self.ir = [first_half, second_half].join(" ")

    self.pc += 2
    return 0

proc execCurrentInstruction*(self: var CPU): int =
    let tokens: seq[string] = self.ir.split(" ")
    case tokens[0]
    of "add" :
        self.add(tokens[1], tokens[2], tokens[3])
    of "sub" :
        self.sub(tokens[1], tokens[2], tokens[3])
    of "mult" :
        self.mult(tokens[1], tokens[2], tokens[3])
    of "div" :
        self.kdiv(tokens[1], tokens[2], tokens[3])
    of "addi" :
        self.addi(tokens[1], tokens[2], int16(parseint(tokens[3])))
    of "subi" :
        self.subi(tokens[1], tokens[2], int16(parseint(tokens[3])))
    of "multi" :
        self.multi(tokens[1], tokens[2], int16(parseint(tokens[3])))
    of "divi" :
        self.divi(tokens[1], tokens[2], int16(parseint(tokens[3])))
    of "move" :
        self.move(tokens[1], tokens[2])
    of "li" :
        self.li(tokens[1], int16(parseint(tokens[2])))
    of "la" :
        self.la(tokens[1], int16(parseint(tokens[2])))
    of "j" :
        self.jump(int16(parseint(tokens[1])))
    of "jal" :
        self.jal(int16(parseint(tokens[1])))
    of "jr" :
        self.jr(tokens[1])
    of "return" :
        self.ret()
    of "beq" :
        self.beq(tokens[1], tokens[2], int16(parseint(tokens[3])))
    of "bne" :
        self.bne(tokens[1], tokens[2], int16(parseint(tokens[3])))
    of "bgt" :
        self.bgt(tokens[1], tokens[2], int16(parseint(tokens[3])))
    of "bge" :
        self.bge(tokens[1], tokens[2], int16(parseint(tokens[3])))
    of "blt" :
        self.blt(tokens[1], tokens[2], int16(parseint(tokens[3])))
    of "ble" :
        self.ble(tokens[1], tokens[2], int16(parseint(tokens[3])))
    of "slt" :
        self.slt(tokens[1], tokens[2], tokens[3])
    of "slti" :
        self.slti(tokens[1], tokens[2], int16(parseint(tokens[3])))
    of "inc" :
        self.kinc(tokens[1])
    of "dec" :
        self.kdec(tokens[1])
    of "sll" :
        self.sll(tokens[1], tokens[2], int16(parseint(tokens[3])))
    of "srl" :
        self.srl(tokens[1], tokens[2], int16(parseint(tokens[3])))
    of "lrb" :
        if (tokens[3][0] == '$') :
            self.lrb(tokens[1], int16(parseint(tokens[2])), self.getRegister(tokens[3]))
        else :
            self.lrb(tokens[1], int16(parseint(tokens[2])), int16(parseint(tokens[3])))
    of "lrw" :
        if (tokens[3][0] == '$') :
            self.lrw(tokens[1], int16(parseint(tokens[2])), self.getRegister(tokens[3]))
        else :
            self.lrw(tokens[1], int16(parseint(tokens[2])), int16(parseint(tokens[3])))
    of "lw" :
        if (tokens[3][0] == '$') :
            self.lw(tokens[1], int16(parseint(tokens[2])), self.getRegister(tokens[3]))
        else :
            self.lw(tokens[1], int16(parseint(tokens[2])), int16(parseint(tokens[3])))
    of "lb" :
        if (tokens[3][0] == '$') :
            self.lb(tokens[1], int16(parseint(tokens[2])), self.getRegister(tokens[3]))
        else :
            self.lb(tokens[1], int16(parseint(tokens[2])), int16(parseint(tokens[3])))
    of "sw" :
        if (tokens[3][0] == '$') :
            self.sw(tokens[1], int16(parseint(tokens[2])), self.getRegister(tokens[3]))
        else :
            self.sw(tokens[1], int16(parseint(tokens[2])), int16(parseint(tokens[3])))
    of "sb" :
        if (tokens[3][0] == '$') :
            self.sb(tokens[1], int16(parseint(tokens[2])), self.getRegister(tokens[3]))
        else :
            self.sb(tokens[1], int16(parseint(tokens[2])), int16(parseint(tokens[3])))
    of "syscall" :
        return self.syscall()
    else :
        # echo tokens
        return -2  

    return 0