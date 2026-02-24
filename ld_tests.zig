const std = @import("std");
const testing = std.testing;
const Cpu = @import("cpu/cpu.zig").Cpu;
const Memory = @import("memory.zig").Memory;

test "LD r,n immediate loads" {
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

    // Program: LD B,0x12; LD C,0x34; LD D,0x56; LD E,0x78; LD H,0x9A; LD L,0xBC; LD A,0x7F
    buf[0] = 0x06;
    buf[1] = 0x12; // LD B,n
    buf[2] = 0x0E;
    buf[3] = 0x34; // LD C,n
    buf[4] = 0x16;
    buf[5] = 0x56; // LD D,n
    buf[6] = 0x1E;
    buf[7] = 0x78; // LD E,n
    buf[8] = 0x26;
    buf[9] = 0x9A; // LD H,n
    buf[10] = 0x2E;
    buf[11] = 0xBC; // LD L,n
    buf[12] = 0x3E;
    buf[13] = 0x7F; // LD A,n

    memory.cartridge.rom = buf;

    var cpu = Cpu{};
    cpu.registers.pc = 0;

    cpu.step(&memory); // LD B,n
    try testing.expectEqual(cpu.registers.bc.bytes.b, @as(u8, 0x12));
    try testing.expectEqual(cpu.registers.pc, @as(u16, 2));

    cpu.step(&memory); // LD C,n
    try testing.expectEqual(cpu.registers.bc.bytes.c, @as(u8, 0x34));
    try testing.expectEqual(cpu.registers.pc, @as(u16, 4));

    cpu.step(&memory); // LD D,n
    try testing.expectEqual(cpu.registers.de.bytes.d, @as(u8, 0x56));
    try testing.expectEqual(cpu.registers.pc, @as(u16, 6));

    cpu.step(&memory); // LD E,n
    try testing.expectEqual(cpu.registers.de.bytes.e, @as(u8, 0x78));
    try testing.expectEqual(cpu.registers.pc, @as(u16, 8));

    cpu.step(&memory); // LD H,n
    try testing.expectEqual(cpu.registers.hl.bytes.h, @as(u8, 0x9A));
    try testing.expectEqual(cpu.registers.pc, @as(u16, 10));

    cpu.step(&memory); // LD L,n
    try testing.expectEqual(cpu.registers.hl.bytes.l, @as(u8, 0xBC));
    try testing.expectEqual(cpu.registers.pc, @as(u16, 12));

    cpu.step(&memory); // LD A,n
    try testing.expectEqual(cpu.registers.af.bytes.a, @as(u8, 0x7F));
    try testing.expectEqual(cpu.registers.pc, @as(u16, 14));

    allocator.free(buf);
}

test "LD memory opcodes (HL/BC/DE)" {
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

    // Sequence: LD (HL),n; LD A,(HL); LD (BC),A; LD A,(BC); LD (DE),A; LD A,(DE)
    buf[0] = 0x36;
    buf[1] = 0x55; // LD (HL),n -> writes 0x55 to [HL]
    buf[2] = 0x7E; // LD A,(HL)
    buf[3] = 0x02; // LD (BC),A
    buf[4] = 0x0A; // LD A,(BC)
    buf[5] = 0x12; // LD (DE),A
    buf[6] = 0x1A; // LD A,(DE)

    memory.cartridge.rom = buf;

    var cpu = Cpu{};
    cpu.registers.pc = 0;

    // Set HL to WRAM address
    cpu.registers.hl.pair = 0xC100;

    cpu.step(&memory); // LD (HL),n
    try testing.expectEqual(memory.read(0xC100), @as(u8, 0x55));
    try testing.expectEqual(cpu.registers.pc, @as(u16, 2));

    cpu.step(&memory); // LD A,(HL)
    try testing.expectEqual(cpu.registers.af.bytes.a, @as(u8, 0x55));
    try testing.expectEqual(cpu.registers.pc, @as(u16, 3));

    // Test LD (BC),A and LD A,(BC)
    cpu.registers.bc.pair = 0xC200;
    // A currently 0x55
    cpu.step(&memory); // LD (BC),A
    try testing.expectEqual(memory.read(0xC200), @as(u8, 0x55));
    try testing.expectEqual(cpu.registers.pc, @as(u16, 4));

    cpu.step(&memory); // LD A,(BC)
    try testing.expectEqual(cpu.registers.af.bytes.a, @as(u8, 0x55));
    try testing.expectEqual(cpu.registers.pc, @as(u16, 5));

    // Test LD (DE),A and LD A,(DE)
    cpu.registers.de.pair = 0xC300;
    // change A to new value
    cpu.registers.af.bytes.a = 0x77;
    cpu.step(&memory); // LD (DE),A
    try testing.expectEqual(memory.read(0xC300), @as(u8, 0x77));
    try testing.expectEqual(cpu.registers.pc, @as(u16, 6));

    cpu.step(&memory); // LD A,(DE)
    try testing.expectEqual(cpu.registers.af.bytes.a, @as(u8, 0x77));
    try testing.expectEqual(cpu.registers.pc, @as(u16, 7));

    allocator.free(buf);
}

test "LD r,r register copies" {
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

    // Program: LD B,C (0x41), LD C,D (0x4A), LD A,L (0x7D)
    buf[0] = 0x41; // LD B,C
    buf[1] = 0x4A; // LD C,D
    buf[2] = 0x7D; // LD A,L

    memory.cartridge.rom = buf;

    var cpu = Cpu{};
    cpu.registers.pc = 0;

    // set source registers
    cpu.registers.bc.bytes.c = 0x21;
    cpu.registers.de.bytes.d = 0x22;
    cpu.registers.hl.bytes.l = 0x33;

    cpu.step(&memory); // LD B,C
    try testing.expectEqual(cpu.registers.bc.bytes.b, @as(u8, 0x21));
    try testing.expectEqual(cpu.registers.pc, @as(u16, 1));

    cpu.step(&memory); // LD C,D
    try testing.expectEqual(cpu.registers.bc.bytes.c, @as(u8, 0x22));
    try testing.expectEqual(cpu.registers.pc, @as(u16, 2));

    cpu.step(&memory); // LD A,L
    try testing.expectEqual(cpu.registers.af.bytes.a, @as(u8, 0x33));
    try testing.expectEqual(cpu.registers.pc, @as(u16, 3));

    allocator.free(buf);
}
