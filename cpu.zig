const std = @import("std");
const Memory = @import("memory.zig").Memory;

pub const Flags = packed struct(u8) {
    zerobits: u4 = 0x00,
    c: u1,
    h: u1,
    n: u1,
    z: u1,

    pub fn format(self: @This(), writer: anytype) !void {
        try writer.print("Flags:\n", .{});
        try writer.print("Z: 0x{X}", .{self.z});
        try writer.print(" N: 0x{X}", .{self.n});
        try writer.print(" H: 0x{X}", .{self.h});
        try writer.print(" C: 0x{X}\n", .{self.c});
        try writer.print("Bits 3-0: 0x{X:0<4}\n", .{self.zerobits});
    }
};

const AF = packed union { pair: u16, bytes: packed struct(u16) {
    f: Flags,
    a: u8,
} };

const BC = packed union { pair: u16, bytes: packed struct(u16) { c: u8, b: u8 } };

const DE = packed union { pair: u16, bytes: packed struct(u16) { e: u8, d: u8 } };

const HL = packed union { pair: u16, bytes: packed struct(u16) { l: u8, h: u8 } };

pub const Registers = packed struct(u96) {
    af: AF,
    bc: BC,
    de: DE,
    hl: HL,
    pc: u16,
    sp: u16,

    pub fn init() Registers {
        return Registers{
            .af = .{ .pair = 0x01B0 },
            .bc = .{ .pair = 0x0013 },
            .de = .{ .pair = 0x00D8 },
            .hl = .{ .pair = 0x014D },
            .pc = 0x0100,
            .sp = 0xFFFE,
        };
    }

    pub fn format(
        self: @This(),
        writer: anytype,
    ) !void {
        try writer.print("Registers\n", .{});
        try writer.print("AF pair:  0x{X:0>4}\n", .{self.af.pair});
        try writer.print("BC pair:  0x{X:0>4}\n", .{self.bc.pair});
        try writer.print("DE pair:  0x{X:0>4}\n", .{self.de.pair});
        try writer.print("HL pair:  0x{X:0>4}\n", .{self.hl.pair});
        try writer.print("PC:       0x{X:0>4}\n", .{self.pc});
        try writer.print("SP:       0x{X:0>4}\n", .{self.sp});
        try writer.print("{f}\n", .{self.af.bytes.f});
    }
};

pub const Cpu = struct {
    registers: Registers,
    memory: Memory,

    pub fn init() Cpu {
        return Cpu{
            .registers = Registers.init(),
            .memory = Memory.init(),
        };
    }
};
