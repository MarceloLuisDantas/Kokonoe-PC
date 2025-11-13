# import strutils

# const INSTRUCTIONS* = [
#     "add", "addi", "sub", "subi", "mult", "multi", "div", "divi", "move",
#     "or", "ori", "and", "andi", "sll", "srl", "slt", "slti", "li", "syscall",
#     "j", "jr", "jal", "beq", "bne", "bgt", "bge", "blt", "ble", "return",
#     "lw", "lb", "sw", "sb", "lv", "sv", "lrw", "lrb", "pop", "push", 
#     ".text", ".data"
# ]

# const DATA_TYPE* = [
#     ".string", ".int8", ".int16"
# ]

# const REGISTERS* = [
#     "$zero", "$t0", "$t1", "$t2", "$t3", "$t4", "$t5", 
#     "$rt", "$gp", "$sp", "$fp", "$sc", "$ra"
# ]

# # add, sub, mult, div, or, and, slt
# func check_3_registers*(line: seq[string]): bool =
#     if (line.len() != 4) :
#         return false

#     if ((not (line[1] in REGISTERS)) or 
#         (not (line[2] in REGISTERS)) or
#         (not (line[3] in REGISTERS))) :
#         return false

#     return true
    
# # addi, subi, multi, divi, ori, andi, sll, srl, slti
# proc check_immediate*(line: seq[string]): bool =
#     if (line.len() != 4) :
#         return false

#     if ((not (line[1] in REGISTERS)) or 
#         (not (line[2] in REGISTERS))) :
#         return false

#     try :
#         discard parseInt(line[3])
#         return true
#     except :
#         return false

# # beq, bne, bgt, bge, blt, ble
# proc check_branch*(line: seq[string]): bool =
#     if (line.len() != 4) :
#         return false
    
#     if ((not (line[1] in REGISTERS)) or 
#         (not (line[2] in REGISTERS))) :
#         return false

#     try :
#         discard parseInt(line[2])
#         return false
#     except :
#         return true

# # li
# func check_li*(line: seq[string]): bool =
#     if (line.len() != 3) :
#         return false

#     if (not (line[1] in REGISTERS)) :
#         return false

#     try :
#         discard parseInt(line[2])
#         return true
#     except :
#         return false

# # move
# func check_move*(line: seq[string]): bool =
#     if (line.len() != 3) :
#         return false

#     if ((not (line[1] in REGISTERS)) or 
#         (not (line[2] in REGISTERS))) :
#         return false
 
#     return true
   
# # TODO =====================================================
# # lw, lb, sw, sb, lv, sv, lrw, lrb
# func check_data_transfer*(line: seq[string]): bool = 
#     # lw $r1 x  ($r2)
#     if (line.len() != 3) :
#         return false

#     if (not (line[1] in REGISTERS)) :
#         return false

#     return
# # TODO =====================================================

# # push, pop
# proc check_push_pop*(line: seq[string]): bool =
#     if (line.len() != 2) :
#         return false

#     # echo line
#     if (not (line[1] in REGISTERS)) :
#         return false

#     return true

# #jump, jal
# func check_jump_jal*(line: seq[string]): bool =
#     if (line.len() != 2) :
#         return false

#     try :
#         discard parseInt(line[2])
#         return false
#     except :
#         return true

# func check_jr*(line: seq[string]): bool =
#     if (line.len() != 2) :
#         return false

#     if (not (line[1] in REGISTERS)) :
#         return false

#     return true

# func check_ret_sys*(line: seq[string]): bool =
#     return (line.len() == 1)

# # .text, .data
# proc check_section(line: seq[string]): bool =
#     if (line.len() != 1) :
#         return false
#     return true

# proc is_jump_label(line: seq[string]): bool =
#     if (line.len() != 1) :
#         return false
#     return true

# proc is_value_label(line: seq[string]): bool =
#     if (line.len() < 3) :
#         return false

#     if (not (line[1] in DATA_TYPE)) :
#         return false

#     var full_line = line.join(" ")
#     if (line[1] == ".string") :
#         var start_str = false
        
#         for i in 0..(full_line.len() - 1) :
#             if ()

#         # Caso o valor for um valor unico


#         # Caso o valor for uma lista de valore
        
#     else : # .int8 ou .int16
#         try :
#             discard parseInt(line[3])
#             return true
#         except :
#             return false

#     return true


# proc check_sintaxe*(line: seq[string]): bool = 
#     if (line[0] in ["add", "sub", "mult", "div", "or", "and", "slt"]) :
#         return check_3_registers(line)
#     elif (line[0] in ["addi", "subi", "multi", "divi", "ori", "andi", "sll", "srl", "slti"]) :
#         return check_immediate(line)
#     elif (line[0] in ["beq", "bne", "bgt", "bge", "blt", "ble"]) :
#         return check_branch(line)
#     elif (line[0] == "li") :
#         return check_li(line)
#     elif (line[0] == "move") :
#         return check_move(line)
#     elif (line[0] in ["push", "pop"]) :
#         return check_push_pop(line)
#     elif (line[0] in ["j", "jal"]) :
#         return check_jump_jal(line)
#     elif (line[0] == "jr") :
#         return check_jr(line)
#     elif (line[0] in ["return", "syscall"]) :
#         return check_ret_sys(line)
#     elif (line[0] in [".text", ".data"]) :
#         return check_section(line)
#     elif (is_jump_label(line)) :
#         return true
#     elif (is_value_label(line)) :
#         return true

#     return false