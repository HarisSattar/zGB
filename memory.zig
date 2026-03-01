const std = @import("std");

const Cartridge = @import("cartridge.zig").Cartridge;

const MEMORY_SIZE = 0x10000;

const SB_ADDR: u16 = 0xFF01;
const SC_ADDR: u16 = 0xFF02;
const DIV_ADDR: u16 = 0xFF04;
const TIMA_ADDR: u16 = 0xFF05;
const TMA_ADDR: u16 = 0xFF06;
const TAC_ADDR: u16 = 0xFF07;
const IF_ADDR: u16 = 0xFF0F;

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
    io: [0x0080]u8 = .{0} ** 0x0080,
    ie: u8 = 0,
    div_counter: u16 = 0,
    tima_counter: u16 = 0,
    serial_buffer: [1024]u8 = .{0} ** 1024,
    serial_len: usize = 0,
    serial_test_done: bool = false,
    serial_test_passed: bool = false,
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
            MemoryMap.IO.start...MemoryMap.IO.end => self.readIo(address),
            MemoryMap.HRAM.start...MemoryMap.HRAM.end => self.readHram(address),
            MemoryMap.IE => self.ie,
            else => 0x00,
        };
    }

    pub fn write(self: *Memory, address: u16, value: u8) void {
        switch (address) {
            MemoryMap.ROM0.start...MemoryMap.ROM0.end => return,
            MemoryMap.ROM1_BANKED.start...MemoryMap.ROM1_BANKED.end => return,
            MemoryMap.VRAM.start...MemoryMap.VRAM.end => self.writeVram(address, value),
            MemoryMap.SRAM.start...MemoryMap.SRAM.end => {
                // Cartridge SRAM not implemented — ignore writes for now
            },
            MemoryMap.WRAM0.start...MemoryMap.WRAM0.end => self.writeWram(address, value),
            MemoryMap.WRAM1.start...MemoryMap.WRAM1.end => self.writeWram(address, value),
            MemoryMap.ECHO_RAM.start...MemoryMap.ECHO_RAM.end => self.writeWram(address - 0x2000, value),
            MemoryMap.OAM.start...MemoryMap.OAM.end => {},
            MemoryMap.IO.start...MemoryMap.IO.end => self.writeIo(address, value),
            MemoryMap.HRAM.start...MemoryMap.HRAM.end => self.writeHram(address, value),
            MemoryMap.IE => self.ie = value,
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

    fn readIo(self: *Memory, address: u16) u8 {
        return self.io[address - 0xFF00];
    }

    fn writeIo(self: *Memory, address: u16, value: u8) void {
        const idx: usize = @as(usize, address - 0xFF00);
        self.io[idx] = value;

        const SB_IDX: usize = @as(usize, SB_ADDR - 0xFF00);
        const SC_IDX: usize = @as(usize, SC_ADDR - 0xFF00);

        if (address == SC_ADDR and value == 0x81) {
            const sb_val: u8 = self.io[SB_IDX];
            self.appendSerialByte(sb_val);
            self.io[SC_IDX] = 0x01;
        } else if (address == DIV_ADDR) {
            self.io[idx] = 0;
            self.div_counter = 0;
        }
    }

    pub fn tickTimers(self: *Memory, cycles: u16) void {
        const div_idx: usize = @as(usize, DIV_ADDR - 0xFF00);
        const tima_idx: usize = @as(usize, TIMA_ADDR - 0xFF00);
        const tma_idx: usize = @as(usize, TMA_ADDR - 0xFF00);
        const tac_idx: usize = @as(usize, TAC_ADDR - 0xFF00);
        const if_idx: usize = @as(usize, IF_ADDR - 0xFF00);

        self.div_counter +%= cycles;
        while (self.div_counter >= 256) {
            self.div_counter -%= 256;
            self.io[div_idx] +%= 1;
        }

        const tac = self.io[tac_idx];
        if ((tac & 0x04) == 0) {
            return;
        }

        const period: u16 = switch (tac & 0x03) {
            0x00 => 1024,
            0x01 => 16,
            0x02 => 64,
            else => 256,
        };

        self.tima_counter +%= cycles;
        while (self.tima_counter >= period) {
            self.tima_counter -%= period;

            if (self.io[tima_idx] == 0xFF) {
                self.io[tima_idx] = self.io[tma_idx];
                self.io[if_idx] |= 0x04;
            } else {
                self.io[tima_idx] +%= 1;
            }
        }
    }

    fn appendSerialByte(self: *Memory, b: u8) void {
        if (b == '\r') {
            return;
        }

        if (b == '\n' or b == 0x00) {
            self.flushSerialBuffer();
            return;
        }

        if (b < 0x20 or b > 0x7E) {
            return;
        }

        if (self.serial_len >= self.serial_buffer.len - 1) {
            self.flushSerialBuffer();
        }

        self.serial_buffer[self.serial_len] = b;
        self.serial_len += 1;
    }

    pub fn flushSerialBuffer(self: *Memory) void {
        if (self.serial_len == 0) return;
        const line = self.serial_buffer[0..self.serial_len];

        if (std.mem.indexOf(u8, line, "Passed") != null) {
            self.serial_test_done = true;
            self.serial_test_passed = true;
        }
        if (std.mem.indexOf(u8, line, "I5:ok") != null) {
            self.serial_test_done = true;
            self.serial_test_passed = true;
        }
        if (std.mem.indexOf(u8, line, "Failed") != null) {
            self.serial_test_done = true;
            self.serial_test_passed = false;
        }

        // const stdout = std.fs.File.stdout().deprecatedWriter();
        std.debug.print("{s}\n", .{line});
        self.serial_len = 0;
    }

    pub fn isSerialTestDone(self: *const Memory) bool {
        return self.serial_test_done;
    }

    pub fn didSerialTestPass(self: *const Memory) bool {
        return self.serial_test_passed;
    }

    pub fn load(self: *Memory, allocator: std.mem.Allocator, filename: []const u8) !void {
        try self.cartridge.load(allocator, filename);
    }

    pub fn deinit(self: *Memory, allocator: std.mem.Allocator) !void {
        try self.cartridge.deinit(allocator);
    }
};
