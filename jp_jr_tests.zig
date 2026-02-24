const std = @import("std");
const testing = std.testing;
const Cpu = @import("cpu/cpu.zig").Cpu;
const Memory = @import("memory.zig").Memory;
const Flags = @import("cpu/cpu.zig").Flags;

test "JP nn unconditional" {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var memory = Memory{};
    const rom_size: usize = 0x8000;
    const buf = try allocator.alloc(u8, rom_size);
    var i: usize = 0;
    while (i < buf.len) : (i += 1) {
        buf[i] = 0;
    }

    // JP 0x1234
    buf[0] = 0xC3; // JP nn
    buf[1] = 0x34;
    buf[2] = 0x12;

    memory.cartridge.rom = buf;

    var cpu = Cpu{};
    cpu.registers.pc = 0;

    cpu.step(&memory);
    try testing.expectEqual(cpu.registers.pc, @as(u16, 0x1234));

    allocator.free(buf);
}

test "JP conditional (Z/NC)" {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var memory = Memory{};
    const rom_size: usize = 0x8000;
    const buf = try allocator.alloc(u8, rom_size);
    var i: usize = 0;
    while (i < buf.len) : (i += 1) {
        buf[i] = 0;
    }

    // JP Z,0x2000 ; JP NC,0x3000
    buf[0] = 0xCA; // JP Z,nn
    buf[1] = 0x00;
    buf[2] = 0x20; // 0x2000
    buf[3] = 0xD2; // JP NC,nn
    buf[4] = 0x00;
    buf[5] = 0x30; // 0x3000

    memory.cartridge.rom = buf;

    var cpu = Cpu{};
    cpu.registers.pc = 0;

    // Case: Z flag set -> JP Z taken
    cpu.registers.af.bytes.f = Flags{ .zerobits = 0, .c = 0, .h = 0, .n = 0, .z = 1 };
    cpu.step(&memory);
    try testing.expectEqual(cpu.registers.pc, @as(u16, 0x2000));

    // Reset PC and clear C flag for NC test
    cpu.registers.pc = 3; // point at 0xD2 instruction
    cpu.registers.af.bytes.f = Flags{ .zerobits = 0, .c = 0, .h = 0, .n = 0, .z = 0 }; // clear flags (C=0)
    cpu.step(&memory);
    try testing.expectEqual(cpu.registers.pc, @as(u16, 0x3000));

    allocator.free(buf);
}

test "JR relative (unconditional and conditional)" {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var memory = Memory{};
    const rom_size: usize = 0x8000;
    const buf = try allocator.alloc(u8, rom_size);
    var i: usize = 0;
    while (i < buf.len) : (i += 1) {
        buf[i] = 0;
    }

    // JR +2 ; JR Z,+3 ; JR NZ,+4
    buf[0] = 0x18; // JR n
    buf[1] = 0x02; // +2 -> target = 0 + 2 + 2 = 4

    buf[2] = 0x28; // JR Z,n
    buf[3] = 0x03; // +3

    buf[4] = 0x20; // JR NZ,n
    buf[5] = 0x04; // +4

    memory.cartridge.rom = buf;

    var cpu = Cpu{};
    cpu.registers.pc = 0;

    cpu.step(&memory); // JR +2
    try testing.expectEqual(cpu.registers.pc, @as(u16, 4));

    // JR Z,+3 when Z=1 -> taken: starting PC is 2, target = 2 + 2 + 3 = 7
    cpu.registers.pc = 2;
    cpu.registers.af.bytes.f = Flags{ .zerobits = 0, .c = 0, .h = 0, .n = 0, .z = 1 };
    cpu.step(&memory);
    try testing.expectEqual(cpu.registers.pc, @as(u16, 7));

    // JR NZ,+4 when Z=0 -> taken: starting PC 4, target = 4 + 2 + 4 = 10
    cpu.registers.pc = 4;
    cpu.registers.af.bytes.f = Flags{ .zerobits = 0, .c = 0, .h = 0, .n = 0, .z = 0 };
    cpu.step(&memory);
    try testing.expectEqual(cpu.registers.pc, @as(u16, 10));

    allocator.free(buf);
}
