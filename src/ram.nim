import strutils
import std/tables

type RAM* = object
    data*: array[65536, string] # 64KB
    len*: int

proc newRam*(): RAM =
    result.data = default(array[65536, string])
    result.len = 0

proc add*(self: var ROM, instruction: string) =
    self.data[self.len] = instruction
    self.len += 1

proc get*(self: ROM, index: int16): string =
    return self.data[index]