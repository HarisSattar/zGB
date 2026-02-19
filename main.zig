const std = @import("std");
const Cpu = @import("cpu.zig").Cpu;

pub fn main() void {
    const cpu = Cpu.init();

    std.debug.print("{f}\n", .{cpu.registers});
}
