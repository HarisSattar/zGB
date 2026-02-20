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
    map: [MEMORY_SIZE]u8 = undefined,
    boot_rom_enabled: bool = true,
    // TODO: need a cartridge

    pub fn init() Memory {
        return Memory{
            .map = [_]u8{0} ** MEMORY_SIZE,
        };
    }

    pub fn read(self: *const @This(), address: u16) u8 {
        return switch (address) {
            MemoryMap.ROM0.start...MemoryMap.ROM0.end => 0x00,
            MemoryMap.ROM1_BANKED.start...MemoryMap.ROM1_BANKED.end => 0x00,
            MemoryMap.VRAM.start...MemoryMap.VRAM.end => 0x00,
            MemoryMap.SRAM.start...MemoryMap.SRAM.end => 0x00,
            MemoryMap.WRAM0.start...MemoryMap.WRAM0.end => self.readByte(address),
            MemoryMap.WRAM1.start...MemoryMap.WRAM1.end => 0x00,
            MemoryMap.ECHO_RAM.start...MemoryMap.ECHO_RAM.end => 0x00,
            MemoryMap.OAM.start...MemoryMap.OAM.end => 0x00,
            MemoryMap.IO.start...MemoryMap.IO.end => 0x00,
            MemoryMap.HRAM.start...MemoryMap.HRAM.start => 0x00,
            MemoryMap.IE => 0x00,
        };
    }

    fn readByte(self: *const @This(), address: u16) u8 {
        return self.map[address];
    }

    fn writeByte(self: *@This(), address: u16, byte: u8) void {
        self.map[address] = byte;
    }
};
