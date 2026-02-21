const std = @import("std");
const GameBoy = @import("gameboy.zig").GameBoy;

pub fn main() !void {
    var gameBoy: GameBoy = .{};

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    std.debug.print("{f}\n", .{gameBoy.cpu.registers});

    try gameBoy.load(allocator, "tetris.gb");
    std.debug.print("Cartridge Details:\n{f}\n", .{gameBoy.memory.cartridge});

    gameBoy.cpu.step(&gameBoy.memory);

    try gameBoy.deinit(allocator);
}
