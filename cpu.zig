const std = @import("std");

pub const Flags = packed struct(u8) {
    zerobits: u4 = 0x00,
    c: u1,
    h: u1,
    n: u1,
    z: u1,
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
};
