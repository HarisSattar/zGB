const std = @import("std");
const Registers = @import("cpu.zig").Registers;

pub fn main() void {
    std.debug.print("Hello {s}\n", .{"World"});

    const registers = Registers.init();

    std.debug.print("AF pair: 0xx{X:0>4}", .{registers.af.pair});
}
