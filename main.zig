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

    try gameBoy.load(allocator, "cpu_instrs.gb");
    // try gameBoy.load(allocator, "tetris.gb");

    std.debug.print("Cartridge Details:\n{f}\n", .{gameBoy.memory.cartridge});

    gameBoy.cpu.step(&gameBoy.memory);

    dumpOpcodesDebug(&gameBoy, 100);

    try gameBoy.deinit(allocator);
}

pub fn dumpOpcodesDebug(gameBoy: *GameBoy, count: usize) void {
    var i: usize = 0;
    while (i < count) : (i += 1) {
        const pc_before = gameBoy.cpu.registers.pc;
        const op: u8 = gameBoy.memory.read(pc_before); // ensure this memory read exists
        // // print PC and opcode in hex
        // std.debug.print("PC=0x{X:0>4}: OPC=0x{X:0>2}\n", .{ pc_before, op });
        // cpu.registers.pc = pc_before +% 1; // wrapping increment
        // // optional stop condition:
        if (op == 0x76) break; // HALT opcode if you want to stop on halt
        gameBoy.cpu.step(&gameBoy.memory);
    }
}
