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
        if (address >= MemoryMap.ROM0.start) {
            // read from cartridge
            return;
        } else if (address == 0xFF00) {
            // get the joy pad input
            return;
        } else {
            return readByte(self, address);
        }
    }

    fn readByte(self: *const @This(), address: u16) u8 {
        return self.map[address];
    }

    fn writeByte(self: *@This(), address: u16, byte: u8) void {
        self.map[address] = byte;
    }
};
