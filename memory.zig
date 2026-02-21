const std = @import("std");

const Cartridge = @import("cartridge.zig").Cartridge;

const MEMORY_SIZE = 0x10000;

pub const MemoryMap = struct {
    pub const ROM0: AddressRange = .{ .start = 0x0000, .end = 0x3FFF };
    pub const ROM1_BANKED: AddressRange = .{ .start = 0x4000, .end = 0x7FFF };
    pub const VRAM: AddressRange = .{ .start = 0x8000, .end = 0x9FFF };
    pub const SRAM: AddressRange = .{ .start = 0xA000, .end = 0xBFFF };
    pub const WRAM0: AddressRange = .{ .start = 0xC000, .end = 0xCFFF };
    pub const WRAM1: AddressRange = .{ .start = 0xD000, .end = 0xDFFF };
    pub const ECHO_RAM: AddressRange = .{ .start = 0xE000, .end = 0xFDFF };
    pub const OAM: AddressRange = .{ .start = 0xFE00, .end = 0xFE9F };
    pub const IO: AddressRange = .{ .start = 0xFF00, .end = 0xFF7F };
    pub const HRAM: AddressRange = .{ .start = 0xFF80, .end = 0xFFFE };
    pub const IE: u16 = 0xFFFF;
};

pub const AddressRange = struct {
    start: u16,
    end: u16,
};

pub const Memory = struct {
    vram: [0x2000]u8 = .{0} ** 0x2000,
    wram: [0x2000]u8 = .{0} ** 0x2000,
    hram: [0x007F]u8 = .{0} ** 0x007F,
    cartridge: Cartridge = .{},
    boot_rom_enabled: bool = true,

    pub fn read(self: *Memory, address: u16) u8 {
        return switch (address) {
            MemoryMap.ROM0.start...MemoryMap.ROM0.end => self.cartridge.read(address),
            MemoryMap.ROM1_BANKED.start...MemoryMap.ROM1_BANKED.end => self.cartridge.read(address),
            MemoryMap.VRAM.start...MemoryMap.VRAM.end => self.readVram(address),
            MemoryMap.SRAM.start...MemoryMap.SRAM.end => 0x00,
            MemoryMap.WRAM0.start...MemoryMap.WRAM0.end => self.readWram(address),
            MemoryMap.WRAM1.start...MemoryMap.WRAM1.end => self.readWram(address),
            MemoryMap.ECHO_RAM.start...MemoryMap.ECHO_RAM.end => self.readWram(address - 0x2000),
            MemoryMap.OAM.start...MemoryMap.OAM.end => 0x00,
            MemoryMap.IO.start...MemoryMap.IO.end => 0x00,
            MemoryMap.HRAM.start...MemoryMap.HRAM.end => self.readHram(address),
            MemoryMap.IE => 0x00,
            else => 0x00,
        };
    }

    pub fn write(self: *Memory, address: u16, value: u8) void {
        switch (address) {
            MemoryMap.ROM0.start...MemoryMap.ROM0.end => return,
            MemoryMap.ROM1_BANKED.start...MemoryMap.ROM1_BANKED.end => return,
            MemoryMap.VRAM.start...MemoryMap.VRAM.end => self.writeVram(address, value),
            MemoryMap.SRAM.start...MemoryMap.SRAM.end => {},
            MemoryMap.WRAM0.start...MemoryMap.WRAM0.end => self.writeWram(address, value),
            MemoryMap.WRAM1.start...MemoryMap.WRAM1.end => self.writeWram(address, value),
            MemoryMap.ECHO_RAM.start...MemoryMap.ECHO_RAM.end => self.writeWram(address - 0x2000, value),
            MemoryMap.OAM.start...MemoryMap.OAM.end => {},
            MemoryMap.IO.start...MemoryMap.IO.end => {},
            MemoryMap.HRAM.start...MemoryMap.HRAM.end => self.writeHram(address, value),
            MemoryMap.IE => {},
            else => {},
        }
    }

    fn readVram(self: *Memory, address: u16) u8 {
        return self.vram[address - 0x8000];
    }

    fn readWram(self: *Memory, address: u16) u8 {
        return self.wram[address - 0xC000];
    }

    fn readHram(self: *Memory, address: u16) u8 {
        return self.hram[address - 0xFF80];
    }

    fn writeVram(self: *Memory, address: u16, value: u8) void {
        self.vram[address - 0x8000] = value;
    }

    fn writeWram(self: *Memory, address: u16, value: u8) void {
        self.wram[address - 0xC000] = value;
    }

    fn writeHram(self: *Memory, address: u16, value: u8) void {
        self.hram[address - 0xFF80] = value;
    }

    pub fn load(self: *Memory, allocator: std.mem.Allocator, filename: []const u8) !void {
        try self.cartridge.load(allocator, filename);
    }

    pub fn deinit(self: *Memory, allocator: std.mem.Allocator) !void {
        try self.cartridge.deinit(allocator);
    }
};
