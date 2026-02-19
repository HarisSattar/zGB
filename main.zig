const std = @import("std");
const Registers = @import("cpu.zig").Registers;

pub fn main() void {
    const registers = Registers.init();

    std.debug.print("{f}\n", .{registers});
}
