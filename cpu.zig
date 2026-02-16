const std = @import("std");

pub const Flags = packed struct(u8) {
    zerobits: u4 = 0,
    c: u1 = 0,
    h: u1 = 0,
    n: u1 = 0,
    z: u1 = 0,
};

const AF = packed union { pair: u16, bytes: packed struct(u16) {
    f: Flags,
    a: u8,
} };

const BC = packed union { pair: u16, bytes: packed struct(u16) { c: u8, b: u8 } };

const DE = packed union { pair: u16, bytes: packed struct(u16) { e: u8, d: u8 } };

const HL = packed union { pair: u16, bytes: packed struct(u16) { l: u8, h: u8 } };

pub const Registers = packed struct(u96) { af: AF, bc: BC, de: DE, hl: HL, sp: u16, pc: u16 };
