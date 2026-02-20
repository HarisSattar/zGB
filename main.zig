const std = @import("std");
const GameBoy = @import("gameboy.zig").GameBoy;

pub fn main() !void {
    var gameBoy: GameBoy = .{};

    std.debug.print("{f}\n", .{gameBoy.cpu.registers});

    try gameBoy.memory.cartridge.load("tetris.gb");
}
