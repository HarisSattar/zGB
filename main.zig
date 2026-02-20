const std = @import("std");
const Cpu = @import("cpu.zig").Cpu;

pub fn main() void {
    const cpu: Cpu = .{};

    std.debug.print("{f}", .{cpu.registers});
}
