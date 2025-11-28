# import strutils
# import std/tables

type RAM* = object
    data*: array[65536, int8] # 64KB
    len*: int

proc newRam*(): RAM =
    result.data = default(array[65536, int8])
    result.len = 0

proc add*(self: var RAM, value: int8) =
    self.data[self.len] = value
    self.len += 1

proc set*(self: var RAM, value: int8, index: int16) =
    self.data[index] = value

proc get*(self: RAM, index: int16): int8 =
    return self.data[index]