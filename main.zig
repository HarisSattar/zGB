const std = @import("std");
const GameBoy = @import("gameboy.zig").GameBoy;
const Cpu = @import("cpu/cpu.zig").Cpu;
const Memory = @import("memory.zig").Memory;

pub fn main() !void {
    var gameBoy: GameBoy = .{};

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    std.debug.print("{f}\n", .{gameBoy.cpu.registers});

    try gameBoy.load(allocator, "mem_timing.gb");
    // try gameBoy.load(allocator, "tetris.gb");

    std.debug.print("Cartridge Details:\n{f}\n", .{gameBoy.memory.cartridge});

    runUntilSerialTestDone(&gameBoy);
    gameBoy.memory.flushSerialBuffer();

    if (gameBoy.memory.isSerialTestDone()) {
        if (gameBoy.memory.didSerialTestPass()) {
            std.debug.print("\nTest result: PASS\n", .{});
        } else {
            std.debug.print("\nTest result: FAIL\n", .{});
        }
    } else {
        std.debug.print("\nTest result: INCOMPLETE (step limit reached)\n", .{});
    }

    try gameBoy.deinit(allocator);
}

pub fn runUntilSerialTestDone(gameBoy: *GameBoy) void {
    var i: usize = 0;

    while (true) : (i += 1) {
        if (gameBoy.memory.isSerialTestDone()) break;
        const pc_before = gameBoy.cpu.registers.pc;
        const op: u8 = gameBoy.memory.read(pc_before);
        // // print PC and opcode in hex
        // std.debug.print("PC=0x{X:0>4}: OPC=0x{X:0>2}\n", .{ pc_before, op });
        // Optional safety stop on HALT if ROM enters a halt loop.
        if (op == 0x76 and gameBoy.memory.isSerialTestDone()) break;
        gameBoy.cpu.step(&gameBoy.memory);
    }
}
