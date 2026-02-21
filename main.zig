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

    const opcode = gameBoy.cpu.fetch(&gameBoy.memory);
    std.debug.print("Opcode: 0x{X:0<2}", .{opcode});

    try gameBoy.deinit(allocator);
}
