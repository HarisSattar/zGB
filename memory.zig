const MEMORY_SIZE = 0x10000;

const CARTRIDGE_ROM_START: u16 = 0x0000;
const CARTRIDGE_ROM_END: u16 = 0x8000;

pub const Memory = struct {
    map: [MEMORY_SIZE]u8 = undefined,
    boot_rom_enabled: bool = true,

    pub fn init() Memory {
        return Memory{
            .map = [_]u8{0} ** MEMORY_SIZE,
        };
    }

    pub fn read(self: *const @This(), address: u16) u8 {
        if (address <= 0xBFFF) {
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
